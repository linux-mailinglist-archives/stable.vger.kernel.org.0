Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DD128C3CA4
	for <lists+stable@lfdr.de>; Tue,  1 Oct 2019 18:54:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727380AbfJAQx0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Oct 2019 12:53:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:55436 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732268AbfJAQnY (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 1 Oct 2019 12:43:24 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B078D21924;
        Tue,  1 Oct 2019 16:43:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1569948203;
        bh=G5VaTwfS5O/XxUYXqnwGpmGX3h20JN+8pFptTAtSvIo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=sP97qoQrvjWoSi4/a1W/bOfOgoiJVCvkRKX7zX8GPBztzJ67NDTSbNn7hePDx2keJ
         Lz097muGjUw1NcIgdfhyPujP8G0Hon6mu3okOg2/YsJmkx6ZJmAxTG3ZNz0+UxwT8+
         kIb08SoomY+ohlEKsDrK4RDNoYGp9bbqFk+uFM9o=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Dongsheng Yang <dongsheng.yang@easystack.cn>,
        Ilya Dryomov <idryomov@gmail.com>,
        Sasha Levin <sashal@kernel.org>, ceph-devel@vger.kernel.org,
        linux-block@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 10/43] rbd: fix response length parameter for encoded strings
Date:   Tue,  1 Oct 2019 12:42:38 -0400
Message-Id: <20191001164311.15993-10-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191001164311.15993-1-sashal@kernel.org>
References: <20191001164311.15993-1-sashal@kernel.org>
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
index 585378bc988cd..3d01ad6a3bcfc 100644
--- a/drivers/block/rbd.c
+++ b/drivers/block/rbd.c
@@ -4510,17 +4510,20 @@ static int rbd_dev_v2_image_size(struct rbd_device *rbd_dev)
 
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
@@ -5489,7 +5492,6 @@ static int rbd_dev_image_id(struct rbd_device *rbd_dev)
 	dout("rbd id object name is %s\n", oid.name);
 
 	/* Response will be an encoded string, which includes a length */
-
 	size = sizeof (__le32) + RBD_IMAGE_ID_LEN_MAX;
 	response = kzalloc(size, GFP_NOIO);
 	if (!response) {
@@ -5501,7 +5503,7 @@ static int rbd_dev_image_id(struct rbd_device *rbd_dev)
 
 	ret = rbd_obj_method_sync(rbd_dev, &oid, &rbd_dev->header_oloc,
 				  "get_id", NULL, 0,
-				  response, RBD_IMAGE_ID_LEN_MAX);
+				  response, size);
 	dout("%s: rbd_obj_method_sync returned %d\n", __func__, ret);
 	if (ret == -ENOENT) {
 		image_id = kstrdup("", GFP_KERNEL);
-- 
2.20.1

