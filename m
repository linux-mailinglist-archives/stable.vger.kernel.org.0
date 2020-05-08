Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2327F1CAFFD
	for <lists+stable@lfdr.de>; Fri,  8 May 2020 15:24:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727819AbgEHNWt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 8 May 2020 09:22:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:55472 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728452AbgEHMio (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 8 May 2020 08:38:44 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6702D2496E;
        Fri,  8 May 2020 12:38:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588941523;
        bh=3EUQqHlhW0Waxsf+eerSa7T/QTJ4Wx2e2/bYdkjLhug=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Ze1HhdryUY2n1oXBoaCJzlPmtv95f4zuD8nLfT1aQsGdMgxqcBfUgD0X7vZpXggyR
         ClTHyMoyGXuBVkzDCMvUu3ZAYA5tHSKlZT+fEJngheHe1xZ3fFg8PhWsA4lJ1j6jeu
         CNWae3BctYX9QVB9qIC8e+oVqJ/gtjOJrjAIiY/M=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, James Hogan <james.hogan@imgtec.com>,
        "Steven J. Hill" <sjhill@realitydiluted.com>,
        Paul Burton <paul.burton@imgtec.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        linux-mips@linux-mips.org, Ralf Baechle <ralf@linux-mips.org>
Subject: [PATCH 4.4 018/312] MIPS: Fix HTW config on XPA kernel without LPA enabled
Date:   Fri,  8 May 2020 14:30:09 +0200
Message-Id: <20200508123125.770053528@linuxfoundation.org>
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

commit 14bc241443e126c62fcbf571b7d4c79740debc58 upstream.

The hardware page table walker (HTW) configuration is broken on XPA
kernels where XPA couldn't be enabled (either nohtw or the hardware
doesn't support it). This is because the PWSize.PTEW field (PTE width)
was only set to 8 bytes (an extra shift of 1) in config_htw_params() if
PageGrain.ELPA (enable large physical addressing) is set. On an XPA
kernel though the size of PTEs is fixed at 8 bytes regardless of whether
XPA could actually be enabled.

Fix the initialisation of this field based on sizeof(pte_t) instead.

Fixes: c5b367835cfc ("MIPS: Add support for XPA.")
Signed-off-by: James Hogan <james.hogan@imgtec.com>
Cc: Steven J. Hill <sjhill@realitydiluted.com>
Cc: Paul Burton <paul.burton@imgtec.com>
Cc: Paul Gortmaker <paul.gortmaker@windriver.com>
Cc: linux-mips@linux-mips.org
Cc: linux-kernel@vger.kernel.org
Patchwork: https://patchwork.linux-mips.org/patch/13113/
Signed-off-by: Paul Burton <paul.burton@imgtec.com>
Signed-off-by: Ralf Baechle <ralf@linux-mips.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/mips/mm/tlbex.c |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

--- a/arch/mips/mm/tlbex.c
+++ b/arch/mips/mm/tlbex.c
@@ -2329,9 +2329,7 @@ static void config_htw_params(void)
 	if (CONFIG_PGTABLE_LEVELS >= 3)
 		pwsize |= ilog2(PTRS_PER_PMD) << MIPS_PWSIZE_MDW_SHIFT;
 
-	/* If XPA has been enabled, PTEs are 64-bit in size. */
-	if (config_enabled(CONFIG_64BITS) || (read_c0_pagegrain() & PG_ELPA))
-		pwsize |= 1;
+	pwsize |= ilog2(sizeof(pte_t)/4) << MIPS_PWSIZE_PTEW_SHIFT;
 
 	write_c0_pwsize(pwsize);
 


