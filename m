Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 870D219904E
	for <lists+stable@lfdr.de>; Tue, 31 Mar 2020 11:11:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731639AbgCaJKx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 31 Mar 2020 05:10:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:54808 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731635AbgCaJKw (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 31 Mar 2020 05:10:52 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2CA8E20772;
        Tue, 31 Mar 2020 09:10:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1585645851;
        bh=HShBr38L9TtO0Jru578++oUHXplOTkg6vdn9iu3NCIQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ojjA0IVe6r+/ESbABBSI29l/H78l8iG9Siq9qubyI7u0Fi2hozEr7Km8flaajJ5Zv
         aPwoCdONp8hlCPhBEZj5tBiMOeda0bCP/NTIX7i3gMbQQNASwff9kRE5huXAuAkQPi
         fIvJeN9dFwy/AIQMb8CFV/REHaCFUS8h/BiyoXoo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ido Schimmel <idosch@mellanox.com>,
        Jiri Pirko <jiri@mellanox.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.4 014/155] mlxsw: spectrum_mr: Fix list iteration in error path
Date:   Tue, 31 Mar 2020 10:57:34 +0200
Message-Id: <20200331085419.978106381@linuxfoundation.org>
X-Mailer: git-send-email 2.26.0
In-Reply-To: <20200331085418.274292403@linuxfoundation.org>
References: <20200331085418.274292403@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ido Schimmel <idosch@mellanox.com>

[ Upstream commit f6bf1bafdc2152bb22aff3a4e947f2441a1d49e2 ]

list_for_each_entry_from_reverse() iterates backwards over the list from
the current position, but in the error path we should start from the
previous position.

Fix this by using list_for_each_entry_continue_reverse() instead.

This suppresses the following error from coccinelle:

drivers/net/ethernet/mellanox/mlxsw//spectrum_mr.c:655:34-38: ERROR:
invalid reference to the index variable of the iterator on line 636

Fixes: c011ec1bbfd6 ("mlxsw: spectrum: Add the multicast routing offloading logic")
Signed-off-by: Ido Schimmel <idosch@mellanox.com>
Reviewed-by: Jiri Pirko <jiri@mellanox.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/mellanox/mlxsw/spectrum_mr.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_mr.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_mr.c
@@ -637,12 +637,12 @@ static int mlxsw_sp_mr_vif_resolve(struc
 	return 0;
 
 err_erif_unresolve:
-	list_for_each_entry_from_reverse(erve, &mr_vif->route_evif_list,
-					 vif_node)
+	list_for_each_entry_continue_reverse(erve, &mr_vif->route_evif_list,
+					     vif_node)
 		mlxsw_sp_mr_route_evif_unresolve(mr_table, erve);
 err_irif_unresolve:
-	list_for_each_entry_from_reverse(irve, &mr_vif->route_ivif_list,
-					 vif_node)
+	list_for_each_entry_continue_reverse(irve, &mr_vif->route_ivif_list,
+					     vif_node)
 		mlxsw_sp_mr_route_ivif_unresolve(mr_table, irve);
 	mr_vif->rif = NULL;
 	return err;


