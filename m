Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0383F3782A4
	for <lists+stable@lfdr.de>; Mon, 10 May 2021 12:37:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230507AbhEJKgq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 May 2021 06:36:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:41272 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232285AbhEJKeR (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 10 May 2021 06:34:17 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id DEC7E6147D;
        Mon, 10 May 2021 10:27:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620642475;
        bh=xseuWw6JTctMg95ZrT7pyFQc/T1B8tchwseyoJPfux8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=D52og8rNpIF90hQFZsSt4vYOHCvOyta6oueo/ZMp0gLtKoSoGbPEaAdTqymty0HI3
         EqS4i0a0A3hzsK3uY0xa4RF61KTCrAZYI9K3bAzlINBiFs20myp8OqfsIpjm0HNJTx
         ml3GsWLcCcxpNjVxhGW/vaMWnnIcr+PfW1jVI8pQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hulk Robot <hulkci@huawei.com>,
        Yang Yingliang <yangyingliang@huawei.com>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 109/184] media: i2c: adv7842: fix possible use-after-free in adv7842_remove()
Date:   Mon, 10 May 2021 12:20:03 +0200
Message-Id: <20210510101953.761553000@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210510101950.200777181@linuxfoundation.org>
References: <20210510101950.200777181@linuxfoundation.org>
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
index 885619841719..02cbab826d0b 100644
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



