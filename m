Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0DF28371D4F
	for <lists+stable@lfdr.de>; Mon,  3 May 2021 19:01:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234682AbhECQ6j (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 May 2021 12:58:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:45566 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233619AbhECQ43 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 3 May 2021 12:56:29 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C2BC86140E;
        Mon,  3 May 2021 16:43:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1620060224;
        bh=o2t2W2YyIFJIlQucS6TNKdg6QFtpsMeIboeh/CYstVU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WgBrIn22PlZCpT6AIqDEHj8lKzhSdTjy1aHgWt4K6G5vfIpbJJbEF0ojy3Yy24JGk
         vBXi/LmLoIh5SC3qyeo9y44p4Z0aZ5UlrPnXbVIBZh+fL+wAx1FqTUNkn8Ku2w5Wem
         t8hmUY0pcHhJUcU1kwRrrg1GBMLNEfcReXXj4cn7KXsMRkcxYHXVWCoP4avFudfFcG
         mOkkt2PYOoxaRQbXJFRaKFR8WpdEMma1018zmhraiW7mOynkqV8SkW+ANxYuVUN/Tg
         cblru5ZLtGmn/VElr90xdu5HNsaOVmP94F/3xWM655nT3xmpHawwHXAUfr0gt/9pAp
         +Q86w2CbXXK1g==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Yang Yingliang <yangyingliang@huawei.com>,
        Hulk Robot <hulkci@huawei.com>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        Sasha Levin <sashal@kernel.org>, linux-media@vger.kernel.org
Subject: [PATCH AUTOSEL 4.4 10/16] media: i2c: adv7511-v4l2: fix possible use-after-free in adv7511_remove()
Date:   Mon,  3 May 2021 12:43:23 -0400
Message-Id: <20210503164329.2854739-10-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210503164329.2854739-1-sashal@kernel.org>
References: <20210503164329.2854739-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Yang Yingliang <yangyingliang@huawei.com>

[ Upstream commit 2c9541720c66899adf6f3600984cf3ef151295ad ]

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
 drivers/media/i2c/adv7511-v4l2.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/i2c/adv7511-v4l2.c b/drivers/media/i2c/adv7511-v4l2.c
index b35400e4e9af..e85777dfe81d 100644
--- a/drivers/media/i2c/adv7511-v4l2.c
+++ b/drivers/media/i2c/adv7511-v4l2.c
@@ -1570,7 +1570,7 @@ static int adv7511_remove(struct i2c_client *client)
 		 client->addr << 1, client->adapter->name);
 
 	adv7511_init_setup(sd);
-	cancel_delayed_work(&state->edid_handler);
+	cancel_delayed_work_sync(&state->edid_handler);
 	i2c_unregister_device(state->i2c_edid);
 	i2c_unregister_device(state->i2c_pktmem);
 	destroy_workqueue(state->work_queue);
-- 
2.30.2

