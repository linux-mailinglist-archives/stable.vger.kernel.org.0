Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 48A29371CBB
	for <lists+stable@lfdr.de>; Mon,  3 May 2021 18:56:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233800AbhECQ4l (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 May 2021 12:56:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:43030 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232381AbhECQwx (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 3 May 2021 12:52:53 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 79C9A613BA;
        Mon,  3 May 2021 16:41:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1620060106;
        bh=FioYxK1JVl1Z9iYz7eBh+7t5FbD8I6Vku1QOl4rzR48=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PVywVjg1qFHhB891cVL/oB0VZNYIbl9QiSsFVdMhJROVAVHclddXCPJbgsq9Q65cT
         HSDkbVDamzykuhrXZ0eK1448hg/nohghZnR0ycTURSKLzuGzbiu/l19mm5Y9ZIbWl7
         Kldx0KKHKhKI9oBSKOPG0S2cT42A5VccN5w1nJbLvISNqDB0+UMsFLQiO/J8fELdIs
         MkOZWFH1k0/xKGJJC4xWW2MWdJ+a+Ii3BwiZilazdjzZ0bpHMmQSZr1nevFDirsbon
         DeQpVszIrAT5qcEQO/lESgM4SPqk1vl1stQ/BDGAyw+dswW6VCUMkX9ITGFGll4Q+w
         NR1OOVcqayIkg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Yang Yingliang <yangyingliang@huawei.com>,
        Hulk Robot <hulkci@huawei.com>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        Sasha Levin <sashal@kernel.org>, linux-media@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 24/35] media: adv7604: fix possible use-after-free in adv76xx_remove()
Date:   Mon,  3 May 2021 12:40:58 -0400
Message-Id: <20210503164109.2853838-24-sashal@kernel.org>
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
index a4b0a89c7e7e..04577d409e63 100644
--- a/drivers/media/i2c/adv7604.c
+++ b/drivers/media/i2c/adv7604.c
@@ -3560,7 +3560,7 @@ static int adv76xx_remove(struct i2c_client *client)
 	io_write(sd, 0x6e, 0);
 	io_write(sd, 0x73, 0);
 
-	cancel_delayed_work(&state->delayed_work_enable_hotplug);
+	cancel_delayed_work_sync(&state->delayed_work_enable_hotplug);
 	v4l2_async_unregister_subdev(sd);
 	media_entity_cleanup(&sd->entity);
 	adv76xx_unregister_clients(to_state(sd));
-- 
2.30.2

