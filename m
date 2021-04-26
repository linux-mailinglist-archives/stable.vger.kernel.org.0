Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E08E836AD71
	for <lists+stable@lfdr.de>; Mon, 26 Apr 2021 09:36:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232471AbhDZHgm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Apr 2021 03:36:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:49184 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232878AbhDZHgF (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 26 Apr 2021 03:36:05 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 765EB61249;
        Mon, 26 Apr 2021 07:33:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1619422417;
        bh=eCfEGQTovAKZ92NQC28F5QS3baM+7g1KYRai2o6cKcM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rDHageYAKrCTRqLFta39zgugseUyoB8keUU/bwopOapWKl+G5AP38r+MA9Zw7Wxrn
         AuVotmdXmYLY2jPEdt+y8FUMkwcp/9R/1OUkrJRaHLdYa35x+NNiCpLlCkB++nz63B
         FOEpOsL59szyB/mX9F/9ZLwmcWLVy5BpUqWnoD9M=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hristo Venev <hristo@venev.name>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 4.9 20/37] net: sit: Unregister catch-all devices
Date:   Mon, 26 Apr 2021 09:29:21 +0200
Message-Id: <20210426072817.942653452@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210426072817.245304364@linuxfoundation.org>
References: <20210426072817.245304364@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Hristo Venev <hristo@venev.name>

commit 610f8c0fc8d46e0933955ce13af3d64484a4630a upstream.

A sit interface created without a local or a remote address is linked
into the `sit_net::tunnels_wc` list of its original namespace. When
deleting a network namespace, delete the devices that have been moved.

The following script triggers a null pointer dereference if devices
linked in a deleted `sit_net` remain:

    for i in `seq 1 30`; do
        ip netns add ns-test
        ip netns exec ns-test ip link add dev veth0 type veth peer veth1
        ip netns exec ns-test ip link add dev sit$i type sit dev veth0
        ip netns exec ns-test ip link set dev sit$i netns $$
        ip netns del ns-test
    done
    for i in `seq 1 30`; do
        ip link del dev sit$i
    done

Fixes: 5e6700b3bf98f ("sit: add support of x-netns")
Signed-off-by: Hristo Venev <hristo@venev.name>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/ipv6/sit.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/net/ipv6/sit.c
+++ b/net/ipv6/sit.c
@@ -1799,9 +1799,9 @@ static void __net_exit sit_destroy_tunne
 		if (dev->rtnl_link_ops == &sit_link_ops)
 			unregister_netdevice_queue(dev, head);
 
-	for (prio = 1; prio < 4; prio++) {
+	for (prio = 0; prio < 4; prio++) {
 		int h;
-		for (h = 0; h < IP6_SIT_HASH_SIZE; h++) {
+		for (h = 0; h < (prio ? IP6_SIT_HASH_SIZE : 1); h++) {
 			struct ip_tunnel *t;
 
 			t = rtnl_dereference(sitn->tunnels[prio][h]);


