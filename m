Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4FC85BAA54
	for <lists+stable@lfdr.de>; Sun, 22 Sep 2019 21:53:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727516AbfIVTY4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 22 Sep 2019 15:24:56 -0400
Received: from mail.kernel.org ([198.145.29.99]:51850 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2407954AbfIVSwk (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 22 Sep 2019 14:52:40 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3C3E021D7C;
        Sun, 22 Sep 2019 18:52:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1569178360;
        bh=NGBREgQg0xhG35aIKc6l9+XMVXAo93KnADau3xrhzVk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=01SlzL044mnGDP5vfZp3XHx4njkNWJdfzjWqwgVAH+0ny5TIVpbHk023IyEhLYkCD
         qlms0/hkLHuz5blezR1sHjdCW/hu8PsOj0iHN9Z/sP39WDSZnBWxVhFVv19nVFB1VY
         BJPhpzgwG9niJvZDjtbQhjqnbqzUvZ3MzlcjNjog=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Wenwen Wang <wenwen@cs.uga.edu>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab+samsung@kernel.org>,
        Sasha Levin <sashal@kernel.org>, linux-media@vger.kernel.org
Subject: [PATCH AUTOSEL 5.2 114/185] media: cpia2_usb: fix memory leaks
Date:   Sun, 22 Sep 2019 14:48:12 -0400
Message-Id: <20190922184924.32534-114-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190922184924.32534-1-sashal@kernel.org>
References: <20190922184924.32534-1-sashal@kernel.org>
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
index 17468f7d78ed2..3ab80a7b44985 100644
--- a/drivers/media/usb/cpia2/cpia2_usb.c
+++ b/drivers/media/usb/cpia2/cpia2_usb.c
@@ -676,6 +676,10 @@ static int submit_urbs(struct camera_data *cam)
 		if (!urb) {
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

