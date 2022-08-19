Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C643E5999F8
	for <lists+stable@lfdr.de>; Fri, 19 Aug 2022 12:43:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348409AbiHSKkd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Aug 2022 06:40:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34882 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348443AbiHSKkd (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 19 Aug 2022 06:40:33 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 886D7E42F7
        for <stable@vger.kernel.org>; Fri, 19 Aug 2022 03:40:32 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 22C6661689
        for <stable@vger.kernel.org>; Fri, 19 Aug 2022 10:40:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 27877C433C1;
        Fri, 19 Aug 2022 10:40:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660905631;
        bh=0pF/M4jMhJ5u/KkOyYI1T8F7XNfVqMJPB3SbkbCSfvI=;
        h=Subject:To:Cc:From:Date:From;
        b=oxg+8ygP6GH9icPSYYhSCcZ8nldJThmc6l3SeMT7AdyozmIGsmbOCwvRlfWkJP2Ez
         LJh3kb93rHWFQ5d2u4JehbwA9n+MY8KGDQJHMtIhiT1ofi/bt/DKkUmevm6L7o8fic
         6+CpvQPOrdbOFNnS9QvpqxwSbhwzOQcTLb2t96Fg=
Subject: FAILED: patch "[PATCH] tee: add overflow check in register_shm_helper()" failed to apply to 4.19-stable tree
To:     jens.wiklander@linaro.org, ch.anirban00727@gmail.com,
        debdeep.mukhopadhyay@gmail.com, jerome.forissier@linaro.org,
        neelam.nimish@gmail.com, torvalds@linux-foundation.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Fri, 19 Aug 2022 12:40:28 +0200
Message-ID: <16609056282712@kroah.com>
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


The patch below does not apply to the 4.19-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 573ae4f13f630d6660008f1974c0a8a29c30e18a Mon Sep 17 00:00:00 2001
From: Jens Wiklander <jens.wiklander@linaro.org>
Date: Thu, 18 Aug 2022 13:08:59 +0200
Subject: [PATCH] tee: add overflow check in register_shm_helper()

With special lengths supplied by user space, register_shm_helper() has
an integer overflow when calculating the number of pages covered by a
supplied user space memory region.

This causes internal_get_user_pages_fast() a helper function of
pin_user_pages_fast() to do a NULL pointer dereference:

  Unable to handle kernel NULL pointer dereference at virtual address 0000000000000010
  Modules linked in:
  CPU: 1 PID: 173 Comm: optee_example_a Not tainted 5.19.0 #11
  Hardware name: QEMU QEMU Virtual Machine, BIOS 0.0.0 02/06/2015
  pc : internal_get_user_pages_fast+0x474/0xa80
  Call trace:
   internal_get_user_pages_fast+0x474/0xa80
   pin_user_pages_fast+0x24/0x4c
   register_shm_helper+0x194/0x330
   tee_shm_register_user_buf+0x78/0x120
   tee_ioctl+0xd0/0x11a0
   __arm64_sys_ioctl+0xa8/0xec
   invoke_syscall+0x48/0x114

Fix this by adding an an explicit call to access_ok() in
tee_shm_register_user_buf() to catch an invalid user space address
early.

Fixes: 033ddf12bcf5 ("tee: add register user memory")
Cc: stable@vger.kernel.org
Reported-by: Nimish Mishra <neelam.nimish@gmail.com>
Reported-by: Anirban Chakraborty <ch.anirban00727@gmail.com>
Reported-by: Debdeep Mukhopadhyay <debdeep.mukhopadhyay@gmail.com>
Suggested-by: Jerome Forissier <jerome.forissier@linaro.org>
Signed-off-by: Jens Wiklander <jens.wiklander@linaro.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>

diff --git a/drivers/tee/tee_shm.c b/drivers/tee/tee_shm.c
index f2b1bcefcadd..1175f3a46859 100644
--- a/drivers/tee/tee_shm.c
+++ b/drivers/tee/tee_shm.c
@@ -326,6 +326,9 @@ struct tee_shm *tee_shm_register_user_buf(struct tee_context *ctx,
 	void *ret;
 	int id;
 
+	if (!access_ok((void __user *)addr, length))
+		return ERR_PTR(-EFAULT);
+
 	mutex_lock(&teedev->mutex);
 	id = idr_alloc(&teedev->idr, NULL, 1, 0, GFP_KERNEL);
 	mutex_unlock(&teedev->mutex);

