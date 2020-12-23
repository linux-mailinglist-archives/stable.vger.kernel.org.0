Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 96A6A2E12B3
	for <lists+stable@lfdr.de>; Wed, 23 Dec 2020 03:27:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728963AbgLWCXh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 22 Dec 2020 21:23:37 -0500
Received: from mail.kernel.org ([198.145.29.99]:52452 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730034AbgLWCXg (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 22 Dec 2020 21:23:36 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id C4B9723333;
        Wed, 23 Dec 2020 02:23:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1608690200;
        bh=7CGrK35cEN11pVpSMg2wMmiuJgUhYG+i/WSrNIA4OIU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=btWFgjYCqgTZaskJ7AWgJA1h/rdwzDblsD1Ax/NAQvhWtS/BXvp0Jxxch67iFohhS
         uMFlb2XM2x/SCElowtFM5aeWzH5pxFuwQ6z6CKV5/vb2tCZScMxO/FGeEuLhoWCBgY
         S2TQF41MvedjHL8cai688m9mgiS74NiB9hJbbGRJXQXTsjEbM46y2+nWR8XiG124Gs
         cxk9eCCbG7MAxUKu1OLcfKdADlnXAogXlLpzkp0xnFn73cPxAXud2wm5x3emCx25xr
         n36dEtSp29JBavNXix5wWqvkuUrwMW/13La9dIfkxGmTdHv9IHY2DXsqr+XyxIavWg
         lp4x4q+AW7blw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        Sasha Levin <sashal@kernel.org>, linux-media@vger.kernel.org
Subject: [PATCH AUTOSEL 4.14 22/66] media: cec-core: first mark device unregistered, then wake up fhs
Date:   Tue, 22 Dec 2020 21:22:08 -0500
Message-Id: <20201223022253.2793452-22-sashal@kernel.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20201223022253.2793452-1-sashal@kernel.org>
References: <20201223022253.2793452-1-sashal@kernel.org>
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
 drivers/media/cec/cec-core.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/media/cec/cec-core.c b/drivers/media/cec/cec-core.c
index 648136e552d5b..7c585e05c6311 100644
--- a/drivers/media/cec/cec-core.c
+++ b/drivers/media/cec/cec-core.c
@@ -175,12 +175,12 @@ static void cec_devnode_unregister(struct cec_devnode *devnode)
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
 
 	cdev_device_del(&devnode->cdev, &devnode->dev);
-- 
2.27.0

