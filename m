Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C0DCD45267A
	for <lists+stable@lfdr.de>; Tue, 16 Nov 2021 03:02:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353125AbhKPCFv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 21:05:51 -0500
Received: from mail.kernel.org ([198.145.29.99]:46102 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239590AbhKOSDU (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 13:03:20 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2853E632DC;
        Mon, 15 Nov 2021 17:37:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1636997859;
        bh=WO2y0uvcQ1d6dDu+zn/6OUKWEAokJ2mdcLkMGr1QBZQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qxdBalck8LWLe2oECgOeBI9ESqXjSiy9KIB1grso+uWcawxDBWhd4OO6QTS3aB/Bb
         Y8M6f/Lo8gIVm9G4yX69Ie4qqOMX9BvIQWfuj60lJzyhK9KauPYF0ZAsW6tNHaA0v3
         j4/4Yq7j33CfG3NOWUCsgAkt5A9Eu4O+2bwuVuN8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Colin Ian King <colin.king@canonical.com>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 302/575] media: em28xx: Dont use ops->suspend if it is NULL
Date:   Mon, 15 Nov 2021 18:00:27 +0100
Message-Id: <20211115165354.223718995@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211115165343.579890274@linuxfoundation.org>
References: <20211115165343.579890274@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Colin Ian King <colin.king@canonical.com>

[ Upstream commit 51fa3b70d27342baf1ea8aaab3e96e5f4f26d5b2 ]

The call to ops->suspend for the dev->dev_next case can currently
trigger a call on a null function pointer if ops->suspend is null.
Skip over the use of function ops->suspend if it is null.

Addresses-Coverity: ("Dereference after null check")

Fixes: be7fd3c3a8c5 ("media: em28xx: Hauppauge DualHD second tuner functionality")
Signed-off-by: Colin Ian King <colin.king@canonical.com>
Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/usb/em28xx/em28xx-core.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/media/usb/em28xx/em28xx-core.c b/drivers/media/usb/em28xx/em28xx-core.c
index 3daa64bb1e1d9..af9216278024f 100644
--- a/drivers/media/usb/em28xx/em28xx-core.c
+++ b/drivers/media/usb/em28xx/em28xx-core.c
@@ -1152,8 +1152,9 @@ int em28xx_suspend_extension(struct em28xx *dev)
 	dev_info(&dev->intf->dev, "Suspending extensions\n");
 	mutex_lock(&em28xx_devlist_mutex);
 	list_for_each_entry(ops, &em28xx_extension_devlist, next) {
-		if (ops->suspend)
-			ops->suspend(dev);
+		if (!ops->suspend)
+			continue;
+		ops->suspend(dev);
 		if (dev->dev_next)
 			ops->suspend(dev->dev_next);
 	}
-- 
2.33.0



