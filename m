Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E931E371CFA
	for <lists+stable@lfdr.de>; Mon,  3 May 2021 18:57:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233013AbhECQ5g (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 May 2021 12:57:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:44506 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234943AbhECQzO (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 3 May 2021 12:55:14 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id BF45061940;
        Mon,  3 May 2021 16:42:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1620060157;
        bh=8TY0t/Ba2F9x7+OvzxIpXR9RQFp4mudCZseaX2LGbz8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=IHWjRLNPB5Q3mucHH3i6ARsWnuNppGqNtxFABR7Qtv2ryIjkEmBbmyyDH82BLvq08
         50UW/Irv68oDik00sjEnSuozhP61jT/k8MYkCrllbbpZU6i4uoqxz7YPmM9s9Bg6Qw
         hQ4/1tBIx0dbgw1kBQsguMAXxNXD9zIiwWL2OFfumjc6QDOstx+kuDA+zK8Izt4r7T
         RNGZKY1rNH2kU+eMUmRZ0al5IQbwVAjRyHOQdKiKRuZ3WaEshOFVLqap840whPZ5J7
         Q44Fi0WJ9ZaQOeUgDjgP+pk/Ks/RLD3kois2HA92uejiic1svbEyBPGn+UyBc9w0FR
         uFjDzGpoVbM6w==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Yang Yingliang <yangyingliang@huawei.com>,
        Hulk Robot <hulkci@huawei.com>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        Sasha Levin <sashal@kernel.org>, linux-media@vger.kernel.org
Subject: [PATCH AUTOSEL 4.14 22/31] media: adv7604: fix possible use-after-free in adv76xx_remove()
Date:   Mon,  3 May 2021 12:41:55 -0400
Message-Id: <20210503164204.2854178-22-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210503164204.2854178-1-sashal@kernel.org>
References: <20210503164204.2854178-1-sashal@kernel.org>
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
index 26c3ec573a56..3078d47d090a 100644
--- a/drivers/media/i2c/adv7604.c
+++ b/drivers/media/i2c/adv7604.c
@@ -3557,7 +3557,7 @@ static int adv76xx_remove(struct i2c_client *client)
 	io_write(sd, 0x6e, 0);
 	io_write(sd, 0x73, 0);
 
-	cancel_delayed_work(&state->delayed_work_enable_hotplug);
+	cancel_delayed_work_sync(&state->delayed_work_enable_hotplug);
 	v4l2_async_unregister_subdev(sd);
 	media_entity_cleanup(&sd->entity);
 	adv76xx_unregister_clients(to_state(sd));
-- 
2.30.2

