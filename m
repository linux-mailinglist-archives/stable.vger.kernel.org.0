Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EB8E03C4538
	for <lists+stable@lfdr.de>; Mon, 12 Jul 2021 08:22:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235300AbhGLGYp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Jul 2021 02:24:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:37526 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234750AbhGLGXq (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Jul 2021 02:23:46 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 098F56113C;
        Mon, 12 Jul 2021 06:20:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626070822;
        bh=Kfq4+vFQ/+PIcxjEuUir11AQzB6rvxUK1mBV1FAM6gw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=zcC8/5UHLKTsFpnzwtu4PAUYFRaZtBnpRVWqiYe/vwyf80nm0Evsu9nUjBpYoj7ng
         Ud3k8f/7vvZFKwUaQYB4WdB6bEt7Nl2A0VcTmCu9raRxCxVRIJ6cw5J07UQ7bG3HNK
         xx0J23k1vTnu3mFFlEv0rdEiMPLO5/Hoa8/aeJGU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dan Carpenter <dan.carpenter@oracle.com>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 154/348] media: au0828: fix a NULL vs IS_ERR() check
Date:   Mon, 12 Jul 2021 08:08:58 +0200
Message-Id: <20210712060721.502432533@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210712060659.886176320@linuxfoundation.org>
References: <20210712060659.886176320@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dan Carpenter <dan.carpenter@oracle.com>

[ Upstream commit 8f2e452730d2bcd59fe05246f0e19a4c52e0012d ]

The media_device_usb_allocate() function returns error pointers when
it's enabled and something goes wrong.  It can return NULL as well, but
only if CONFIG_MEDIA_CONTROLLER is disabled so that doesn't apply here.

Fixes: 812658d88d26 ("media: change au0828 to use Media Device Allocator API")
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/usb/au0828/au0828-core.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/media/usb/au0828/au0828-core.c b/drivers/media/usb/au0828/au0828-core.c
index a8a72d5fbd12..caefac07af92 100644
--- a/drivers/media/usb/au0828/au0828-core.c
+++ b/drivers/media/usb/au0828/au0828-core.c
@@ -199,8 +199,8 @@ static int au0828_media_device_init(struct au0828_dev *dev,
 	struct media_device *mdev;
 
 	mdev = media_device_usb_allocate(udev, KBUILD_MODNAME, THIS_MODULE);
-	if (!mdev)
-		return -ENOMEM;
+	if (IS_ERR(mdev))
+		return PTR_ERR(mdev);
 
 	dev->media_dev = mdev;
 #endif
-- 
2.30.2



