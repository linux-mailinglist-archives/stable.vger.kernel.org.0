Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EE52B38A5ED
	for <lists+stable@lfdr.de>; Thu, 20 May 2021 12:20:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235916AbhETKVc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 May 2021 06:21:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:52000 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236389AbhETKTb (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 20 May 2021 06:19:31 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4DD02619B9;
        Thu, 20 May 2021 09:47:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1621504031;
        bh=1xHvd1vg/suJBGNxxzClRs3R8asIGh7BF20ZXBq74mo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ycQYUuJVYGJ4QUtMQYBBUIQAOXkmBUg/+EjWnnmg7pT7IKxoylJbWQlaa86VnpN5s
         wllqsOR+wxTs0wL6x3OLdH6zke0vT3JD/bbPZfc39p8GcNetiLdJXkgLGH6bzqYxo9
         DoWWUilKFWcl55zYU6GcWREgh7BZ/cjJdJfR186E=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hulk Robot <hulkci@huawei.com>,
        Yang Yingliang <yangyingliang@huawei.com>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 064/323] media: i2c: adv7511-v4l2: fix possible use-after-free in adv7511_remove()
Date:   Thu, 20 May 2021 11:19:16 +0200
Message-Id: <20210520092122.303012230@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210520092120.115153432@linuxfoundation.org>
References: <20210520092120.115153432@linuxfoundation.org>
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
index ef1144668809..2148a29909e0 100644
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



