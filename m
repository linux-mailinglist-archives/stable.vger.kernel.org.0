Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D5CDE451E69
	for <lists+stable@lfdr.de>; Tue, 16 Nov 2021 01:33:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345103AbhKPAf6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 19:35:58 -0500
Received: from mail.kernel.org ([198.145.29.99]:45402 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1344875AbhKOTZi (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 14:25:38 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 24205633EE;
        Mon, 15 Nov 2021 19:05:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637003158;
        bh=Anahu57UVRbHPfBatxwAVanp6zGzGg91igYa5IY1BA8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=soxLYGyTYcPfFubw5/FsXo7u66EXQPI0EmSwpriDxzhmw6bTUZtHSwCmSIqz2w7tK
         JUl+6H4vJMY64kuGFTaG8ArNN2x3nBjzNGC59Soe6Ll870WjGjk8Y5CwXtYtSf0SaN
         7AUm2DDu3TmscepLJezpmKqh3yS1e1v/9dMHH6OA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>,
        "Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>,
        Andrew Lunn <andrew@lunn.ch>, Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 832/917] net: dsa: mv88e6xxx: Dont support >1G speeds on 6191X on ports other than 10
Date:   Mon, 15 Nov 2021 18:05:27 +0100
Message-Id: <20211115165457.257164507@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211115165428.722074685@linuxfoundation.org>
References: <20211115165428.722074685@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Marek Behún <kabel@kernel.org>

[ Upstream commit dc2fc9f03c5c410d8f01c2206b3d529f80b13733 ]

Model 88E6191X only supports >1G speeds on port 10. Port 0 and 9 are
only 1G.

Fixes: de776d0d316f ("net: dsa: mv88e6xxx: add support for mv88e6393x family")
Signed-off-by: Marek Behún <kabel@kernel.org>
Cc: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
Link: https://lore.kernel.org/r/20211104171747.10509-1-kabel@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/dsa/mv88e6xxx/chip.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/net/dsa/mv88e6xxx/chip.c b/drivers/net/dsa/mv88e6xxx/chip.c
index 8dadcae93c9b5..be8589fa86a15 100644
--- a/drivers/net/dsa/mv88e6xxx/chip.c
+++ b/drivers/net/dsa/mv88e6xxx/chip.c
@@ -640,7 +640,10 @@ static void mv88e6393x_phylink_validate(struct mv88e6xxx_chip *chip, int port,
 					unsigned long *mask,
 					struct phylink_link_state *state)
 {
-	if (port == 0 || port == 9 || port == 10) {
+	bool is_6191x =
+		chip->info->prod_num == MV88E6XXX_PORT_SWITCH_ID_PROD_6191X;
+
+	if (((port == 0 || port == 9) && !is_6191x) || port == 10) {
 		phylink_set(mask, 10000baseT_Full);
 		phylink_set(mask, 10000baseKR_Full);
 		phylink_set(mask, 10000baseCR_Full);
-- 
2.33.0



