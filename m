Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AA98C29AFDB
	for <lists+stable@lfdr.de>; Tue, 27 Oct 2020 15:13:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2507645AbgJ0ONa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Oct 2020 10:13:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:34894 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2409905AbgJ0ON2 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Oct 2020 10:13:28 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C07302072D;
        Tue, 27 Oct 2020 14:13:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603808008;
        bh=Rjr/AYJ6z4qLYNmPgGD3eZQOjOTcbOLR5DGJXuwEh8E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=uE3/WpkDcCg/g3R+dLS1NZSncWnY4jBfJh6ZGc9Tqo3Q6WEnD7jaEHZMqroHq8S5M
         JKMRbHBjHctdxFp+IWRu4t6xprYaDe0U57LEndQEy0KTIFxmPCORUirDYAtcuxsJ09
         oaPPgb0+gqhdsyw+jyWkAVOlHAIPQtG8oThoFzUQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Krzysztof Kozlowski <krzk@kernel.org>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 122/191] Input: omap4-keypad - fix handling of platform_get_irq() error
Date:   Tue, 27 Oct 2020 14:49:37 +0100
Message-Id: <20201027134915.559098521@linuxfoundation.org>
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

[ Upstream commit 4738dd1992fa13acfbbd71800c71c612f466fa44 ]

platform_get_irq() returns -ERRNO on error.  In such case comparison
to 0 would pass the check.

Fixes: f3a1ba60dbdb ("Input: omap4-keypad - use platform device helpers")
Signed-off-by: Krzysztof Kozlowski <krzk@kernel.org>
Link: https://lore.kernel.org/r/20200828145744.3636-2-krzk@kernel.org
Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/input/keyboard/omap4-keypad.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/input/keyboard/omap4-keypad.c b/drivers/input/keyboard/omap4-keypad.c
index 616fdd94b0694..5480f1a5658ee 100644
--- a/drivers/input/keyboard/omap4-keypad.c
+++ b/drivers/input/keyboard/omap4-keypad.c
@@ -253,10 +253,8 @@ static int omap4_keypad_probe(struct platform_device *pdev)
 	}
 
 	irq = platform_get_irq(pdev, 0);
-	if (!irq) {
-		dev_err(&pdev->dev, "no keyboard irq assigned\n");
-		return -EINVAL;
-	}
+	if (irq < 0)
+		return irq;
 
 	keypad_data = kzalloc(sizeof(struct omap4_keypad), GFP_KERNEL);
 	if (!keypad_data) {
-- 
2.25.1



