Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F1292D2462
	for <lists+stable@lfdr.de>; Thu, 10 Oct 2019 11:00:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387837AbfJJIoX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 10 Oct 2019 04:44:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:49544 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388914AbfJJIoW (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 10 Oct 2019 04:44:22 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6D7B5218AC;
        Thu, 10 Oct 2019 08:44:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1570697061;
        bh=iZqvM8/ML7/3iO5oJRFmHz/GQMXiufVRTiQWFhISntU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Xj+6+BtjPvD4U91VtTLl0VtZ3otYRaKtx4grZ2s3rXULg/3UkugAvyuGJ0PgWleOc
         BEx+vx8gEESSIGUUi5nMsJXLaKVxZ5dvxN47m3vlApA3PG4LYtJRXi2mbw0o/MB9Qs
         dXUhnxb+JNRamJS+2Qf4FAnMU7AOk6HUMwT5new0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Danielle Ratson <danieller@mellanox.com>,
        Jiri Pirko <jiri@mellanox.com>,
        Ido Schimmel <idosch@mellanox.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.3 133/148] mlxsw: spectrum_flower: Fail in case user specifies multiple mirror actions
Date:   Thu, 10 Oct 2019 10:36:34 +0200
Message-Id: <20191010083620.441596408@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191010083609.660878383@linuxfoundation.org>
References: <20191010083609.660878383@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Danielle Ratson <danieller@mellanox.com>

[ Upstream commit 52feb8b588f6d23673dd7cc2b44b203493b627f6 ]

The ASIC can only mirror a packet to one port, but when user is trying
to set more than one mirror action, it doesn't fail.

Add a check if more than one mirror action was specified per rule and if so,
fail for not being supported.

Fixes: d0d13c1858a11 ("mlxsw: spectrum_acl: Add support for mirror action")
Signed-off-by: Danielle Ratson <danieller@mellanox.com>
Acked-by: Jiri Pirko <jiri@mellanox.com>
Signed-off-by: Ido Schimmel <idosch@mellanox.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/mellanox/mlxsw/spectrum_flower.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_flower.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_flower.c
index 202e9a2460194..7c13656a83384 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_flower.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_flower.c
@@ -21,6 +21,7 @@ static int mlxsw_sp_flower_parse_actions(struct mlxsw_sp *mlxsw_sp,
 					 struct netlink_ext_ack *extack)
 {
 	const struct flow_action_entry *act;
+	int mirror_act_count = 0;
 	int err, i;
 
 	if (!flow_action_has_entries(flow_action))
@@ -95,6 +96,11 @@ static int mlxsw_sp_flower_parse_actions(struct mlxsw_sp *mlxsw_sp,
 		case FLOW_ACTION_MIRRED: {
 			struct net_device *out_dev = act->dev;
 
+			if (mirror_act_count++) {
+				NL_SET_ERR_MSG_MOD(extack, "Multiple mirror actions per rule are not supported");
+				return -EOPNOTSUPP;
+			}
+
 			err = mlxsw_sp_acl_rulei_act_mirror(mlxsw_sp, rulei,
 							    block, out_dev,
 							    extack);
-- 
2.20.1



