Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F202029C633
	for <lists+stable@lfdr.de>; Tue, 27 Oct 2020 19:27:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1825831AbgJ0SOV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Oct 2020 14:14:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:34820 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1756464AbgJ0ON0 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Oct 2020 10:13:26 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2523422265;
        Tue, 27 Oct 2020 14:13:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603808005;
        bh=Gm6quWG61QDKSQll4BJQfDy3dvG4rp4sAm9JUEJKn28=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GKvQ+CASf3DnIWWSgys2qlITISRMgDjT8mSKuJYs+0qIVv2CQyONltzw/yKJtI/pg
         upSxMwFEv9Iakrf29eEuwOSh9vTfgqz7HUev8IDE4OT7IBrs/3cSjyZgPrY7xTg48G
         9yJU6td6bBLrPOiouBiMvxqMEUEiyMVNJWWIORMw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Krzysztof Kozlowski <krzk@kernel.org>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 121/191] Input: ep93xx_keypad - fix handling of platform_get_irq() error
Date:   Tue, 27 Oct 2020 14:49:36 +0100
Message-Id: <20201027134915.510188262@linuxfoundation.org>
X-Mailer: git-send-email 2.29.1
In-Reply-To: <20201027134909.701581493@linuxfoundation.org>
References: <20201027134909.701581493@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Krzysztof Kozlowski <krzk@kernel.org>

[ Upstream commit 7d50f6656dacf085a00beeedbc48b19a37d17881 ]

platform_get_irq() returns -ERRNO on error.  In such case comparison
to 0 would pass the check.

Fixes: 60214f058f44 ("Input: ep93xx_keypad - update driver to new core support")
Signed-off-by: Krzysztof Kozlowski <krzk@kernel.org>
Link: https://lore.kernel.org/r/20200828145744.3636-1-krzk@kernel.org
Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/input/keyboard/ep93xx_keypad.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/input/keyboard/ep93xx_keypad.c b/drivers/input/keyboard/ep93xx_keypad.c
index f77b295e0123e..01788a78041b3 100644
--- a/drivers/input/keyboard/ep93xx_keypad.c
+++ b/drivers/input/keyboard/ep93xx_keypad.c
@@ -257,8 +257,8 @@ static int ep93xx_keypad_probe(struct platform_device *pdev)
 	}
 
 	keypad->irq = platform_get_irq(pdev, 0);
-	if (!keypad->irq) {
-		err = -ENXIO;
+	if (keypad->irq < 0) {
+		err = keypad->irq;
 		goto failed_free;
 	}
 
-- 
2.25.1



