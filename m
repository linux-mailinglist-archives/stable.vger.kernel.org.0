Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5CF8D498B62
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 20:13:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237290AbiAXTNM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 14:13:12 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:37356 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347787AbiAXTLK (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 14:11:10 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 451AFB81232;
        Mon, 24 Jan 2022 19:11:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5DC1DC340E7;
        Mon, 24 Jan 2022 19:11:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643051467;
        bh=DthYjh+AUf6U0msGHmNsk3EuOaLtsWRn1QyFhfakDLQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=zb51iuivRtVdWVwNQN83Eo4upmNDdauGY42iXkxDnA5TlvmuT+fZ6OCm6rnrkRZqq
         9RagJTNOmmLpoHsKe/Ed5jG980Qte65SQUwJBLRQD7vcGopZFXO02fk64gPryp0T70
         twSl08Pu3H/Mgx5sBZIcm9XiNuM06BL/Cr4PP988=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Guillaume Nault <gnault@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 4.14 171/186] libcxgb: Dont accidentally set RTO_ONLINK in cxgb_find_route()
Date:   Mon, 24 Jan 2022 19:44:06 +0100
Message-Id: <20220124183942.616265035@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124183937.101330125@linuxfoundation.org>
References: <20220124183937.101330125@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Guillaume Nault <gnault@redhat.com>

commit a915deaa9abe4fb3a440312c954253a6a733608e upstream.

Mask the ECN bits before calling ip_route_output_ports(). The tos
variable might be passed directly from an IPv4 header, so it may have
the last ECN bit set. This interferes with the route lookup process as
ip_route_output_key_hash() interpretes this bit specially (to restrict
the route scope).

Found by code inspection, compile tested only.

Fixes: 804c2f3e36ef ("libcxgb,iw_cxgb4,cxgbit: add cxgb_find_route()")
Signed-off-by: Guillaume Nault <gnault@redhat.com>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/chelsio/libcxgb/libcxgb_cm.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/net/ethernet/chelsio/libcxgb/libcxgb_cm.c
+++ b/drivers/net/ethernet/chelsio/libcxgb/libcxgb_cm.c
@@ -32,6 +32,7 @@
 
 #include <linux/tcp.h>
 #include <linux/ipv6.h>
+#include <net/inet_ecn.h>
 #include <net/route.h>
 #include <net/ip6_route.h>
 
@@ -99,7 +100,7 @@ cxgb_find_route(struct cxgb4_lld_info *l
 
 	rt = ip_route_output_ports(&init_net, &fl4, NULL, peer_ip, local_ip,
 				   peer_port, local_port, IPPROTO_TCP,
-				   tos, 0);
+				   tos & ~INET_ECN_MASK, 0);
 	if (IS_ERR(rt))
 		return NULL;
 	n = dst_neigh_lookup(&rt->dst, &peer_ip);


