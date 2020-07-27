Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EFD9E22F009
	for <lists+stable@lfdr.de>; Mon, 27 Jul 2020 16:21:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731146AbgG0OVY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Jul 2020 10:21:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:49912 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730232AbgG0OVU (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 27 Jul 2020 10:21:20 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7FD2C2070A;
        Mon, 27 Jul 2020 14:21:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1595859680;
        bh=AqQKZTUQ38W5fZS4lnOhbxBemp0qTW8dKqkGdBhn1Mo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1lyNr6gFEjDWUx3pmOY2A+QDFhGWzuC8sN/ZpSuQkdlqr4CzGB6BTdILR9yB/kO8O
         c+alZnnA2e3/tvdR23izgh/WOi2PiDkD1wJVb/Lt/tDxJjcBdz72g93pCRCqcIg9HK
         djYXLw6+8nJUKGtb6X849jyf2yxKdgCItxvLN0Tg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Martin Rowe <martin.p.rowe@gmail.com>,
        Russell King <rmk+kernel@armlinux.org.uk>,
        Andrew Lunn <andrew@lunn.ch>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.7 064/179] arm64: dts: clearfog-gt-8k: fix switch link configuration
Date:   Mon, 27 Jul 2020 16:03:59 +0200
Message-Id: <20200727134935.788541190@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200727134932.659499757@linuxfoundation.org>
References: <20200727134932.659499757@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Russell King <rmk+kernel@armlinux.org.uk>

[ Upstream commit 7c6719a1aaca51ffd7cdf3905e70aa8313f6ef26 ]

The commit below caused a regression for clearfog-gt-8k, where the link
between the switch and the host does not come up.

Investigation revealed two issues:
- MV88E6xxx DSA no longer allows an in-band link to come up as the link
  is programmed to be forced down. Commit "net: dsa: mv88e6xxx: fix
  in-band AN link establishment" addresses this.

- The dts configured dissimilar link modes at each end of the host to
  switch link; the host was configured using a fixed link (so has no
  in-band status) and the switch was configured to expect in-band
  status.

With both issues fixed, the regression is resolved.

Fixes: 34b5e6a33c1a ("net: dsa: mv88e6xxx: Configure MAC when using fixed link")
Reported-by: Martin Rowe <martin.p.rowe@gmail.com>
Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/marvell/armada-8040-clearfog-gt-8k.dts | 5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/arch/arm64/boot/dts/marvell/armada-8040-clearfog-gt-8k.dts b/arch/arm64/boot/dts/marvell/armada-8040-clearfog-gt-8k.dts
index b90d78a5724b2..e32a491e909f1 100644
--- a/arch/arm64/boot/dts/marvell/armada-8040-clearfog-gt-8k.dts
+++ b/arch/arm64/boot/dts/marvell/armada-8040-clearfog-gt-8k.dts
@@ -454,10 +454,7 @@
 	status = "okay";
 	phy-mode = "2500base-x";
 	phys = <&cp1_comphy5 2>;
-	fixed-link {
-		speed = <2500>;
-		full-duplex;
-	};
+	managed = "in-band-status";
 };
 
 &cp1_spi1 {
-- 
2.25.1



