Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 60DAE6214E7
	for <lists+stable@lfdr.de>; Tue,  8 Nov 2022 15:06:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235057AbiKHOGU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Nov 2022 09:06:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41714 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235075AbiKHOGQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 8 Nov 2022 09:06:16 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 89A6769DFB
        for <stable@vger.kernel.org>; Tue,  8 Nov 2022 06:06:15 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 358E7B81B00
        for <stable@vger.kernel.org>; Tue,  8 Nov 2022 14:06:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 80D8AC433B5;
        Tue,  8 Nov 2022 14:06:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1667916372;
        bh=I35xNGiCwyHYqbID6tWQwArL0frw3chKk0FW4N1offI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QUUWz87JbKhKqGdmBQZ8nhIBm2PA9bR3lahOei+Imd5vHPP83laDwp6U8n2anvl8f
         EOl3GohBRDfmoBdW6s4T6P1KWsTLr4dH5ctwGdEyubw/Hve+BJBSqScejjNTBof6Je
         sIjChyuvtJLCR2QWYbsWhHWblFrJCTEpcK9U+AHQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Sahil Malhotra <sahil.malhotra@nxp.com>,
        Sumit Garg <sumit.garg@linaro.org>
Subject: [PATCH 5.15 137/144] tee: Fix tee_shm_register() for kernel TEE drivers
Date:   Tue,  8 Nov 2022 14:40:14 +0100
Message-Id: <20221108133351.106448265@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221108133345.346704162@linuxfoundation.org>
References: <20221108133345.346704162@linuxfoundation.org>
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

From: Sumit Garg <sumit.garg@linaro.org>

Commit 056d3fed3d1f ("tee: add tee_shm_register_{user,kernel}_buf()")
refactored tee_shm_register() into corresponding user and kernel space
functions named tee_shm_register_{user,kernel}_buf(). The upstream fix
commit 573ae4f13f63 ("tee: add overflow check in register_shm_helper()")
only applied to tee_shm_register_user_buf().

But the stable kernel 4.19, 5.4, 5.10 and 5.15 don't have the above
mentioned tee_shm_register() refactoring commit. Hence a direct backport
wasn't possible and the fix has to be rather applied to
tee_ioctl_shm_register().

Somehow the fix was correctly backported to 4.19 and 5.4 stable kernels
but the backports for 5.10 and 5.15 stable kernels were broken as fix
was applied to common tee_shm_register() function which broke its kernel
space users such as trusted keys driver.

Fortunately the backport for 5.10 stable kernel was incidently fixed by:
commit 606fe84a4185 ("tee: fix memory leak in tee_shm_register()"). So
fix the backport for 5.15 stable kernel as well.

Fixes: 578c349570d2 ("tee: add overflow check in register_shm_helper()")
Cc: stable@vger.kernel.org # 5.15
Reported-by: Sahil Malhotra <sahil.malhotra@nxp.com>
Signed-off-by: Sumit Garg <sumit.garg@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/tee/tee_core.c |    3 +++
 drivers/tee/tee_shm.c  |    3 ---
 2 files changed, 3 insertions(+), 3 deletions(-)

--- a/drivers/tee/tee_core.c
+++ b/drivers/tee/tee_core.c
@@ -334,6 +334,9 @@ tee_ioctl_shm_register(struct tee_contex
 	if (data.flags)
 		return -EINVAL;
 
+	if (!access_ok((void __user *)(unsigned long)data.addr, data.length))
+		return -EFAULT;
+
 	shm = tee_shm_register(ctx, data.addr, data.length,
 			       TEE_SHM_DMA_BUF | TEE_SHM_USER_MAPPED);
 	if (IS_ERR(shm))
--- a/drivers/tee/tee_shm.c
+++ b/drivers/tee/tee_shm.c
@@ -223,9 +223,6 @@ struct tee_shm *tee_shm_register(struct
 		goto err;
 	}
 
-	if (!access_ok((void __user *)addr, length))
-		return ERR_PTR(-EFAULT);
-
 	mutex_lock(&teedev->mutex);
 	shm->id = idr_alloc(&teedev->idr, shm, 1, 0, GFP_KERNEL);
 	mutex_unlock(&teedev->mutex);


