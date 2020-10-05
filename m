Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2016E283B02
	for <lists+stable@lfdr.de>; Mon,  5 Oct 2020 17:39:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728651AbgJEPjT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Oct 2020 11:39:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:56288 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727723AbgJEPaD (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 5 Oct 2020 11:30:03 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5AEB92085B;
        Mon,  5 Oct 2020 15:30:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601911801;
        bh=RuIy+oBQXSvf5mse+Z28ABsLBNoDwgE1iFj9PdPuDHE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=wERiVgBVelwRYjDnRpVV7EUfdtdmN+Fn6EAkEm/VgUAa51eBKwO6PCxujbh2rRutf
         LnziambYV0vh3jUt1NzF4WtxsDt4AaiwNkukXFEFqx8+pYsRTD7jf2cKJgHbqUkKoP
         pnv2WdHFK3y2tp+J43gNv+/yFZZqBMHaumv0v1UM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Tao Ren <rentao.bupt@gmail.com>,
        Andrew Jeffery <andrew@aj.id.au>,
        Bartosz Golaszewski <bgolaszewski@baylibre.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 42/57] gpio: aspeed: fix ast2600 bank properties
Date:   Mon,  5 Oct 2020 17:26:54 +0200
Message-Id: <20201005142111.825582591@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201005142109.796046410@linuxfoundation.org>
References: <20201005142109.796046410@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Tao Ren <rentao.bupt@gmail.com>

[ Upstream commit 3e640b1eec38e4c8eba160f26cba4f592e657f3d ]

GPIO_U is mapped to the least significant byte of input/output mask, and
the byte in "output" mask should be 0 because GPIO_U is input only. All
the other bits need to be 1 because GPIO_V/W/X support both input and
output modes.

Similarly, GPIO_Y/Z are mapped to the 2 least significant bytes, and the
according bits need to be 1 because GPIO_Y/Z support both input and
output modes.

Fixes: ab4a85534c3e ("gpio: aspeed: Add in ast2600 details to Aspeed driver")
Signed-off-by: Tao Ren <rentao.bupt@gmail.com>
Reviewed-by: Andrew Jeffery <andrew@aj.id.au>
Signed-off-by: Bartosz Golaszewski <bgolaszewski@baylibre.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpio/gpio-aspeed.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/gpio/gpio-aspeed.c b/drivers/gpio/gpio-aspeed.c
index 09e53c5f3b0a4..2820c59b5f071 100644
--- a/drivers/gpio/gpio-aspeed.c
+++ b/drivers/gpio/gpio-aspeed.c
@@ -1115,8 +1115,8 @@ static const struct aspeed_gpio_config ast2500_config =
 
 static const struct aspeed_bank_props ast2600_bank_props[] = {
 	/*     input	  output   */
-	{5, 0xffffffff,  0x0000ffff}, /* U/V/W/X */
-	{6, 0xffff0000,  0x0fff0000}, /* Y/Z */
+	{5, 0xffffffff,  0xffffff00}, /* U/V/W/X */
+	{6, 0x0000ffff,  0x0000ffff}, /* Y/Z */
 	{ },
 };
 
-- 
2.25.1



