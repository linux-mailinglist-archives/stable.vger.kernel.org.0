Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 98AAF12F0EE
	for <lists+stable@lfdr.de>; Thu,  2 Jan 2020 23:57:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727429AbgABWRc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 2 Jan 2020 17:17:32 -0500
Received: from mail.kernel.org ([198.145.29.99]:60012 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728168AbgABWRa (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 2 Jan 2020 17:17:30 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5674A24125;
        Thu,  2 Jan 2020 22:17:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1578003449;
        bh=xZQLgMunRJyO2nb4wPwgaz0jgqxLQJDMF+Jhyi9R9Ds=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=BQ32KbMfUJQNc2DW5OMcW7xVdI2i2UxJk41W1VMJmS8u1o3q2lf3NlHbqPzovajWp
         li+r8/BR7X27x2E4quUInI9N0T2XPPj8zgKdPuNr0XYFgv5LW22GHWYwQVczL35mIW
         t/uwe++I1aYwXEIg1rMewIlfJ6s/elixW2i62YyA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Amit Cohen <amitc@mellanox.com>,
        Ido Schimmel <idosch@mellanox.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.4 165/191] mlxsw: spectrum_router: Skip loopback RIFs during MAC validation
Date:   Thu,  2 Jan 2020 23:07:27 +0100
Message-Id: <20200102215847.025180886@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200102215829.911231638@linuxfoundation.org>
References: <20200102215829.911231638@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Amit Cohen <amitc@mellanox.com>

[ Upstream commit 314bd842d98e1035cc40b671a71e07f48420e58f ]

When a router interface (RIF) is created the MAC address of the backing
netdev is verified to have the same MSBs as existing RIFs. This is
required in order to avoid changing existing RIF MAC addresses that all
share the same MSBs.

Loopback RIFs are special in this regard as they do not have a MAC
address, given they are only used to loop packets from the overlay to
the underlay.

Without this change, an error is returned when trying to create a RIF
after the creation of a GRE tunnel that is represented by a loopback
RIF. 'rif->dev->dev_addr' points to the GRE device's local IP, which
does not share the same MSBs as physical interfaces. Adding an IP
address to any physical interface results in:

Error: mlxsw_spectrum: All router interface MAC addresses must have the
same prefix.

Fix this by skipping loopback RIFs during MAC validation.

Fixes: 74bc99397438 ("mlxsw: spectrum_router: Veto unsupported RIF MAC addresses")
Signed-off-by: Amit Cohen <amitc@mellanox.com>
Signed-off-by: Ido Schimmel <idosch@mellanox.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c
@@ -6985,6 +6985,9 @@ static int mlxsw_sp_router_port_check_ri
 
 	for (i = 0; i < MLXSW_CORE_RES_GET(mlxsw_sp->core, MAX_RIFS); i++) {
 		rif = mlxsw_sp->router->rifs[i];
+		if (rif && rif->ops &&
+		    rif->ops->type == MLXSW_SP_RIF_TYPE_IPIP_LB)
+			continue;
 		if (rif && rif->dev && rif->dev != dev &&
 		    !ether_addr_equal_masked(rif->dev->dev_addr, dev_addr,
 					     mlxsw_sp->mac_mask)) {


