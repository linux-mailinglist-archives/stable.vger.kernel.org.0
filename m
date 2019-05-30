Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 50A7C2EECD
	for <lists+stable@lfdr.de>; Thu, 30 May 2019 05:50:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729661AbfE3DuG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 29 May 2019 23:50:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:57408 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732101AbfE3DUA (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 29 May 2019 23:20:00 -0400
Received: from localhost (ip67-88-213-2.z213-88-67.customer.algx.net [67.88.213.2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9A58B24905;
        Thu, 30 May 2019 03:19:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1559186399;
        bh=o4fi0g2p2e7kj7BIN5dxvkwBx3Nj9p6CmJ1glO/bds0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ivo1Xa+AogLK4R0FKasqBUrUUQIizcsLYq4y4WVKuF5y05GYD55PX5Kcvwr149LrD
         pFizLxFgweRZDAL13EEm/n8Q5D5wbUY3SH3fWmGtegLtbGXVRbaQZB0qWNGIoeQ1Cz
         2ZAMIqbl81KchvF2Yg8llAeeCsqBLuudCaiiMH6A=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Mauro Carvalho Chehab <mchehab+samsung@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 181/193] media: vimc: zero the media_device on probe
Date:   Wed, 29 May 2019 20:07:15 -0700
Message-Id: <20190530030512.748251914@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190530030446.953835040@linuxfoundation.org>
References: <20190530030446.953835040@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit f74267b51cb36321f777807b2e04ca02167ecc08 ]

The media_device is part of a static global vimc_device struct.
The media framework expects this to be zeroed before it is
used, however, since this is a global this is not the case if
vimc is unbound and then bound again.

So call memset to ensure any left-over values are cleared.

Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Reviewed-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Signed-off-by: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/platform/vimc/vimc-core.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/media/platform/vimc/vimc-core.c b/drivers/media/platform/vimc/vimc-core.c
index 51c0eee61ca67..57e5d6a020b0e 100644
--- a/drivers/media/platform/vimc/vimc-core.c
+++ b/drivers/media/platform/vimc/vimc-core.c
@@ -302,6 +302,8 @@ static int vimc_probe(struct platform_device *pdev)
 
 	dev_dbg(&pdev->dev, "probe");
 
+	memset(&vimc->mdev, 0, sizeof(vimc->mdev));
+
 	/* Create platform_device for each entity in the topology*/
 	vimc->subdevs = devm_kcalloc(&vimc->pdev.dev, vimc->pipe_cfg->num_ents,
 				     sizeof(*vimc->subdevs), GFP_KERNEL);
-- 
2.20.1



