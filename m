Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 981E637844E
	for <lists+stable@lfdr.de>; Mon, 10 May 2021 12:51:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232904AbhEJKv2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 May 2021 06:51:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:41704 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233203AbhEJKtv (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 10 May 2021 06:49:51 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6C250619D2;
        Mon, 10 May 2021 10:38:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620643110;
        bh=pnU9lood80HhbEnlhYAl1vyRpRzo4Er1YBUOOWUprhI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=l1z72IgSvsdNvnlgIBJYW4+3TXVyJMUT0ykEA/gsB5ORR+ooFXaZoGUIauOLtj7hV
         bQpT/6wEATJhfpPMEVFAIYHWyGe6FnKjDuQMG2tE7dB84D+KvDM/7qlXD1ST7H575f
         yXwy27Cqxi9nsrLluEXbomJCKYxP+P5EWpoyeP8s=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dinghao Liu <dinghao.liu@zju.edu.cn>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 182/299] media: sun8i-di: Fix runtime PM imbalance in deinterlace_start_streaming
Date:   Mon, 10 May 2021 12:19:39 +0200
Message-Id: <20210510102010.969519680@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210510102004.821838356@linuxfoundation.org>
References: <20210510102004.821838356@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dinghao Liu <dinghao.liu@zju.edu.cn>

[ Upstream commit f1995d5e43cf897f63b4d7a7f84a252d891ae820 ]

pm_runtime_get_sync() will increase the runtime PM counter
even it returns an error. Thus a pairing decrement is needed
to prevent refcount leak. Fix this by replacing this API with
pm_runtime_resume_and_get(), which will not change the runtime
PM counter on error.

Signed-off-by: Dinghao Liu <dinghao.liu@zju.edu.cn>
Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/platform/sunxi/sun8i-di/sun8i-di.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/platform/sunxi/sun8i-di/sun8i-di.c b/drivers/media/platform/sunxi/sun8i-di/sun8i-di.c
index ba5d07886607..2c159483c56b 100644
--- a/drivers/media/platform/sunxi/sun8i-di/sun8i-di.c
+++ b/drivers/media/platform/sunxi/sun8i-di/sun8i-di.c
@@ -589,7 +589,7 @@ static int deinterlace_start_streaming(struct vb2_queue *vq, unsigned int count)
 	int ret;
 
 	if (V4L2_TYPE_IS_OUTPUT(vq->type)) {
-		ret = pm_runtime_get_sync(dev);
+		ret = pm_runtime_resume_and_get(dev);
 		if (ret < 0) {
 			dev_err(dev, "Failed to enable module\n");
 
-- 
2.30.2



