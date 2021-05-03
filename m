Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8F058371CBD
	for <lists+stable@lfdr.de>; Mon,  3 May 2021 18:56:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233824AbhECQ4m (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 May 2021 12:56:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:43040 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232949AbhECQwx (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 3 May 2021 12:52:53 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 02C3F613D2;
        Mon,  3 May 2021 16:41:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1620060107;
        bh=rsMu6y5D+b5JETNkKwdumLVnzmYpdfFAAJ+6RY3kY+A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QrmXR4T2mgRO6BPOQGNoJ5Sw5zwHk4I2FBIP72W1uHOnsQSVSgkUaleerbstHlHqa
         IVk7NL6F4s4DtZfLRns157m+NRcB5+IgDgwhHQWwMl3wcmyFqJj+a0vdK0NhldxOxo
         6n8IRDbG+ZiORx6HNHhFj8lHfZ4aCVZbKs6bGqIiPuXABl5lUC0e/bKHoB3cBtiIgB
         +9g1j80oJBr/lFLQdwKKIpQqmH/eVrpMW7iXsDGmdI82dhZt8zVB3uTsC7fTbe4LC4
         57XHcHXoq/VqCt+v/ci8lUf7vUl+taDz05DYnJEnR666puqnZ4pX6qG1qD5ZSxLIcq
         K+Nz4Upy5VEtQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Yang Yingliang <yangyingliang@huawei.com>,
        Hulk Robot <hulkci@huawei.com>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        Sasha Levin <sashal@kernel.org>, linux-media@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 25/35] media: i2c: adv7511-v4l2: fix possible use-after-free in adv7511_remove()
Date:   Mon,  3 May 2021 12:40:59 -0400
Message-Id: <20210503164109.2853838-25-sashal@kernel.org>
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
index 6869bb593a68..4052abeead50 100644
--- a/drivers/media/i2c/adv7511-v4l2.c
+++ b/drivers/media/i2c/adv7511-v4l2.c
@@ -1965,7 +1965,7 @@ static int adv7511_remove(struct i2c_client *client)
 
 	adv7511_set_isr(sd, false);
 	adv7511_init_setup(sd);
-	cancel_delayed_work(&state->edid_handler);
+	cancel_delayed_work_sync(&state->edid_handler);
 	i2c_unregister_device(state->i2c_edid);
 	if (state->i2c_cec)
 		i2c_unregister_device(state->i2c_cec);
-- 
2.30.2

