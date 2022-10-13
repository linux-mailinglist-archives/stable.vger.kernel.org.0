Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E61B25FD08D
	for <lists+stable@lfdr.de>; Thu, 13 Oct 2022 02:28:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231381AbiJMA2L (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 Oct 2022 20:28:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58216 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231134AbiJMA1T (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 12 Oct 2022 20:27:19 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 24C373F30E;
        Wed, 12 Oct 2022 17:24:57 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 86688B81CF4;
        Thu, 13 Oct 2022 00:23:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 55F9FC433D6;
        Thu, 13 Oct 2022 00:23:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1665620633;
        bh=UR63eXK32mdq79RpdY/D8aufxHgBPZJACfCRDlovMcc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tmgn/ty5Jzgv02Xmo3J+JFuv+nS0XTkAIzVZQGpNfXJ5KKueJE6ma1IzRmbUmTCMt
         kGgi7ak2UR6m0KZ74T3vLQbt57Dutl+qh/GpOnRKXHoKmrB6/m5kyvljlF3XkWRUPj
         MY5SAxRGOLJVk1dRe9Ib+K1G5fFqhCNFjsprLsPTf0W3fnNqigjXTIj5AtaDj93+rG
         lY6VZpU+272oCy4E/cgPP1rtdOO1BkNN1DulCh4erohQA8hMc4lG1kP6+WXRe51U6E
         +dzJQZT7+UP24plvN6vhgP9qp9t5wlXoR2J1D28lDuFmdUYdH2vWc9AwG286JSdlq+
         kMVJeb0egdeMw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Shigeru Yoshida <syoshida@redhat.com>,
        syzbot+38e6c55d4969a14c1534@syzkaller.appspotmail.com,
        Josef Bacik <josef@toxicpanda.com>,
        Jens Axboe <axboe@kernel.dk>, Sasha Levin <sashal@kernel.org>,
        linux-block@vger.kernel.org, nbd@other.debian.org
Subject: [PATCH AUTOSEL 5.10 08/33] nbd: Fix hung when signal interrupts nbd_start_device_ioctl()
Date:   Wed, 12 Oct 2022 20:23:07 -0400
Message-Id: <20221013002334.1894749-8-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221013002334.1894749-1-sashal@kernel.org>
References: <20221013002334.1894749-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Shigeru Yoshida <syoshida@redhat.com>

[ Upstream commit 1de7c3cf48fc41cd95adb12bd1ea9033a917798a ]

syzbot reported hung task [1].  The following program is a simplified
version of the reproducer:

int main(void)
{
	int sv[2], fd;

	if (socketpair(AF_UNIX, SOCK_STREAM, 0, sv) < 0)
		return 1;
	if ((fd = open("/dev/nbd0", 0)) < 0)
		return 1;
	if (ioctl(fd, NBD_SET_SIZE_BLOCKS, 0x81) < 0)
		return 1;
	if (ioctl(fd, NBD_SET_SOCK, sv[0]) < 0)
		return 1;
	if (ioctl(fd, NBD_DO_IT) < 0)
		return 1;
	return 0;
}

When signal interrupt nbd_start_device_ioctl() waiting the condition
atomic_read(&config->recv_threads) == 0, the task can hung because it
waits the completion of the inflight IOs.

This patch fixes the issue by clearing queue, not just shutdown, when
signal interrupt nbd_start_device_ioctl().

Link: https://syzkaller.appspot.com/bug?id=7d89a3ffacd2b83fdd39549bc4d8e0a89ef21239 [1]
Reported-by: syzbot+38e6c55d4969a14c1534@syzkaller.appspotmail.com
Signed-off-by: Shigeru Yoshida <syoshida@redhat.com>
Reviewed-by: Josef Bacik <josef@toxicpanda.com>
Link: https://lore.kernel.org/r/20220907163502.577561-1-syoshida@redhat.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/block/nbd.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/block/nbd.c b/drivers/block/nbd.c
index 4a6b82d434ee..b0d3dadeb964 100644
--- a/drivers/block/nbd.c
+++ b/drivers/block/nbd.c
@@ -1342,10 +1342,12 @@ static int nbd_start_device_ioctl(struct nbd_device *nbd, struct block_device *b
 	mutex_unlock(&nbd->config_lock);
 	ret = wait_event_interruptible(config->recv_wq,
 					 atomic_read(&config->recv_threads) == 0);
-	if (ret)
+	if (ret) {
 		sock_shutdown(nbd);
-	flush_workqueue(nbd->recv_workq);
+		nbd_clear_que(nbd);
+	}
 
+	flush_workqueue(nbd->recv_workq);
 	mutex_lock(&nbd->config_lock);
 	nbd_bdev_reset(bdev);
 	/* user requested, ignore socket errors */
-- 
2.35.1

