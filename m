Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 85BFC3CDA67
	for <lists+stable@lfdr.de>; Mon, 19 Jul 2021 17:17:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244911AbhGSOft (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Jul 2021 10:35:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:47690 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S244779AbhGSOeY (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 19 Jul 2021 10:34:24 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7191F6113B;
        Mon, 19 Jul 2021 15:13:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626707623;
        bh=tsXakENf65MVAX+mh5UgIySG52GWmSjONSb1rsvTrUk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=zjUDIKSw+yTSKk8pIHAYPFcRO5lr6Yvsfu8S/pa3vMyl2euWYqlrK0kF1xBknIUsU
         Xw5FYvjeqE/iodNXAYuVU5EAA6Kf7aXbNw/cCF8NOHks2A6/LXTqu7SVm5IX2eK4Jr
         pGf4LuMZWFvq3XFy5O35r0v1e0LKSPJv2ZjETxrY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= 
        <u.kleine-koenig@pengutronix.de>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 238/245] reset: bail if try_module_get() fails
Date:   Mon, 19 Jul 2021 16:53:00 +0200
Message-Id: <20210719144948.066708794@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210719144940.288257948@linuxfoundation.org>
References: <20210719144940.288257948@linuxfoundation.org>
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
index d0ebca301afc..c15c898fe0dc 100644
--- a/drivers/reset/core.c
+++ b/drivers/reset/core.c
@@ -263,7 +263,10 @@ static struct reset_control *__reset_control_get_internal(
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



