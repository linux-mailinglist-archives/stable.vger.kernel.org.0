Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0CAD0404A94
	for <lists+stable@lfdr.de>; Thu,  9 Sep 2021 13:46:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238926AbhIILrZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 9 Sep 2021 07:47:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:46928 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238883AbhIILpW (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 9 Sep 2021 07:45:22 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 70505611C2;
        Thu,  9 Sep 2021 11:42:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631187766;
        bh=taLJ9PKWC7x9RU8xDW2ToEJ9OVv2CFyuQyAlImHraLQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=uTZeCtsr0FnnPETBU78ZtUwe5brd5sjICqbtlAmv3e9eDxScAP2MjgrSB+iX9ZXsc
         OrGWWOk5Z+oL2yzOBDfsssa3zyqTV0qcpE1TAQFfdqBcl4yRakRw1uDjMCbyHJ4AB4
         wAXDtZ3GLw3XV31ZEzxCfJMAEU/+YkmRp3UTKXta/zE1xw2Xb3XtVzzh1Hg/0DVvzo
         M0AjjsvH7sagttVxMxRBJoIm1XRfOCf3jKdh7b8HHU0B70H6LdQERQ7PgrnetzQ2n6
         0n3mo6BEeLxf40iJrgnON56FY3u9IrvqpmClB92UXn+LPtT+KH1XiTcV7VAmuDn1o1
         gV+bugAlqZiqQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Dennis Giaya <dgiaya@whoi.edu>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>, linux-serial@vger.kernel.org
Subject: [PATCH AUTOSEL 5.14 078/252] serial: max310x: Use clock-names property matching to recognize EXTCLK
Date:   Thu,  9 Sep 2021 07:38:12 -0400
Message-Id: <20210909114106.141462-78-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210909114106.141462-1-sashal@kernel.org>
References: <20210909114106.141462-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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

