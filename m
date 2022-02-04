Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DE03B4A96D4
	for <lists+stable@lfdr.de>; Fri,  4 Feb 2022 10:31:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357834AbiBDJa1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 4 Feb 2022 04:30:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33316 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357589AbiBDJ2j (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 4 Feb 2022 04:28:39 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D9E0DC061779;
        Fri,  4 Feb 2022 01:27:12 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4CEE6615ED;
        Fri,  4 Feb 2022 09:27:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1A503C340ED;
        Fri,  4 Feb 2022 09:27:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643966831;
        bh=vWUsnLKaMLS0zuZYpr+LPWNeIvOfQMdUJ9pyGN6qUaM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=OQMD9gJ44cIHn8S1BmoitWoxniQUoTQ686dFuQaLHb3L0QP7w+F/WUgBCRKDODEma
         akruJaW+XmpDp+xczL9inaYLfcBM4lPMC2mtpS4GsQTruyNJhINC6Y5OOT81J1jJQP
         uJibKPA+IXnL1EYgSdmURBiDYmcA7wSTTYkJnPDQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Roi Dayan <roid@nvidia.com>,
        Ariel Levkovich <lariel@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [PATCH 5.16 28/43] net/mlx5e: Avoid implicit modify hdr for decap drop rule
Date:   Fri,  4 Feb 2022 10:22:35 +0100
Message-Id: <20220204091918.080295755@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220204091917.166033635@linuxfoundation.org>
References: <20220204091917.166033635@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Roi Dayan <roid@nvidia.com>

commit 5b209d1a22afabfb7d644abb10510c5713a3e569 upstream.

Currently the driver adds implicit modify hdr action for
decap rules on tunnel devices if the port is an ovs port.
This is also done if the action is drop and makes the modify
hdr redundant and also the FW doesn't support it and will generate
a syndrome.

kernel: mlx5_core 0000:08:00.0: mlx5_cmd_check:777:(pid 102063): SET_FLOW_TABLE_ENTRY(0x936) op_mod(0x0) failed, status bad parameter(0x3), syndrome (0x8708c3)

Fix it by adding the implicit modify hdr only for fwd actions.

Fixes: b16eb3c81fe2 ("net/mlx5: Support internal port as decap route device")
Fixes: 077cdda764c7 ("net/mlx5e: TC, Fix memory leak with rules with internal port")
Signed-off-by: Roi Dayan <roid@nvidia.com>
Reviewed-by: Ariel Levkovich <lariel@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/mellanox/mlx5/core/en_tc.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
@@ -1425,7 +1425,8 @@ mlx5e_tc_add_fdb_flow(struct mlx5e_priv
 		if (err)
 			goto err_out;
 
-		if (!attr->chain && esw_attr->int_port) {
+		if (!attr->chain && esw_attr->int_port &&
+		    attr->action & MLX5_FLOW_CONTEXT_ACTION_FWD_DEST) {
 			/* If decap route device is internal port, change the
 			 * source vport value in reg_c0 back to uplink just in
 			 * case the rule performs goto chain > 0. If we have a miss


