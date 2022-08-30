Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5FAFA5A6AD1
	for <lists+stable@lfdr.de>; Tue, 30 Aug 2022 19:33:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231997AbiH3RdM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 30 Aug 2022 13:33:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32848 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231796AbiH3RcR (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 30 Aug 2022 13:32:17 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D0E0E1636EC;
        Tue, 30 Aug 2022 10:28:12 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 4137BB81D2D;
        Tue, 30 Aug 2022 17:26:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 23F69C433D6;
        Tue, 30 Aug 2022 17:26:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1661880407;
        bh=0cH85VvIYBOZ+pBLS98yG/BMwMyFTJk/yyn7iuR9B+E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=t75wnxgK3+WlrxRSLhHuGe9HNWDv6fZCDT1dMxQ+SmB8D5Dn8TW3X3Zes4cYbIPcU
         mT0szj9Z3hjYXAOO/p6SSD4lyBGeFsCmx20U3PTClpjl3rw+l/BvEflg8Sl2FMPHFi
         JDgH5g6NsfKiGuHhqU4TBIjY2RjvMbMXzO9y7QWMFEIgG3HNGkXs4EsPPrkDQAFe2a
         gGwRM0JtiK45HrWqIboWM22MVmME8Dk0PB3VMXimXZkijn35fJMOtglJjcqgHVTr8Y
         secRA9KWVbsIG9C6RwK31SS8UTMjMJpJRcM2VF3gSNALl5XMRgbwqSVw1oMDLw85Wk
         w2Jut3USIOQmQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Helge Deller <deller@gmx.de>, Sasha Levin <sashal@kernel.org>,
        James.Bottomley@HansenPartnership.com, svens@stackframe.org,
        linux-parisc@vger.kernel.org
Subject: [PATCH AUTOSEL 4.14 5/8] parisc: Add runtime check to prevent PA2.0 kernels on PA1.x machines
Date:   Tue, 30 Aug 2022 13:26:28 -0400
Message-Id: <20220830172631.581969-5-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220830172631.581969-1-sashal@kernel.org>
References: <20220830172631.581969-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Helge Deller <deller@gmx.de>

[ Upstream commit 591d2108f3abc4db9f9073cae37cf3591fd250d6 ]

If a 32-bit kernel was compiled for PA2.0 CPUs, it won't be able to run
on machines with PA1.x CPUs. Add a check and bail out early if a PA1.x
machine is detected.

Signed-off-by: Helge Deller <deller@gmx.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/parisc/kernel/head.S | 43 ++++++++++++++++++++++++++++++++++++++-
 1 file changed, 42 insertions(+), 1 deletion(-)

diff --git a/arch/parisc/kernel/head.S b/arch/parisc/kernel/head.S
index 9b99eb0712ad1..2f570a5205866 100644
--- a/arch/parisc/kernel/head.S
+++ b/arch/parisc/kernel/head.S
@@ -22,7 +22,7 @@
 #include <linux/linkage.h>
 #include <linux/init.h>
 
-	.level	PA_ASM_LEVEL
+	.level	1.1
 
 	__INITDATA
 ENTRY(boot_args)
@@ -69,6 +69,47 @@ $bss_loop:
 	stw,ma          %arg2,4(%r1)
 	stw,ma          %arg3,4(%r1)
 
+#if !defined(CONFIG_64BIT) && defined(CONFIG_PA20)
+	/* This 32-bit kernel was compiled for PA2.0 CPUs. Check current CPU
+	 * and halt kernel if we detect a PA1.x CPU. */
+	ldi		32,%r10
+	mtctl		%r10,%cr11
+	.level 2.0
+	mfctl,w		%cr11,%r10
+	.level 1.1
+	comib,<>,n	0,%r10,$cpu_ok
+
+	load32		PA(msg1),%arg0
+	ldi		msg1_end-msg1,%arg1
+$iodc_panic:
+	copy		%arg0, %r10
+	copy		%arg1, %r11
+	load32		PA(init_stack),%sp
+#define MEM_CONS 0x3A0
+	ldw		MEM_CONS+32(%r0),%arg0	// HPA
+	ldi		ENTRY_IO_COUT,%arg1
+	ldw		MEM_CONS+36(%r0),%arg2	// SPA
+	ldw		MEM_CONS+8(%r0),%arg3	// layers
+	load32		PA(__bss_start),%r1
+	stw		%r1,-52(%sp)		// arg4
+	stw		%r0,-56(%sp)		// arg5
+	stw		%r10,-60(%sp)		// arg6 = ptr to text
+	stw		%r11,-64(%sp)		// arg7 = len
+	stw		%r0,-68(%sp)		// arg8
+	load32		PA(.iodc_panic_ret), %rp
+	ldw		MEM_CONS+40(%r0),%r1	// ENTRY_IODC
+	bv,n		(%r1)
+.iodc_panic_ret:
+	b .				/* wait endless with ... */
+	or		%r10,%r10,%r10	/* qemu idle sleep */
+msg1:	.ascii "Can't boot kernel which was built for PA8x00 CPUs on this machine.\r\n"
+msg1_end:
+
+$cpu_ok:
+#endif
+
+	.level	PA_ASM_LEVEL
+
 	/* Initialize startup VM. Just map first 16/32 MB of memory */
 	load32		PA(swapper_pg_dir),%r4
 	mtctl		%r4,%cr24	/* Initialize kernel root pointer */
-- 
2.35.1

