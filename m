Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3C0F05931F9
	for <lists+stable@lfdr.de>; Mon, 15 Aug 2022 17:34:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235155AbiHOPd7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 11:33:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46782 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232978AbiHOPdh (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 11:33:37 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E222A175BA
        for <stable@vger.kernel.org>; Mon, 15 Aug 2022 08:33:18 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 903A4B80EF0
        for <stable@vger.kernel.org>; Mon, 15 Aug 2022 15:33:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EFEA8C433D7;
        Mon, 15 Aug 2022 15:33:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660577596;
        bh=Nz9cwyZn7j9Rbc4YF6EcjS+kvTdPNmv56mCr+K7Dc1c=;
        h=Subject:To:Cc:From:Date:From;
        b=tGxcd2Yy2vsL80oXB5cphjtpi0ThXF+zzqDR3JQQ3Z+21eeao60/B2QtH2r+OlorW
         3oaB3XL28slnfhevSCzDO3IQLM/qGEFB3PRS4uXdFu0dMkfqedUFBSeA1zcT2VhFrR
         R+eZf86cjHEliXTADiIOAG4zQmz42CDLcbdmy8Ig=
Subject: FAILED: patch "[PATCH] arm64: kexec_file: use more system keyrings to verify kernel" failed to apply to 5.10-stable tree
To:     coxu@redhat.com, bhe@redhat.com, msuchanek@suse.de,
        will@kernel.org, zohar@linux.ibm.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 15 Aug 2022 17:33:06 +0200
Message-ID: <166057758686253@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
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


The patch below does not apply to the 5.10-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 0d519cadf75184a24313568e7f489a7fc9b1be3b Mon Sep 17 00:00:00 2001
From: Coiby Xu <coxu@redhat.com>
Date: Thu, 14 Jul 2022 21:40:26 +0800
Subject: [PATCH] arm64: kexec_file: use more system keyrings to verify kernel
 image signature

Currently, when loading a kernel image via the kexec_file_load() system
call, arm64 can only use the .builtin_trusted_keys keyring to verify
a signature whereas x86 can use three more keyrings i.e.
.secondary_trusted_keys, .machine and .platform keyrings. For example,
one resulting problem is kexec'ing a kernel image  would be rejected
with the error "Lockdown: kexec: kexec of unsigned images is restricted;
see man kernel_lockdown.7".

This patch set enables arm64 to make use of the same keyrings as x86 to
verify the signature kexec'ed kernel image.

Fixes: 732b7b93d849 ("arm64: kexec_file: add kernel signature verification support")
Cc: stable@vger.kernel.org # 105e10e2cf1c: kexec_file: drop weak attribute from functions
Cc: stable@vger.kernel.org # 34d5960af253: kexec: clean up arch_kexec_kernel_verify_sig
Cc: stable@vger.kernel.org # 83b7bb2d49ae: kexec, KEYS: make the code in bzImage64_verify_sig generic
Acked-by: Baoquan He <bhe@redhat.com>
Cc: kexec@lists.infradead.org
Cc: keyrings@vger.kernel.org
Cc: linux-security-module@vger.kernel.org
Co-developed-by: Michal Suchanek <msuchanek@suse.de>
Signed-off-by: Michal Suchanek <msuchanek@suse.de>
Acked-by: Will Deacon <will@kernel.org>
Signed-off-by: Coiby Xu <coxu@redhat.com>
Signed-off-by: Mimi Zohar <zohar@linux.ibm.com>

diff --git a/arch/arm64/kernel/kexec_image.c b/arch/arm64/kernel/kexec_image.c
index 9ec34690e255..5ed6a585f21f 100644
--- a/arch/arm64/kernel/kexec_image.c
+++ b/arch/arm64/kernel/kexec_image.c
@@ -14,7 +14,6 @@
 #include <linux/kexec.h>
 #include <linux/pe.h>
 #include <linux/string.h>
-#include <linux/verification.h>
 #include <asm/byteorder.h>
 #include <asm/cpufeature.h>
 #include <asm/image.h>
@@ -130,18 +129,10 @@ static void *image_load(struct kimage *image,
 	return NULL;
 }
 
-#ifdef CONFIG_KEXEC_IMAGE_VERIFY_SIG
-static int image_verify_sig(const char *kernel, unsigned long kernel_len)
-{
-	return verify_pefile_signature(kernel, kernel_len, NULL,
-				       VERIFYING_KEXEC_PE_SIGNATURE);
-}
-#endif
-
 const struct kexec_file_ops kexec_image_ops = {
 	.probe = image_probe,
 	.load = image_load,
 #ifdef CONFIG_KEXEC_IMAGE_VERIFY_SIG
-	.verify_sig = image_verify_sig,
+	.verify_sig = kexec_kernel_verify_pe_sig,
 #endif
 };

