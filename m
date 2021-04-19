Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D23B53642FD
	for <lists+stable@lfdr.de>; Mon, 19 Apr 2021 15:17:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240243AbhDSNNT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Apr 2021 09:13:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:45772 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239939AbhDSNLs (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 19 Apr 2021 09:11:48 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id EEFCD613C0;
        Mon, 19 Apr 2021 13:11:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1618837877;
        bh=uTn/P7ShC6ybQpeMSlQSWl7Llh9H4+W/oEmmZDnLqy8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=afPZDLhIysV6LHQewTqLZE7HlVanTV+UX51sAsuuKhqvjG29AkLIcF2GqtrEcFeFd
         ypBXQUmxeiWqRGyFxVEg0Wka6HYLGE7sTh6An8NfWYBC1mQ1bW/b5deYSOvCJei4ZZ
         lIopiKqZcDtxO1NOLBN+cW9mGuWZ9Z+82JJWY3Do=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hristo Venev <hristo@venev.name>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.11 086/122] net: sit: Unregister catch-all devices
Date:   Mon, 19 Apr 2021 15:06:06 +0200
Message-Id: <20210419130533.074002117@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210419130530.166331793@linuxfoundation.org>
References: <20210419130530.166331793@linuxfoundation.org>
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
@@ -1867,9 +1867,9 @@ static void __net_exit sit_destroy_tunne
 		if (dev->rtnl_link_ops == &sit_link_ops)
 			unregister_netdevice_queue(dev, head);
 
-	for (prio = 1; prio < 4; prio++) {
+	for (prio = 0; prio < 4; prio++) {
 		int h;
-		for (h = 0; h < IP6_SIT_HASH_SIZE; h++) {
+		for (h = 0; h < (prio ? IP6_SIT_HASH_SIZE : 1); h++) {
 			struct ip_tunnel *t;
 
 			t = rtnl_dereference(sitn->tunnels[prio][h]);


