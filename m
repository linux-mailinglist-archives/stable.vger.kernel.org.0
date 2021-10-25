Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A646C43A032
	for <lists+stable@lfdr.de>; Mon, 25 Oct 2021 21:27:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234901AbhJYT3Y (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 25 Oct 2021 15:29:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:46716 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235010AbhJYT0v (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 25 Oct 2021 15:26:51 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 444D7610F8;
        Mon, 25 Oct 2021 19:23:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1635189818;
        bh=nJZkzGejf4EI9OeSs65hfhWR70BVNtVIsjh595JktZg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Sec7sOdlfsbXLer0xHbgLnVQha+12cCQjOE8+J6V8ZxX4EiJvxM1joYGEy73E9UJ7
         cruqFf61WEwGBVN2JdeoXQFnKP7G2CSN+5OqMI1BggE6X3P8GVfFxqjYpDRvLKTP2P
         Lrf8V1nd4r84A0ZLnL5xHiyGDOnxuj7pCwBQxvkI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Antoine Tenart <atenart@kernel.org>,
        Julian Anastasov <ja@ssi.bg>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 07/37] netfilter: ipvs: make global sysctl readonly in non-init netns
Date:   Mon, 25 Oct 2021 21:14:32 +0200
Message-Id: <20211025190929.721115472@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211025190926.680827862@linuxfoundation.org>
References: <20211025190926.680827862@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Antoine Tenart <atenart@kernel.org>

[ Upstream commit 174c376278949c44aad89c514a6b5db6cee8db59 ]

Because the data pointer of net/ipv4/vs/debug_level is not updated per
netns, it must be marked as read-only in non-init netns.

Fixes: c6d2d445d8de ("IPVS: netns, final patch enabling network name space.")
Signed-off-by: Antoine Tenart <atenart@kernel.org>
Acked-by: Julian Anastasov <ja@ssi.bg>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netfilter/ipvs/ip_vs_ctl.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/net/netfilter/ipvs/ip_vs_ctl.c b/net/netfilter/ipvs/ip_vs_ctl.c
index 6208fa09fe71..3bf8d7f3cdc3 100644
--- a/net/netfilter/ipvs/ip_vs_ctl.c
+++ b/net/netfilter/ipvs/ip_vs_ctl.c
@@ -3955,6 +3955,11 @@ static int __net_init ip_vs_control_net_init_sysctl(struct netns_ipvs *ipvs)
 	tbl[idx++].data = &ipvs->sysctl_conn_reuse_mode;
 	tbl[idx++].data = &ipvs->sysctl_schedule_icmp;
 	tbl[idx++].data = &ipvs->sysctl_ignore_tunneled;
+#ifdef CONFIG_IP_VS_DEBUG
+	/* Global sysctls must be ro in non-init netns */
+	if (!net_eq(net, &init_net))
+		tbl[idx++].mode = 0444;
+#endif
 
 	ipvs->sysctl_hdr = register_net_sysctl(net, "net/ipv4/vs", tbl);
 	if (ipvs->sysctl_hdr == NULL) {
-- 
2.33.0



