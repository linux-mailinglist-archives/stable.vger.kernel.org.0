Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 67B4E371CBF
	for <lists+stable@lfdr.de>; Mon,  3 May 2021 18:56:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233884AbhECQ4p (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 May 2021 12:56:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:43042 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233018AbhECQwx (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 3 May 2021 12:52:53 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6FC18613F6;
        Mon,  3 May 2021 16:41:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1620060109;
        bh=evni02BbwAdeZIzay0TcfA75MDlrzK9isldoS+5pYSw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=oV8MUvsIr36VgV5mrVyWMJW5nrPj1LbhJSUYgLkB0S8doun8HKgX3VEi43c6M5DCt
         JG/XIZL9XYeCg8uFOkGyZcbFrCcR79sOCkLrNPH4nst/0w92Tz+lRIKurnP+PtQI/d
         3tTZeYuIUkj7XQTmr4aHkbn3qHklWU4IVOrlMVj5TsBSucmfbytwlTUaapYBYumpED
         1jZfsdHXbu3vSkY+rY3nKQCfIg6HEZZ0wTE95QFv038WaUZdkkRyvkcgXCozy5nE/y
         0+1sclIAB1Ra9M0mSJvB2UVVi4pIGS18NNF+njT3oUaDv5KU3xX8d+HAouSzMqnNib
         bSvdw/7gObElA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Yang Yingliang <yangyingliang@huawei.com>,
        Hulk Robot <hulkci@huawei.com>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        Sasha Levin <sashal@kernel.org>, linux-media@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 26/35] media: i2c: adv7842: fix possible use-after-free in adv7842_remove()
Date:   Mon,  3 May 2021 12:41:00 -0400
Message-Id: <20210503164109.2853838-26-sashal@kernel.org>
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
index 58662ba92d4f..d0ed20652ddb 100644
--- a/drivers/media/i2c/adv7842.c
+++ b/drivers/media/i2c/adv7842.c
@@ -3585,7 +3585,7 @@ static int adv7842_remove(struct i2c_client *client)
 	struct adv7842_state *state = to_state(sd);
 
 	adv7842_irq_enable(sd, false);
-	cancel_delayed_work(&state->delayed_work_enable_hotplug);
+	cancel_delayed_work_sync(&state->delayed_work_enable_hotplug);
 	v4l2_device_unregister_subdev(sd);
 	media_entity_cleanup(&sd->entity);
 	adv7842_unregister_clients(sd);
-- 
2.30.2

