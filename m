Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6992B378641
	for <lists+stable@lfdr.de>; Mon, 10 May 2021 13:31:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234667AbhEJLFO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 May 2021 07:05:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:55722 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235054AbhEJK5f (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 10 May 2021 06:57:35 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 62FA361953;
        Mon, 10 May 2021 10:51:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620643898;
        bh=EbJmfGcfFUZegJrpcKXCsCBQlYDEv1znjBfrxCgRBF0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CjG/fxfSQdKE8M+Un/heZGDp3ggaH2iaYLNM5y9cnH1dEoqwJhRWPX34/g+9ZljRX
         dNB738DTn02C4y18FydeOG9wxxzgbh/gqzpiJfr9SYZELo/gS/SeAyKqxAzFdbJG5g
         U+lEUSPhHIX2W+N3qxjoihjEf/BjWf6CsRT/5ZKI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hulk Robot <hulkci@huawei.com>,
        Yang Yingliang <yangyingliang@huawei.com>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.11 204/342] media: adv7604: fix possible use-after-free in adv76xx_remove()
Date:   Mon, 10 May 2021 12:19:54 +0200
Message-Id: <20210510102016.823155071@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210510102010.096403571@linuxfoundation.org>
References: <20210510102010.096403571@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Yang Yingliang <yangyingliang@huawei.com>

[ Upstream commit fa56f5f1fe31c2050675fa63b84963ebd504a5b3 ]

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
 drivers/media/i2c/adv7604.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/i2c/adv7604.c b/drivers/media/i2c/adv7604.c
index 09004d928d11..d1f58795794f 100644
--- a/drivers/media/i2c/adv7604.c
+++ b/drivers/media/i2c/adv7604.c
@@ -3616,7 +3616,7 @@ static int adv76xx_remove(struct i2c_client *client)
 	io_write(sd, 0x6e, 0);
 	io_write(sd, 0x73, 0);
 
-	cancel_delayed_work(&state->delayed_work_enable_hotplug);
+	cancel_delayed_work_sync(&state->delayed_work_enable_hotplug);
 	v4l2_async_unregister_subdev(sd);
 	media_entity_cleanup(&sd->entity);
 	adv76xx_unregister_clients(to_state(sd));
-- 
2.30.2



