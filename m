Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0CF7C499BF0
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 23:05:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348426AbiAXV5s (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 16:57:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57526 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1574952AbiAXVuu (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 16:50:50 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BDF23C0885A2;
        Mon, 24 Jan 2022 12:33:36 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 7C52FB81229;
        Mon, 24 Jan 2022 20:33:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 95F58C340E5;
        Mon, 24 Jan 2022 20:33:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643056414;
        bh=eSOZJjsod7JXBVDUOGZX0mGYhD7AX7qWZXKijpCydxQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nUuoS53NbokrU/t7mxrwIJeG8D+r2Q489HOPZHkCAGs9tVFmu+a9GcIBHPgFVArgA
         Lvx/S43aBMwoIXFqg0Hk2mx7TrrGUbssU44A2NPN4k9m79eLhQcEvyQpKP5SXvK18/
         gnuEhDP0dwWdNd41vJGp+Fs+UinR3knQnNVb7Wsg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Tycho Andersen <tycho@tycho.pizza>,
        =?UTF-8?q?Linus=20L=C3=BCssing?= <linus.luessing@c0d3.blue>,
        Sven Eckelmann <sven@narfation.org>,
        Simon Wunderlich <sw@simonwunderlich.de>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 477/846] batman-adv: allow netlink usage in unprivileged containers
Date:   Mon, 24 Jan 2022 19:39:54 +0100
Message-Id: <20220124184117.471049406@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124184100.867127425@linuxfoundation.org>
References: <20220124184100.867127425@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Linus Lüssing <linus.luessing@c0d3.blue>

[ Upstream commit 9057d6c23e7388ee9d037fccc9a7bc8557ce277b ]

Currently, creating a batman-adv interface in an unprivileged LXD
container and attaching secondary interfaces to it with "ip" or "batctl"
works fine. However all batctl debug and configuration commands
fail:

  root@container:~# batctl originators
  Error received: Operation not permitted
  root@container:~# batctl orig_interval
  1000
  root@container:~# batctl orig_interval 2000
  root@container:~# batctl orig_interval
  1000

To fix this change the generic netlink permissions from GENL_ADMIN_PERM
to GENL_UNS_ADMIN_PERM. This way a batman-adv interface is fully
maintainable as root from within a user namespace, from an unprivileged
container.

All except one batman-adv netlink setting are per interface and do not
leak information or change settings from the host system and are
therefore save to retrieve or modify as root from within an unprivileged
container.

"batctl routing_algo" / BATADV_CMD_GET_ROUTING_ALGOS is the only
exception: It provides the batman-adv kernel module wide default routing
algorithm. However it is read-only from netlink and an unprivileged
container is still not allowed to modify
/sys/module/batman_adv/parameters/routing_algo. Instead it is advised to
use the newly introduced "batctl if create routing_algo RA_NAME" /
IFLA_BATADV_ALGO_NAME to set the routing algorithm on interface
creation, which already works fine in an unprivileged container.

Cc: Tycho Andersen <tycho@tycho.pizza>
Signed-off-by: Linus Lüssing <linus.luessing@c0d3.blue>
Signed-off-by: Sven Eckelmann <sven@narfation.org>
Signed-off-by: Simon Wunderlich <sw@simonwunderlich.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/batman-adv/netlink.c | 30 +++++++++++++++---------------
 1 file changed, 15 insertions(+), 15 deletions(-)

diff --git a/net/batman-adv/netlink.c b/net/batman-adv/netlink.c
index 29276284d281c..00875e1d8c44c 100644
--- a/net/batman-adv/netlink.c
+++ b/net/batman-adv/netlink.c
@@ -1368,21 +1368,21 @@ static const struct genl_small_ops batadv_netlink_ops[] = {
 	{
 		.cmd = BATADV_CMD_TP_METER,
 		.validate = GENL_DONT_VALIDATE_STRICT | GENL_DONT_VALIDATE_DUMP,
-		.flags = GENL_ADMIN_PERM,
+		.flags = GENL_UNS_ADMIN_PERM,
 		.doit = batadv_netlink_tp_meter_start,
 		.internal_flags = BATADV_FLAG_NEED_MESH,
 	},
 	{
 		.cmd = BATADV_CMD_TP_METER_CANCEL,
 		.validate = GENL_DONT_VALIDATE_STRICT | GENL_DONT_VALIDATE_DUMP,
-		.flags = GENL_ADMIN_PERM,
+		.flags = GENL_UNS_ADMIN_PERM,
 		.doit = batadv_netlink_tp_meter_cancel,
 		.internal_flags = BATADV_FLAG_NEED_MESH,
 	},
 	{
 		.cmd = BATADV_CMD_GET_ROUTING_ALGOS,
 		.validate = GENL_DONT_VALIDATE_STRICT | GENL_DONT_VALIDATE_DUMP,
-		.flags = GENL_ADMIN_PERM,
+		.flags = GENL_UNS_ADMIN_PERM,
 		.dumpit = batadv_algo_dump,
 	},
 	{
@@ -1397,68 +1397,68 @@ static const struct genl_small_ops batadv_netlink_ops[] = {
 	{
 		.cmd = BATADV_CMD_GET_TRANSTABLE_LOCAL,
 		.validate = GENL_DONT_VALIDATE_STRICT | GENL_DONT_VALIDATE_DUMP,
-		.flags = GENL_ADMIN_PERM,
+		.flags = GENL_UNS_ADMIN_PERM,
 		.dumpit = batadv_tt_local_dump,
 	},
 	{
 		.cmd = BATADV_CMD_GET_TRANSTABLE_GLOBAL,
 		.validate = GENL_DONT_VALIDATE_STRICT | GENL_DONT_VALIDATE_DUMP,
-		.flags = GENL_ADMIN_PERM,
+		.flags = GENL_UNS_ADMIN_PERM,
 		.dumpit = batadv_tt_global_dump,
 	},
 	{
 		.cmd = BATADV_CMD_GET_ORIGINATORS,
 		.validate = GENL_DONT_VALIDATE_STRICT | GENL_DONT_VALIDATE_DUMP,
-		.flags = GENL_ADMIN_PERM,
+		.flags = GENL_UNS_ADMIN_PERM,
 		.dumpit = batadv_orig_dump,
 	},
 	{
 		.cmd = BATADV_CMD_GET_NEIGHBORS,
 		.validate = GENL_DONT_VALIDATE_STRICT | GENL_DONT_VALIDATE_DUMP,
-		.flags = GENL_ADMIN_PERM,
+		.flags = GENL_UNS_ADMIN_PERM,
 		.dumpit = batadv_hardif_neigh_dump,
 	},
 	{
 		.cmd = BATADV_CMD_GET_GATEWAYS,
 		.validate = GENL_DONT_VALIDATE_STRICT | GENL_DONT_VALIDATE_DUMP,
-		.flags = GENL_ADMIN_PERM,
+		.flags = GENL_UNS_ADMIN_PERM,
 		.dumpit = batadv_gw_dump,
 	},
 	{
 		.cmd = BATADV_CMD_GET_BLA_CLAIM,
 		.validate = GENL_DONT_VALIDATE_STRICT | GENL_DONT_VALIDATE_DUMP,
-		.flags = GENL_ADMIN_PERM,
+		.flags = GENL_UNS_ADMIN_PERM,
 		.dumpit = batadv_bla_claim_dump,
 	},
 	{
 		.cmd = BATADV_CMD_GET_BLA_BACKBONE,
 		.validate = GENL_DONT_VALIDATE_STRICT | GENL_DONT_VALIDATE_DUMP,
-		.flags = GENL_ADMIN_PERM,
+		.flags = GENL_UNS_ADMIN_PERM,
 		.dumpit = batadv_bla_backbone_dump,
 	},
 	{
 		.cmd = BATADV_CMD_GET_DAT_CACHE,
 		.validate = GENL_DONT_VALIDATE_STRICT | GENL_DONT_VALIDATE_DUMP,
-		.flags = GENL_ADMIN_PERM,
+		.flags = GENL_UNS_ADMIN_PERM,
 		.dumpit = batadv_dat_cache_dump,
 	},
 	{
 		.cmd = BATADV_CMD_GET_MCAST_FLAGS,
 		.validate = GENL_DONT_VALIDATE_STRICT | GENL_DONT_VALIDATE_DUMP,
-		.flags = GENL_ADMIN_PERM,
+		.flags = GENL_UNS_ADMIN_PERM,
 		.dumpit = batadv_mcast_flags_dump,
 	},
 	{
 		.cmd = BATADV_CMD_SET_MESH,
 		.validate = GENL_DONT_VALIDATE_STRICT | GENL_DONT_VALIDATE_DUMP,
-		.flags = GENL_ADMIN_PERM,
+		.flags = GENL_UNS_ADMIN_PERM,
 		.doit = batadv_netlink_set_mesh,
 		.internal_flags = BATADV_FLAG_NEED_MESH,
 	},
 	{
 		.cmd = BATADV_CMD_SET_HARDIF,
 		.validate = GENL_DONT_VALIDATE_STRICT | GENL_DONT_VALIDATE_DUMP,
-		.flags = GENL_ADMIN_PERM,
+		.flags = GENL_UNS_ADMIN_PERM,
 		.doit = batadv_netlink_set_hardif,
 		.internal_flags = BATADV_FLAG_NEED_MESH |
 				  BATADV_FLAG_NEED_HARDIF,
@@ -1474,7 +1474,7 @@ static const struct genl_small_ops batadv_netlink_ops[] = {
 	{
 		.cmd = BATADV_CMD_SET_VLAN,
 		.validate = GENL_DONT_VALIDATE_STRICT | GENL_DONT_VALIDATE_DUMP,
-		.flags = GENL_ADMIN_PERM,
+		.flags = GENL_UNS_ADMIN_PERM,
 		.doit = batadv_netlink_set_vlan,
 		.internal_flags = BATADV_FLAG_NEED_MESH |
 				  BATADV_FLAG_NEED_VLAN,
-- 
2.34.1



