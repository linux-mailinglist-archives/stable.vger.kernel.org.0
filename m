Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 45F4B5BBC0E
	for <lists+stable@lfdr.de>; Sun, 18 Sep 2022 07:48:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229498AbiIRFsf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 18 Sep 2022 01:48:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44790 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229517AbiIRFse (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 18 Sep 2022 01:48:34 -0400
Received: from mail-pj1-x1034.google.com (mail-pj1-x1034.google.com [IPv6:2607:f8b0:4864:20::1034])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BF372286E7
        for <stable@vger.kernel.org>; Sat, 17 Sep 2022 22:48:32 -0700 (PDT)
Received: by mail-pj1-x1034.google.com with SMTP id s14-20020a17090a6e4e00b0020057c70943so3752299pjm.1
        for <stable@vger.kernel.org>; Sat, 17 Sep 2022 22:48:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=purestorage.com; s=google;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date;
        bh=XOndsD3PjUa8LyFYJzyKjY1yNsjpkmqRmuhKkebimFY=;
        b=PZWPG4B1GccIM2IbGrvfFQfE2XOCCYd7u3OA+lgQf6erK2FV4v882WBOFwyNuuDguc
         oLiN/AafXRx1AIz7D6P/OBhMcUp1tuZyFrzOw4pp4qu3VYiMFMEQYAsON/R/FF2lVOqG
         JfbUp7x8nlwpjhGoWDSWv3+E1nuVVtNhorVeY=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date;
        bh=XOndsD3PjUa8LyFYJzyKjY1yNsjpkmqRmuhKkebimFY=;
        b=62kfjNZX7W/Tu96P/u/s1HHYhylpI81XIT5ormOk6WMtw1DTydBN+sCbO37Aqtt9Ym
         eixtRGEPnoGBmZGOkKkEpOWoQFO+UZarWei2xFjRc7iokbIPJcTw9LLHgPWyKLQk8777
         JAClPExxhIKY6NYtAV1fsTjiy8MVvjhwnLJdP2pA1lg4Z0RWn8w0AtcSkTnXuY+7IcK/
         uISVZ7JqBA/+jEYzQkRhZqODrsOKC7roHzndOrKcYuckwJ1A8mfnTKAIr7vUiPzHNNVt
         kH4yZhBq6GGjf9NrAH6zbDAuEaIeYRYAW3GTnTJW8C3BovrxtfWIK1ZC/Dv95K0o0IJN
         7+jQ==
X-Gm-Message-State: ACrzQf2qBoePhLq+vGTGEYn/zSFLeltXR5dtt9+BVfXLmAPW9Mt4GXlr
        NdwPRdotblwy4f/CgshCZWzphQ==
X-Google-Smtp-Source: AMsMyM7Or294lI/U4UnyF1S77l+pUsEJrrenHM3B0ZR5BwEbYQNN64WKvvyJBh60bMk8I+qnHYm0zQ==
X-Received: by 2002:a17:90b:1e45:b0:202:fbc9:3df1 with SMTP id pi5-20020a17090b1e4500b00202fbc93df1mr25068654pjb.72.1663480112265;
        Sat, 17 Sep 2022 22:48:32 -0700 (PDT)
Received: from oceanus.lab.kspace.sh (c-98-207-191-243.hsd1.ca.comcast.net. [98.207.191.243])
        by smtp.googlemail.com with ESMTPSA id rv11-20020a17090b2c0b00b001fb3522d53asm4100105pjb.34.2022.09.17.22.48.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 17 Sep 2022 22:48:31 -0700 (PDT)
From:   Mohamed Khalfella <mkhalfella@purestorage.com>
To:     mkhalfella@purestorage.com
Cc:     stable@vger.kernel.org, Eric Badger <ebadger@purestorage.com>,
        Keith Busch <kbusch@kernel.org>, Jens Axboe <axboe@fb.com>,
        Christoph Hellwig <hch@lst.de>,
        Sagi Grimberg <sagi@grimberg.me>,
        Tao Chiu <taochiu@synology.com>,
        Leon Chien <leonchien@synology.com>,
        Cody Wong <codywong@synology.com>,
        linux-nvme@lists.infradead.org (open list:NVM EXPRESS DRIVER),
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH] nvme-pci: Make sure to ring doorbell when last request is short-circuited
Date:   Sun, 18 Sep 2022 05:48:16 +0000
Message-Id: <20220918054816.936669-1-mkhalfella@purestorage.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

When processing a batch of requests, it is possible that nvme_queue_rq()
misses to ring nvme queue doorbell if the last request fails because the
controller is not ready. As a result of that, previously queued requests
will timeout because the device had not chance to know about the commands
existence. This failure can cause nvme controller reset to timeout if
there was another App using adminq while nvme reset was taking place.

Consider this case:
- App is hammering adminq with NVME_ADMIN_IDENTIFY commands
- Controller reset triggered by "echo 1 > /sys/.../nvme0/reset_controller"

nvme_reset_ctrl() will change controller state to NVME_CTRL_RESETTING.
From that point on all requests from App will be forced to fail because
the controller is no longer ready. More importantly these requests will
not make it to adminq and will be short-circuited in nvme_queue_rq().
Unlike App requests, requests issued by reset code path will be allowed
to go through adminq in order to carry out the reset process. The problem
happens when blk-mq decides to mix requests from reset code path and App
in one batch, in particular when the last request in such batch happens
to be from App.

In this case the last request will have bd->last set to true telling the
driver to ring doorbell after queuing this request. However, since the
controller is not ready, this App request will be completed without going
through adminq, and nvme_queue_rq() will miss the opportunity to ring
adminq doorbell leaving earlier queued requests unknown to the device.

Fixes: d4060d2be1132 ("nvme-pci: fix controller reset hang when racing with nvme_timeout")
Cc: stable@vger.kernel.org
Reported-by: Eric Badger <ebadger@purestorage.com>
Signed-off-by: Mohamed Khalfella <mkhalfella@purestorage.com>
Reviewed-by: Eric Badger <ebadger@purestorage.com>
---
 drivers/nvme/host/pci.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/drivers/nvme/host/pci.c b/drivers/nvme/host/pci.c
index 98864b853eef..f6b1ae593e8e 100644
--- a/drivers/nvme/host/pci.c
+++ b/drivers/nvme/host/pci.c
@@ -946,8 +946,12 @@ static blk_status_t nvme_queue_rq(struct blk_mq_hw_ctx *hctx,
 	if (unlikely(!test_bit(NVMEQ_ENABLED, &nvmeq->flags)))
 		return BLK_STS_IOERR;
 
-	if (unlikely(!nvme_check_ready(&dev->ctrl, req, true)))
-		return nvme_fail_nonready_command(&dev->ctrl, req);
+	if (unlikely(!nvme_check_ready(&dev->ctrl, req, true))) {
+		ret = nvme_fail_nonready_command(&dev->ctrl, req);
+		if (ret == BLK_STS_OK && bd->last)
+			nvme_commit_rqs(hctx);
+		return ret;
+	}
 
 	ret = nvme_prep_rq(dev, req);
 	if (unlikely(ret))
@@ -1724,6 +1728,7 @@ static int nvme_create_queue(struct nvme_queue *nvmeq, int qid, bool polled)
 static const struct blk_mq_ops nvme_mq_admin_ops = {
 	.queue_rq	= nvme_queue_rq,
 	.complete	= nvme_pci_complete_rq,
+	.commit_rqs	= nvme_commit_rqs,
 	.init_hctx	= nvme_admin_init_hctx,
 	.init_request	= nvme_pci_init_request,
 	.timeout	= nvme_timeout,
-- 
2.25.1

