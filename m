Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EA083199225
	for <lists+stable@lfdr.de>; Tue, 31 Mar 2020 11:24:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730618AbgCaJBx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 31 Mar 2020 05:01:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:41226 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730615AbgCaJBw (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 31 Mar 2020 05:01:52 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BA78420848;
        Tue, 31 Mar 2020 09:01:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1585645311;
        bh=HShBr38L9TtO0Jru578++oUHXplOTkg6vdn9iu3NCIQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ln8aFy0Cmy0q7xS1oYjd1guMpNNpVu/0VaCKxnYV4Aj03v5VriBANlB/PKMqL0x8C
         FYEnjq/WETXFijz8wPkAbZUDAfHYHZuLLQ7WacRmE4mR259OvZ6wumTGQKQmXZAf4h
         9wsqXjoMihncXRjJAwmpwb30q+k4P80AgcQqMsiU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ido Schimmel <idosch@mellanox.com>,
        Jiri Pirko <jiri@mellanox.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.5 015/170] mlxsw: spectrum_mr: Fix list iteration in error path
Date:   Tue, 31 Mar 2020 10:57:09 +0200
Message-Id: <20200331085425.732849676@linuxfoundation.org>
X-Mailer: git-send-email 2.26.0
In-Reply-To: <20200331085423.990189598@linuxfoundation.org>
References: <20200331085423.990189598@linuxfoundation.org>
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


