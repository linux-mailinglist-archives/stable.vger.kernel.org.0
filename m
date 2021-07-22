Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B634C3D2816
	for <lists+stable@lfdr.de>; Thu, 22 Jul 2021 18:37:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230415AbhGVPyq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 22 Jul 2021 11:54:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:57234 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231228AbhGVPxw (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 22 Jul 2021 11:53:52 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 366746135B;
        Thu, 22 Jul 2021 16:34:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626971667;
        bh=4PhV6mX3miDV96hA6X52LxHgvBlrZtVu1Dkw0qw2lRM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=n9jfg5/dTxxjzp2bk5/DSppkGgXnTrKbByKk5bIq0LJ380aTiNBpm2OFCl1Jx3biF
         /KKIuFKSh5Vy5QNY6I4krC/S03wMVRta/U3KipQ4Xiqoh/PgU72DiBCMyjmxqB+geu
         ynocirolMUeQIb8v19NUyr/j/CNVOvUTjOs6UqeM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>,
        Andrew Lunn <andrew@lunn.ch>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.4 53/71] net: dsa: mv88e6xxx: enable .rmu_disable() on Topaz
Date:   Thu, 22 Jul 2021 18:31:28 +0200
Message-Id: <20210722155619.658916474@linuxfoundation.org>
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

commit 3709488790022c85720f991bff50d48ed5a36e6a upstream.

Commit 9e5baf9b36367 ("net: dsa: mv88e6xxx: add RMU disable op")
introduced .rmu_disable() method with implementation for several models,
but forgot to add Topaz, which can use the Peridot implementation.

Use the Peridot implementation of .rmu_disable() on Topaz.

Signed-off-by: Marek Behún <kabel@kernel.org>
Fixes: 9e5baf9b36367 ("net: dsa: mv88e6xxx: add RMU disable op")
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/dsa/mv88e6xxx/chip.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/net/dsa/mv88e6xxx/chip.c
+++ b/drivers/net/dsa/mv88e6xxx/chip.c
@@ -3917,6 +3917,7 @@ static const struct mv88e6xxx_ops mv88e6
 	.mgmt_rsvd2cpu =  mv88e6390_g1_mgmt_rsvd2cpu,
 	.pot_clear = mv88e6xxx_g2_pot_clear,
 	.reset = mv88e6352_g1_reset,
+	.rmu_disable = mv88e6390_g1_rmu_disable,
 	.vtu_getnext = mv88e6352_g1_vtu_getnext,
 	.vtu_loadpurge = mv88e6352_g1_vtu_loadpurge,
 	.serdes_power = mv88e6390_serdes_power,
@@ -4006,6 +4007,7 @@ static const struct mv88e6xxx_ops mv88e6
 	.mgmt_rsvd2cpu = mv88e6352_g2_mgmt_rsvd2cpu,
 	.pot_clear = mv88e6xxx_g2_pot_clear,
 	.reset = mv88e6352_g1_reset,
+	.rmu_disable = mv88e6390_g1_rmu_disable,
 	.vtu_getnext = mv88e6352_g1_vtu_getnext,
 	.vtu_loadpurge = mv88e6352_g1_vtu_loadpurge,
 	.avb_ops = &mv88e6352_avb_ops,


