Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 85BFE328D87
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 20:13:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241175AbhCATNA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 14:13:00 -0500
Received: from mail.kernel.org ([198.145.29.99]:39680 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241122AbhCATIQ (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 14:08:16 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id AA27265194;
        Mon,  1 Mar 2021 17:10:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614618607;
        bh=h4ZWlSYR2+h/Jw99zRo59+VmAS7yRMLLLQSuCh7kN4c=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bpoD/1e26GQ9yj98F8rmxUZIbyPF3rdptCgr7XtlsCuA2KRxHQVijr+GMzQ9UiSdp
         rUNQsCZldnGx4n910Cf8l3gvzz7bzyNg5yvVCDI7qcePwDyNyRvBehZg+3YizlHmRN
         U48bXWoen1wFXS3/2CCfP7DuPCrljCisVLKVHKWY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dan Carpenter <dan.carpenter@oracle.com>,
        Michael Tretter <m.tretter@pengutronix.de>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 148/663] media: allegro: Fix use after free on error
Date:   Mon,  1 Mar 2021 17:06:36 +0100
Message-Id: <20210301161149.094815852@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210301161141.760350206@linuxfoundation.org>
References: <20210301161141.760350206@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dan Carpenter <dan.carpenter@oracle.com>

[ Upstream commit ce814ad4bb52bfc7c0472e6da0aa742ab88f4361 ]

The "channel" is added to the "dev->channels" but then if
v4l2_m2m_ctx_init() fails then we free "channel" but it's still on the
list so it could lead to a use after free.  Let's not add it to the
list until after v4l2_m2m_ctx_init() succeeds.

Fixes: cc62c74749a3 ("media: allegro: add missed checks in allegro_open()")
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Reviewed-by: Michael Tretter <m.tretter@pengutronix.de>
Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/staging/media/allegro-dvt/allegro-core.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/staging/media/allegro-dvt/allegro-core.c b/drivers/staging/media/allegro-dvt/allegro-core.c
index 9f718f43282bc..640451134072b 100644
--- a/drivers/staging/media/allegro-dvt/allegro-core.c
+++ b/drivers/staging/media/allegro-dvt/allegro-core.c
@@ -2483,8 +2483,6 @@ static int allegro_open(struct file *file)
 	INIT_LIST_HEAD(&channel->buffers_reference);
 	INIT_LIST_HEAD(&channel->buffers_intermediate);
 
-	list_add(&channel->list, &dev->channels);
-
 	channel->fh.m2m_ctx = v4l2_m2m_ctx_init(dev->m2m_dev, channel,
 						allegro_queue_init);
 
@@ -2493,6 +2491,7 @@ static int allegro_open(struct file *file)
 		goto error;
 	}
 
+	list_add(&channel->list, &dev->channels);
 	file->private_data = &channel->fh;
 	v4l2_fh_add(&channel->fh);
 
-- 
2.27.0



