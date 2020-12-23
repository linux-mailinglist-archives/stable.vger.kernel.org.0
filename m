Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D1DA12E13A1
	for <lists+stable@lfdr.de>; Wed, 23 Dec 2020 03:37:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729666AbgLWCcj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 22 Dec 2020 21:32:39 -0500
Received: from mail.kernel.org ([198.145.29.99]:55618 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730448AbgLWCZS (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 22 Dec 2020 21:25:18 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id C20932339D;
        Wed, 23 Dec 2020 02:24:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1608690277;
        bh=bfortx+wnC+TGOCt//qZ8vIqwkv0I4jomBOictlh65k=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=AMUBVodX/eEFEhjI3HFLzCM9ZdHdFPBWNUpacerZWjqdi/CaHRzwIOqbovKCbIlL8
         KMxDzneSX37Kx2IoSWthv97RWWq5RGpETcE5Vtfi9cpcOSQFlZaNahnq5M99j0La4m
         yNlBR2RzMKSH3Irdx6si6woQ593rIncw8IBf6otIFGsDtGBY4UzI7o2gpTbWhM1I6L
         ORYODpHVd1bRRGDIg3alJQaLW0WlC5ZEQpKg3N943bqx22nAHxqg4TfnZh7JteovpY
         d9vaSCd+cGUnAVHEOQiCoJly9+BZ3JhWiyFx0qKAO93nwNW4s6/Z5lMnrY/0mZyuav
         //k9uMxriHH5g==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        Sasha Levin <sashal@kernel.org>, linux-media@vger.kernel.org,
        devel@driverdev.osuosl.org
Subject: [PATCH AUTOSEL 4.9 17/48] media: cec-core: first mark device unregistered, then wake up fhs
Date:   Tue, 22 Dec 2020 21:23:45 -0500
Message-Id: <20201223022417.2794032-17-sashal@kernel.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20201223022417.2794032-1-sashal@kernel.org>
References: <20201223022417.2794032-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Hans Verkuil <hverkuil-cisco@xs4all.nl>

[ Upstream commit e91c255733d9bbb4978a372f44fb5ed689ccdbd1 ]

If a CEC device node is unregistered, then it should be marked as
unregistered before waking up any filehandles that are waiting for
an event.

This ensures that there is no race condition where an application can
call CEC_DQEVENT and have the ioctl return 0 instead of ENODEV.

Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/staging/media/cec/cec-core.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/media/cec/cec-core.c b/drivers/staging/media/cec/cec-core.c
index b0137e247dc9a..bb189f753c3ac 100644
--- a/drivers/staging/media/cec/cec-core.c
+++ b/drivers/staging/media/cec/cec-core.c
@@ -183,12 +183,12 @@ static void cec_devnode_unregister(struct cec_devnode *devnode)
 		mutex_unlock(&devnode->lock);
 		return;
 	}
+	devnode->registered = false;
+	devnode->unregistered = true;
 
 	list_for_each_entry(fh, &devnode->fhs, list)
 		wake_up_interruptible(&fh->wait);
 
-	devnode->registered = false;
-	devnode->unregistered = true;
 	mutex_unlock(&devnode->lock);
 
 	device_del(&devnode->dev);
-- 
2.27.0

