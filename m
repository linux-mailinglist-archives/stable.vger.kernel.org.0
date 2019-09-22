Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7189BBA6A3
	for <lists+stable@lfdr.de>; Sun, 22 Sep 2019 21:46:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392985AbfIVSv7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 22 Sep 2019 14:51:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:50312 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2392977AbfIVSv6 (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 22 Sep 2019 14:51:58 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 914FA222C1;
        Sun, 22 Sep 2019 18:51:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1569178318;
        bh=hjmpnAIp7H1b+RS9Gb7JtQbLwf8dNp2GOvMS39yQNrM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=wrAJUvtL4Ar4nEAuYpQwQ8hdSlMBy10JcYx8ynlEa/HeV4rpHYmrX+d8Er6Tv0y8o
         +SqnywmtI2jgeVnLZJzKBHVxs7FrwXB3/6KETOWkMaxcl9GSW29goamELfCXfTfTnY
         ONuftq2GZg13hbdCdLFy8e3ELo6vxzcujVd88Nrc=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        syzbot+79d18aac4bf1770dd050@syzkaller.appspotmail.com,
        Mauro Carvalho Chehab <mchehab+samsung@kernel.org>,
        Sasha Levin <sashal@kernel.org>, linux-media@vger.kernel.org
Subject: [PATCH AUTOSEL 5.2 085/185] media: hdpvr: add terminating 0 at end of string
Date:   Sun, 22 Sep 2019 14:47:43 -0400
Message-Id: <20190922184924.32534-85-sashal@kernel.org>
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

From: Hans Verkuil <hverkuil-cisco@xs4all.nl>

[ Upstream commit 8b8900b729e4f31f12ac1127bde137c775c327e6 ]

dev->usbc_buf was passed as argument for %s, but it was not safeguarded
by a terminating 0.

This caused this syzbot issue:

https://syzkaller.appspot.com/bug?extid=79d18aac4bf1770dd050

Reported-and-tested-by: syzbot+79d18aac4bf1770dd050@syzkaller.appspotmail.com

Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Signed-off-by: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/usb/hdpvr/hdpvr-core.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/media/usb/hdpvr/hdpvr-core.c b/drivers/media/usb/hdpvr/hdpvr-core.c
index a0905c81d2cb2..b75c18a012a73 100644
--- a/drivers/media/usb/hdpvr/hdpvr-core.c
+++ b/drivers/media/usb/hdpvr/hdpvr-core.c
@@ -137,6 +137,7 @@ static int device_authorization(struct hdpvr_device *dev)
 
 	dev->fw_ver = dev->usbc_buf[1];
 
+	dev->usbc_buf[46] = '\0';
 	v4l2_info(&dev->v4l2_dev, "firmware version 0x%x dated %s\n",
 			  dev->fw_ver, &dev->usbc_buf[2]);
 
-- 
2.20.1

