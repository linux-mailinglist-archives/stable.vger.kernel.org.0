Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6002A34CA3A
	for <lists+stable@lfdr.de>; Mon, 29 Mar 2021 10:40:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234332AbhC2If7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Mar 2021 04:35:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:55600 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234013AbhC2Iee (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 29 Mar 2021 04:34:34 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1A3DE61864;
        Mon, 29 Mar 2021 08:34:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1617006871;
        bh=Aa15mx8PmigcSszyLxha9b0HRqmadViSukRDRdTfQ/U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZuaqkWHLJfxeRZv9Fo7g46pbsWoaTD6KEZiLuJRTPr8t6VRWvMElyi2iYHhOzQG6r
         rt6r/Np8au2GG4QG3qapNcZP9uq09xs6XO7/kBU9Ni9ZEQpGsDZ3twIDi0aDTktRHn
         burm4kkYWz+waTRyC3iCzZfq89rVLmf7c6XgG7eE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.11 133/254] net: phy: broadcom: Add power down exit reset state delay
Date:   Mon, 29 Mar 2021 09:57:29 +0200
Message-Id: <20210329075637.589414757@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210329075633.135869143@linuxfoundation.org>
References: <20210329075633.135869143@linuxfoundation.org>
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
index 8a4ec3222168..ec45a1608309 100644
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



