Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DFF7518B693
	for <lists+stable@lfdr.de>; Thu, 19 Mar 2020 14:28:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730950AbgCSN1v (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 19 Mar 2020 09:27:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:56344 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730946AbgCSN1v (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 19 Mar 2020 09:27:51 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DD15C208D6;
        Thu, 19 Mar 2020 13:27:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1584624470;
        bh=vIWVVQSsxa0q2PBnre3MSrwGIHMPHLvVS/E2Zr8HFLo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DSBZaP7I4lHsRKMzdrt6pu73Cmz8lYnls6FKXZ17jhpkOLso4ySBc4HO9u5vmkL9v
         F2mfTHH92tVKRrfKNcYvd7MZlZKZchV4DQqjoCx0l08xbCLRapMxGLWqRvFuyAgm3v
         5xyhi0sX5Of9I/l2FA8zA3OQk31bkGoEccyitK48=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Kevin Benson <Kevin.Benson@zii.aero>,
        Chris Healy <Chris.Healy@zii.aero>,
        Andrew Lunn <andrew@lunn.ch>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.5 56/65] net: dsa: mv88e6xxx: Fix masking of egress port
Date:   Thu, 19 Mar 2020 14:04:38 +0100
Message-Id: <20200319123943.985046228@linuxfoundation.org>
X-Mailer: git-send-email 2.25.2
In-Reply-To: <20200319123926.466988514@linuxfoundation.org>
References: <20200319123926.466988514@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Andrew Lunn <andrew@lunn.ch>

[ Upstream commit 3ee339eb28959629db33aaa2b8cde4c63c6289eb ]

Add missing ~ to the usage of the mask.

Reported-by: Kevin Benson <Kevin.Benson@zii.aero>
Reported-by: Chris Healy <Chris.Healy@zii.aero>
Fixes: 5c74c54ce6ff ("net: dsa: mv88e6xxx: Split monitor port configuration")
Signed-off-by: Andrew Lunn <andrew@lunn.ch>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/dsa/mv88e6xxx/global1.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/dsa/mv88e6xxx/global1.c b/drivers/net/dsa/mv88e6xxx/global1.c
index b016cc205f81f..ca3a7a7a73c32 100644
--- a/drivers/net/dsa/mv88e6xxx/global1.c
+++ b/drivers/net/dsa/mv88e6xxx/global1.c
@@ -278,13 +278,13 @@ int mv88e6095_g1_set_egress_port(struct mv88e6xxx_chip *chip,
 	switch (direction) {
 	case MV88E6XXX_EGRESS_DIR_INGRESS:
 		dest_port_chip = &chip->ingress_dest_port;
-		reg &= MV88E6185_G1_MONITOR_CTL_INGRESS_DEST_MASK;
+		reg &= ~MV88E6185_G1_MONITOR_CTL_INGRESS_DEST_MASK;
 		reg |= port <<
 		       __bf_shf(MV88E6185_G1_MONITOR_CTL_INGRESS_DEST_MASK);
 		break;
 	case MV88E6XXX_EGRESS_DIR_EGRESS:
 		dest_port_chip = &chip->egress_dest_port;
-		reg &= MV88E6185_G1_MONITOR_CTL_EGRESS_DEST_MASK;
+		reg &= ~MV88E6185_G1_MONITOR_CTL_EGRESS_DEST_MASK;
 		reg |= port <<
 		       __bf_shf(MV88E6185_G1_MONITOR_CTL_EGRESS_DEST_MASK);
 		break;
-- 
2.20.1



