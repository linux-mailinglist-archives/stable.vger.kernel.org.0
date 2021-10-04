Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4FCDB420FBE
	for <lists+stable@lfdr.de>; Mon,  4 Oct 2021 15:35:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238247AbhJDNhk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 4 Oct 2021 09:37:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:48748 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237929AbhJDNfp (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 4 Oct 2021 09:35:45 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5D8A163235;
        Mon,  4 Oct 2021 13:16:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1633353378;
        bh=I+zoxOHyrC8Sc9tP4I02hf6JFr5n+FniFXjBeVbVrxM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=zLdD+e7MxHm1AFSuYWZs7Zsrf7FEUL41L9dgIZbf0dWMdo3QmMxww4dbaurSEwrt3
         N8an2bDcSiL4Mxk0HaUwmT4HWeufMlvJSPAwsYWsVD3r7mhHpQCjGmdNjcZiv//xS9
         aBsA+xxWTFqaH26OsI76v4MZsm2WdUWuaD7Cbevc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Andrew Lunn <andrew@lunn.ch>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.14 106/172] dsa: mv88e6xxx: 6161: Use chip wide MAX MTU
Date:   Mon,  4 Oct 2021 14:52:36 +0200
Message-Id: <20211004125048.408605566@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211004125044.945314266@linuxfoundation.org>
References: <20211004125044.945314266@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Andrew Lunn <andrew@lunn.ch>

[ Upstream commit fe23036192c95b66e60d019d2ec1814d0d561ffd ]

The datasheets suggests the 6161 uses a per port setting for jumbo
frames. Testing has however shown this is not correct, it uses the old
style chip wide MTU control. Change the ops in the 6161 structure to
reflect this.

Fixes: 1baf0fac10fb ("net: dsa: mv88e6xxx: Use chip-wide max frame size for MTU")
Reported by: 曹煜 <cao88yu@gmail.com>
Signed-off-by: Andrew Lunn <andrew@lunn.ch>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/dsa/mv88e6xxx/chip.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/dsa/mv88e6xxx/chip.c b/drivers/net/dsa/mv88e6xxx/chip.c
index 1c122a1f2f97..f99f09c50722 100644
--- a/drivers/net/dsa/mv88e6xxx/chip.c
+++ b/drivers/net/dsa/mv88e6xxx/chip.c
@@ -3657,7 +3657,6 @@ static const struct mv88e6xxx_ops mv88e6161_ops = {
 	.port_set_ucast_flood = mv88e6352_port_set_ucast_flood,
 	.port_set_mcast_flood = mv88e6352_port_set_mcast_flood,
 	.port_set_ether_type = mv88e6351_port_set_ether_type,
-	.port_set_jumbo_size = mv88e6165_port_set_jumbo_size,
 	.port_egress_rate_limiting = mv88e6097_port_egress_rate_limiting,
 	.port_pause_limit = mv88e6097_port_pause_limit,
 	.port_disable_learn_limit = mv88e6xxx_port_disable_learn_limit,
@@ -3682,6 +3681,7 @@ static const struct mv88e6xxx_ops mv88e6161_ops = {
 	.avb_ops = &mv88e6165_avb_ops,
 	.ptp_ops = &mv88e6165_ptp_ops,
 	.phylink_validate = mv88e6185_phylink_validate,
+	.set_max_frame_size = mv88e6185_g1_set_max_frame_size,
 };
 
 static const struct mv88e6xxx_ops mv88e6165_ops = {
-- 
2.33.0



