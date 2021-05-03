Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 409F6371CFB
	for <lists+stable@lfdr.de>; Mon,  3 May 2021 18:57:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234361AbhECQ5h (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 May 2021 12:57:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:44910 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234949AbhECQzP (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 3 May 2021 12:55:15 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5282E61936;
        Mon,  3 May 2021 16:42:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1620060159;
        bh=1xHvd1vg/suJBGNxxzClRs3R8asIGh7BF20ZXBq74mo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DQCw3z4wqM60l+eSxXn9zj6xcgTNmWcIGiCGa9DxIPyzcJdfwLeaIetvKmZo9NDWB
         Mk8Wf6RP7UU7J7WLFq5dixeC5nv/mSvVpTMJVu1Bje6mAXz3cy9/uG1RN/wt32AVKW
         v4aD9kfA+nLd+ITAezhJQ8myrX6oS1/TE0nrk5RDxATbFVjRCGfzXs8V28rsFozxUI
         BUYfWhUiKhIJ6Kc8oW7srkZQrxrF9h1sTprS8Fcn3f2bJQO9arGPFetYXhBfwlxbuV
         3vkG3Jkm8eB699Rq/dr28O1cOZDVwyx+gDuuDlS5FRwIGTREbOqaA5jW6jZS0rZW5+
         z0Hf0USIXsWVQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Yang Yingliang <yangyingliang@huawei.com>,
        Hulk Robot <hulkci@huawei.com>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        Sasha Levin <sashal@kernel.org>, linux-media@vger.kernel.org
Subject: [PATCH AUTOSEL 4.14 23/31] media: i2c: adv7511-v4l2: fix possible use-after-free in adv7511_remove()
Date:   Mon,  3 May 2021 12:41:56 -0400
Message-Id: <20210503164204.2854178-23-sashal@kernel.org>
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

