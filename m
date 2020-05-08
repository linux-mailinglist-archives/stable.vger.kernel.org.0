Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1FDC31CAF3D
	for <lists+stable@lfdr.de>; Fri,  8 May 2020 15:17:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728454AbgEHNQU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 8 May 2020 09:16:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:44614 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727943AbgEHMpP (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 8 May 2020 08:45:15 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 89D2121473;
        Fri,  8 May 2020 12:45:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588941915;
        bh=+3sH12Mcafg+dre+feGqjGBkiQ+LF0frBeNkWn0pyhI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gQWiYfXDk1lV0cqnnYQPTW7MJtpqhG0lyo6eRPNu2fyjLwR2I4l9GngdpG9fmgDHI
         +7HlxOmAqXk+R/zx5ynZpTct5IbWE0u1fZzbk3+ixwZ7IhL5hPrHSbA0tPWOmHTKta
         tWRXJjfeyuh0Z/67G2DVDGcou8ZQ2Rh+TwJzQ6DU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Yotam Gigi <yotamg@mellanox.com>,
        Ido Schimmel <idosch@mellanox.com>,
        Jiri Pirko <jiri@mellanox.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 4.4 222/312] mlxsw: switchx2: Fix misuse of hard_header_len
Date:   Fri,  8 May 2020 14:33:33 +0200
Message-Id: <20200508123140.073297562@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200508123124.574959822@linuxfoundation.org>
References: <20200508123124.574959822@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Yotam Gigi <yotamg@mellanox.com>

commit 251d41c58b765f00d73b1b4230cad256e25f2735 upstream.

In order to specify that the mlxsw switchx2 driver needs additional
headroom for packets, there have been use of the hard_header_len field of
the netdevice struct.

This commit changes that to use needed_headroom instead, as this is the
correct way to do that.

Fixes: 31557f0f9755 ("mlxsw: Introduce Mellanox SwitchX-2 ASIC support")
Signed-off-by: Yotam Gigi <yotamg@mellanox.com>
Acked-by: Ido Schimmel <idosch@mellanox.com>
Signed-off-by: Jiri Pirko <jiri@mellanox.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/net/ethernet/mellanox/mlxsw/switchx2.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/net/ethernet/mellanox/mlxsw/switchx2.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/switchx2.c
@@ -993,7 +993,7 @@ static int mlxsw_sx_port_create(struct m
 	/* Each packet needs to have a Tx header (metadata) on top all other
 	 * headers.
 	 */
-	dev->hard_header_len += MLXSW_TXHDR_LEN;
+	dev->needed_headroom = MLXSW_TXHDR_LEN;
 
 	err = mlxsw_sx_port_module_check(mlxsw_sx_port, &usable);
 	if (err) {


