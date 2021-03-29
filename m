Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C1D6B34C88B
	for <lists+stable@lfdr.de>; Mon, 29 Mar 2021 10:25:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233057AbhC2IXW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Mar 2021 04:23:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:38380 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233538AbhC2IVW (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 29 Mar 2021 04:21:22 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7814761932;
        Mon, 29 Mar 2021 08:21:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1617006082;
        bh=Itvmwy1S2qgFEM+tQdjJCEoVy+P7Q+pNMr39gdJ9+AI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=l46am3RkwEzreLKr15kvUGIbE2AOhQaiKPA4uFjLrLt+hm1HTmNECB22c7WsnSa5+
         nCOcuVKlJ4PeqxvzxU+EGfZAlKVUBpkaNIbyT3LLpRPoBBjfoNm2XqDtPBOZmnrah8
         H0rEVdJnQ+V4qJZQR1Bj949509JTO7fFhWK2j6Ug=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 112/221] net: phy: broadcom: Add power down exit reset state delay
Date:   Mon, 29 Mar 2021 09:57:23 +0200
Message-Id: <20210329075632.954177697@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210329075629.172032742@linuxfoundation.org>
References: <20210329075629.172032742@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Florian Fainelli <f.fainelli@gmail.com>

[ Upstream commit 7a1468ba0e02eee24ae1353e8933793a27198e20 ]

Per the datasheet, when we clear the power down bit, the PHY remains in
an internal reset state for 40us and then resume normal operation.
Account for that delay to avoid any issues in the future if
genphy_resume() changes.

Fixes: fe26821fa614 ("net: phy: broadcom: Wire suspend/resume for BCM54810")
Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/phy/broadcom.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/net/phy/broadcom.c b/drivers/net/phy/broadcom.c
index cd271de9609b..69713ea36d4e 100644
--- a/drivers/net/phy/broadcom.c
+++ b/drivers/net/phy/broadcom.c
@@ -332,6 +332,11 @@ static int bcm54xx_resume(struct phy_device *phydev)
 	if (ret < 0)
 		return ret;
 
+	/* Upon exiting power down, the PHY remains in an internal reset state
+	 * for 40us
+	 */
+	fsleep(40);
+
 	return bcm54xx_config_init(phydev);
 }
 
-- 
2.30.1



