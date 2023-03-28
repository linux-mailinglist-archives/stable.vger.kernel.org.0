Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 71A286CC3FB
	for <lists+stable@lfdr.de>; Tue, 28 Mar 2023 16:58:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233657AbjC1O6y (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Mar 2023 10:58:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35544 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233676AbjC1O6o (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 28 Mar 2023 10:58:44 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 85CE9197
        for <stable@vger.kernel.org>; Tue, 28 Mar 2023 07:58:35 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 219F06183C
        for <stable@vger.kernel.org>; Tue, 28 Mar 2023 14:58:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2E882C4339B;
        Tue, 28 Mar 2023 14:58:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1680015514;
        bh=KDDxBnEe8PyQ9UZWZq/QsN2uO1AnDwNhjF+8EoXVacU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=EZXkPdkKJS5xCpCDuVsWsQUm03wAl6xswXSklRUKQT+9Prf/UI5xGbzSIU9xuueFD
         cI4OOZnH65N6AJApTqVtCSg4DgM9Zu3ayEo6waolV2JFLWzG/7vrzu3R/VjIXbXs5i
         LDU989/y5ru9Wv7AezDsfG7WtIQVn5tvtXqgmvEM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Ido Schimmel <idosch@nvidia.com>,
        Danielle Ratson <danieller@nvidia.com>,
        Petr Machata <petrm@nvidia.com>,
        Simon Horman <simon.horman@corigine.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 075/224] mlxsw: spectrum_fid: Fix incorrect local port type
Date:   Tue, 28 Mar 2023 16:41:11 +0200
Message-Id: <20230328142620.461332920@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230328142617.205414124@linuxfoundation.org>
References: <20230328142617.205414124@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-5.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ido Schimmel <idosch@nvidia.com>

[ Upstream commit bb765a743377d46d8da8e7f7e5128022504741b9 ]

Local port is a 10-bit number, but it was mistakenly stored in a u8,
resulting in firmware errors when using a netdev corresponding to a
local port higher than 255.

Fix by storing the local port in u16, as is done in the rest of the
code.

Fixes: bf73904f5fba ("mlxsw: Add support for 802.1Q FID family")
Signed-off-by: Ido Schimmel <idosch@nvidia.com>
Reviewed-by: Danielle Ratson <danieller@nvidia.com>
Signed-off-by: Petr Machata <petrm@nvidia.com>
Reviewed-by: Simon Horman <simon.horman@corigine.com>
Link: https://lore.kernel.org/r/eace1f9d96545ab8a2775db857cb7e291a9b166b.1679398549.git.petrm@nvidia.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/mellanox/mlxsw/spectrum_fid.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_fid.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_fid.c
index 045a24cacfa51..b6ee2d658b0c4 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_fid.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_fid.c
@@ -1354,7 +1354,7 @@ static int mlxsw_sp_fid_8021q_port_vid_map(struct mlxsw_sp_fid *fid,
 					   u16 vid)
 {
 	struct mlxsw_sp *mlxsw_sp = mlxsw_sp_port->mlxsw_sp;
-	u8 local_port = mlxsw_sp_port->local_port;
+	u16 local_port = mlxsw_sp_port->local_port;
 	int err;
 
 	/* In case there are no {Port, VID} => FID mappings on the port,
@@ -1391,7 +1391,7 @@ mlxsw_sp_fid_8021q_port_vid_unmap(struct mlxsw_sp_fid *fid,
 				  struct mlxsw_sp_port *mlxsw_sp_port, u16 vid)
 {
 	struct mlxsw_sp *mlxsw_sp = mlxsw_sp_port->mlxsw_sp;
-	u8 local_port = mlxsw_sp_port->local_port;
+	u16 local_port = mlxsw_sp_port->local_port;
 
 	mlxsw_sp_fid_port_vid_list_del(fid, mlxsw_sp_port->local_port, vid);
 	mlxsw_sp_fid_evid_map(fid, local_port, vid, false);
-- 
2.39.2



