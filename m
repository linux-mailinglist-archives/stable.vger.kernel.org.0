Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5BDCD1CAB9B
	for <lists+stable@lfdr.de>; Fri,  8 May 2020 14:45:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729285AbgEHMpO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 8 May 2020 08:45:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:44510 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728559AbgEHMpN (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 8 May 2020 08:45:13 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1DE26208D6;
        Fri,  8 May 2020 12:45:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588941912;
        bh=3Gv960WOUHXTssVcGdsk3y/VLn7wVu7uSqVU1Wsl9Jo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=D6ZshCZkqviC1G33C6EEoVuxb3tN+Rwmf22YmBazagbXjqZK4EXHSzV3Rsm2Vb5xp
         ggcYCYTruMPKmokWADXprx1xY1KY4IA9iXZ+N6pY8RosrzA6uHeR2Q7YqpGFxh4wku
         S5dVuxR4I6RuYXTGcn7MiDLyp9tCImZBHIqW0aXU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Moshe Shemesh <moshe@mellanox.com>,
        Tariq Toukan <tariqt@mellanox.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 4.4 221/312] net/mlx4_core: Fix QUERY FUNC CAP flags
Date:   Fri,  8 May 2020 14:33:32 +0200
Message-Id: <20200508123140.002267257@linuxfoundation.org>
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

From: Moshe Shemesh <moshe@mellanox.com>

commit c9cc599a96a6822c52cd72ed31dd7f813d792b4f upstream.

Separate QUERY_FUNC_CAP flags0 from QUERY_FUNC_CAP flags, as 'flags' is
already used for another set of flags in FUNC CAP, while phv bit should be
part of a different set of flags.
Remove QUERY_FUNC_CAP port_flags field, as it is not in use.

Fixes: 77fc29c4bbbb ('net/mlx4_core: Preparations for 802.1ad VLAN support')
Fixes: 5cc914f10851 ('mlx4_core: Added FW commands and their wrappers for supporting SRIOV')
Signed-off-by: Moshe Shemesh <moshe@mellanox.com>
Signed-off-by: Tariq Toukan <tariqt@mellanox.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/net/ethernet/mellanox/mlx4/fw.c |    5 ++---
 drivers/net/ethernet/mellanox/mlx4/fw.h |    2 +-
 2 files changed, 3 insertions(+), 4 deletions(-)

--- a/drivers/net/ethernet/mellanox/mlx4/fw.c
+++ b/drivers/net/ethernet/mellanox/mlx4/fw.c
@@ -610,8 +610,7 @@ int mlx4_QUERY_FUNC_CAP(struct mlx4_dev
 		MLX4_GET(func_cap->phys_port_id, outbox,
 			 QUERY_FUNC_CAP_PHYS_PORT_ID);
 
-	MLX4_GET(field, outbox, QUERY_FUNC_CAP_FLAGS0_OFFSET);
-	func_cap->flags |= (field & QUERY_FUNC_CAP_PHV_BIT);
+	MLX4_GET(func_cap->flags0, outbox, QUERY_FUNC_CAP_FLAGS0_OFFSET);
 
 	/* All other resources are allocated by the master, but we still report
 	 * 'num' and 'reserved' capabilities as follows:
@@ -2840,7 +2839,7 @@ int get_phv_bit(struct mlx4_dev *dev, u8
 	memset(&func_cap, 0, sizeof(func_cap));
 	err = mlx4_QUERY_FUNC_CAP(dev, port, &func_cap);
 	if (!err)
-		*phv = func_cap.flags & QUERY_FUNC_CAP_PHV_BIT;
+		*phv = func_cap.flags0 & QUERY_FUNC_CAP_PHV_BIT;
 	return err;
 }
 EXPORT_SYMBOL(get_phv_bit);
--- a/drivers/net/ethernet/mellanox/mlx4/fw.h
+++ b/drivers/net/ethernet/mellanox/mlx4/fw.h
@@ -150,7 +150,7 @@ struct mlx4_func_cap {
 	u32	qp1_proxy_qpn;
 	u32	reserved_lkey;
 	u8	physical_port;
-	u8	port_flags;
+	u8	flags0;
 	u8	flags1;
 	u64	phys_port_id;
 	u32	extra_flags;


