Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E6AAF378441
	for <lists+stable@lfdr.de>; Mon, 10 May 2021 12:50:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232941AbhEJKvS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 May 2021 06:51:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:59374 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232951AbhEJKtR (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 10 May 2021 06:49:17 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 85268619C4;
        Mon, 10 May 2021 10:38:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620643094;
        bh=j5njG6kfjfeKS8Pe74lDvSoVoXEqAO/FDdLBo589vLg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Hryk/7bqDAqz7a2F4P9IyUxmhMNdLiIEt4iyLrscpuECWSFL1WF7pkKWMKeyJc9xd
         Bp+8fyy1r1QU13cOZdlXC0adjmgThdD+W0B/EV5C0jXJnZT6Tw4U4zdkxTBrjyhvea
         ESen6qdwep58uETN00kuyzjXA4K4rsnsexJ2bVkc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hulk Robot <hulkci@huawei.com>,
        Yang Yingliang <yangyingliang@huawei.com>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 176/299] media: tc358743: fix possible use-after-free in tc358743_remove()
Date:   Mon, 10 May 2021 12:19:33 +0200
Message-Id: <20210510102010.770371950@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210510102004.821838356@linuxfoundation.org>
References: <20210510102004.821838356@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
index 831b5b54fd78..1b309bb743c7 100644
--- a/drivers/media/i2c/tc358743.c
+++ b/drivers/media/i2c/tc358743.c
@@ -2193,7 +2193,7 @@ static int tc358743_remove(struct i2c_client *client)
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



