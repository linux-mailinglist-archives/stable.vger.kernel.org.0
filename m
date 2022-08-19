Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2E4D4599E72
	for <lists+stable@lfdr.de>; Fri, 19 Aug 2022 17:43:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349862AbiHSPlx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Aug 2022 11:41:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37706 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350023AbiHSPlI (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 19 Aug 2022 11:41:08 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 06C611022AA;
        Fri, 19 Aug 2022 08:40:56 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 306C6615FB;
        Fri, 19 Aug 2022 15:40:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 09269C433D6;
        Fri, 19 Aug 2022 15:40:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660923655;
        bh=wJ/V/LvE4I2T4P1SCgVc+d8avzexWZgTIgSHPGcTF3Q=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cwMcdZXcqnj5TWnZhsapq+LghaSoX3Um/Sg3SNqT8iColeP82mypuFPnhHYaNudv0
         BtmtJbF1qd2uEit6dgCWguyIxh2UrsLyo/UEdumjPNoCH5BTvKmg1WvBpP7LncYg5U
         wgjYHOwMY40+6/gGMEZJKPxEZxhn/OOgRdbRWlIc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Michal Suchanek <msuchanek@suse.de>,
        Baoquan He <bhe@redhat.com>, Coiby Xu <coxu@redhat.com>,
        Mimi Zohar <zohar@linux.ibm.com>
Subject: [PATCH 5.15 12/14] kexec: clean up arch_kexec_kernel_verify_sig
Date:   Fri, 19 Aug 2022 17:40:28 +0200
Message-Id: <20220819153712.072098573@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220819153711.658766010@linuxfoundation.org>
References: <20220819153711.658766010@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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

From: Coiby Xu <coxu@redhat.com>

commit 689a71493bd2f31c024f8c0395f85a1fd4b2138e upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/linux/kexec.h |    5 -----
 kernel/kexec_file.c   |   33 +++++++++++++--------------------
 2 files changed, 13 insertions(+), 25 deletions(-)

--- a/include/linux/kexec.h
+++ b/include/linux/kexec.h
@@ -206,11 +206,6 @@ static inline void *arch_kexec_kernel_im
 }
 #endif
 
-#ifdef CONFIG_KEXEC_SIG
-int arch_kexec_kernel_verify_sig(struct kimage *image, void *buf,
-				 unsigned long buf_len);
-#endif
-
 extern int kexec_add_buffer(struct kexec_buf *kbuf);
 int kexec_locate_mem_hole(struct kexec_buf *kbuf);
 
--- a/kernel/kexec_file.c
+++ b/kernel/kexec_file.c
@@ -81,24 +81,6 @@ int kexec_image_post_load_cleanup_defaul
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
@@ -141,13 +123,24 @@ void kimage_file_post_load_cleanup(struc
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


