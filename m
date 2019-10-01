Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8A68EC3D3B
	for <lists+stable@lfdr.de>; Tue,  1 Oct 2019 18:58:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731273AbfJAQlo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Oct 2019 12:41:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:53372 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731270AbfJAQln (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 1 Oct 2019 12:41:43 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 787A721906;
        Tue,  1 Oct 2019 16:41:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1569948103;
        bh=oSN9Cn1zQHdh/Pl1gG+9mshtPat0ykifj8O0qi2zwvE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=iEt6lSFvBVTJeAvWxCRv7ruAH4RHbyCTjEjXZoffrDRXFf6ZiVVIM+9mzjin8fu8l
         w0WHZXp3TjPjR2wsAcQQIa13lXKGzwuGSzdgTjJjAZWF45uESRhP9XbalU3n4Yu+1Q
         lJR2pfg5kThcZBef0xvXg2YPc0upEH9k8AARYRyI=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Dongsheng Yang <dongsheng.yang@easystack.cn>,
        Ilya Dryomov <idryomov@gmail.com>,
        Sasha Levin <sashal@kernel.org>, ceph-devel@vger.kernel.org,
        linux-block@vger.kernel.org
Subject: [PATCH AUTOSEL 5.2 14/63] rbd: fix response length parameter for encoded strings
Date:   Tue,  1 Oct 2019 12:40:36 -0400
Message-Id: <20191001164125.15398-14-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191001164125.15398-1-sashal@kernel.org>
References: <20191001164125.15398-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dongsheng Yang <dongsheng.yang@easystack.cn>

[ Upstream commit 5435d2069503e2aa89c34a94154f4f2fa4a0c9c4 ]

rbd_dev_image_id() allocates space for length but passes a smaller
value to rbd_obj_method_sync().  rbd_dev_v2_object_prefix() doesn't
allocate space for length.  Fix both to be consistent.

Signed-off-by: Dongsheng Yang <dongsheng.yang@easystack.cn>
Reviewed-by: Ilya Dryomov <idryomov@gmail.com>
Signed-off-by: Ilya Dryomov <idryomov@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/block/rbd.c | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/drivers/block/rbd.c b/drivers/block/rbd.c
index e5009a34f9c26..e78794bfcbbef 100644
--- a/drivers/block/rbd.c
+++ b/drivers/block/rbd.c
@@ -4696,17 +4696,20 @@ static int rbd_dev_v2_image_size(struct rbd_device *rbd_dev)
 
 static int rbd_dev_v2_object_prefix(struct rbd_device *rbd_dev)
 {
+	size_t size;
 	void *reply_buf;
 	int ret;
 	void *p;
 
-	reply_buf = kzalloc(RBD_OBJ_PREFIX_LEN_MAX, GFP_KERNEL);
+	/* Response will be an encoded string, which includes a length */
+	size = sizeof(__le32) + RBD_OBJ_PREFIX_LEN_MAX;
+	reply_buf = kzalloc(size, GFP_KERNEL);
 	if (!reply_buf)
 		return -ENOMEM;
 
 	ret = rbd_obj_method_sync(rbd_dev, &rbd_dev->header_oid,
 				  &rbd_dev->header_oloc, "get_object_prefix",
-				  NULL, 0, reply_buf, RBD_OBJ_PREFIX_LEN_MAX);
+				  NULL, 0, reply_buf, size);
 	dout("%s: rbd_obj_method_sync returned %d\n", __func__, ret);
 	if (ret < 0)
 		goto out;
@@ -5676,7 +5679,6 @@ static int rbd_dev_image_id(struct rbd_device *rbd_dev)
 	dout("rbd id object name is %s\n", oid.name);
 
 	/* Response will be an encoded string, which includes a length */
-
 	size = sizeof (__le32) + RBD_IMAGE_ID_LEN_MAX;
 	response = kzalloc(size, GFP_NOIO);
 	if (!response) {
@@ -5688,7 +5690,7 @@ static int rbd_dev_image_id(struct rbd_device *rbd_dev)
 
 	ret = rbd_obj_method_sync(rbd_dev, &oid, &rbd_dev->header_oloc,
 				  "get_id", NULL, 0,
-				  response, RBD_IMAGE_ID_LEN_MAX);
+				  response, size);
 	dout("%s: rbd_obj_method_sync returned %d\n", __func__, ret);
 	if (ret == -ENOENT) {
 		image_id = kstrdup("", GFP_KERNEL);
-- 
2.20.1

