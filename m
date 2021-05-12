Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7804C37C8F8
	for <lists+stable@lfdr.de>; Wed, 12 May 2021 18:45:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234845AbhELQOH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 12:14:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:34346 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239401AbhELQH7 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 12 May 2021 12:07:59 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id BC94861943;
        Wed, 12 May 2021 15:38:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620833883;
        bh=nRzAMf3I6Dy0YLNjTDV+dQDfRWsNX/Es5UuYMHT8VK4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ag08dEeXcz7nUlIObFoseKqo/JH7WXSkJGRjeL2cF4KsBy39u4uUJDQJm375G7iFO
         h7kxK/G1X83Q8Ab6hyY3Je9IRuhcoZyJJwZBwJtn6b3rSRvY2Cgz5IEzJi+m055feh
         V97+FaSJyWiy6ZIGfrKs/hrheV3wV8aTAlcHK7bU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hulk Robot <hulkci@huawei.com>,
        Wei Yongjun <weiyongjun1@huawei.com>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.11 325/601] media: m88ds3103: fix return value check in m88ds3103_probe()
Date:   Wed, 12 May 2021 16:46:42 +0200
Message-Id: <20210512144838.510485902@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210512144827.811958675@linuxfoundation.org>
References: <20210512144827.811958675@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Wei Yongjun <weiyongjun1@huawei.com>

[ Upstream commit e61f9ea271933d987ab895c689fa37744f6fc27f ]

In case of error, the function i2c_new_dummy_device() returns
ERR_PTR() and never returns NULL. The NULL test in the return
value check should be replaced with IS_ERR().

Fixes: e6089feca460 ("media: m88ds3103: Add support for ds3103b demod")
Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: Wei Yongjun <weiyongjun1@huawei.com>
Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/dvb-frontends/m88ds3103.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/media/dvb-frontends/m88ds3103.c b/drivers/media/dvb-frontends/m88ds3103.c
index cfa4cdde99d8..02e8aa11e36e 100644
--- a/drivers/media/dvb-frontends/m88ds3103.c
+++ b/drivers/media/dvb-frontends/m88ds3103.c
@@ -1904,8 +1904,8 @@ static int m88ds3103_probe(struct i2c_client *client,
 
 		dev->dt_client = i2c_new_dummy_device(client->adapter,
 						      dev->dt_addr);
-		if (!dev->dt_client) {
-			ret = -ENODEV;
+		if (IS_ERR(dev->dt_client)) {
+			ret = PTR_ERR(dev->dt_client);
 			goto err_kfree;
 		}
 	}
-- 
2.30.2



