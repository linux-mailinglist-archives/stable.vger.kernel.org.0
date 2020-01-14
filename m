Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AF03F13A58A
	for <lists+stable@lfdr.de>; Tue, 14 Jan 2020 11:09:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730694AbgANKIk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 14 Jan 2020 05:08:40 -0500
Received: from mail.kernel.org ([198.145.29.99]:40352 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730679AbgANKIk (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 14 Jan 2020 05:08:40 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8945A24676;
        Tue, 14 Jan 2020 10:08:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1578996520;
        bh=Pe+dFRjzapqzZ3u+uMbMOYlB5SMIdJfnVdCronLZ9+s=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ouUL92JIbCKAlsSVgFfxeCJXe6xBFbxYxDjqyGPs1U3OfyCdRFUXnG8Hybtz2BVfr
         VuF6wEqaKxFW3HAQBkxSQTEOy2XOmhkP8pQBgDFMt1Bag+0Ak25ye48myXkZlvJ6ZC
         raQv3nyuHi9BcCNfVySkkgL09QsTlG2IWlHGyLGU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        syzbot+46a4ad33f345d1dd346e@syzkaller.appspotmail.com,
        Florian Westphal <fw@strlen.de>,
        Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 4.19 45/46] netfilter: conntrack: dccp, sctp: handle null timeout argument
Date:   Tue, 14 Jan 2020 11:02:02 +0100
Message-Id: <20200114094348.771052110@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200114094339.608068818@linuxfoundation.org>
References: <20200114094339.608068818@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Florian Westphal <fw@strlen.de>

commit 1d9a7acd3d1e74c2d150d8934f7f55bed6d70858 upstream.

The timeout pointer can be NULL which means we should modify the
per-nets timeout instead.

All do this, except sctp and dccp which instead give:

general protection fault: 0000 [#1] PREEMPT SMP KASAN
net/netfilter/nf_conntrack_proto_dccp.c:682
 ctnl_timeout_parse_policy+0x150/0x1d0 net/netfilter/nfnetlink_cttimeout.c:67
 cttimeout_default_set+0x150/0x1c0 net/netfilter/nfnetlink_cttimeout.c:368
 nfnetlink_rcv_msg+0xcf2/0xfb0 net/netfilter/nfnetlink.c:229
 netlink_rcv_skb+0x177/0x450 net/netlink/af_netlink.c:2477

Reported-by: syzbot+46a4ad33f345d1dd346e@syzkaller.appspotmail.com
Fixes: c779e849608a8 ("netfilter: conntrack: remove get_timeout() indirection")
Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 net/netfilter/nf_conntrack_proto_dccp.c |    3 +++
 net/netfilter/nf_conntrack_proto_sctp.c |    3 +++
 2 files changed, 6 insertions(+)

--- a/net/netfilter/nf_conntrack_proto_dccp.c
+++ b/net/netfilter/nf_conntrack_proto_dccp.c
@@ -687,6 +687,9 @@ static int dccp_timeout_nlattr_to_obj(st
 	unsigned int *timeouts = data;
 	int i;
 
+	if (!timeouts)
+		 timeouts = dn->dccp_timeout;
+
 	/* set default DCCP timeouts. */
 	for (i=0; i<CT_DCCP_MAX; i++)
 		timeouts[i] = dn->dccp_timeout[i];
--- a/net/netfilter/nf_conntrack_proto_sctp.c
+++ b/net/netfilter/nf_conntrack_proto_sctp.c
@@ -603,6 +603,9 @@ static int sctp_timeout_nlattr_to_obj(st
 	struct nf_sctp_net *sn = sctp_pernet(net);
 	int i;
 
+	if (!timeouts)
+		timeouts = sn->timeouts;
+
 	/* set default SCTP timeouts. */
 	for (i=0; i<SCTP_CONNTRACK_MAX; i++)
 		timeouts[i] = sn->timeouts[i];


