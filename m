Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A14911CAB48
	for <lists+stable@lfdr.de>; Fri,  8 May 2020 14:42:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728477AbgEHMmH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 8 May 2020 08:42:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:38414 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728905AbgEHMmF (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 8 May 2020 08:42:05 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AB6262495F;
        Fri,  8 May 2020 12:42:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588941725;
        bh=QnA5e/swKIZPucP09Yx8qvSickkdiQEwsBpFGjTzc9o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=clGhx8bKR7/jyaiUbXe1r4c2RwB4ONAoMx7IWNNNpLBwT2RV+i1DGlep6ts++Y+DA
         WGcXQNfno3LmggEUFDO3R8mBY53wF4xpjgc8z8ID55WXcZVQ5fmA+4Ydj9Wuvisyi/
         WIX4VeagerGfqrcgVvY7hjAX1dus5Fn/jbdrDzgw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Yotam Gigi <yotamg@mellanox.com>,
        Ido Schimmel <idosch@mellanox.com>,
        Jiri Pirko <jiri@mellanox.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 4.4 109/312] mlxsw: spectrum: Fix misuse of hard_header_len
Date:   Fri,  8 May 2020 14:31:40 +0200
Message-Id: <20200508123132.158392167@linuxfoundation.org>
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

commit feb7d387a6cf6c1ec66d4a2b6d4b2cc52309876e upstream.

In order to specify that the mlxsw spectrum driver needs additional
headroom for packets, there have been use of the hard_header_len field of
the netdevice struct.

This commit changes that to use needed_headroom instead, as this is the
correct way to do that.

Fixes: 56ade8fe3fe1 ("mlxsw: spectrum: Add initial support for Spectrum ASIC")
Signed-off-by: Yotam Gigi <yotamg@mellanox.com>
Acked-by: Ido Schimmel <idosch@mellanox.com>
Signed-off-by: Jiri Pirko <jiri@mellanox.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/net/ethernet/mellanox/mlxsw/spectrum.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
@@ -1261,7 +1261,7 @@ static int mlxsw_sp_port_create(struct m
 	/* Each packet needs to have a Tx header (metadata) on top all other
 	 * headers.
 	 */
-	dev->hard_header_len += MLXSW_TXHDR_LEN;
+	dev->needed_headroom = MLXSW_TXHDR_LEN;
 
 	err = mlxsw_sp_port_module_check(mlxsw_sp_port, &usable);
 	if (err) {


