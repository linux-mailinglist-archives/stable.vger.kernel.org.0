Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 32933CACE4
	for <lists+stable@lfdr.de>; Thu,  3 Oct 2019 19:47:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731561AbfJCRbR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 3 Oct 2019 13:31:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:59660 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387618AbfJCQKV (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 3 Oct 2019 12:10:21 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 915AE215EA;
        Thu,  3 Oct 2019 16:10:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1570119021;
        bh=XT86kEpiNU0DwRGGQv65OB+v1DaHSodQuRRLnE4WgMo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=IoG8NCiYeKFIa3E/shLh+pMbGk4c6pDnNWXVhBVQdJYisDDV54sZPzEbleFSI8uHy
         lBru/BvBmgf+uiz8trJ1oucZxyh2Ra3rlhk+KRc+vl1i3JaD8NOMnrHEApEwzJdKv4
         Ivp4gB068XnO/fOMNAaUeJaDjqCAd4KWHR53MDTs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab+samsung@kernel.org>,
        Sasha Levin <sashal@kernel.org>,
        syzbot+79d18aac4bf1770dd050@syzkaller.appspotmail.com
Subject: [PATCH 4.14 097/185] media: hdpvr: add terminating 0 at end of string
Date:   Thu,  3 Oct 2019 17:52:55 +0200
Message-Id: <20191003154500.436507794@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191003154437.541662648@linuxfoundation.org>
References: <20191003154437.541662648@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
index 416092c47ef40..dd82948b1cb05 100644
--- a/drivers/media/usb/hdpvr/hdpvr-core.c
+++ b/drivers/media/usb/hdpvr/hdpvr-core.c
@@ -141,6 +141,7 @@ static int device_authorization(struct hdpvr_device *dev)
 
 	dev->fw_ver = dev->usbc_buf[1];
 
+	dev->usbc_buf[46] = '\0';
 	v4l2_info(&dev->v4l2_dev, "firmware version 0x%x dated %s\n",
 			  dev->fw_ver, &dev->usbc_buf[2]);
 
-- 
2.20.1



