Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D3541106E5B
	for <lists+stable@lfdr.de>; Fri, 22 Nov 2019 12:08:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731596AbfKVLEn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 22 Nov 2019 06:04:43 -0500
Received: from mail.kernel.org ([198.145.29.99]:59874 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731592AbfKVLEn (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 22 Nov 2019 06:04:43 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EBB3120854;
        Fri, 22 Nov 2019 11:04:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574420682;
        bh=EYGUwQYilh4pekqnanWVL0ztc04HiI88xFpbAfHhJyE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=recG/xlFwP7zth13JHoLE2avzrTnGvwwX2b9Bn5MvJfKapT+fk/9kGfqcpn2jPzpH
         RIU+AP87eP0+VhMrq4/e0NNMxrfaNPhYo9om09fSWqreQw/1tVodaJjZcEfX7NWPAg
         R40ltE/YJRIy8Axf8hPx/KRWc2ZppCEXz5hTADLo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Marek Vasut <marex@denx.de>,
        Linus Walleij <linus.walleij@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 190/220] gpio: syscon: Fix possible NULL ptr usage
Date:   Fri, 22 Nov 2019 11:29:15 +0100
Message-Id: <20191122100927.791893500@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191122100912.732983531@linuxfoundation.org>
References: <20191122100912.732983531@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Marek Vasut <marex@denx.de>

[ Upstream commit 70728c29465bc4bfa7a8c14304771eab77e923c7 ]

The priv->data->set can be NULL while flags contains GPIO_SYSCON_FEAT_OUT
and chip->set is valid pointer. This happens in case the controller uses
the default GPIO setter. Always use chip->set to access the setter to avoid
possible NULL pointer dereferencing.

Signed-off-by: Marek Vasut <marex@denx.de>
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpio/gpio-syscon.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpio/gpio-syscon.c b/drivers/gpio/gpio-syscon.c
index 87c18a5445137..7f3da34c78746 100644
--- a/drivers/gpio/gpio-syscon.c
+++ b/drivers/gpio/gpio-syscon.c
@@ -122,7 +122,7 @@ static int syscon_gpio_dir_out(struct gpio_chip *chip, unsigned offset, int val)
 				   BIT(offs % SYSCON_REG_BITS));
 	}
 
-	priv->data->set(chip, offset, val);
+	chip->set(chip, offset, val);
 
 	return 0;
 }
-- 
2.20.1



