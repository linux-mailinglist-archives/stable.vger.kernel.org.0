Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 21972328819
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 18:37:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238342AbhCARcv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 12:32:51 -0500
Received: from mail.kernel.org ([198.145.29.99]:49390 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238422AbhCAR1B (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 12:27:01 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 388BE6508C;
        Mon,  1 Mar 2021 16:51:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614617474;
        bh=CYai9BKE8NdzACpse8j7nuN1npzCJfMHli3YH2Emq/c=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QWfym69ogxbZ60O7cEfMm0oFTmLQ2UMnjtG+oOG6PuXsLWEKab9Fk5B1saL3o+4Wy
         GZ3SdVK7NhEiPizXTvg+ZAds8U4cnamfhKEGHLGlZV0L8jhG6yaLYPO2XkWlFA8BWF
         wgGa8eC3YJxGya15GXU+O81caeyraL1iaWyHaUmM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dinghao Liu <dinghao.liu@zju.edu.cn>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 086/340] media: media/pci: Fix memleak in empress_init
Date:   Mon,  1 Mar 2021 17:10:30 +0100
Message-Id: <20210301161052.558675614@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210301161048.294656001@linuxfoundation.org>
References: <20210301161048.294656001@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dinghao Liu <dinghao.liu@zju.edu.cn>

[ Upstream commit 15d0c52241ecb1c9d802506bff6f5c3f7872c0df ]

When vb2_queue_init() fails, dev->empress_dev
should be released just like other error handling
paths.

Fixes: 2ada815fc48bb ("[media] saa7134: convert to vb2")
Signed-off-by: Dinghao Liu <dinghao.liu@zju.edu.cn>
Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/pci/saa7134/saa7134-empress.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/media/pci/saa7134/saa7134-empress.c b/drivers/media/pci/saa7134/saa7134-empress.c
index cb65d345fd3e9..e2666d1c68964 100644
--- a/drivers/media/pci/saa7134/saa7134-empress.c
+++ b/drivers/media/pci/saa7134/saa7134-empress.c
@@ -282,8 +282,11 @@ static int empress_init(struct saa7134_dev *dev)
 	q->lock = &dev->lock;
 	q->dev = &dev->pci->dev;
 	err = vb2_queue_init(q);
-	if (err)
+	if (err) {
+		video_device_release(dev->empress_dev);
+		dev->empress_dev = NULL;
 		return err;
+	}
 	dev->empress_dev->queue = q;
 	dev->empress_dev->device_caps = V4L2_CAP_READWRITE | V4L2_CAP_STREAMING |
 					V4L2_CAP_VIDEO_CAPTURE;
-- 
2.27.0



