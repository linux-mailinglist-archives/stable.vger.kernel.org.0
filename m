Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 077483788AD
	for <lists+stable@lfdr.de>; Mon, 10 May 2021 13:48:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234341AbhEJLWy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 May 2021 07:22:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:53450 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237073AbhEJLLS (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 10 May 2021 07:11:18 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 44EFA61624;
        Mon, 10 May 2021 11:06:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620644812;
        bh=Flj2XUniNDbetaM18kcPy5NuPj9fV4e9/VoYPU8LiEk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WEkLcqr73hPsv2sjA0UCkCwQ5DbRvFNw+O2KK45/t3rWqR2zuhVEMYoCQfNPUqAyj
         9QGIu7X16Mq9LwP4jZVA8vMj4RKbDufkJ8pHWvvumwhx4vnRlyGqnQpZYfexJff2RC
         nS1kiUadY++1af8eaqLUeQ9XpdbcDfmW64xnkBEY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dinghao Liu <dinghao.liu@zju.edu.cn>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.12 235/384] media: sun8i-di: Fix runtime PM imbalance in deinterlace_start_streaming
Date:   Mon, 10 May 2021 12:20:24 +0200
Message-Id: <20210510102022.635672292@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210510102014.849075526@linuxfoundation.org>
References: <20210510102014.849075526@linuxfoundation.org>
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
index ed863bf5ea80..671e4a928993 100644
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



