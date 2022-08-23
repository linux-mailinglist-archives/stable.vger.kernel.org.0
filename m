Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3719859DFE7
	for <lists+stable@lfdr.de>; Tue, 23 Aug 2022 14:36:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356425AbiHWLC5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Aug 2022 07:02:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42938 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357388AbiHWLCO (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 23 Aug 2022 07:02:14 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BE76C66A65;
        Tue, 23 Aug 2022 02:14:42 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6EFF660F54;
        Tue, 23 Aug 2022 09:14:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 47165C433C1;
        Tue, 23 Aug 2022 09:14:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1661246081;
        bh=/oMobxsHDcQ6CFIW6sFoMoFbRFb9fNLZWxhjzCQjgwg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=xoUs7O1Ih6W1Q7hFRVHjDB3cwKDSzxWtMQGaJOpSeU8Oik5RkiriUBBGt2y9Cjhg/
         vJdzI2mbcVFgGuVB89qU6HjSpG1ubXtrR+NVeqXd3zLtV/9YG9k1fWBdPEAsLY7aI7
         93YI+q5Awk4/wzewajwa3G7+iyD6XD/ljmYJB9GI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Nimish Mishra <neelam.nimish@gmail.com>,
        Anirban Chakraborty <ch.anirban00727@gmail.com>,
        Debdeep Mukhopadhyay <debdeep.mukhopadhyay@gmail.com>,
        Jerome Forissier <jerome.forissier@linaro.org>,
        Jens Wiklander <jens.wiklander@linaro.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 4.19 284/287] tee: add overflow check in register_shm_helper()
Date:   Tue, 23 Aug 2022 10:27:33 +0200
Message-Id: <20220823080111.068435965@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220823080100.268827165@linuxfoundation.org>
References: <20220823080100.268827165@linuxfoundation.org>
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

From: Jens Wiklander <jens.wiklander@linaro.org>

commit 573ae4f13f630d6660008f1974c0a8a29c30e18a upstream.

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
[JW: backport to stable-4.19 + update commit message]
Signed-off-by: Jens Wiklander <jens.wiklander@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/tee/tee_core.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/drivers/tee/tee_core.c
+++ b/drivers/tee/tee_core.c
@@ -175,6 +175,10 @@ tee_ioctl_shm_register(struct tee_contex
 	if (data.flags)
 		return -EINVAL;
 
+	if (!access_ok(VERIFY_WRITE, (void __user *)(unsigned long)data.addr,
+		       data.length))
+		return -EFAULT;
+
 	shm = tee_shm_register(ctx, data.addr, data.length,
 			       TEE_SHM_DMA_BUF | TEE_SHM_USER_MAPPED);
 	if (IS_ERR(shm))


