Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CC2421CB010
	for <lists+stable@lfdr.de>; Fri,  8 May 2020 15:24:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728351AbgEHMiN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 8 May 2020 08:38:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:53080 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728340AbgEHMiM (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 8 May 2020 08:38:12 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 23DEE218AC;
        Fri,  8 May 2020 12:38:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588941491;
        bh=3KB/8lPwoZMw72b3N2MrQizpZ5wvF7S6jVFfMLPhnZ0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cf9ne06ILTyA82myOWhwCiwR1lDEPG/b3EaTT0mhtY2dBsnh85NkJU6E8WFCfnnvL
         qvCZ9xG+14ZvQAeqMV5abFmt8JRxjPABkrM2yEfDB32fl1/Y0Gbgf7TjT4NhYgqAvp
         KPErmrUJqOb2WN/7VBkM7t7o5oPrddxDtKSkV3jQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Nicolas Dichtel <nicolas.dichtel@6wind.com>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        Vegard Nossum <vegard.nossum@oracle.com>
Subject: [PATCH 4.4 052/312] xfrm: fix crash in XFRM_MSG_GETSA netlink handler
Date:   Fri,  8 May 2020 14:30:43 +0200
Message-Id: <20200508123128.210437137@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200508123124.574959822@linuxfoundation.org>
References: <20200508123124.574959822@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Vegard Nossum <vegard.nossum@oracle.com>

commit 1ba5bf993c6a3142e18e68ea6452b347f9cb5635 upstream.

If we hit any of the error conditions inside xfrm_dump_sa(), then
xfrm_state_walk_init() never gets called. However, we still call
xfrm_state_walk_done() from xfrm_dump_sa_done(), which will crash
because the state walk was never initialized properly.

We can fix this by setting cb->args[0] only after we've processed the
first element and checking this before calling xfrm_state_walk_done().

Fixes: d3623099d3 ("ipsec: add support of limited SA dump")
Cc: Nicolas Dichtel <nicolas.dichtel@6wind.com>
Cc: Steffen Klassert <steffen.klassert@secunet.com>
Signed-off-by: Vegard Nossum <vegard.nossum@oracle.com>
Acked-by: Nicolas Dichtel <nicolas.dichtel@6wind.com>
Signed-off-by: Steffen Klassert <steffen.klassert@secunet.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 net/xfrm/xfrm_user.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/net/xfrm/xfrm_user.c
+++ b/net/xfrm/xfrm_user.c
@@ -923,7 +923,8 @@ static int xfrm_dump_sa_done(struct netl
 	struct sock *sk = cb->skb->sk;
 	struct net *net = sock_net(sk);
 
-	xfrm_state_walk_done(walk, net);
+	if (cb->args[0])
+		xfrm_state_walk_done(walk, net);
 	return 0;
 }
 
@@ -948,8 +949,6 @@ static int xfrm_dump_sa(struct sk_buff *
 		u8 proto = 0;
 		int err;
 
-		cb->args[0] = 1;
-
 		err = nlmsg_parse(cb->nlh, 0, attrs, XFRMA_MAX,
 				  xfrma_policy);
 		if (err < 0)
@@ -966,6 +965,7 @@ static int xfrm_dump_sa(struct sk_buff *
 			proto = nla_get_u8(attrs[XFRMA_PROTO]);
 
 		xfrm_state_walk_init(walk, proto, filter);
+		cb->args[0] = 1;
 	}
 
 	(void) xfrm_state_walk(net, walk, dump_one_state, &info);


