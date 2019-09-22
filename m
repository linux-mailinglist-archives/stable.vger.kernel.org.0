Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2D9C5BA5B7
	for <lists+stable@lfdr.de>; Sun, 22 Sep 2019 21:45:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388984AbfIVSpG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 22 Sep 2019 14:45:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:40660 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388972AbfIVSpG (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 22 Sep 2019 14:45:06 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9E67E2186A;
        Sun, 22 Sep 2019 18:45:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1569177905;
        bh=u/cx5Fx7ocHi7GpON+az0NLHqlFEw3vSZrk3Gb0TNFw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tqjr/rYYPEt0cQjYnDh8mwN91wo4bjRv4mPMTQMKfe1bIYieiDIH5K1eViyqJJuET
         dybP2jRDxiMb+EvAvk5x5bjXL8weqlKofZfKy7nbIqCeL7Om2XZpyRTywMMANi8tYE
         WqfkjwU1bxlEGHdZKEmdV5dzTqxWV8n+B5KtUgOs=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Luke Nowakowski-Krijger <lnowakow@eng.ucsd.edu>,
        syzbot+aac8d0d7205f112045d2@syzkaller.appspotmail.com,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab+samsung@kernel.org>,
        Sasha Levin <sashal@kernel.org>, linux-media@vger.kernel.org
Subject: [PATCH AUTOSEL 5.3 022/203] media: hdpvr: Add device num check and handling
Date:   Sun, 22 Sep 2019 14:40:48 -0400
Message-Id: <20190922184350.30563-22-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190922184350.30563-1-sashal@kernel.org>
References: <20190922184350.30563-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Luke Nowakowski-Krijger <lnowakow@eng.ucsd.edu>

[ Upstream commit d4a6a9537bc32811486282206ecfb7c53754b74d ]

Add hdpvr device num check and error handling

We need to increment the device count atomically before we checkout a
device to make sure that we do not reach the max count, otherwise we get
out-of-bounds errors as reported by syzbot.

Reported-and-tested-by: syzbot+aac8d0d7205f112045d2@syzkaller.appspotmail.com

Signed-off-by: Luke Nowakowski-Krijger <lnowakow@eng.ucsd.edu>
Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Signed-off-by: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/usb/hdpvr/hdpvr-core.c | 12 +++++++++++-
 1 file changed, 11 insertions(+), 1 deletion(-)

diff --git a/drivers/media/usb/hdpvr/hdpvr-core.c b/drivers/media/usb/hdpvr/hdpvr-core.c
index 9b9d894d29bcb..a0905c81d2cb2 100644
--- a/drivers/media/usb/hdpvr/hdpvr-core.c
+++ b/drivers/media/usb/hdpvr/hdpvr-core.c
@@ -271,6 +271,7 @@ static int hdpvr_probe(struct usb_interface *interface,
 #endif
 	size_t buffer_size;
 	int i;
+	int dev_num;
 	int retval = -ENOMEM;
 
 	/* allocate memory for our device state and initialize it */
@@ -368,8 +369,17 @@ static int hdpvr_probe(struct usb_interface *interface,
 	}
 #endif
 
+	dev_num = atomic_inc_return(&dev_nr);
+	if (dev_num >= HDPVR_MAX) {
+		v4l2_err(&dev->v4l2_dev,
+			 "max device number reached, device register failed\n");
+		atomic_dec(&dev_nr);
+		retval = -ENODEV;
+		goto reg_fail;
+	}
+
 	retval = hdpvr_register_videodev(dev, &interface->dev,
-				    video_nr[atomic_inc_return(&dev_nr)]);
+				    video_nr[dev_num]);
 	if (retval < 0) {
 		v4l2_err(&dev->v4l2_dev, "registering videodev failed\n");
 		goto reg_fail;
-- 
2.20.1

