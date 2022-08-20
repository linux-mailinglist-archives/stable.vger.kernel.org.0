Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1F7EA59B26F
	for <lists+stable@lfdr.de>; Sun, 21 Aug 2022 09:01:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229873AbiHUHBF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 21 Aug 2022 03:01:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49862 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229992AbiHUHAi (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 21 Aug 2022 03:00:38 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CD82426106
        for <stable@vger.kernel.org>; Sun, 21 Aug 2022 00:00:36 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 363B8CE0ADA
        for <stable@vger.kernel.org>; Sun, 21 Aug 2022 07:00:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1988FC433C1;
        Sun, 21 Aug 2022 07:00:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1661065233;
        bh=Xhyau39+MrCh/SJi9UVC0ZfZPlCGfZTHOA3rzJ5XzGI=;
        h=Subject:To:Cc:From:Date:From;
        b=OjowCZBLee4B0jPG6HArJSBxJlkWrSvG7H9DAwZ7nAIXxvxP7m6jhiSU9t5kJP/iC
         6pJQhPKHGS/oiXMFVJJCVknwU7N2ovOOP5EX2NqtLFAmDA3fWJwLL03eRuNO26tDNE
         iWg9KngweRRhk79Ixk8jJYeEq4h9Pg8l1kWydYi4=
Subject: FAILED: patch "[PATCH] kexec: clean up arch_kexec_kernel_verify_sig" failed to apply to 5.15-stable tree
To:     coxu@redhat.com, bhe@redhat.com, ebiederm@xmission.com,
        msuchanek@suse.de, zohar@linux.ibm.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sat, 20 Aug 2022 20:20:51 +0200
Message-ID: <1661019651206101@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-6.1 required=5.0 tests=BAYES_00,DATE_IN_PAST_12_24,
        DKIMWL_WL_HIGH,DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.15-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 689a71493bd2f31c024f8c0395f85a1fd4b2138e Mon Sep 17 00:00:00 2001
From: Coiby Xu <coxu@redhat.com>
Date: Thu, 14 Jul 2022 21:40:24 +0800
Subject: [PATCH] kexec: clean up arch_kexec_kernel_verify_sig

Before commit 105e10e2cf1c ("kexec_file: drop weak attribute from
functions"), there was already no arch-specific implementation
of arch_kexec_kernel_verify_sig. With weak attribute dropped by that
commit, arch_kexec_kernel_verify_sig is completely useless. So clean it
up.

Note later patches are dependent on this patch so it should be backported
to the stable tree as well.

Cc: stable@vger.kernel.org
Suggested-by: Eric W. Biederman <ebiederm@xmission.com>
Reviewed-by: Michal Suchanek <msuchanek@suse.de>
Acked-by: Baoquan He <bhe@redhat.com>
Signed-off-by: Coiby Xu <coxu@redhat.com>
[zohar@linux.ibm.com: reworded patch description "Note"]
Link: https://lore.kernel.org/linux-integrity/20220714134027.394370-1-coxu@redhat.com/
Signed-off-by: Mimi Zohar <zohar@linux.ibm.com>

diff --git a/include/linux/kexec.h b/include/linux/kexec.h
index 8107606ad1e8..7f710fb3712b 100644
--- a/include/linux/kexec.h
+++ b/include/linux/kexec.h
@@ -212,11 +212,6 @@ static inline void *arch_kexec_kernel_image_load(struct kimage *image)
 }
 #endif
 
-#ifdef CONFIG_KEXEC_SIG
-int arch_kexec_kernel_verify_sig(struct kimage *image, void *buf,
-				 unsigned long buf_len);
-#endif
-
 extern int kexec_add_buffer(struct kexec_buf *kbuf);
 int kexec_locate_mem_hole(struct kexec_buf *kbuf);
 
diff --git a/kernel/kexec_file.c b/kernel/kexec_file.c
index 0c27c81351ee..6dc1294c90fc 100644
--- a/kernel/kexec_file.c
+++ b/kernel/kexec_file.c
@@ -81,24 +81,6 @@ int kexec_image_post_load_cleanup_default(struct kimage *image)
 	return image->fops->cleanup(image->image_loader_data);
 }
 
-#ifdef CONFIG_KEXEC_SIG
-static int kexec_image_verify_sig_default(struct kimage *image, void *buf,
-					  unsigned long buf_len)
-{
-	if (!image->fops || !image->fops->verify_sig) {
-		pr_debug("kernel loader does not support signature verification.\n");
-		return -EKEYREJECTED;
-	}
-
-	return image->fops->verify_sig(buf, buf_len);
-}
-
-int arch_kexec_kernel_verify_sig(struct kimage *image, void *buf, unsigned long buf_len)
-{
-	return kexec_image_verify_sig_default(image, buf, buf_len);
-}
-#endif
-
 /*
  * Free up memory used by kernel, initrd, and command line. This is temporary
  * memory allocation which is not needed any more after these buffers have
@@ -141,13 +123,24 @@ void kimage_file_post_load_cleanup(struct kimage *image)
 }
 
 #ifdef CONFIG_KEXEC_SIG
+static int kexec_image_verify_sig(struct kimage *image, void *buf,
+				  unsigned long buf_len)
+{
+	if (!image->fops || !image->fops->verify_sig) {
+		pr_debug("kernel loader does not support signature verification.\n");
+		return -EKEYREJECTED;
+	}
+
+	return image->fops->verify_sig(buf, buf_len);
+}
+
 static int
 kimage_validate_signature(struct kimage *image)
 {
 	int ret;
 
-	ret = arch_kexec_kernel_verify_sig(image, image->kernel_buf,
-					   image->kernel_buf_len);
+	ret = kexec_image_verify_sig(image, image->kernel_buf,
+				     image->kernel_buf_len);
 	if (ret) {
 
 		if (sig_enforce) {

