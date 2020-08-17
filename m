Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 32A3A247082
	for <lists+stable@lfdr.de>; Mon, 17 Aug 2020 20:10:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390360AbgHQSKD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Aug 2020 14:10:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:56286 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388308AbgHQQHq (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 17 Aug 2020 12:07:46 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5BB6122BF5;
        Mon, 17 Aug 2020 16:07:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597680465;
        bh=sCe7Ewi+32Ukxatm3iQNS9tLYzYCFtSCDUzNc7/qDaU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FD4Cd1oas35g4d1I7vMdFeEb29xhxNSrVjV5Y7RDEx7H+6J5NlXRXkRs5elEFCrNK
         meQ+IEjECPtmG5wNmehgoz/m5L+3H7+cZm0472qmDrqHe6ZJj19Dx8ffrJyMA0w94v
         h6lXvrznDbiHztDbozN4yCX9ZSiCW0DbdM/tIldE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Chris Packham <chris.packham@alliedtelesis.co.nz>,
        Andrew Lunn <andrew@lunn.ch>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 167/270] net: dsa: mv88e6xxx: MV88E6097 does not support jumbo configuration
Date:   Mon, 17 Aug 2020 17:16:08 +0200
Message-Id: <20200817143804.155028236@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200817143755.807583758@linuxfoundation.org>
References: <20200817143755.807583758@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Chris Packham <chris.packham@alliedtelesis.co.nz>

[ Upstream commit 0f3c66a3c7b4e8b9f654b3c998e9674376a51b0f ]

The MV88E6097 chip does not support configuring jumbo frames. Prior to
commit 5f4366660d65 only the 6352, 6351, 6165 and 6320 chips configured
jumbo mode. The refactor accidentally added the function for the 6097.
Remove the erroneous function pointer assignment.

Fixes: 5f4366660d65 ("net: dsa: mv88e6xxx: Refactor setting of jumbo frames")
Signed-off-by: Chris Packham <chris.packham@alliedtelesis.co.nz>
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/dsa/mv88e6xxx/chip.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/net/dsa/mv88e6xxx/chip.c b/drivers/net/dsa/mv88e6xxx/chip.c
index 6787d560e9e3d..92e4d140df6fa 100644
--- a/drivers/net/dsa/mv88e6xxx/chip.c
+++ b/drivers/net/dsa/mv88e6xxx/chip.c
@@ -3063,7 +3063,6 @@ static const struct mv88e6xxx_ops mv88e6097_ops = {
 	.port_set_frame_mode = mv88e6351_port_set_frame_mode,
 	.port_set_egress_floods = mv88e6352_port_set_egress_floods,
 	.port_set_ether_type = mv88e6351_port_set_ether_type,
-	.port_set_jumbo_size = mv88e6165_port_set_jumbo_size,
 	.port_egress_rate_limiting = mv88e6095_port_egress_rate_limiting,
 	.port_pause_limit = mv88e6097_port_pause_limit,
 	.port_disable_learn_limit = mv88e6xxx_port_disable_learn_limit,
-- 
2.25.1



