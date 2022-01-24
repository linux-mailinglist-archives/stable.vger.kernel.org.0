Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C584449A4C5
	for <lists+stable@lfdr.de>; Tue, 25 Jan 2022 03:10:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2371896AbiAYAKF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 19:10:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57336 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2364092AbiAXXqp (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 18:46:45 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 252F1C07A945;
        Mon, 24 Jan 2022 13:42:51 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E35F9B81142;
        Mon, 24 Jan 2022 21:42:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1FDBAC340E4;
        Mon, 24 Jan 2022 21:42:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643060568;
        bh=DthYjh+AUf6U0msGHmNsk3EuOaLtsWRn1QyFhfakDLQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ksX1h0/zfO9OHobYtuSOCQOyLdUqnP1WcsIsMA6WJ7JPXx3xepEeNmO85ndydcQC1
         VtF238wBH9wM19Maz7kIptyAnPpOQXlB0fjlV5wgURpiXVh6/Glgi0qmUIUSz3dviT
         deVKy+Acru37OvX41FI4hFaVaIu468jToC6vZaMM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Guillaume Nault <gnault@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.16 0992/1039] libcxgb: Dont accidentally set RTO_ONLINK in cxgb_find_route()
Date:   Mon, 24 Jan 2022 19:46:21 +0100
Message-Id: <20220124184158.638161873@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124184125.121143506@linuxfoundation.org>
References: <20220124184125.121143506@linuxfoundation.org>
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


