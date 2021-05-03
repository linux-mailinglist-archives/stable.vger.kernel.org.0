Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0802D371C38
	for <lists+stable@lfdr.de>; Mon,  3 May 2021 18:51:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231851AbhECQvp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 May 2021 12:51:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:60624 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234509AbhECQuO (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 3 May 2021 12:50:14 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A2CFB61919;
        Mon,  3 May 2021 16:40:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1620060041;
        bh=a4qec0eUaW4CGkoQVdxPSVWNPWbA1sfc9ehNFfyDrzw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KrVYlsIJ06htKSFbFarvawUKzgPe76OsX3r/ce7dHT4rESSfOA4ZAZCGd1obZnBER
         O8Sh0NS+IJ7xDdC31NyeHWkmE/hgL0LJHNpyYYZ28KZuyLR5GGMexjbDW9UEKxKESw
         UiOiJVFMFT7Lp1+GjpNeqEl9isMnctplaPbWTBNSPwN4y2bbGbAONOObKUSov6A9y5
         Lg/CRJGAjZtb4/wfBZt0FoZIox0RvoFvPDOMcGgBPQdaVArM+S6P1bWH89ulwMT0xp
         YBghAqLjR9nHuNJ0x/X/qLpKBzmsTORLElLSOaJ3PWeG4dTqkOy5XswYT6O+9NLC+A
         0FVvivF0zybFg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Yang Yingliang <yangyingliang@huawei.com>,
        Hulk Robot <hulkci@huawei.com>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        Sasha Levin <sashal@kernel.org>, linux-media@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 39/57] media: adv7604: fix possible use-after-free in adv76xx_remove()
Date:   Mon,  3 May 2021 12:39:23 -0400
Message-Id: <20210503163941.2853291-39-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210503163941.2853291-1-sashal@kernel.org>
References: <20210503163941.2853291-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Yang Yingliang <yangyingliang@huawei.com>

[ Upstream commit fa56f5f1fe31c2050675fa63b84963ebd504a5b3 ]

This driver's remove path calls cancel_delayed_work(). However, that
function does not wait until the work function finishes. This means
that the callback function may still be running after the driver's
remove function has finished, which would result in a use-after-free.

Fix by calling cancel_delayed_work_sync(), which ensures that
the work is properly cancelled, no longer running, and unable
to re-schedule itself.

Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/i2c/adv7604.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/i2c/adv7604.c b/drivers/media/i2c/adv7604.c
index 2dedd6ebb236..b887299ac195 100644
--- a/drivers/media/i2c/adv7604.c
+++ b/drivers/media/i2c/adv7604.c
@@ -3606,7 +3606,7 @@ static int adv76xx_remove(struct i2c_client *client)
 	io_write(sd, 0x6e, 0);
 	io_write(sd, 0x73, 0);
 
-	cancel_delayed_work(&state->delayed_work_enable_hotplug);
+	cancel_delayed_work_sync(&state->delayed_work_enable_hotplug);
 	v4l2_async_unregister_subdev(sd);
 	media_entity_cleanup(&sd->entity);
 	adv76xx_unregister_clients(to_state(sd));
-- 
2.30.2

