Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9CEEB371D2F
	for <lists+stable@lfdr.de>; Mon,  3 May 2021 19:01:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234620AbhECQ6J (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 May 2021 12:58:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:42992 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235292AbhECQ4J (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 3 May 2021 12:56:09 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 22FBD6196C;
        Mon,  3 May 2021 16:43:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1620060196;
        bh=tcIqoDhSdlnMtI/Ic/0nYuj/89dWfHyaRrv7gQ4v1Z0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Aven5qdSQV0IF7u3Nlkc0Filvp2E5kuPGUOebnDQ6F/aFaMVrI3ZDZC/2RJq5Kr4B
         odQuZwIzVR3vx9a5govdqtl70ZEf3nlYD7C7tJELTW8CPFteay6A7rX7leg4w7f8iS
         r1m4h5onOF+asW6Bsb7eUC8tUr1+49DGCHjZTGoyfmU4HNSLVKXGXR5G8LMMkNDUKm
         tjCoXp73JBTs1X2zgL4+OJrUy2Ypma/7AnTft+OsSMlw80Ry0xTrUW4ZoxaHY6w+q4
         NqDXn0Nhx4MqCtapgw2u/uRFQFuPSlsLyEiymzbN/e237dftMwCgh7f98xLc37xuLs
         D9utPgA/Wlklw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Yang Yingliang <yangyingliang@huawei.com>,
        Hulk Robot <hulkci@huawei.com>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        Sasha Levin <sashal@kernel.org>, linux-media@vger.kernel.org
Subject: [PATCH AUTOSEL 4.9 16/24] media: adv7604: fix possible use-after-free in adv76xx_remove()
Date:   Mon,  3 May 2021 12:42:44 -0400
Message-Id: <20210503164252.2854487-16-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210503164252.2854487-1-sashal@kernel.org>
References: <20210503164252.2854487-1-sashal@kernel.org>
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
index ce6f93074ae0..56b8b7bf759e 100644
--- a/drivers/media/i2c/adv7604.c
+++ b/drivers/media/i2c/adv7604.c
@@ -3541,7 +3541,7 @@ static int adv76xx_remove(struct i2c_client *client)
 	io_write(sd, 0x6e, 0);
 	io_write(sd, 0x73, 0);
 
-	cancel_delayed_work(&state->delayed_work_enable_hotplug);
+	cancel_delayed_work_sync(&state->delayed_work_enable_hotplug);
 	v4l2_async_unregister_subdev(sd);
 	media_entity_cleanup(&sd->entity);
 	adv76xx_unregister_clients(to_state(sd));
-- 
2.30.2

