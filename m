Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 46B7486A4F
	for <lists+stable@lfdr.de>; Thu,  8 Aug 2019 21:15:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404433AbfHHTIO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 8 Aug 2019 15:08:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:42218 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2404851AbfHHTIN (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 8 Aug 2019 15:08:13 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EAA1E2189E;
        Thu,  8 Aug 2019 19:08:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1565291292;
        bh=s6GFSmA/8yXWLOplHTaprjXne1sJJ38SREKr2hd5Roo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZB0GX7teQ+Ve7t3ZVz8AtnVnaq0QRqSg0tXxk3JLOzbHzV95B5g4uNHiVUeQ2TFGR
         ukb4OcuaZZ7iVs4hQNvy0EGropZhTdo3OyLONEoF/85rhveyBHxINuMqUMBPsoqRcY
         5mItg7j8AIkxnjp9oR34HnIB3VpP2umhdbsYQWlM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jesper Dangaard Brouer <brouer@redhat.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.2 44/56] selftests/bpf: reduce time to execute test_xdp_vlan.sh
Date:   Thu,  8 Aug 2019 21:05:10 +0200
Message-Id: <20190808190454.902151470@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190808190452.867062037@linuxfoundation.org>
References: <20190808190452.867062037@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jesper Dangaard Brouer <brouer@redhat.com>

[ Upstream commit 13978d1e73d2fcfb6addcf3392707ad68fa88ccb ]

Given the increasing number of BPF selftests, it makes sense to
reduce the time to execute these tests.  The ping parameters are
adjusted to reduce the time from measures 9 sec to approx 2.8 sec.

Signed-off-by: Jesper Dangaard Brouer <brouer@redhat.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/testing/selftests/bpf/test_xdp_vlan.sh |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

--- a/tools/testing/selftests/bpf/test_xdp_vlan.sh
+++ b/tools/testing/selftests/bpf/test_xdp_vlan.sh
@@ -188,7 +188,7 @@ ip netns exec ns2 ip link set lo up
 # At this point, the hosts cannot reach each-other,
 # because ns2 are using VLAN tags on the packets.
 
-ip netns exec ns2 sh -c 'ping -W 1 -c 1 100.64.41.1 || echo "Okay ping fails"'
+ip netns exec ns2 sh -c 'ping -W 1 -c 1 100.64.41.1 || echo "Success: First ping must fail"'
 
 
 # Now we can use the test_xdp_vlan.c program to pop/push these VLAN tags
@@ -210,8 +210,8 @@ ip netns exec ns1 tc filter add dev $DEV
   prio 1 handle 1 bpf da obj $FILE sec tc_vlan_push
 
 # Now the namespaces can reach each-other, test with ping:
-ip netns exec ns2 ping -W 2 -c 3 $IPADDR1
-ip netns exec ns1 ping -W 2 -c 3 $IPADDR2
+ip netns exec ns2 ping -i 0.2 -W 2 -c 2 $IPADDR1
+ip netns exec ns1 ping -i 0.2 -W 2 -c 2 $IPADDR2
 
 # Second test: Replace xdp prog, that fully remove vlan header
 #
@@ -224,5 +224,5 @@ ip netns exec ns1 ip link set $DEVNS1 $X
 ip netns exec ns1 ip link set $DEVNS1 $XDP_MODE object $FILE section $XDP_PROG
 
 # Now the namespaces should still be able reach each-other, test with ping:
-ip netns exec ns2 ping -W 2 -c 3 $IPADDR1
-ip netns exec ns1 ping -W 2 -c 3 $IPADDR2
+ip netns exec ns2 ping -i 0.2 -W 2 -c 2 $IPADDR1
+ip netns exec ns1 ping -i 0.2 -W 2 -c 2 $IPADDR2


