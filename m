Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C8E561B0BC4
	for <lists+stable@lfdr.de>; Mon, 20 Apr 2020 14:58:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727095AbgDTMm7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Apr 2020 08:42:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:36234 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728294AbgDTMm5 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 Apr 2020 08:42:57 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 550712072B;
        Mon, 20 Apr 2020 12:42:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1587386575;
        bh=otd2QZ8LurhFqBTT0j5u25PASA7bqvPKOXhJaz2Pir8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=snvMmV5TtUs0XM4OIrInTXiWw3v2SjT0eDar6QDlAQEddRFUvFSMTW6QAuOgx/y9i
         JhnnQrYPgpFN+JXe8EHF433P743NuUqCeFZOhiuiz06RHGqnTGx2oVHnX4pG0QfbSh
         Sb7yxgG5yi2MDWwNMq0Y521vClRYZ3Ju7bCgcvSQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Michael=20Wei=C3=9F?= <michael.weiss@aisec.fraunhofer.de>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.6 03/71] l2tp: Allow management of tunnels and session in user namespace
Date:   Mon, 20 Apr 2020 14:38:17 +0200
Message-Id: <20200420121509.093352831@linuxfoundation.org>
X-Mailer: git-send-email 2.26.1
In-Reply-To: <20200420121508.491252919@linuxfoundation.org>
References: <20200420121508.491252919@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: "Michael Weiﬂ" <michael.weiss@aisec.fraunhofer.de>

[ Upstream commit 2abe05234f2e892728c388169631e4b99f354c86 ]

Creation and management of L2TPv3 tunnels and session through netlink
requires CAP_NET_ADMIN. However, a process with CAP_NET_ADMIN in a
non-initial user namespace gets an EPERM due to the use of the
genetlink GENL_ADMIN_PERM flag. Thus, management of L2TP VPNs inside
an unprivileged container won't work.

We replaced the GENL_ADMIN_PERM by the GENL_UNS_ADMIN_PERM flag
similar to other network modules which also had this problem, e.g.,
openvswitch (commit 4a92602aa1cd "openvswitch: allow management from
inside user namespaces") and nl80211 (commit 5617c6cd6f844 "nl80211:
Allow privileged operations from user namespaces").

I tested this in the container runtime trustm3 (trustm3.github.io)
and was able to create l2tp tunnels and sessions in unpriviliged
(user namespaced) containers using a private network namespace.
For other runtimes such as docker or lxc this should work, too.

Signed-off-by: Michael Wei√ü <michael.weiss@aisec.fraunhofer.de>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/l2tp/l2tp_netlink.c |   16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

--- a/net/l2tp/l2tp_netlink.c
+++ b/net/l2tp/l2tp_netlink.c
@@ -920,51 +920,51 @@ static const struct genl_ops l2tp_nl_ops
 		.cmd = L2TP_CMD_TUNNEL_CREATE,
 		.validate = GENL_DONT_VALIDATE_STRICT | GENL_DONT_VALIDATE_DUMP,
 		.doit = l2tp_nl_cmd_tunnel_create,
-		.flags = GENL_ADMIN_PERM,
+		.flags = GENL_UNS_ADMIN_PERM,
 	},
 	{
 		.cmd = L2TP_CMD_TUNNEL_DELETE,
 		.validate = GENL_DONT_VALIDATE_STRICT | GENL_DONT_VALIDATE_DUMP,
 		.doit = l2tp_nl_cmd_tunnel_delete,
-		.flags = GENL_ADMIN_PERM,
+		.flags = GENL_UNS_ADMIN_PERM,
 	},
 	{
 		.cmd = L2TP_CMD_TUNNEL_MODIFY,
 		.validate = GENL_DONT_VALIDATE_STRICT | GENL_DONT_VALIDATE_DUMP,
 		.doit = l2tp_nl_cmd_tunnel_modify,
-		.flags = GENL_ADMIN_PERM,
+		.flags = GENL_UNS_ADMIN_PERM,
 	},
 	{
 		.cmd = L2TP_CMD_TUNNEL_GET,
 		.validate = GENL_DONT_VALIDATE_STRICT | GENL_DONT_VALIDATE_DUMP,
 		.doit = l2tp_nl_cmd_tunnel_get,
 		.dumpit = l2tp_nl_cmd_tunnel_dump,
-		.flags = GENL_ADMIN_PERM,
+		.flags = GENL_UNS_ADMIN_PERM,
 	},
 	{
 		.cmd = L2TP_CMD_SESSION_CREATE,
 		.validate = GENL_DONT_VALIDATE_STRICT | GENL_DONT_VALIDATE_DUMP,
 		.doit = l2tp_nl_cmd_session_create,
-		.flags = GENL_ADMIN_PERM,
+		.flags = GENL_UNS_ADMIN_PERM,
 	},
 	{
 		.cmd = L2TP_CMD_SESSION_DELETE,
 		.validate = GENL_DONT_VALIDATE_STRICT | GENL_DONT_VALIDATE_DUMP,
 		.doit = l2tp_nl_cmd_session_delete,
-		.flags = GENL_ADMIN_PERM,
+		.flags = GENL_UNS_ADMIN_PERM,
 	},
 	{
 		.cmd = L2TP_CMD_SESSION_MODIFY,
 		.validate = GENL_DONT_VALIDATE_STRICT | GENL_DONT_VALIDATE_DUMP,
 		.doit = l2tp_nl_cmd_session_modify,
-		.flags = GENL_ADMIN_PERM,
+		.flags = GENL_UNS_ADMIN_PERM,
 	},
 	{
 		.cmd = L2TP_CMD_SESSION_GET,
 		.validate = GENL_DONT_VALIDATE_STRICT | GENL_DONT_VALIDATE_DUMP,
 		.doit = l2tp_nl_cmd_session_get,
 		.dumpit = l2tp_nl_cmd_session_dump,
-		.flags = GENL_ADMIN_PERM,
+		.flags = GENL_UNS_ADMIN_PERM,
 	},
 };
 


