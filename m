Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C949943F79
	for <lists+stable@lfdr.de>; Thu, 13 Jun 2019 17:58:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728997AbfFMP5p (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 13 Jun 2019 11:57:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:38000 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731501AbfFMIu1 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 13 Jun 2019 04:50:27 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9ECC620851;
        Thu, 13 Jun 2019 08:50:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1560415826;
        bh=EqveQuQ8vAwYp2bMan7+4CNOfmNfE00CvUUpSJw1APY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0TO+wGopfwoud3A4FHmsFJgoOyBi5x6Otdv5mclzUUIeHCbyJMXtTKd798lu03RTK
         mN18tBU2vbMZk9syeUs/nmw1N9p5z4TaJm5Int9G43Y2R/1szr8rEbQ4wN3p4BwumJ
         HrE54OkMHQ2Y8IaEGMAEJFtAigtcsWWXJBoR3iL4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dafna Hirschfeld <dafna3@gmail.com>,
        Paul Kocialkowski <paul.kocialkowski@bootlin.com>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab+samsung@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.1 137/155] media: v4l2-ctrl: v4l2_ctrl_request_setup returns with error upon failure
Date:   Thu, 13 Jun 2019 10:34:09 +0200
Message-Id: <20190613075700.376173009@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190613075652.691765927@linuxfoundation.org>
References: <20190613075652.691765927@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit 09ca38a50795a263d2b16dc95794dc5bc17c1d5c ]

If one of the controls fails to set,
then 'v4l2_ctrl_request_setup'
immediately returns with the error code.

Signed-off-by: Dafna Hirschfeld <dafna3@gmail.com>
Reviewed-by: Paul Kocialkowski <paul.kocialkowski@bootlin.com>
Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Signed-off-by: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/v4l2-core/v4l2-ctrls.c | 18 +++++++++++-------
 include/media/v4l2-ctrls.h           |  2 +-
 2 files changed, 12 insertions(+), 8 deletions(-)

diff --git a/drivers/media/v4l2-core/v4l2-ctrls.c b/drivers/media/v4l2-core/v4l2-ctrls.c
index b79d3bbd8350..54d66dbc2a31 100644
--- a/drivers/media/v4l2-core/v4l2-ctrls.c
+++ b/drivers/media/v4l2-core/v4l2-ctrls.c
@@ -3899,18 +3899,19 @@ void v4l2_ctrl_request_complete(struct media_request *req,
 }
 EXPORT_SYMBOL(v4l2_ctrl_request_complete);
 
-void v4l2_ctrl_request_setup(struct media_request *req,
+int v4l2_ctrl_request_setup(struct media_request *req,
 			     struct v4l2_ctrl_handler *main_hdl)
 {
 	struct media_request_object *obj;
 	struct v4l2_ctrl_handler *hdl;
 	struct v4l2_ctrl_ref *ref;
+	int ret = 0;
 
 	if (!req || !main_hdl)
-		return;
+		return 0;
 
 	if (WARN_ON(req->state != MEDIA_REQUEST_STATE_QUEUED))
-		return;
+		return -EBUSY;
 
 	/*
 	 * Note that it is valid if nothing was found. It means
@@ -3919,10 +3920,10 @@ void v4l2_ctrl_request_setup(struct media_request *req,
 	 */
 	obj = media_request_object_find(req, &req_ops, main_hdl);
 	if (!obj)
-		return;
+		return 0;
 	if (obj->completed) {
 		media_request_object_put(obj);
-		return;
+		return -EBUSY;
 	}
 	hdl = container_of(obj, struct v4l2_ctrl_handler, req_obj);
 
@@ -3990,12 +3991,15 @@ void v4l2_ctrl_request_setup(struct media_request *req,
 				update_from_auto_cluster(master);
 		}
 
-		try_or_set_cluster(NULL, master, true, 0);
-
+		ret = try_or_set_cluster(NULL, master, true, 0);
 		v4l2_ctrl_unlock(master);
+
+		if (ret)
+			break;
 	}
 
 	media_request_object_put(obj);
+	return ret;
 }
 EXPORT_SYMBOL(v4l2_ctrl_request_setup);
 
diff --git a/include/media/v4l2-ctrls.h b/include/media/v4l2-ctrls.h
index e5cae37ced2d..200f8a66ecaa 100644
--- a/include/media/v4l2-ctrls.h
+++ b/include/media/v4l2-ctrls.h
@@ -1127,7 +1127,7 @@ __poll_t v4l2_ctrl_poll(struct file *file, struct poll_table_struct *wait);
  * applying control values in a request is only applicable to memory-to-memory
  * devices.
  */
-void v4l2_ctrl_request_setup(struct media_request *req,
+int v4l2_ctrl_request_setup(struct media_request *req,
 			     struct v4l2_ctrl_handler *parent);
 
 /**
-- 
2.20.1



