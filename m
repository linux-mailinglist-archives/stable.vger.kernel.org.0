Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 85BCD73FC4
	for <lists+stable@lfdr.de>; Wed, 24 Jul 2019 22:35:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729215AbfGXTZ5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Jul 2019 15:25:57 -0400
Received: from mail.kernel.org ([198.145.29.99]:42892 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726371AbfGXTZ4 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 24 Jul 2019 15:25:56 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 57DAA22387;
        Wed, 24 Jul 2019 19:25:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1563996355;
        bh=wzqwrX74dR3G7OHB5fz38U9yevnkrxg3WmYhEN7OhUA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=X3R9iMkn+gSskNjfyoSDfeqSUSjd8RET4JtBOB3bXMY5JiBMFAWfUcIGBrAL+MytP
         EdFVVCIvO5VLMWjudz7/cAoHt9wya6afU+1G8fasPiAWGko9i3GLthmU6xJSkFjzoR
         Rv+Aav8NZqp2wh0RK8WyXztxq1iFu/yhoBkxrFEU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Jae Hyun Yoo <jae.hyun.yoo@linux.intel.com>,
        Eddie James <eajames@linux.ibm.com>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab+samsung@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.2 067/413] media: aspeed: change irq to threaded irq
Date:   Wed, 24 Jul 2019 21:15:58 +0200
Message-Id: <20190724191739.967570464@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190724191735.096702571@linuxfoundation.org>
References: <20190724191735.096702571@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit 12ae1c1bf5db2f33fcd9092a96f630291c4b181a ]

Differently from other Aspeed drivers, this driver calls clock
control APIs in interrupt context. Since ECLK is coupled with a
reset bit in clk-aspeed module, aspeed_clk_enable will make 10ms of
busy waiting delay for triggering the reset and it will eventually
disturb other drivers' interrupt handling. To fix this issue, this
commit changes this driver's irq to threaded irq so that the delay
can be happened in a thread context.

Signed-off-by: Jae Hyun Yoo <jae.hyun.yoo@linux.intel.com>
Reviewed-by: Eddie James <eajames@linux.ibm.com>
Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Signed-off-by: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/platform/aspeed-video.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/media/platform/aspeed-video.c b/drivers/media/platform/aspeed-video.c
index 8144fe36ad48..76d7512c82a3 100644
--- a/drivers/media/platform/aspeed-video.c
+++ b/drivers/media/platform/aspeed-video.c
@@ -1589,8 +1589,9 @@ static int aspeed_video_init(struct aspeed_video *video)
 		return -ENODEV;
 	}
 
-	rc = devm_request_irq(dev, irq, aspeed_video_irq, IRQF_SHARED,
-			      DEVICE_NAME, video);
+	rc = devm_request_threaded_irq(dev, irq, NULL, aspeed_video_irq,
+				       IRQF_ONESHOT | IRQF_SHARED, DEVICE_NAME,
+				       video);
 	if (rc < 0) {
 		dev_err(dev, "Unable to request IRQ %d\n", irq);
 		return rc;
-- 
2.20.1



