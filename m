Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4AB22F7F5
	for <lists+stable@lfdr.de>; Tue, 30 Apr 2019 14:04:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728708AbfD3Lmy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 30 Apr 2019 07:42:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:52506 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729621AbfD3Lmx (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 30 Apr 2019 07:42:53 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4101121734;
        Tue, 30 Apr 2019 11:42:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1556624572;
        bh=AA/ezfwnN75aWAfPNZjA1OF7FxN3hdmIpnqpwiSVqM4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jOXp1/VFOinEpSI8Ntez9+kSICCG7VVYfrN6SGA5Mcec4/CidIdAqrNRCFjC4jP4/
         fCOYmjC3H/Vm/5XHoBH7Ea83fRL3jqxPHr39dInJXdkUespqVX+oHIFCYNfYbjnS/e
         e3a3uHs/nSGyA9BrOtSRN3V2C4gBQrTgQ7edhmM8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Amit Cohen <amitc@mellanox.com>,
        Ido Schimmel <idosch@mellanox.com>,
        Jiri Pirko <jiri@mellanox.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 4.14 45/53] mlxsw: spectrum: Fix autoneg status in ethtool
Date:   Tue, 30 Apr 2019 13:38:52 +0200
Message-Id: <20190430113558.669947083@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190430113549.400132183@linuxfoundation.org>
References: <20190430113549.400132183@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Amit Cohen <amitc@mellanox.com>

[ Upstream commit 151f0dddbbfe4c35c9c5b64873115aafd436af9d ]

If link is down and autoneg is set to on/off, the status in ethtool does
not change.

The reason is when the link is down the function returns with zero
before changing autoneg value.

Move the checking of link state (up/down) to be performed after setting
autoneg value, in order to be sure that autoneg will change in any case.

Fixes: 56ade8fe3fe1 ("mlxsw: spectrum: Add initial support for Spectrum ASIC")
Signed-off-by: Amit Cohen <amitc@mellanox.com>
Signed-off-by: Ido Schimmel <idosch@mellanox.com>
Acked-by: Jiri Pirko <jiri@mellanox.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/mellanox/mlxsw/spectrum.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
@@ -2521,11 +2521,11 @@ mlxsw_sp_port_set_link_ksettings(struct
 	if (err)
 		return err;
 
+	mlxsw_sp_port->link.autoneg = autoneg;
+
 	if (!netif_running(dev))
 		return 0;
 
-	mlxsw_sp_port->link.autoneg = autoneg;
-
 	mlxsw_sp_port_admin_status_set(mlxsw_sp_port, false);
 	mlxsw_sp_port_admin_status_set(mlxsw_sp_port, true);
 


