Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0325C328EB8
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 20:37:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242119AbhCATfR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 14:35:17 -0500
Received: from mail.kernel.org ([198.145.29.99]:49914 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241896AbhCAT3m (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 14:29:42 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 12BD765304;
        Mon,  1 Mar 2021 17:41:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614620513;
        bh=h4ZWlSYR2+h/Jw99zRo59+VmAS7yRMLLLQSuCh7kN4c=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CDe258L5Da3+3o+96HJJrBGut5lJaDMcn0jG4YKYxwSzUNJykzemf/JhWb1HTHAhE
         93uzbl2FsgkJcTyaiTjs8pPzAc7ZkHZ9ihQnWtYgTsvKCFXEPVwvXYjI95/nv2pH8U
         EmU01CFvM5RsLJKQOlGQQe3NbMcvKkwfc1cMi4zc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dan Carpenter <dan.carpenter@oracle.com>,
        Michael Tretter <m.tretter@pengutronix.de>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.11 181/775] media: allegro: Fix use after free on error
Date:   Mon,  1 Mar 2021 17:05:49 +0100
Message-Id: <20210301161210.574915391@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210301161201.679371205@linuxfoundation.org>
References: <20210301161201.679371205@linuxfoundation.org>
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



