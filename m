Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DC20E1CB003
	for <lists+stable@lfdr.de>; Fri,  8 May 2020 15:24:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727109AbgEHMif (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 8 May 2020 08:38:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:54686 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728409AbgEHMie (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 8 May 2020 08:38:34 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4F6E521582;
        Fri,  8 May 2020 12:38:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588941513;
        bh=kDgKTk6zSvN1I0mYRhrLAZSenMElEVVerabyFRFK6K4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=OXZ2IgH/9oGRntt/wjtX0bRQjcNwNSLArqFEz2n+W+dM877I+9bq1XOK++ujATxMQ
         WitqCMZoiC6y2f3h5bYw5L0LM5TI7elcHc9BdGbj/hpnpESXYhxNT+wXP7lIG8d8Uk
         IUwrl6pHCSSjgTBpC2/LXJxrdeSZZycdAdcqQ2+4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, James Hogan <james.hogan@imgtec.com>,
        Paul Burton <paul.burton@imgtec.com>,
        linux-mips@linux-mips.org, Ralf Baechle <ralf@linux-mips.org>
Subject: [PATCH 4.4 024/312] MIPS: Fix 64-bit HTW configuration
Date:   Fri,  8 May 2020 14:30:15 +0200
Message-Id: <20200508123126.189876683@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200508123124.574959822@linuxfoundation.org>
References: <20200508123124.574959822@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: James Hogan <james.hogan@imgtec.com>

commit aa76042a016474775ccd187c068669148c30c3bb upstream.

The Hardware page Table Walker (HTW) is being misconfigured on 64-bit
kernels. The PWSize.PS (pointer size) bit determines whether pointers
within directories are loaded as 32-bit or 64-bit addresses, but was
never being set to 1 for 64-bit kernels where the unsigned long in pgd_t
is 64-bits wide.

This actually reduces rather than improves performance when the HTW is
enabled on P6600 since the HTW is initiated lots, but walks are all
aborted due I think to bad intermediate pointers.

Since we were already taking the width of the PTEs into account by
setting PWSize.PTEW, which is the left shift applied to the page table
index *in addition to* the native pointer size, we also need to reduce
PTEW by 1 when PS=1. This is done by calculating PTEW based on the
relative size of pte_t compared to pgd_t.

Finally in order for the HTW to be used when PS=1, the appropriate
XK/XS/XU bits corresponding to the different 64-bit segments need to be
set in PWCtl. We enable only XU for now to enable walking for XUSeg.

Supporting walking for XKSeg would be a bit more involved so is left for
a future patch. It would either require the use of a per-CPU top level
base directory if supported by the HTW (a bit like pgd_current but with
a second entry pointing at swapper_pg_dir), or the HTW would prepend bit
63 of the address to the global directory index which doesn't really
match how we split user and kernel page directories.

Fixes: cab25bc7537b ("MIPS: Extend hardware table walking support to MIPS64")
Signed-off-by: James Hogan <james.hogan@imgtec.com>
Cc: Paul Burton <paul.burton@imgtec.com>
Cc: linux-mips@linux-mips.org
Patchwork: https://patchwork.linux-mips.org/patch/13364/
Signed-off-by: Ralf Baechle <ralf@linux-mips.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/mips/mm/tlbex.c |   14 ++++++++++++--
 1 file changed, 12 insertions(+), 2 deletions(-)

--- a/arch/mips/mm/tlbex.c
+++ b/arch/mips/mm/tlbex.c
@@ -2329,15 +2329,25 @@ static void config_htw_params(void)
 	if (CONFIG_PGTABLE_LEVELS >= 3)
 		pwsize |= ilog2(PTRS_PER_PMD) << MIPS_PWSIZE_MDW_SHIFT;
 
-	pwsize |= ilog2(sizeof(pte_t)/4) << MIPS_PWSIZE_PTEW_SHIFT;
+	/* Set pointer size to size of directory pointers */
+	if (config_enabled(CONFIG_64BIT))
+		pwsize |= MIPS_PWSIZE_PS_MASK;
+	/* PTEs may be multiple pointers long (e.g. with XPA) */
+	pwsize |= ((PTE_T_LOG2 - PGD_T_LOG2) << MIPS_PWSIZE_PTEW_SHIFT)
+			& MIPS_PWSIZE_PTEW_MASK;
 
 	write_c0_pwsize(pwsize);
 
 	/* Make sure everything is set before we enable the HTW */
 	back_to_back_c0_hazard();
 
-	/* Enable HTW and disable the rest of the pwctl fields */
+	/*
+	 * Enable HTW (and only for XUSeg on 64-bit), and disable the rest of
+	 * the pwctl fields.
+	 */
 	config = 1 << MIPS_PWCTL_PWEN_SHIFT;
+	if (config_enabled(CONFIG_64BIT))
+		config |= MIPS_PWCTL_XU_MASK;
 	write_c0_pwctl(config);
 	pr_info("Hardware Page Table Walker enabled\n");
 


