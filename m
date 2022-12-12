Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E703364A191
	for <lists+stable@lfdr.de>; Mon, 12 Dec 2022 14:42:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233106AbiLLNmP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Dec 2022 08:42:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41758 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232853AbiLLNlb (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 12 Dec 2022 08:41:31 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 28CF0140AF
        for <stable@vger.kernel.org>; Mon, 12 Dec 2022 05:41:01 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 6BF93CE0F7F
        for <stable@vger.kernel.org>; Mon, 12 Dec 2022 13:40:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4870FC433EF;
        Mon, 12 Dec 2022 13:40:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1670852457;
        bh=+dCOKp5HDu8gfuthbDRRHAO03zpfaGehV31YqYiRQ8w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=yQLiMCChB1KvLjUcjJY1ZQDJcRvsNlG35Nvnleo73OdpooMRKP3evzGy0Uw7QAlmu
         d4IGfYAA05JrFhZLEP05CWHjnXUWocwEtI66IcqHiED0wN54N+NrvUgwo3ezhccC+S
         SVI7jbJrUsM0e+6DwMuFVCWQwiZOX8z6GOAtJHFE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Kefeng Wang <wangkefeng.wang@huawei.com>,
        "Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>
Subject: [PATCH 6.0 084/157] ARM: 9278/1: kfence: only handle translation faults
Date:   Mon, 12 Dec 2022 14:17:12 +0100
Message-Id: <20221212130938.164150310@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221212130934.337225088@linuxfoundation.org>
References: <20221212130934.337225088@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Wang Kefeng <wangkefeng.wang@huawei.com>

commit 73a0b6ee5d6269f92df43e1d09b3278a2886bf8a upstream.

This is a similar fixup like arm64 does, only handle translation faults
in case of unexpected kfence report when alignment faults on ARM, see
more from commit 0bb1fbffc631 ("arm64: mm: kfence: only handle translation
faults").

Fixes: 75969686ec0d ("ARM: 9166/1: Support KFENCE for ARM")
Signed-off-by: Kefeng Wang <wangkefeng.wang@huawei.com>
Signed-off-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm/mm/fault.c |   18 ++++++++++++++++--
 arch/arm/mm/fault.h |    9 ++++++---
 2 files changed, 22 insertions(+), 5 deletions(-)

--- a/arch/arm/mm/fault.c
+++ b/arch/arm/mm/fault.c
@@ -105,6 +105,19 @@ static inline bool is_write_fault(unsign
 	return (fsr & FSR_WRITE) && !(fsr & FSR_CM);
 }
 
+static inline bool is_translation_fault(unsigned int fsr)
+{
+	int fs = fsr_fs(fsr);
+#ifdef CONFIG_ARM_LPAE
+	if ((fs & FS_MMU_NOLL_MASK) == FS_TRANS_NOLL)
+		return true;
+#else
+	if (fs == FS_L1_TRANS || fs == FS_L2_TRANS)
+		return true;
+#endif
+	return false;
+}
+
 static void die_kernel_fault(const char *msg, struct mm_struct *mm,
 			     unsigned long addr, unsigned int fsr,
 			     struct pt_regs *regs)
@@ -140,7 +153,8 @@ __do_kernel_fault(struct mm_struct *mm,
 	if (addr < PAGE_SIZE) {
 		msg = "NULL pointer dereference";
 	} else {
-		if (kfence_handle_page_fault(addr, is_write_fault(fsr), regs))
+		if (is_translation_fault(fsr) &&
+		    kfence_handle_page_fault(addr, is_write_fault(fsr), regs))
 			return;
 
 		msg = "paging request";
@@ -208,7 +222,7 @@ static inline bool is_permission_fault(u
 {
 	int fs = fsr_fs(fsr);
 #ifdef CONFIG_ARM_LPAE
-	if ((fs & FS_PERM_NOLL_MASK) == FS_PERM_NOLL)
+	if ((fs & FS_MMU_NOLL_MASK) == FS_PERM_NOLL)
 		return true;
 #else
 	if (fs == FS_L1_PERM || fs == FS_L2_PERM)
--- a/arch/arm/mm/fault.h
+++ b/arch/arm/mm/fault.h
@@ -14,8 +14,9 @@
 
 #ifdef CONFIG_ARM_LPAE
 #define FSR_FS_AEA		17
+#define FS_TRANS_NOLL		0x4
 #define FS_PERM_NOLL		0xC
-#define FS_PERM_NOLL_MASK	0x3C
+#define FS_MMU_NOLL_MASK	0x3C
 
 static inline int fsr_fs(unsigned int fsr)
 {
@@ -23,8 +24,10 @@ static inline int fsr_fs(unsigned int fs
 }
 #else
 #define FSR_FS_AEA		22
-#define FS_L1_PERM             0xD
-#define FS_L2_PERM             0xF
+#define FS_L1_TRANS		0x5
+#define FS_L2_TRANS		0x7
+#define FS_L1_PERM		0xD
+#define FS_L2_PERM		0xF
 
 static inline int fsr_fs(unsigned int fsr)
 {


