Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6485213FE5E
	for <lists+stable@lfdr.de>; Fri, 17 Jan 2020 00:35:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391647AbgAPXex (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Jan 2020 18:34:53 -0500
Received: from mail.kernel.org ([198.145.29.99]:42708 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2403813AbgAPXcx (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Jan 2020 18:32:53 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A8588206D9;
        Thu, 16 Jan 2020 23:32:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579217573;
        bh=X/RhwB3ltoFu/o5xwb831LGVLfW0AvB+9BD9HsiGhGs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qQ6xv1REYmW+K82Ppkh1EuSx9J75afdn7dzFllnxEsT+dACqlwT0Ad87DKiTZ8D51
         zVZf7SLkLepBmlDbcxfAOKYAAw2uta+8kBAUFb/XSsvoqMfR6DfGPWbYOTRPB1F1fM
         w3eWNJomQk+LALr9z7g9tNqaZ7RRByqKvK6588qY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Taehee Yoo <ap420073@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 4.14 27/71] hsr: reset network header when supervision frame is created
Date:   Fri, 17 Jan 2020 00:18:25 +0100
Message-Id: <20200116231713.384983535@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200116231709.377772748@linuxfoundation.org>
References: <20200116231709.377772748@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Taehee Yoo <ap420073@gmail.com>

commit 3ed0a1d563903bdb4b4c36c58c4d9c1bcb23a6e6 upstream.

The supervision frame is L2 frame.
When supervision frame is created, hsr module doesn't set network header.
If tap routine is enabled, dev_queue_xmit_nit() is called and it checks
network_header. If network_header pointer wasn't set(or invalid),
it resets network_header and warns.
In order to avoid unnecessary warning message, resetting network_header
is needed.

Test commands:
    ip netns add nst
    ip link add veth0 type veth peer name veth1
    ip link add veth2 type veth peer name veth3
    ip link set veth1 netns nst
    ip link set veth3 netns nst
    ip link set veth0 up
    ip link set veth2 up
    ip link add hsr0 type hsr slave1 veth0 slave2 veth2
    ip a a 192.168.100.1/24 dev hsr0
    ip link set hsr0 up
    ip netns exec nst ip link set veth1 up
    ip netns exec nst ip link set veth3 up
    ip netns exec nst ip link add hsr1 type hsr slave1 veth1 slave2 veth3
    ip netns exec nst ip a a 192.168.100.2/24 dev hsr1
    ip netns exec nst ip link set hsr1 up
    tcpdump -nei veth0

Splat looks like:
[  175.852292][    C3] protocol 88fb is buggy, dev veth0

Fixes: f421436a591d ("net/hsr: Add support for the High-availability Seamless Redundancy protocol (HSRv0)")
Signed-off-by: Taehee Yoo <ap420073@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 net/hsr/hsr_device.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/net/hsr/hsr_device.c
+++ b/net/hsr/hsr_device.c
@@ -281,6 +281,8 @@ static void send_hsr_supervision_frame(s
 			    skb->dev->dev_addr, skb->len) <= 0)
 		goto out;
 	skb_reset_mac_header(skb);
+	skb_reset_network_header(skb);
+	skb_reset_transport_header(skb);
 
 	if (hsrVer > 0) {
 		hsr_tag = skb_put(skb, sizeof(struct hsr_tag));


