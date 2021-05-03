Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9D4D8371CB8
	for <lists+stable@lfdr.de>; Mon,  3 May 2021 18:56:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233718AbhECQ4k (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 May 2021 12:56:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:42992 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234314AbhECQwv (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 3 May 2021 12:52:51 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id EC41F61073;
        Mon,  3 May 2021 16:41:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1620060105;
        bh=OGZPhf9AAnvplo3tk4SDgZ6m8WAY3wshvN3+bs/qWjA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cV7bcnEbEDdY7vV7jRwkSFqIl2JYUFptL0Vdn175yIdR+J2Rxs7biLDdQ4QnhgqZj
         Wr8EY5a62v13jrg1kZuei7uSsqKjD5EMGlqPcvQq42r0bCnfZQ/itEy5EU5aj/mEeq
         j5Fus0ZTWdWFePrTh/1ISRF5lFvb+CboO3Pm30Tmp+DuJW4AfOhu6r6LiahuWzS2q6
         JD5O/wInF/loXukKnJ37x75ObDpJjYO2COiUv6KY7Pqqu0Wdr9fYxAk1IueALUMpKO
         Pbak57QbFNDy9fOsj+8P0I44E8ozBTGKFpMd1jDu0OVzryzkT9pDxI7j5JeHQ72OLw
         bkXYF3BhhKFPg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Yang Yingliang <yangyingliang@huawei.com>,
        Hulk Robot <hulkci@huawei.com>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        Sasha Levin <sashal@kernel.org>, linux-media@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 23/35] media: tc358743: fix possible use-after-free in tc358743_remove()
Date:   Mon,  3 May 2021 12:40:57 -0400
Message-Id: <20210503164109.2853838-23-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210503164109.2853838-1-sashal@kernel.org>
References: <20210503164109.2853838-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Yang Yingliang <yangyingliang@huawei.com>

[ Upstream commit 6107a4fdf8554a7aa9488bdc835bb010062fa8a9 ]

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
 drivers/media/i2c/tc358743.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/i2c/tc358743.c b/drivers/media/i2c/tc358743.c
index d9bc3851bf63..041b16965b96 100644
--- a/drivers/media/i2c/tc358743.c
+++ b/drivers/media/i2c/tc358743.c
@@ -2192,7 +2192,7 @@ static int tc358743_remove(struct i2c_client *client)
 		del_timer_sync(&state->timer);
 		flush_work(&state->work_i2c_poll);
 	}
-	cancel_delayed_work(&state->delayed_work_enable_hotplug);
+	cancel_delayed_work_sync(&state->delayed_work_enable_hotplug);
 	cec_unregister_adapter(state->cec_adap);
 	v4l2_async_unregister_subdev(sd);
 	v4l2_device_unregister_subdev(sd);
-- 
2.30.2

