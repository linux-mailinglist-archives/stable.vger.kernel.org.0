Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 96F63521A4B
	for <lists+stable@lfdr.de>; Tue, 10 May 2022 15:51:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236299AbiEJNyw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 May 2022 09:54:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38382 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244367AbiEJNxy (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 10 May 2022 09:53:54 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2655829B83F;
        Tue, 10 May 2022 06:38:23 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E4B826188F;
        Tue, 10 May 2022 13:38:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D7917C385A6;
        Tue, 10 May 2022 13:38:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1652189902;
        bh=C2v2vHSQbWR7p6v8H7wLTi3ABqS6AIycrKUhuDO3oM0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hMqd14sL1OkGpcjxxT0aquCaQAGpssjqKQ3WeXmp23FvfUJK01ZkKX7yIXW/ulE84
         VTkggQn0VGbNKlOlrSBDITisT5IKRKSVjSm9XAw7FOUA0waa9pQewb6jqLL+xoKoW1
         WXBfGOE6PidT2EWLoZjzQpVBXaSAsjdbhiRQ64RQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ariel Levkovich <lariel@nvidia.com>,
        Maor Dickman <maord@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [PATCH 5.17 065/140] net/mlx5e: Fix wrong source vport matching on tunnel rule
Date:   Tue, 10 May 2022 15:07:35 +0200
Message-Id: <20220510130743.477938626@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220510130741.600270947@linuxfoundation.org>
References: <20220510130741.600270947@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ariel Levkovich <lariel@nvidia.com>

commit cb0d54cbf94866b48a73e10a73a55655f808cc7c upstream.

When OVS internal port is the vtep device, the first decap
rule is matching on the internal port's vport metadata value
and then changes the metadata to be the uplink's value.

Therefore, following rules on the tunnel, in chain > 0, should
avoid matching on internal port metadata and use the uplink
vport metadata instead.

Select the uplink's metadata value for the source vport match
in case the rule is in chain greater than zero, even if the tunnel
route device is internal port.

Fixes: 166f431ec6be ("net/mlx5e: Add indirect tc offload of ovs internal port")
Signed-off-by: Ariel Levkovich <lariel@nvidia.com>
Reviewed-by: Maor Dickman <maord@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c b/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
index 3f63df127091..3b151332e2f8 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
@@ -139,7 +139,7 @@ mlx5_eswitch_set_rule_source_port(struct mlx5_eswitch *esw,
 		if (mlx5_esw_indir_table_decap_vport(attr))
 			vport = mlx5_esw_indir_table_decap_vport(attr);
 
-		if (esw_attr->int_port)
+		if (attr && !attr->chain && esw_attr->int_port)
 			metadata =
 				mlx5e_tc_int_port_get_metadata_for_match(esw_attr->int_port);
 		else
-- 
2.36.1



