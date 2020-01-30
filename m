Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C7DD414E113
	for <lists+stable@lfdr.de>; Thu, 30 Jan 2020 19:41:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730100AbgA3SlJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 30 Jan 2020 13:41:09 -0500
Received: from mail.kernel.org ([198.145.29.99]:48978 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730069AbgA3SlI (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 30 Jan 2020 13:41:08 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D799F2082E;
        Thu, 30 Jan 2020 18:41:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1580409668;
        bh=PX+NekbHaH9u/jpvMiovw0iRieOMJ7bTyjXb933qnTw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZEOQe68PLl06dmW/9beIjqlRBQk/n7wTrh1csvpMPbG1uqxJNy+m83ehorL8qyc/A
         pKJLR+Mcj9ES8dTypVU5Jce+hvJmEVZGCNgds1j+PD+fVwJqO3dXyKr+zolpkoPuhc
         TY4vcr1iJmli+uat9PCG5ZMOkFhxeCC+0B1xxOMQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        Ido Schimmel <idosch@mellanox.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.5 43/56] mlxsw: minimal: Fix an error handling path in mlxsw_m_port_create()
Date:   Thu, 30 Jan 2020 19:39:00 +0100
Message-Id: <20200130183616.880159739@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200130183608.849023566@linuxfoundation.org>
References: <20200130183608.849023566@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Christophe JAILLET <christophe.jaillet@wanadoo.fr>

[ Upstream commit 6dd4b4f3936e17fedea1308bc70e9716f68bf232 ]

An 'alloc_etherdev()' called is not ballanced by a corresponding
'free_netdev()' call in one error handling path.

Slighly reorder the error handling code to catch the missed case.

Fixes: c100e47caa8e ("mlxsw: minimal: Add ethtool support")
Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Reviewed-by: Ido Schimmel <idosch@mellanox.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/mellanox/mlxsw/minimal.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/net/ethernet/mellanox/mlxsw/minimal.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/minimal.c
@@ -213,8 +213,8 @@ mlxsw_m_port_create(struct mlxsw_m *mlxs
 
 err_register_netdev:
 	mlxsw_m->ports[local_port] = NULL;
-	free_netdev(dev);
 err_dev_addr_get:
+	free_netdev(dev);
 err_alloc_etherdev:
 	mlxsw_core_port_fini(mlxsw_m->core, local_port);
 	return err;


