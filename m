Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E416E99DB8
	for <lists+stable@lfdr.de>; Thu, 22 Aug 2019 19:44:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392874AbfHVRow (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 22 Aug 2019 13:44:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:42712 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2403869AbfHVRXN (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 22 Aug 2019 13:23:13 -0400
Received: from localhost (wsip-184-188-36-2.sd.sd.cox.net [184.188.36.2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4DF0F23407;
        Thu, 22 Aug 2019 17:23:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1566494592;
        bh=mOYmqVCbk6H8xdyTBJlt9TLH0hGrZxWq6Vd3l7rgDeM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KTKJQ6tM4EmjuRNor6bdyB2cVNMLRa7fnh5EJueRl12NbMiHZ92kqQNBpVRvSQg3i
         ++atQHssv6oZTSbXOKOTn+ri4c+aI+GNTkUrV8OgPw9w8D3q1JShCTjOnrjJJ98Sg2
         HJrTs/rNPLcNHra3rlczRSjR2URVsPY7Jl6tcvXA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Thomas Jarosch <thomas.jarosch@intra2net.com>,
        Juliana Rodrigueiro <juliana.rodrigueiro@intra2net.com>,
        Florian Westphal <fw@strlen.de>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 012/103] netfilter: nfnetlink: avoid deadlock due to synchronous request_module
Date:   Thu, 22 Aug 2019 10:18:00 -0700
Message-Id: <20190822171729.349583932@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20190822171728.445189830@linuxfoundation.org>
References: <20190822171728.445189830@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit 1b0890cd60829bd51455dc5ad689ed58c4408227 ]

Thomas and Juliana report a deadlock when running:

(rmmod nf_conntrack_netlink/xfrm_user)

  conntrack -e NEW -E &
  modprobe -v xfrm_user

They provided following analysis:

conntrack -e NEW -E
    netlink_bind()
        netlink_lock_table() -> increases "nl_table_users"
            nfnetlink_bind()
            # does not unlock the table as it's locked by netlink_bind()
                __request_module()
                    call_usermodehelper_exec()

This triggers "modprobe nf_conntrack_netlink" from kernel, netlink_bind()
won't return until modprobe process is done.

"modprobe xfrm_user":
    xfrm_user_init()
        register_pernet_subsys()
            -> grab pernet_ops_rwsem
                ..
                netlink_table_grab()
                    calls schedule() as "nl_table_users" is non-zero

so modprobe is blocked because netlink_bind() increased
nl_table_users while also holding pernet_ops_rwsem.

"modprobe nf_conntrack_netlink" runs and inits nf_conntrack_netlink:
    ctnetlink_init()
        register_pernet_subsys()
            -> blocks on "pernet_ops_rwsem" thanks to xfrm_user module

both modprobe processes wait on one another -- neither can make
progress.

Switch netlink_bind() to "nowait" modprobe -- this releases the netlink
table lock, which then allows both modprobe instances to complete.

Reported-by: Thomas Jarosch <thomas.jarosch@intra2net.com>
Reported-by: Juliana Rodrigueiro <juliana.rodrigueiro@intra2net.com>
Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netfilter/nfnetlink.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/netfilter/nfnetlink.c b/net/netfilter/nfnetlink.c
index 2278d9ab723bf..9837a61cb3e3b 100644
--- a/net/netfilter/nfnetlink.c
+++ b/net/netfilter/nfnetlink.c
@@ -490,7 +490,7 @@ static int nfnetlink_bind(struct net *net, int group)
 	ss = nfnetlink_get_subsys(type << 8);
 	rcu_read_unlock();
 	if (!ss)
-		request_module("nfnetlink-subsys-%d", type);
+		request_module_nowait("nfnetlink-subsys-%d", type);
 	return 0;
 }
 #endif
-- 
2.20.1



