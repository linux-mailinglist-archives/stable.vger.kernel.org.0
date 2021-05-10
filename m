Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C8CB137888B
	for <lists+stable@lfdr.de>; Mon, 10 May 2021 13:48:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234198AbhEJLWJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 May 2021 07:22:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:49920 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237207AbhEJLLf (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 10 May 2021 07:11:35 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3F0C461883;
        Mon, 10 May 2021 11:08:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620644893;
        bh=kW+Kz7+iyT/blgzYJhQ6JJtZ8Tz4bngwHmfpwDRDbB8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=T7Lt/xFx6nVyPmOfnyQi6CzOSeVsL7SThZ3pj5Kd8Zbpw5cGDziTtYgjgpnD5Bkvc
         UgAmTi00yiXZ14MUfXQ9rFMuM9qvC5mHRXNHFsXOVzEptXEXk0f+csrFBfYJey82/g
         22crBTLa5GS7bclzk7zqytMtJ4MWIXxUuvMsHxUA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hulk Robot <hulkci@huawei.com>,
        Yang Yingliang <yangyingliang@huawei.com>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.12 233/384] media: i2c: adv7842: fix possible use-after-free in adv7842_remove()
Date:   Mon, 10 May 2021 12:20:22 +0200
Message-Id: <20210510102022.573929827@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210510102014.849075526@linuxfoundation.org>
References: <20210510102014.849075526@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
index 0855f648416d..f7d2b6cd3008 100644
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



