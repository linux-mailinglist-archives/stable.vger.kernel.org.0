Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 51FD41CAABA
	for <lists+stable@lfdr.de>; Fri,  8 May 2020 14:36:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726638AbgEHMgZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 8 May 2020 08:36:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:49488 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727124AbgEHMgZ (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 8 May 2020 08:36:25 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2073821473;
        Fri,  8 May 2020 12:36:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588941384;
        bh=tcgZXyYJLW2CvBxvw8LEQKfAFWzcUcs5rilOxYRENjM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KyVUiq2KGxtLXXUE2fDBZXX+hDoYJyVm4blVk0JkhWqMDIEHrHK9yEEo3brwema9o
         cO/IShOPCPL56L5WFWBLN/SCiVjlczLJrTil1wFN/IkiIj0wEIsnOpvTzpni3UJLqG
         Aj2DwF+k/8+Oxv2sQmDYxmKOqcr43Dm9ZWJ+KqsU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Florian Fainelli <f.fainelli@gmail.com>,
        john@phrozen.org, cernekee@gmail.com, jogo@openwrt.org,
        jaedon.shin@gmail.com, jfraser@broadcom.com, pgynther@google.com,
        dragan.stancevic@gmail.com, linux-mips@linux-mips.org,
        Ralf Baechle <ralf@linux-mips.org>
Subject: [PATCH 4.4 011/312] MIPS: BMIPS: Fix PRID_IMP_BMIPS5000 masking for BMIPS5200
Date:   Fri,  8 May 2020 14:30:02 +0200
Message-Id: <20200508123125.303734179@linuxfoundation.org>
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

From: Florian Fainelli <f.fainelli@gmail.com>

commit cbbda6e7c9c3e4532bd70a73ff9d5e6655c894dc upstream.

BMIPS5000 have a PrID value of 0x5A00 and BMIPS5200 have a PrID value of
0x5B00, which, masked with 0x5A00, returns 0x5A00. Update all conditionals on
the PrID to cover both variants since we are going to need this to enable
BMIPS5200 SMP. The existing check, masking with 0xFF00 would not cover
BMIPS5200 at all.

Fixes: 68e6a78373a6d ("MIPS: BMIPS: Add PRId for BMIPS5200 (Whirlwind)")
Fixes: 6465460c92a85 ("MIPS: BMIPS: change compile time checks to runtime checks")
Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
Cc: john@phrozen.org
Cc: cernekee@gmail.com
Cc: jogo@openwrt.org
Cc: jaedon.shin@gmail.com
Cc: jfraser@broadcom.com
Cc: pgynther@google.com
Cc: dragan.stancevic@gmail.com
Cc: linux-mips@linux-mips.org
Patchwork: https://patchwork.linux-mips.org/patch/12279/
Signed-off-by: Ralf Baechle <ralf@linux-mips.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/mips/kernel/bmips_vec.S |    9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

--- a/arch/mips/kernel/bmips_vec.S
+++ b/arch/mips/kernel/bmips_vec.S
@@ -93,7 +93,8 @@ NESTED(bmips_reset_nmi_vec, PT_SIZE, sp)
 #if defined(CONFIG_CPU_BMIPS5000)
 	mfc0	k0, CP0_PRID
 	li	k1, PRID_IMP_BMIPS5000
-	andi	k0, 0xff00
+	/* mask with PRID_IMP_BMIPS5000 to cover both variants */
+	andi	k0, PRID_IMP_BMIPS5000
 	bne	k0, k1, 1f
 
 	/* if we're not on core 0, this must be the SMP boot signal */
@@ -166,10 +167,12 @@ bmips_smp_entry:
 2:
 #endif /* CONFIG_CPU_BMIPS4350 || CONFIG_CPU_BMIPS4380 */
 #if defined(CONFIG_CPU_BMIPS5000)
-	/* set exception vector base */
+	/* mask with PRID_IMP_BMIPS5000 to cover both variants */
 	li	k1, PRID_IMP_BMIPS5000
+	andi	k0, PRID_IMP_BMIPS5000
 	bne	k0, k1, 3f
 
+	/* set exception vector base */
 	la	k0, ebase
 	lw	k0, 0(k0)
 	mtc0	k0, $15, 1
@@ -263,6 +266,8 @@ LEAF(bmips_enable_xks01)
 #endif /* CONFIG_CPU_BMIPS4380 */
 #if defined(CONFIG_CPU_BMIPS5000)
 	li	t1, PRID_IMP_BMIPS5000
+	/* mask with PRID_IMP_BMIPS5000 to cover both variants */
+	andi	t2, PRID_IMP_BMIPS5000
 	bne	t2, t1, 2f
 
 	mfc0	t0, $22, 5


