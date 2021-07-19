Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1F40B3CE3CB
	for <lists+stable@lfdr.de>; Mon, 19 Jul 2021 18:30:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235473AbhGSPkh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Jul 2021 11:40:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:33928 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1350062AbhGSPgg (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 19 Jul 2021 11:36:36 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id CECDB600EF;
        Mon, 19 Jul 2021 16:17:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626711436;
        bh=1ZqEOEfh63fClZWxEBSktfASpTlJjqo67Xfny5rh4cY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dk8BgID/TsjAPh8ROJP+CHwojkV5jC0xbK/CR/3Y9+9oPvgKYMc5QjGkzCw+WMc9M
         LYU3XN2Amvd6ZxI4D6lGq/JroyGQe4vEGy+5EdYXFe59BakINrsivN3CYOi6ZIsdf1
         icsfxEVimSPkn3PZcaHJgxkt8egWkYojJsBrNPj0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= 
        <u.kleine-koenig@pengutronix.de>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.13 309/351] reset: bail if try_module_get() fails
Date:   Mon, 19 Jul 2021 16:54:15 +0200
Message-Id: <20210719144955.273296406@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210719144944.537151528@linuxfoundation.org>
References: <20210719144944.537151528@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Philipp Zabel <p.zabel@pengutronix.de>

[ Upstream commit 4fb26fb83f0def3d39c14e268bcd4003aae8fade ]

Abort instead of returning a new reset control for a reset controller
device that is going to have its module unloaded.

Reported-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
Fixes: 61fc41317666 ("reset: Add reset controller API")
Acked-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
Link: https://lore.kernel.org/r/20210607082615.15160-1-p.zabel@pengutronix.de
Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/reset/core.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/reset/core.c b/drivers/reset/core.c
index 71c1c8264b2d..e2a6a927b84c 100644
--- a/drivers/reset/core.c
+++ b/drivers/reset/core.c
@@ -774,7 +774,10 @@ static struct reset_control *__reset_control_get_internal(
 	if (!rstc)
 		return ERR_PTR(-ENOMEM);
 
-	try_module_get(rcdev->owner);
+	if (!try_module_get(rcdev->owner)) {
+		kfree(rstc);
+		return ERR_PTR(-ENODEV);
+	}
 
 	rstc->rcdev = rcdev;
 	list_add(&rstc->list, &rcdev->reset_control_head);
-- 
2.30.2



