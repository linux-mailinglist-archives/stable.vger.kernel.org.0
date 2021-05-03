Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0FD14371C3B
	for <lists+stable@lfdr.de>; Mon,  3 May 2021 18:51:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232511AbhECQvs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 May 2021 12:51:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:60808 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234529AbhECQuQ (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 3 May 2021 12:50:16 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0CFAD6191E;
        Mon,  3 May 2021 16:40:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1620060043;
        bh=4HDkMF/rnkaFYhl4N7vbJp2w2Tc9rn69yJ6Y47iyDc4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=q8Mspi0evDdK/FUkPQrKrotOD1Q2zh/4Gb9sQ/z/APyh9T5CiIHhK3jGTdrxQpf+w
         5k7BmgKRVyc3NQEn/p+AAS7+f1PlLnu/HkbDiQkQEm2Jnzu8JjIv2oOu1TpPs0ZjBv
         ACj/gb0FuNLwnEnmTqKONOlmf55gJRFQoXl/5CGA8DswnRfONI+aR9EqxNu1w9YpON
         8nMof69RU+5FxfoHCtK/GHZ3iXz0d5ulehLUJWkHENxlIPAtU9CeZaLai54RDvdMbP
         7nmOQclGpCePnR53cVoBlwBICQl93iBDyYlCZmyPET9G9/SoxqekC31CkEFmusQO/f
         aRNIuZX3sR4zg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Yang Yingliang <yangyingliang@huawei.com>,
        Hulk Robot <hulkci@huawei.com>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        Sasha Levin <sashal@kernel.org>, linux-media@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 40/57] media: i2c: adv7511-v4l2: fix possible use-after-free in adv7511_remove()
Date:   Mon,  3 May 2021 12:39:24 -0400
Message-Id: <20210503163941.2853291-40-sashal@kernel.org>
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
index 62763ec4cd07..809fa44ed988 100644
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

