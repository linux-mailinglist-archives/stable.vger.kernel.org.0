Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D001843A05E
	for <lists+stable@lfdr.de>; Mon, 25 Oct 2021 21:27:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235467AbhJYTaA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 25 Oct 2021 15:30:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:48094 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235746AbhJYT3H (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 25 Oct 2021 15:29:07 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4F75961166;
        Mon, 25 Oct 2021 19:25:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1635189949;
        bh=yXLbsg3x+I/rte+J64RRq+gVzgk3Xq/TV92Jmjr7ifg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YJCNSDmImK0qCCg3O21bliU7T7N83RFuWENZmtJwGUKuAT50/IXFk3YZrBaTahoi5
         kEH/skNkf+r3VWVIY4PfM0QWhzflM5Y/v5eHNZfOs+ErtT7miSYQf20U/WK4L9h0Xb
         iMHSOAWzAXorusVVyOa4paQulmqcUXsFYsMOAjLg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Antoine Tenart <atenart@kernel.org>,
        Julian Anastasov <ja@ssi.bg>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 10/58] netfilter: ipvs: make global sysctl readonly in non-init netns
Date:   Mon, 25 Oct 2021 21:14:27 +0200
Message-Id: <20211025190939.193930036@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211025190937.555108060@linuxfoundation.org>
References: <20211025190937.555108060@linuxfoundation.org>
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
index f93fa0e21097..07242503d74d 100644
--- a/net/netfilter/ipvs/ip_vs_ctl.c
+++ b/net/netfilter/ipvs/ip_vs_ctl.c
@@ -4047,6 +4047,11 @@ static int __net_init ip_vs_control_net_init_sysctl(struct netns_ipvs *ipvs)
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



