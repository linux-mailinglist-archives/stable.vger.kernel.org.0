Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0F65414E279
	for <lists+stable@lfdr.de>; Thu, 30 Jan 2020 19:52:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730613AbgA3Sng (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 30 Jan 2020 13:43:36 -0500
Received: from mail.kernel.org ([198.145.29.99]:52268 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730632AbgA3Snc (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 30 Jan 2020 13:43:32 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A4BC620702;
        Thu, 30 Jan 2020 18:43:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1580409812;
        bh=raX50WWaKVukrHP5KXHr94zDerD/GUrE8P+KgpctcOo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ND8a9CjONwRRbUDsHGtlEtgeCZ9hrmE96DNbV52VXODE6SkrN8yEGXPYX/WiqE3ot
         v8Y8w8+ikq4PNMJi81lVjQCDnEfs1ZIuUfNx/vzMY0xjXctQyg0dsdb87rxebHU0V6
         ow5a6X3n8XGCkSDsF7ELuN5PzYFs0K+CL3uMpCS4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        Ido Schimmel <idosch@mellanox.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.4 041/110] mlxsw: minimal: Fix an error handling path in mlxsw_m_port_create()
Date:   Thu, 30 Jan 2020 19:38:17 +0100
Message-Id: <20200130183620.204606891@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200130183613.810054545@linuxfoundation.org>
References: <20200130183613.810054545@linuxfoundation.org>
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
@@ -204,8 +204,8 @@ mlxsw_m_port_create(struct mlxsw_m *mlxs
 
 err_register_netdev:
 	mlxsw_m->ports[local_port] = NULL;
-	free_netdev(dev);
 err_dev_addr_get:
+	free_netdev(dev);
 err_alloc_etherdev:
 	mlxsw_core_port_fini(mlxsw_m->core, local_port);
 	return err;


