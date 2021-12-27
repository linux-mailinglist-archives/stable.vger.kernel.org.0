Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 151BD480053
	for <lists+stable@lfdr.de>; Mon, 27 Dec 2021 16:45:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238552AbhL0Ppp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Dec 2021 10:45:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37550 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239689AbhL0PnD (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 27 Dec 2021 10:43:03 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F03A4C07E5E5;
        Mon, 27 Dec 2021 07:41:31 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8D5E661120;
        Mon, 27 Dec 2021 15:41:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 71E7AC36AEA;
        Mon, 27 Dec 2021 15:41:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1640619691;
        bh=gX1CNiBibYMHUETV59xze0Iv1253ENQYFGbv7vvgXoo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=sBMc1py2FiLRLfMG11m2SWvAE3s/1LmRW4AhT7YdXpAyObdM6vmUcW3TvnUpvlcRR
         6UOOywFB2qmt4NsFqqBDSmvnhg5QuS8WjXKSLUyMgXdRGit+jd2XS1ynhv9gYG4B7y
         CwkgB5AQMxyy98xwARu/Mx0VpBE7Qa348K2tzgU4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Vincent Whitchurch <vincent.whitchurch@axis.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Viresh Kumar <viresh.kumar@linaro.org>,
        Bartosz Golaszewski <brgl@bgdev.pl>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 035/128] gpio: virtio: remove timeout
Date:   Mon, 27 Dec 2021 16:30:10 +0100
Message-Id: <20211227151332.700955617@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211227151331.502501367@linuxfoundation.org>
References: <20211227151331.502501367@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Vincent Whitchurch <vincent.whitchurch@axis.com>

[ Upstream commit 3e4d9a485029aa9e172dab5420abe775fd86f8e8 ]

The driver imposes an arbitrary one second timeout on virtio requests,
but the specification doesn't prevent the virtio device from taking
longer to process requests, so remove this timeout to support all
systems and device implementations.

Fixes: 3a29355a22c0275fe86 ("gpio: Add virtio-gpio driver")
Signed-off-by: Vincent Whitchurch <vincent.whitchurch@axis.com>
Acked-by: Michael S. Tsirkin <mst@redhat.com>
Acked-by: Viresh Kumar <viresh.kumar@linaro.org>
Signed-off-by: Bartosz Golaszewski <brgl@bgdev.pl>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpio/gpio-virtio.c | 6 +-----
 1 file changed, 1 insertion(+), 5 deletions(-)

diff --git a/drivers/gpio/gpio-virtio.c b/drivers/gpio/gpio-virtio.c
index d24f1c9264bc9..dd3b23c9580b1 100644
--- a/drivers/gpio/gpio-virtio.c
+++ b/drivers/gpio/gpio-virtio.c
@@ -81,11 +81,7 @@ static int _virtio_gpio_req(struct virtio_gpio *vgpio, u16 type, u16 gpio,
 	virtqueue_kick(vgpio->request_vq);
 	mutex_unlock(&vgpio->lock);
 
-	if (!wait_for_completion_timeout(&line->completion, HZ)) {
-		dev_err(dev, "GPIO operation timed out\n");
-		ret = -ETIMEDOUT;
-		goto out;
-	}
+	wait_for_completion(&line->completion);
 
 	if (unlikely(res->status != VIRTIO_GPIO_STATUS_OK)) {
 		dev_err(dev, "GPIO request failed: %d\n", gpio);
-- 
2.34.1



