Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 867D7599EB1
	for <lists+stable@lfdr.de>; Fri, 19 Aug 2022 17:44:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350060AbiHSPm2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Aug 2022 11:42:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38634 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349981AbiHSPlt (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 19 Aug 2022 11:41:49 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EAAFFEA336;
        Fri, 19 Aug 2022 08:41:07 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 262D8B82814;
        Fri, 19 Aug 2022 15:41:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6EE08C433C1;
        Fri, 19 Aug 2022 15:41:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660923664;
        bh=qh/axndb7wUJZpXguucKoIulVp/Qb3Nd7Atm6YWpB5k=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KyUglHcQebGDrtrwLWNu1M4ir0TS5OALsmqOMY7HEjtejt2cb6sMFLjxduKsyugpv
         DbJqbOMTUQcWoe3cDCAUFVGImrQPocItkbBU107NqAbvSvTmJ4tuRgrxZWLTknBqyx
         MF4+Xo6eb1esJQQgtJiLJh4GqqRDmxqbIBWpK08s=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Nimish Mishra <neelam.nimish@gmail.com>,
        Anirban Chakraborty <ch.anirban00727@gmail.com>,
        Debdeep Mukhopadhyay <debdeep.mukhopadhyay@gmail.com>,
        Jerome Forissier <jerome.forissier@linaro.org>,
        Jens Wiklander <jens.wiklander@linaro.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 5.15 02/14] tee: add overflow check in register_shm_helper()
Date:   Fri, 19 Aug 2022 17:40:18 +0200
Message-Id: <20220819153711.747538439@linuxfoundation.org>
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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/tee/tee_shm.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/tee/tee_shm.c
+++ b/drivers/tee/tee_shm.c
@@ -222,6 +222,9 @@ struct tee_shm *tee_shm_register(struct
 		goto err;
 	}
 
+	if (!access_ok((void __user *)addr, length))
+		return ERR_PTR(-EFAULT);
+
 	mutex_lock(&teedev->mutex);
 	shm->id = idr_alloc(&teedev->idr, shm, 1, 0, GFP_KERNEL);
 	mutex_unlock(&teedev->mutex);


