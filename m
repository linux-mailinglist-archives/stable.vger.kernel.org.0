Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CBF70383652
	for <lists+stable@lfdr.de>; Mon, 17 May 2021 17:33:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244465AbhEQPbV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 May 2021 11:31:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:55470 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S244838AbhEQP2k (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 17 May 2021 11:28:40 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B804861CB8;
        Mon, 17 May 2021 14:37:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1621262243;
        bh=G6hP73oeazIRH5gidff3/V9DUdiTvbXmIuGk0bUDG4k=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CjO8HHTrs2NqZi3Ds10fMTMDsbscZkviJA0kU5275wiFD/DKXN4Hsybit0diyENaT
         Xg9mZhSqshoEo66xzrZNn2Mta1So6WQqbE+JkBeLrI0KjU4eldMgvFLUQOO2c8h0eP
         Ttyh/UlnMs1X2dJPM3eqmE9CWChbORNbMfoxNpf4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Jonathon Reinhart <Jonathon.Reinhart@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.4 138/141] netfilter: conntrack: Make global sysctls readonly in non-init netns
Date:   Mon, 17 May 2021 16:03:10 +0200
Message-Id: <20210517140247.475806146@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210517140242.729269392@linuxfoundation.org>
References: <20210517140242.729269392@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jonathon Reinhart <jonathon.reinhart@gmail.com>

commit 2671fa4dc0109d3fb581bc3078fdf17b5d9080f6 upstream.

These sysctls point to global variables:
- NF_SYSCTL_CT_MAX (&nf_conntrack_max)
- NF_SYSCTL_CT_EXPECT_MAX (&nf_ct_expect_max)
- NF_SYSCTL_CT_BUCKETS (&nf_conntrack_htable_size_user)

Because their data pointers are not updated to point to per-netns
structures, they must be marked read-only in a non-init_net ns.
Otherwise, changes in any net namespace are reflected in (leaked into)
all other net namespaces. This problem has existed since the
introduction of net namespaces.

The current logic marks them read-only only if the net namespace is
owned by an unprivileged user (other than init_user_ns).

Commit d0febd81ae77 ("netfilter: conntrack: re-visit sysctls in
unprivileged namespaces") "exposes all sysctls even if the namespace is
unpriviliged." Since we need to mark them readonly in any case, we can
forego the unprivileged user check altogether.

Fixes: d0febd81ae77 ("netfilter: conntrack: re-visit sysctls in unprivileged namespaces")
Signed-off-by: Jonathon Reinhart <Jonathon.Reinhart@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/netfilter/nf_conntrack_standalone.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/net/netfilter/nf_conntrack_standalone.c
+++ b/net/netfilter/nf_conntrack_standalone.c
@@ -1071,8 +1071,11 @@ static int nf_conntrack_standalone_init_
 #endif
 	}
 
-	if (!net_eq(&init_net, net))
+	if (!net_eq(&init_net, net)) {
+		table[NF_SYSCTL_CT_MAX].mode = 0444;
+		table[NF_SYSCTL_CT_EXPECT_MAX].mode = 0444;
 		table[NF_SYSCTL_CT_BUCKETS].mode = 0444;
+	}
 
 	net->ct.sysctl_header = register_net_sysctl(net, "net/netfilter", table);
 	if (!net->ct.sysctl_header)


