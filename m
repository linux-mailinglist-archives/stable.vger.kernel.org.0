Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 382533CDFF3
	for <lists+stable@lfdr.de>; Mon, 19 Jul 2021 17:55:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344427AbhGSPMs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Jul 2021 11:12:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:48730 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1344905AbhGSPLT (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 19 Jul 2021 11:11:19 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8BE346120A;
        Mon, 19 Jul 2021 15:51:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626709919;
        bh=FYY0wPdjYFvUScwzv/feV7G9JhIy/WU9o9UGwFEyxt8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=l6BwQPwyWHTQ5f4jZ7CQXMv7N/4A+Sst9u8N/+7huG6v4BSPZwhDXR+10fZSaX2qL
         1JDcd25Je2a6nwfGv6BoESI5artMQkn5CFSEsn9nwy4pfLooH69k7T7rNzkvXHWgrq
         8gkr7vptHGQJWiZc1i2h6ZEd2yiOCY3VVihxv1yU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= 
        <u.kleine-koenig@pengutronix.de>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 131/149] reset: bail if try_module_get() fails
Date:   Mon, 19 Jul 2021 16:53:59 +0200
Message-Id: <20210719144932.340057158@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210719144901.370365147@linuxfoundation.org>
References: <20210719144901.370365147@linuxfoundation.org>
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
index 76c0dc7f165d..688b4f6227fc 100644
--- a/drivers/reset/core.c
+++ b/drivers/reset/core.c
@@ -565,7 +565,10 @@ static struct reset_control *__reset_control_get_internal(
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



