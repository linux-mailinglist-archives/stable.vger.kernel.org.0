Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2EADB261E7C
	for <lists+stable@lfdr.de>; Tue,  8 Sep 2020 21:52:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730722AbgIHTwQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Sep 2020 15:52:16 -0400
Received: from mail.kernel.org ([198.145.29.99]:38042 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730673AbgIHPtg (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 8 Sep 2020 11:49:36 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4AC6E24836;
        Tue,  8 Sep 2020 15:45:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1599579902;
        bh=cCRwyX5JqDlrIsMkrQUCSuP6rXkvUd/btO1Tmdo9eW8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Yw+oOx/zVgC1lv8h43wRRTIxz0rGZBNnNY7cF1fFwiKaYEbEjd6yfTL5sBrBYuWuA
         5euFW7qKyfAXYxn9zQFjJHnIJQBTfXSnfYXZClMcEKYzr8qN53xZULLHvYPCRAF5/6
         Va+8ubqsEUq3PznMbHQIza9A09si5ChBgbU9vUOM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ezequiel Garcia <ezequiel@collabora.com>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 050/129] media: cedrus: Add missing v4l2_ctrl_request_hdl_put()
Date:   Tue,  8 Sep 2020 17:24:51 +0200
Message-Id: <20200908152232.211011409@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200908152229.689878733@linuxfoundation.org>
References: <20200908152229.689878733@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ezequiel Garcia <ezequiel@collabora.com>

[ Upstream commit b30063976f29fc221a99d18d37d22ca035068aa9 ]

The check for a required control in the request was missing a call to
v4l2_ctrl_request_hdl_put() in the error path. Fix it.

Fixes: 50e761516f2b8c ("media: platform: Add Cedrus VPU decoder driver")
Signed-off-by: Ezequiel Garcia <ezequiel@collabora.com>
Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/staging/media/sunxi/cedrus/cedrus.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/staging/media/sunxi/cedrus/cedrus.c b/drivers/staging/media/sunxi/cedrus/cedrus.c
index 3439f6ad63380..e80e82a276e93 100644
--- a/drivers/staging/media/sunxi/cedrus/cedrus.c
+++ b/drivers/staging/media/sunxi/cedrus/cedrus.c
@@ -159,6 +159,7 @@ static int cedrus_request_validate(struct media_request *req)
 	struct v4l2_ctrl *ctrl_test;
 	unsigned int count;
 	unsigned int i;
+	int ret = 0;
 
 	list_for_each_entry(obj, &req->objects, list) {
 		struct vb2_buffer *vb;
@@ -203,12 +204,16 @@ static int cedrus_request_validate(struct media_request *req)
 		if (!ctrl_test) {
 			v4l2_info(&ctx->dev->v4l2_dev,
 				  "Missing required codec control\n");
-			return -ENOENT;
+			ret = -ENOENT;
+			break;
 		}
 	}
 
 	v4l2_ctrl_request_hdl_put(hdl);
 
+	if (ret)
+		return ret;
+
 	return vb2_request_validate(req);
 }
 
-- 
2.25.1



