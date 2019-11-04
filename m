Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CA615EED58
	for <lists+stable@lfdr.de>; Mon,  4 Nov 2019 23:06:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389374AbfKDWFr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 4 Nov 2019 17:05:47 -0500
Received: from mail.kernel.org ([198.145.29.99]:37302 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388286AbfKDWFq (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 4 Nov 2019 17:05:46 -0500
Received: from localhost (6.204-14-84.ripe.coltfrance.com [84.14.204.6])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 96DCF205C9;
        Mon,  4 Nov 2019 22:05:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1572905146;
        bh=/TiINZmJsoedbiu+tJ48La03mc4J9pQ/MseuO/2nh5w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hjSjrtvCExkIGII6glN6AX8sMr+MNmwF8Rvu2/gp6WemaaGHWmXPA2PwE1hPLDDTY
         OFasr45yqpyvD9OdUVyk8T3WIh7q4vjXqH5FnBDFBz+cOX4YqOFwmsA3WgV4FMVaxw
         geCmNNy89fhgUBaJcg/vi/hhTKnflCK1hodRzxzE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Thierry Reding <treding@nvidia.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.3 043/163] gpio: max77620: Use correct unit for debounce times
Date:   Mon,  4 Nov 2019 22:43:53 +0100
Message-Id: <20191104212143.370815953@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191104212140.046021995@linuxfoundation.org>
References: <20191104212140.046021995@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Thierry Reding <treding@nvidia.com>

[ Upstream commit fffa6af94894126994a7600c6f6f09b892e89fa9 ]

The gpiod_set_debounce() function takes the debounce time in
microseconds. Adjust the switch/case values in the MAX77620 GPIO to use
the correct unit.

Signed-off-by: Thierry Reding <treding@nvidia.com>
Link: https://lore.kernel.org/r/20191002122825.3948322-1-thierry.reding@gmail.com
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpio/gpio-max77620.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/gpio/gpio-max77620.c b/drivers/gpio/gpio-max77620.c
index b7d89e30131e2..06e8caaafa811 100644
--- a/drivers/gpio/gpio-max77620.c
+++ b/drivers/gpio/gpio-max77620.c
@@ -192,13 +192,13 @@ static int max77620_gpio_set_debounce(struct max77620_gpio *mgpio,
 	case 0:
 		val = MAX77620_CNFG_GPIO_DBNC_None;
 		break;
-	case 1 ... 8:
+	case 1000 ... 8000:
 		val = MAX77620_CNFG_GPIO_DBNC_8ms;
 		break;
-	case 9 ... 16:
+	case 9000 ... 16000:
 		val = MAX77620_CNFG_GPIO_DBNC_16ms;
 		break;
-	case 17 ... 32:
+	case 17000 ... 32000:
 		val = MAX77620_CNFG_GPIO_DBNC_32ms;
 		break;
 	default:
-- 
2.20.1



