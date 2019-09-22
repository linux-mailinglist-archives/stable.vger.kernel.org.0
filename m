Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EE095BA7D7
	for <lists+stable@lfdr.de>; Sun, 22 Sep 2019 21:49:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2395114AbfIVTAR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 22 Sep 2019 15:00:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:35878 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2395109AbfIVTAQ (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 22 Sep 2019 15:00:16 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 617E7206C2;
        Sun, 22 Sep 2019 19:00:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1569178816;
        bh=ErDtY2kpllQvvj4z6lp/isxmwDgPqnbmLsd+yvJXw78=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rJb0B5/wZ3qcIa2c7flh9OTg4oupcstvvVmSN8carhhBwOB7UwnLnXWIc1DJvKTNf
         JKena2JH1QncpKclpYn5qXKra70VM2s09zZOypWy4PaVVEGg8SkQLwggvDuN5cnmfP
         FvR3M8Ccyz9SSYmDpwLXixxHZ4G4Gw6XBlvaLFIQ=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        syzbot+79d18aac4bf1770dd050@syzkaller.appspotmail.com,
        Mauro Carvalho Chehab <mchehab+samsung@kernel.org>,
        Sasha Levin <sashal@kernel.org>, linux-media@vger.kernel.org
Subject: [PATCH AUTOSEL 4.9 29/60] media: hdpvr: add terminating 0 at end of string
Date:   Sun, 22 Sep 2019 14:59:02 -0400
Message-Id: <20190922185934.4305-29-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190922185934.4305-1-sashal@kernel.org>
References: <20190922185934.4305-1-sashal@kernel.org>
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
index 7b34108f6587e..99171b912a2d8 100644
--- a/drivers/media/usb/hdpvr/hdpvr-core.c
+++ b/drivers/media/usb/hdpvr/hdpvr-core.c
@@ -143,6 +143,7 @@ static int device_authorization(struct hdpvr_device *dev)
 
 	dev->fw_ver = dev->usbc_buf[1];
 
+	dev->usbc_buf[46] = '\0';
 	v4l2_info(&dev->v4l2_dev, "firmware version 0x%x dated %s\n",
 			  dev->fw_ver, &dev->usbc_buf[2]);
 
-- 
2.20.1

