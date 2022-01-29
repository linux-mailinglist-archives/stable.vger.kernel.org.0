Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 73B534A307A
	for <lists+stable@lfdr.de>; Sat, 29 Jan 2022 17:17:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230389AbiA2QR2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 29 Jan 2022 11:17:28 -0500
Received: from mail.nic.cz ([217.31.204.67]:35072 "EHLO mail.nic.cz"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233877AbiA2QR2 (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 29 Jan 2022 11:17:28 -0500
Received: from dellmb.labs.office.nic.cz (unknown [IPv6:2001:1488:fffe:6:8747:7254:5571:3010])
        by mail.nic.cz (Postfix) with ESMTPSA id F29B0140C2E;
        Sat, 29 Jan 2022 17:09:46 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=nic.cz; s=default;
        t=1643472587; bh=VoGzT76iRvl5l+4N5/SPm9685rNfnuO1eooBTkzSfB0=;
        h=From:To:Date;
        b=Lu2Em1NTrJcSSfgrrSm+ruY+ihmIZxH/7EdP9mT1y4fI0ueU6PBfpmR2InigeQkqA
         S62sXyyE9VjtIKv+PUxUJOg6OMZJYlT4wxcGq/272RvK4y5DX9CB63tI6wrZ61Fx0B
         KHruhubCMkvJ3s54BCshWko3SY44BfD9nc2AuTu8=
From:   =?UTF-8?q?Marek=20Beh=C3=BAn?= <marek.behun@nic.cz>
To:     gregkh@linuxfoundation.org
Cc:     stable@vger.kernel.org, kabel@kernel.org,
        "David S . Miller" <davem@davemloft.net>
Subject: [PATCH 4.14] net: sfp: ignore disabled SFP node
Date:   Sat, 29 Jan 2022 17:09:46 +0100
Message-Id: <20220129160946.11423-1-marek.behun@nic.cz>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <1643457650212105@kroah.com>
References: 
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-100.0 required=5.9 tests=SHORTCIRCUIT,
        USER_IN_WELCOMELIST,USER_IN_WHITELIST shortcircuit=ham
        autolearn=disabled version=3.4.2
X-Spam-Checker-Version: SpamAssassin 3.4.2 (2018-09-13) on mail.nic.cz
X-Virus-Scanned: clamav-milter 0.102.4 at mail
X-Virus-Status: Clean
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Marek Behún <kabel@kernel.org>

commit 2148927e6ed43a1667baf7c2ae3e0e05a44b51a0 upstream.

Commit ce0aa27ff3f6 ("sfp: add sfp-bus to bridge between network devices
and sfp cages") added code which finds SFP bus DT node even if the node
is disabled with status = "disabled". Because of this, when phylink is
created, it ends with non-null .sfp_bus member, even though the SFP
module is not probed (because the node is disabled).

We need to ignore disabled SFP bus node.

Fixes: ce0aa27ff3f6 ("sfp: add sfp-bus to bridge between network devices and sfp cages")
Signed-off-by: Marek Behún <kabel@kernel.org>
Cc: stable@vger.kernel.org # 2203cbf2c8b5 ("net: sfp: move fwnode parsing into sfp-bus layer")
Signed-off-by: David S. Miller <davem@davemloft.net>
[ backport to 4.14 ]
Signed-off-by: Marek Behún <kabel@kernel.org>
---
 drivers/net/phy/phylink.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/net/phy/phylink.c b/drivers/net/phy/phylink.c
index 89d8efe8753e..a045fb3a698b 100644
--- a/drivers/net/phy/phylink.c
+++ b/drivers/net/phy/phylink.c
@@ -514,6 +514,11 @@ static int phylink_register_sfp(struct phylink *pl, struct device_node *np)
 	if (!sfp_np)
 		return 0;
 
+	if (!of_device_is_available(sfp_np)) {
+		of_node_put(sfp_np);
+		return 0;
+	}
+
 	pl->sfp_bus = sfp_register_upstream(sfp_np, pl->netdev, pl,
 					    &sfp_phylink_ops);
 	if (!pl->sfp_bus)
-- 
2.34.1

