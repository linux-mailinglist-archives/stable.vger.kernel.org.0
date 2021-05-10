Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3E2D5378445
	for <lists+stable@lfdr.de>; Mon, 10 May 2021 12:50:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233004AbhEJKvW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 May 2021 06:51:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:41454 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233167AbhEJKtl (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 10 May 2021 06:49:41 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id BF0AA6145C;
        Mon, 10 May 2021 10:38:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620643101;
        bh=TbnfRyrVPiZhBN1/T3YrOQ5IbnGguP1qyaLCMaCnOYc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=e8Roq9h7wsky3RndkjBRBr1usU3beJiYaWzxVR9fx0dr3DeHhzqXgOC3jib4xTvMu
         i84jb/r5KWNsn35aKWo+FgLX4ctX8kl2qGTgQifxzGb/SbBZrSGywNrCCfWRzRv5ks
         hCDy4bcPF2CKeJcSe5HF419JZLUSWSX9mpMi9jXU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hulk Robot <hulkci@huawei.com>,
        Yang Yingliang <yangyingliang@huawei.com>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 178/299] media: i2c: adv7511-v4l2: fix possible use-after-free in adv7511_remove()
Date:   Mon, 10 May 2021 12:19:35 +0200
Message-Id: <20210510102010.839621294@linuxfoundation.org>
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
index a3161d709015..ab7883cff8b2 100644
--- a/drivers/media/i2c/adv7511-v4l2.c
+++ b/drivers/media/i2c/adv7511-v4l2.c
@@ -1964,7 +1964,7 @@ static int adv7511_remove(struct i2c_client *client)
 
 	adv7511_set_isr(sd, false);
 	adv7511_init_setup(sd);
-	cancel_delayed_work(&state->edid_handler);
+	cancel_delayed_work_sync(&state->edid_handler);
 	i2c_unregister_device(state->i2c_edid);
 	i2c_unregister_device(state->i2c_cec);
 	i2c_unregister_device(state->i2c_pktmem);
-- 
2.30.2



