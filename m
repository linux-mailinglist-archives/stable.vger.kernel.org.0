Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 81C64371C3E
	for <lists+stable@lfdr.de>; Mon,  3 May 2021 18:51:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233094AbhECQvu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 May 2021 12:51:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:60824 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234537AbhECQuY (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 3 May 2021 12:50:24 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id F2EF961921;
        Mon,  3 May 2021 16:40:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1620060046;
        bh=xseuWw6JTctMg95ZrT7pyFQc/T1B8tchwseyoJPfux8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JSH99/SW08i4TqN6w0IMc66ddwRD22cRxt3TSr+mVeGpEYfFZPcj4BLiqsI6Lp0ss
         af9JrB4JihKHBcTMVTMYoEEOHwXrp1WHRrF/I9upEZiIMREkwVDzfgnGFMEudj7AHc
         PGyclBnOip6pafNYu6fLGGwhurY8/Ajt/zpeGv4N70wOuBg8bCCDVVTACJQaIdKp0q
         rY2rIAiVjWNd0AeJInFjBuFUVbydgB/+HKZ65r4+GXxrLq9fGQ5LMYu4HqWF2nYrZq
         QCKMcKxw4mzjvoXUcAwwWDeKCZhz+FS4rY8g3vD0ITiN29J8RCOpDNIveY+PrbE+3g
         PCbVyZiERVUOw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Yang Yingliang <yangyingliang@huawei.com>,
        Hulk Robot <hulkci@huawei.com>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        Sasha Levin <sashal@kernel.org>, linux-media@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 42/57] media: i2c: adv7842: fix possible use-after-free in adv7842_remove()
Date:   Mon,  3 May 2021 12:39:26 -0400
Message-Id: <20210503163941.2853291-42-sashal@kernel.org>
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

[ Upstream commit 4a15275b6a18597079f18241c87511406575179a ]

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
 drivers/media/i2c/adv7842.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/i2c/adv7842.c b/drivers/media/i2c/adv7842.c
index 885619841719..02cbab826d0b 100644
--- a/drivers/media/i2c/adv7842.c
+++ b/drivers/media/i2c/adv7842.c
@@ -3586,7 +3586,7 @@ static int adv7842_remove(struct i2c_client *client)
 	struct adv7842_state *state = to_state(sd);
 
 	adv7842_irq_enable(sd, false);
-	cancel_delayed_work(&state->delayed_work_enable_hotplug);
+	cancel_delayed_work_sync(&state->delayed_work_enable_hotplug);
 	v4l2_device_unregister_subdev(sd);
 	media_entity_cleanup(&sd->entity);
 	adv7842_unregister_clients(sd);
-- 
2.30.2

