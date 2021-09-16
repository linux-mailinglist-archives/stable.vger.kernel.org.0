Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CC80F40E713
	for <lists+stable@lfdr.de>; Thu, 16 Sep 2021 19:32:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231556AbhIPR2J (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Sep 2021 13:28:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:46924 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1348358AbhIPRZw (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Sep 2021 13:25:52 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3FEE860F6C;
        Thu, 16 Sep 2021 16:44:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1631810686;
        bh=taLJ9PKWC7x9RU8xDW2ToEJ9OVv2CFyuQyAlImHraLQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Oh51nb5hsl71fQXuFTtE5k8TUnvlOoW3/ZifjhEvz89rfym+WjcP9IT6NoT/hlD+b
         4In8Qm8eezb/CSiUQUviekZP98s0kPJ2PGKfUlHEWVi435LCbcmRD4mAaemglR+nTP
         SxA7k1JLWJAx43R0g1UKLK13fAIRFHguwyXxiCv4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Sasha Levin <sashal@kernel.org>, Dennis Giaya <dgiaya@whoi.edu>
Subject: [PATCH 5.14 230/432] serial: max310x: Use clock-names property matching to recognize EXTCLK
Date:   Thu, 16 Sep 2021 17:59:39 +0200
Message-Id: <20210916155818.642037458@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210916155810.813340753@linuxfoundation.org>
References: <20210916155810.813340753@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>

[ Upstream commit 3d1fa055ea7298345795b982de7a5b9ec6ae238d ]

Dennis reported that on ACPI-based systems the clock frequency
isn't enough to configure device properly. We have to respect
the clock source as well. To achieve this match the clock-names
property against "osc" to recognize external clock connection.
On DT-based system this doesn't change anything.

Reported-and-tested-by: Dennis Giaya <dgiaya@whoi.edu>
Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Link: https://lore.kernel.org/r/20210723125943.22039-1-andriy.shevchenko@linux.intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/tty/serial/max310x.c | 15 +++++----------
 1 file changed, 5 insertions(+), 10 deletions(-)

diff --git a/drivers/tty/serial/max310x.c b/drivers/tty/serial/max310x.c
index ef11860cd69e..3df0788ddeb0 100644
--- a/drivers/tty/serial/max310x.c
+++ b/drivers/tty/serial/max310x.c
@@ -1271,18 +1271,13 @@ static int max310x_probe(struct device *dev, const struct max310x_devtype *devty
 	/* Always ask for fixed clock rate from a property. */
 	device_property_read_u32(dev, "clock-frequency", &uartclk);
 
-	s->clk = devm_clk_get_optional(dev, "osc");
+	xtal = device_property_match_string(dev, "clock-names", "osc") < 0;
+	if (xtal)
+		s->clk = devm_clk_get_optional(dev, "xtal");
+	else
+		s->clk = devm_clk_get_optional(dev, "osc");
 	if (IS_ERR(s->clk))
 		return PTR_ERR(s->clk);
-	if (s->clk) {
-		xtal = false;
-	} else {
-		s->clk = devm_clk_get_optional(dev, "xtal");
-		if (IS_ERR(s->clk))
-			return PTR_ERR(s->clk);
-
-		xtal = true;
-	}
 
 	ret = clk_prepare_enable(s->clk);
 	if (ret)
-- 
2.30.2



