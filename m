Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 686A6BA83B
	for <lists+stable@lfdr.de>; Sun, 22 Sep 2019 21:49:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2439067AbfIVTBs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 22 Sep 2019 15:01:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:38098 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2439068AbfIVTBr (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 22 Sep 2019 15:01:47 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4E3392070C;
        Sun, 22 Sep 2019 19:01:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1569178907;
        bh=NSukmqKx85zf26wnhrsuHIwKRjUlm+nK4EgIzbL9UfQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=BP5kB8MS7MLRjbPdlxTtjmWS+lzPmXn/GvkjQlSfT7a4F2gMlIa6bQ7+ZgVGDi5c0
         bISTN1pcSohWPeephbOJY/fyxVa6dQHRbi3XguaDPZmPl6YUTDAKcMaLBgIhNtrlDS
         sUZegqYy1nl1JropB8WKfacXo5Wh6WzbzgOgD6WA=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Wenwen Wang <wenwen@cs.uga.edu>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab+samsung@kernel.org>,
        Sasha Levin <sashal@kernel.org>, linux-media@vger.kernel.org
Subject: [PATCH AUTOSEL 4.4 27/44] media: cpia2_usb: fix memory leaks
Date:   Sun, 22 Sep 2019 15:00:45 -0400
Message-Id: <20190922190103.4906-27-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190922190103.4906-1-sashal@kernel.org>
References: <20190922190103.4906-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Wenwen Wang <wenwen@cs.uga.edu>

[ Upstream commit 1c770f0f52dca1a2323c594f01f5ec6f1dddc97f ]

In submit_urbs(), 'cam->sbuf[i].data' is allocated through kmalloc_array().
However, it is not deallocated if the following allocation for urbs fails.
To fix this issue, free 'cam->sbuf[i].data' if usb_alloc_urb() fails.

Signed-off-by: Wenwen Wang <wenwen@cs.uga.edu>
Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Signed-off-by: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/usb/cpia2/cpia2_usb.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/media/usb/cpia2/cpia2_usb.c b/drivers/media/usb/cpia2/cpia2_usb.c
index 41ea00ac3a873..76b9cb940b871 100644
--- a/drivers/media/usb/cpia2/cpia2_usb.c
+++ b/drivers/media/usb/cpia2/cpia2_usb.c
@@ -665,6 +665,10 @@ static int submit_urbs(struct camera_data *cam)
 			ERR("%s: usb_alloc_urb error!\n", __func__);
 			for (j = 0; j < i; j++)
 				usb_free_urb(cam->sbuf[j].urb);
+			for (j = 0; j < NUM_SBUF; j++) {
+				kfree(cam->sbuf[j].data);
+				cam->sbuf[j].data = NULL;
+			}
 			return -ENOMEM;
 		}
 
-- 
2.20.1

