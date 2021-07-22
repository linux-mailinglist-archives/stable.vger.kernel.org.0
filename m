Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6D2803D2815
	for <lists+stable@lfdr.de>; Thu, 22 Jul 2021 18:37:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230290AbhGVPyq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 22 Jul 2021 11:54:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:57568 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231210AbhGVPxv (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 22 Jul 2021 11:53:51 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id BAF3F6135C;
        Thu, 22 Jul 2021 16:34:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626971665;
        bh=NEYFG3I6zwcenDUCHN94hlPqLozF/00j677ijGCPZiE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=wooJn8OmzUEdzHKvN3wmGatddb8gUmIFaFDOpOcr1g/JW4DsD384MXLc31wTc9mf2
         DOwTrROa3dG2Nrgbg1aM613ynHmdUo1M1EK07VybrYe+8YbrqU1dng78f9Yt77+zyB
         NYoDx7u5yYTVHN4Y1s+E/oomCiMLaJz/Gyxjd6XU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>,
        Andrew Lunn <andrew@lunn.ch>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.4 52/71] net: dsa: mv88e6xxx: enable .port_set_policy() on Topaz
Date:   Thu, 22 Jul 2021 18:31:27 +0200
Message-Id: <20210722155619.625863063@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210722155617.865866034@linuxfoundation.org>
References: <20210722155617.865866034@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Marek Behún <kabel@kernel.org>

commit 7da467d82d1ed4fb317aff836f99709169e73f10 upstream.

Commit f3a2cd326e44 ("net: dsa: mv88e6xxx: introduce .port_set_policy")
introduced .port_set_policy() method with implementation for several
models, but forgot to add Topaz, which can use the 6352 implementation.

Use the 6352 implementation of .port_set_policy() on Topaz.

Signed-off-by: Marek Behún <kabel@kernel.org>
Fixes: f3a2cd326e44 ("net: dsa: mv88e6xxx: introduce .port_set_policy")
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/dsa/mv88e6xxx/chip.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/net/dsa/mv88e6xxx/chip.c
+++ b/drivers/net/dsa/mv88e6xxx/chip.c
@@ -3715,6 +3715,7 @@ static const struct mv88e6xxx_ops mv88e6
 	.port_set_rgmii_delay = mv88e6352_port_set_rgmii_delay,
 	.port_set_speed = mv88e6250_port_set_speed,
 	.port_tag_remap = mv88e6095_port_tag_remap,
+	.port_set_policy = mv88e6352_port_set_policy,
 	.port_set_frame_mode = mv88e6351_port_set_frame_mode,
 	.port_set_egress_floods = mv88e6352_port_set_egress_floods,
 	.port_set_ether_type = mv88e6351_port_set_ether_type,
@@ -3982,6 +3983,7 @@ static const struct mv88e6xxx_ops mv88e6
 	.port_set_rgmii_delay = mv88e6352_port_set_rgmii_delay,
 	.port_set_speed = mv88e6185_port_set_speed,
 	.port_tag_remap = mv88e6095_port_tag_remap,
+	.port_set_policy = mv88e6352_port_set_policy,
 	.port_set_frame_mode = mv88e6351_port_set_frame_mode,
 	.port_set_egress_floods = mv88e6352_port_set_egress_floods,
 	.port_set_ether_type = mv88e6351_port_set_ether_type,


