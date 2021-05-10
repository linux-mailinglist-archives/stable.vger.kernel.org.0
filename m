Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 17AF63788BE
	for <lists+stable@lfdr.de>; Mon, 10 May 2021 13:48:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234598AbhEJLX0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 May 2021 07:23:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:45768 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237206AbhEJLLf (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 10 May 2021 07:11:35 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D71146192C;
        Mon, 10 May 2021 11:08:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620644891;
        bh=jSFnpPCMOcIv5/ncZmQy4KGPp60iGDNp1gQ4t8bTZgo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DLXMlkJnb+d+qsDdCiDpXhkyoZoEph8Vcj0C3AOT+p6TCXQClmhgwUpo3Zeae53AH
         x3DuzxqWltHYP87CEYgXYGuQX6qr6hfa8ua5nOoLrQXI/VJlqr4NiAKENeWq4qRpIy
         04+XKUY6oU/erM+q7AIzAytTtkTbM3DS2mTRe75k=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hulk Robot <hulkci@huawei.com>,
        Yang Yingliang <yangyingliang@huawei.com>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.12 232/384] media: i2c: tda1997: Fix possible use-after-free in tda1997x_remove()
Date:   Mon, 10 May 2021 12:20:21 +0200
Message-Id: <20210510102022.541210100@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210510102014.849075526@linuxfoundation.org>
References: <20210510102014.849075526@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Yang Yingliang <yangyingliang@huawei.com>

[ Upstream commit 7f820ab5d4eebfe2d970d32a76ae496a6c286f0f ]

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
 drivers/media/i2c/tda1997x.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/i2c/tda1997x.c b/drivers/media/i2c/tda1997x.c
index a09bf0a39d05..89bb7e6dc7a4 100644
--- a/drivers/media/i2c/tda1997x.c
+++ b/drivers/media/i2c/tda1997x.c
@@ -2804,7 +2804,7 @@ static int tda1997x_remove(struct i2c_client *client)
 	media_entity_cleanup(&sd->entity);
 	v4l2_ctrl_handler_free(&state->hdl);
 	regulator_bulk_disable(TDA1997X_NUM_SUPPLIES, state->supplies);
-	cancel_delayed_work(&state->delayed_work_enable_hpd);
+	cancel_delayed_work_sync(&state->delayed_work_enable_hpd);
 	mutex_destroy(&state->page_lock);
 	mutex_destroy(&state->lock);
 
-- 
2.30.2



