Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 36F163DD9CC
	for <lists+stable@lfdr.de>; Mon,  2 Aug 2021 16:04:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234707AbhHBOEG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 2 Aug 2021 10:04:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:47228 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236287AbhHBOCE (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 2 Aug 2021 10:02:04 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2274060F51;
        Mon,  2 Aug 2021 13:56:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1627912607;
        bh=PID4COQ8dq3pZ6rNMV2PSeT1oQnsspD1+0eG2YKCBH4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Kj1n9ssTfIZ8J1xNBq/EUvRF0FYV4Pu3Vosw9kk5VhwdsJwIJQy8juWo7uMVjUcdn
         SYddDc0vA6hvjZQFKz20+3oB9RNEsp0Uo6fu2SzCLvHTQK1O34EXdL7xiEQ4LfcHJS
         bMU8kPAeX/N2OK2emqVQ+R/l+kSHm8x3laUnDBTI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Vladimir Oltean <vladimir.oltean@nxp.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.13 052/104] net: dsa: mv88e6xxx: silently accept the deletion of VID 0 too
Date:   Mon,  2 Aug 2021 15:44:49 +0200
Message-Id: <20210802134345.733543157@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210802134344.028226640@linuxfoundation.org>
References: <20210802134344.028226640@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

[ Upstream commit c92c74131a84b508aa8f079a25d7bbe10748449e ]

The blamed commit modified the driver to accept the addition of VID 0
without doing anything, but deleting that VID still fails:

[   32.080780] mv88e6085 d0032004.mdio-mii:10 lan8: failed to kill vid 0081/0

Modify mv88e6xxx_port_vlan_leave() to do the same thing as the addition.

Fixes: b8b79c414eca ("net: dsa: mv88e6xxx: Fix adding vlan 0")
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/dsa/mv88e6xxx/chip.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/dsa/mv88e6xxx/chip.c b/drivers/net/dsa/mv88e6xxx/chip.c
index beb41572d04e..272b0535d946 100644
--- a/drivers/net/dsa/mv88e6xxx/chip.c
+++ b/drivers/net/dsa/mv88e6xxx/chip.c
@@ -2155,7 +2155,7 @@ static int mv88e6xxx_port_vlan_leave(struct mv88e6xxx_chip *chip,
 	int i, err;
 
 	if (!vid)
-		return -EOPNOTSUPP;
+		return 0;
 
 	err = mv88e6xxx_vtu_get(chip, vid, &vlan);
 	if (err)
-- 
2.30.2



