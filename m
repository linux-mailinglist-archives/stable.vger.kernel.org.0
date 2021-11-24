Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5485245BFFB
	for <lists+stable@lfdr.de>; Wed, 24 Nov 2021 14:01:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343593AbhKXNEA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Nov 2021 08:04:00 -0500
Received: from mail.kernel.org ([198.145.29.99]:41110 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1346807AbhKXNCV (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 24 Nov 2021 08:02:21 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8BA04619E9;
        Wed, 24 Nov 2021 12:35:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637757346;
        bh=7NmHKJhBuQmvjxD9pIk7Xc7mYPo+QYRzuSCsYcyqECk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=V4Vhp0jfTodNrUyQ2ggRPvcW6N64r/XwlM6ByL8ROzJSOYH6wG8k+VjvnNgZKza5k
         mVkG9MA7PX8SzhWU2FwmCgZZJ2+yDz8kNAIlhNlMBj5Hv2ZZ0uH6mvRsSBUZwiWgIZ
         4vO82kc3/EWeUoqLf2bfJ3ZzF3O4TDmn5sGdDSJw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Colin Ian King <colin.king@canonical.com>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 137/323] media: em28xx: Dont use ops->suspend if it is NULL
Date:   Wed, 24 Nov 2021 12:55:27 +0100
Message-Id: <20211124115723.553657243@linuxfoundation.org>
X-Mailer: git-send-email 2.34.0
In-Reply-To: <20211124115718.822024889@linuxfoundation.org>
References: <20211124115718.822024889@linuxfoundation.org>
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
index d0f95a5cb4d23..437651307056f 100644
--- a/drivers/media/usb/em28xx/em28xx-core.c
+++ b/drivers/media/usb/em28xx/em28xx-core.c
@@ -1151,8 +1151,9 @@ int em28xx_suspend_extension(struct em28xx *dev)
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



