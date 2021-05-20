Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3452938A525
	for <lists+stable@lfdr.de>; Thu, 20 May 2021 12:12:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235957AbhETKNQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 May 2021 06:13:16 -0400
Received: from mail.kernel.org ([198.145.29.99]:46110 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235286AbhETKLQ (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 20 May 2021 06:11:16 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8317D61965;
        Thu, 20 May 2021 09:43:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1621503814;
        bh=SnlLtt0XASlW4bHj5v4Rk5vDUK47wB4CKjWPBGbXPEY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Y+zj6zK1L+cQOew3szOVWSNP7NwgZvJP/xP8K8YTupOg/xZKdCMBJ7XGNwReTGJ+q
         lk2sFK5TpJ+6H1zlnqHJNSrNgTVS9yKgysd6l9RMHBKDsz+Sb6uD1JtI8LVvpDCSUn
         5biWr8xD/Cy+Qv0Pf+X31lhPhQSUje3V0+8Fcgso=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Jonathon Reinhart <Jonathon.Reinhart@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 4.19 391/425] netfilter: conntrack: Make global sysctls readonly in non-init netns
Date:   Thu, 20 May 2021 11:22:40 +0200
Message-Id: <20210520092144.251440663@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210520092131.308959589@linuxfoundation.org>
References: <20210520092131.308959589@linuxfoundation.org>
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
@@ -594,8 +594,11 @@ static int nf_conntrack_standalone_init_
 	if (net->user_ns != &init_user_ns)
 		table[0].procname = NULL;
 
-	if (!net_eq(&init_net, net))
+	if (!net_eq(&init_net, net)) {
+		table[0].mode = 0444;
 		table[2].mode = 0444;
+		table[5].mode = 0444;
+	}
 
 	net->ct.sysctl_header = register_net_sysctl(net, "net/netfilter", table);
 	if (!net->ct.sysctl_header)


