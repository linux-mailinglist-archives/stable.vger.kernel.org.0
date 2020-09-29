Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E4C8F27C658
	for <lists+stable@lfdr.de>; Tue, 29 Sep 2020 13:44:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730310AbgI2LoN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 29 Sep 2020 07:44:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:43016 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730853AbgI2LoM (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 29 Sep 2020 07:44:12 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EDDD42076A;
        Tue, 29 Sep 2020 11:44:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601379851;
        bh=4QyhCQYhik/mnoyt6VC91J/68akRV2AxGSUZPqprYfI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=G5ZzuwCR7vOuQfYvmfkBh2g7Z2bC4VgTl/9XaSZqeQ0ToPkgV7cwCBfFlqNhqChpF
         ID9pS2x5bt6T8QwUvzo4IzBmOFGZxBupBKctWcyorsEwg6rtYs6xsqR/FS9OIRe4f7
         C3o1SPJg5Yeq0Aml/jLOHgBgSfhFoqndk/4K71c8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Eelco Chaudron <echaudro@redhat.com>,
        Simon Horman <simon.horman@netronome.com>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 344/388] netfilter: conntrack: nf_conncount_init is failing with IPv6 disabled
Date:   Tue, 29 Sep 2020 13:01:15 +0200
Message-Id: <20200929110027.111654436@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200929110010.467764689@linuxfoundation.org>
References: <20200929110010.467764689@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Eelco Chaudron <echaudro@redhat.com>

[ Upstream commit 526e81b990e53e31ba40ba304a2285ffd098721f ]

The openvswitch module fails initialization when used in a kernel
without IPv6 enabled. nf_conncount_init() fails because the ct code
unconditionally tries to initialize the netns IPv6 related bit,
regardless of the build option. The change below ignores the IPv6
part if not enabled.

Note that the corresponding _put() function already has this IPv6
configuration check.

Fixes: 11efd5cb04a1 ("openvswitch: Support conntrack zone limit")
Signed-off-by: Eelco Chaudron <echaudro@redhat.com>
Reviewed-by: Simon Horman <simon.horman@netronome.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netfilter/nf_conntrack_proto.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/net/netfilter/nf_conntrack_proto.c b/net/netfilter/nf_conntrack_proto.c
index a0560d175a7ff..aaf4293ddd459 100644
--- a/net/netfilter/nf_conntrack_proto.c
+++ b/net/netfilter/nf_conntrack_proto.c
@@ -565,6 +565,7 @@ static int nf_ct_netns_inet_get(struct net *net)
 	int err;
 
 	err = nf_ct_netns_do_get(net, NFPROTO_IPV4);
+#if IS_ENABLED(CONFIG_IPV6)
 	if (err < 0)
 		goto err1;
 	err = nf_ct_netns_do_get(net, NFPROTO_IPV6);
@@ -575,6 +576,7 @@ static int nf_ct_netns_inet_get(struct net *net)
 err2:
 	nf_ct_netns_put(net, NFPROTO_IPV4);
 err1:
+#endif
 	return err;
 }
 
-- 
2.25.1



