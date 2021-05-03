Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 54A67371C36
	for <lists+stable@lfdr.de>; Mon,  3 May 2021 18:51:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233352AbhECQvo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 May 2021 12:51:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:35394 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234405AbhECQuK (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 3 May 2021 12:50:10 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1FF4F6191D;
        Mon,  3 May 2021 16:40:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1620060040;
        bh=vTb31YzKtHMvMdueKvKNtoz0SHfmU8NPxkhT+E+o4yk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=eWkNfB7VaIkbQNKR3JG6e/Lxt2WoogOdOpI7Oqe883lORXavEqKTLvAqzRm4fwxu1
         cwP1Rq0wyioC5fpEOx+/VGyhZ2e8iZVMuHSUZDXUaCL0N0s2TZYSKNJNAbb8wsIiHC
         m3qf3RxWOKH5G8bGjjl6s2/sxpubYJibHtfBOkIdVknzs0xsQQnfCev99lr0oVlQV9
         QRrP0id9fEi0nPANWpQiJGIshhvbkphmzNR6dGRFGR4x9b49DEJ/0oCY/2xN+Eheux
         1klYQYcuX0C02luSLH6+AcVfYOmPRTFnFbMxdPu2mgMQOBIWL8JZIP/BqNJ2Z568zW
         99U6Xj/2/ENBw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Yang Yingliang <yangyingliang@huawei.com>,
        Hulk Robot <hulkci@huawei.com>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        Sasha Levin <sashal@kernel.org>, linux-media@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 38/57] media: tc358743: fix possible use-after-free in tc358743_remove()
Date:   Mon,  3 May 2021 12:39:22 -0400
Message-Id: <20210503163941.2853291-38-sashal@kernel.org>
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
index cff99cf61ed4..114c084c4aec 100644
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

