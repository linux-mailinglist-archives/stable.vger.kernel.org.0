Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 493B3371D31
	for <lists+stable@lfdr.de>; Mon,  3 May 2021 19:01:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234551AbhECQ6K (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 May 2021 12:58:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:43030 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235295AbhECQ4J (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 3 May 2021 12:56:09 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B4FC76196A;
        Mon,  3 May 2021 16:43:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1620060197;
        bh=4z/ycUZ7/q9+pbbzp4P379DE3gn4uLBgDMv3QLkQ/dc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GdKogSMsaswhDNRj6VC5vWvfpCYAmG1rFXnP4weqQc80v5/Arnn4wo80XyA8Na07D
         Sdnv2UXwiGvtXGR0t0EIzbccy1IawtW9dCjhCV8XJOAkcLzjiQK1L1XxeA2eZMROgc
         cF8y8C+tD2t98eKhzZ8D56FmOP94S8vgw6Z7SnAWrw5QoWlLuVHbb7KrbDqB83stKA
         0BYAIm/+s2J9EPzllGHcqhpPPiNJOjrhNQwehtsra1rNYMenlz+l8YwvG1lG90S/BT
         +vt+XlH6YllkDDv1O4Emf1kuIXPNda0sY7Q4EAGAFTHNLQUmaxZ+/n8si/jNURXNeD
         hGC7XeAvEMPww==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Yang Yingliang <yangyingliang@huawei.com>,
        Hulk Robot <hulkci@huawei.com>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        Sasha Levin <sashal@kernel.org>, linux-media@vger.kernel.org
Subject: [PATCH AUTOSEL 4.9 17/24] media: i2c: adv7511-v4l2: fix possible use-after-free in adv7511_remove()
Date:   Mon,  3 May 2021 12:42:45 -0400
Message-Id: <20210503164252.2854487-17-sashal@kernel.org>
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
index b87c9e7ff146..e81c4cca50c6 100644
--- a/drivers/media/i2c/adv7511-v4l2.c
+++ b/drivers/media/i2c/adv7511-v4l2.c
@@ -1976,7 +1976,7 @@ static int adv7511_remove(struct i2c_client *client)
 
 	adv7511_set_isr(sd, false);
 	adv7511_init_setup(sd);
-	cancel_delayed_work(&state->edid_handler);
+	cancel_delayed_work_sync(&state->edid_handler);
 	i2c_unregister_device(state->i2c_edid);
 	if (state->i2c_cec)
 		i2c_unregister_device(state->i2c_cec);
-- 
2.30.2

