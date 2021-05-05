Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B7C7A373A5E
	for <lists+stable@lfdr.de>; Wed,  5 May 2021 14:09:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232949AbhEEMKQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 5 May 2021 08:10:16 -0400
Received: from mail.kernel.org ([198.145.29.99]:51444 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233440AbhEEMJh (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 5 May 2021 08:09:37 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5569461402;
        Wed,  5 May 2021 12:08:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620216509;
        bh=jfsNba7U9iA8JZj5ycsqVMIeZBeB2IQaEFt7ctlUEek=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Y8cloEkYU5Fpic4p29kXUwP/EmDxCH9e4u9mQvVlfPBL1p5bEq2ClgZD/EaZ+cirS
         RJpUI375cdMUOkTJ2ykOidp5QZyrhXolb3uvjfYU/024GNaYWaI9aKvz1yQXhN21lY
         ea9qDiAOmR/rumBdVs/TN0gjtfel3+gzQotn193Q=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Jonathon Reinhart <Jonathon.Reinhart@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.12 02/17] netfilter: conntrack: Make global sysctls readonly in non-init netns
Date:   Wed,  5 May 2021 14:05:57 +0200
Message-Id: <20210505112325.034188957@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210505112324.956720416@linuxfoundation.org>
References: <20210505112324.956720416@linuxfoundation.org>
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
 net/netfilter/nf_conntrack_standalone.c |   10 ++--------
 1 file changed, 2 insertions(+), 8 deletions(-)

--- a/net/netfilter/nf_conntrack_standalone.c
+++ b/net/netfilter/nf_conntrack_standalone.c
@@ -1060,16 +1060,10 @@ static int nf_conntrack_standalone_init_
 	nf_conntrack_standalone_init_dccp_sysctl(net, table);
 	nf_conntrack_standalone_init_gre_sysctl(net, table);
 
-	/* Don't allow unprivileged users to alter certain sysctls */
-	if (net->user_ns != &init_user_ns) {
+	/* Don't allow non-init_net ns to alter global sysctls */
+	if (!net_eq(&init_net, net)) {
 		table[NF_SYSCTL_CT_MAX].mode = 0444;
 		table[NF_SYSCTL_CT_EXPECT_MAX].mode = 0444;
-		table[NF_SYSCTL_CT_HELPER].mode = 0444;
-#ifdef CONFIG_NF_CONNTRACK_EVENTS
-		table[NF_SYSCTL_CT_EVENTS].mode = 0444;
-#endif
-		table[NF_SYSCTL_CT_BUCKETS].mode = 0444;
-	} else if (!net_eq(&init_net, net)) {
 		table[NF_SYSCTL_CT_BUCKETS].mode = 0444;
 	}
 


