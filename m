Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CD646371C3D
	for <lists+stable@lfdr.de>; Mon,  3 May 2021 18:51:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232453AbhECQvt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 May 2021 12:51:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:60760 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234532AbhECQuS (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 3 May 2021 12:50:18 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 703DA61628;
        Mon,  3 May 2021 16:40:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1620060044;
        bh=4KlBC0WUa0ro5p4CMyIxeEkz8qtxpYGBJcTcLS8FXA0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=h83YZWhXrQuZq1mcrBRVSA6fj6QpzDqVI4w6kp/33LdE8VjTTpCQBEDD2OZJfE6kx
         ZM4Y/UMBBiXGxHkNmoCTJvJHx6L/XaYFqHrhr+4pymfrTUoAELCec72DKPGesWM0mO
         xagxTyFd7HGyoIcptWDr9lHb3qd9tDJfFs1EHhcfYJJ7uPUzWurv6C8Y15TxShuW9j
         l7OTDzXzwrbXUTEh4mgXhHlAJPkdzB6b5q+0f9cRKjH6rH80re+n9aO5syGA0GWSEk
         mE/pMYbR9xxBIhNF1ohKtm1TaBlqTaIJnVWLWj6ITmWPVIHQtPJvOMKI7gMIdlkamd
         6JE8mfUcFt3VQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Yang Yingliang <yangyingliang@huawei.com>,
        Hulk Robot <hulkci@huawei.com>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        Sasha Levin <sashal@kernel.org>, linux-media@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 41/57] media: i2c: tda1997: Fix possible use-after-free in tda1997x_remove()
Date:   Mon,  3 May 2021 12:39:25 -0400
Message-Id: <20210503163941.2853291-41-sashal@kernel.org>
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

[ Upstream commit 7f820ab5d4eebfe2d970d32a76ae496a6c286f0f ]

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
 drivers/media/i2c/tda1997x.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/i2c/tda1997x.c b/drivers/media/i2c/tda1997x.c
index 5e68182001ec..e43d8327b810 100644
--- a/drivers/media/i2c/tda1997x.c
+++ b/drivers/media/i2c/tda1997x.c
@@ -2804,7 +2804,7 @@ static int tda1997x_remove(struct i2c_client *client)
 	media_entity_cleanup(&sd->entity);
 	v4l2_ctrl_handler_free(&state->hdl);
 	regulator_bulk_disable(TDA1997X_NUM_SUPPLIES, state->supplies);
-	cancel_delayed_work(&state->delayed_work_enable_hpd);
+	cancel_delayed_work_sync(&state->delayed_work_enable_hpd);
 	mutex_destroy(&state->page_lock);
 	mutex_destroy(&state->lock);
 
-- 
2.30.2

