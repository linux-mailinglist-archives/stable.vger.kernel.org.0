Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DC6AD1EAAC5
	for <lists+stable@lfdr.de>; Mon,  1 Jun 2020 20:12:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729665AbgFASLS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Jun 2020 14:11:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:58386 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729108AbgFASLQ (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Jun 2020 14:11:16 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6790B206E2;
        Mon,  1 Jun 2020 18:11:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1591035075;
        bh=9zuuffeI7sKuAZyAqKZVUFU8nDeJiIG7ehz5hVmqyOo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LMeEMaNxUU3SjMARFpBYq7p2m/gbCVGQwDCJaZOjqHqA71DpwNmqCu3kjdEFYS5Mp
         WTRQBmfpysybDCHVwb6+X2YMLw9+4xfYwVTcLWlNbrjhU0FO6/Sw7hMbDHXonW3wVS
         gxsaMytkJIqx7rY1W5phknmBPlyPKAzNKtvWUnhY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Nathan Chancellor <natechancellor@gmail.com>,
        Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 5.4 140/142] netfilter: conntrack: Pass value of ctinfo to __nf_conntrack_update
Date:   Mon,  1 Jun 2020 19:54:58 +0200
Message-Id: <20200601174052.199090805@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200601174037.904070960@linuxfoundation.org>
References: <20200601174037.904070960@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Nathan Chancellor <natechancellor@gmail.com>

commit 46c1e0621a72e0469ec4edfdb6ed4d387ec34f8a upstream.

Clang warns:

net/netfilter/nf_conntrack_core.c:2068:21: warning: variable 'ctinfo' is
uninitialized when used here [-Wuninitialized]
        nf_ct_set(skb, ct, ctinfo);
                           ^~~~~~
net/netfilter/nf_conntrack_core.c:2024:2: note: variable 'ctinfo' is
declared here
        enum ip_conntrack_info ctinfo;
        ^
1 warning generated.

nf_conntrack_update was split up into nf_conntrack_update and
__nf_conntrack_update, where the assignment of ctinfo is in
nf_conntrack_update but it is used in __nf_conntrack_update.

Pass the value of ctinfo from nf_conntrack_update to
__nf_conntrack_update so that uninitialized memory is not used
and everything works properly.

Fixes: ee04805ff54a ("netfilter: conntrack: make conntrack userspace helpers work again")
Link: https://github.com/ClangBuiltLinux/linux/issues/1039
Signed-off-by: Nathan Chancellor <natechancellor@gmail.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 net/netfilter/nf_conntrack_core.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/net/netfilter/nf_conntrack_core.c
+++ b/net/netfilter/nf_conntrack_core.c
@@ -1880,11 +1880,11 @@ static void nf_conntrack_attach(struct s
 }
 
 static int __nf_conntrack_update(struct net *net, struct sk_buff *skb,
-				 struct nf_conn *ct)
+				 struct nf_conn *ct,
+				 enum ip_conntrack_info ctinfo)
 {
 	struct nf_conntrack_tuple_hash *h;
 	struct nf_conntrack_tuple tuple;
-	enum ip_conntrack_info ctinfo;
 	struct nf_nat_hook *nat_hook;
 	unsigned int status;
 	int dataoff;
@@ -2009,7 +2009,7 @@ static int nf_conntrack_update(struct ne
 		return 0;
 
 	if (!nf_ct_is_confirmed(ct)) {
-		err = __nf_conntrack_update(net, skb, ct);
+		err = __nf_conntrack_update(net, skb, ct, ctinfo);
 		if (err < 0)
 			return err;
 	}


