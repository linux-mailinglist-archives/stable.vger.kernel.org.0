Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DDAE93F63EE
	for <lists+stable@lfdr.de>; Tue, 24 Aug 2021 19:00:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238874AbhHXQ7J (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 24 Aug 2021 12:59:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:39218 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237883AbhHXQ6F (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 24 Aug 2021 12:58:05 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B2847613D2;
        Tue, 24 Aug 2021 16:57:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1629824227;
        bh=r5QCkYiwvKL+bT9wavF/bvkgPXMTAm2rn6uLqMlghBY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SKVdcbGHytgYqwY83UBQitji3SulBJUsXiwvOs8SElOsnZSC1aaCEXOTjVmqbdynx
         ZoSC6pvBJFhXWDz9hPC1BAA/UAanoe6zQ4I98r1Z3E4v+KH2FOlkUZOAL5iwBSeVTc
         OasEQIRPE5mH+WoKob7E9YpNOZ1JOLwF3JJYT8vknxzdyUcdoTHnSEte2qE0csw9vn
         16lWh77NtUNKN4G4DL74v3II6ZpFBALib8QLunO/pSlknfcy8SG05TJhstrVjgU38I
         1L1mpJza2G46W3OuLK6GcfbMfkDNj0a+PQ1EYM32D89AG6vrvEwo+hyQtzj7UllS1c
         U/U0mpNtgxfSQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Lahav Schlesinger <lschlesinger@drivenets.com>,
        David Ahern <dsahern@kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.13 060/127] vrf: Reset skb conntrack connection on VRF rcv
Date:   Tue, 24 Aug 2021 12:55:00 -0400
Message-Id: <20210824165607.709387-61-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210824165607.709387-1-sashal@kernel.org>
References: <20210824165607.709387-1-sashal@kernel.org>
MIME-Version: 1.0
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.13.13-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.13.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.13.13-rc1
X-KernelTest-Deadline: 2021-08-26T16:55+00:00
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Lahav Schlesinger <lschlesinger@drivenets.com>

[ Upstream commit 09e856d54bda5f288ef8437a90ab2b9b3eab83d1 ]

To fix the "reverse-NAT" for replies.

When a packet is sent over a VRF, the POST_ROUTING hooks are called
twice: Once from the VRF interface, and once from the "actual"
interface the packet will be sent from:
1) First SNAT: l3mdev_l3_out() -> vrf_l3_out() -> .. -> vrf_output_direct()
     This causes the POST_ROUTING hooks to run.
2) Second SNAT: 'ip_output()' calls POST_ROUTING hooks again.

Similarly for replies, first ip_rcv() calls PRE_ROUTING hooks, and
second vrf_l3_rcv() calls them again.

As an example, consider the following SNAT rule:
> iptables -t nat -A POSTROUTING -p udp -m udp --dport 53 -j SNAT --to-source 2.2.2.2 -o vrf_1

In this case sending over a VRF will create 2 conntrack entries.
The first is from the VRF interface, which performs the IP SNAT.
The second will run the SNAT, but since the "expected reply" will remain
the same, conntrack randomizes the source port of the packet:
e..g With a socket bound to 1.1.1.1:10000, sending to 3.3.3.3:53, the conntrack
rules are:
udp      17 29 src=2.2.2.2 dst=3.3.3.3 sport=10000 dport=53 packets=1 bytes=68 [UNREPLIED] src=3.3.3.3 dst=2.2.2.2 sport=53 dport=61033 packets=0 bytes=0 mark=0 use=1
udp      17 29 src=1.1.1.1 dst=3.3.3.3 sport=10000 dport=53 packets=1 bytes=68 [UNREPLIED] src=3.3.3.3 dst=2.2.2.2 sport=53 dport=10000 packets=0 bytes=0 mark=0 use=1

i.e. First SNAT IP from 1.1.1.1 --> 2.2.2.2, and second the src port is
SNAT-ed from 10000 --> 61033.

But when a reply is sent (3.3.3.3:53 -> 2.2.2.2:61033) only the later
conntrack entry is matched:
udp      17 29 src=2.2.2.2 dst=3.3.3.3 sport=10000 dport=53 packets=1 bytes=68 src=3.3.3.3 dst=2.2.2.2 sport=53 dport=61033 packets=1 bytes=49 mark=0 use=1
udp      17 28 src=1.1.1.1 dst=3.3.3.3 sport=10000 dport=53 packets=1 bytes=68 [UNREPLIED] src=3.3.3.3 dst=2.2.2.2 sport=53 dport=10000 packets=0 bytes=0 mark=0 use=1

And a "port 61033 unreachable" ICMP packet is sent back.

The issue is that when PRE_ROUTING hooks are called from vrf_l3_rcv(),
the skb already has a conntrack flow attached to it, which means
nf_conntrack_in() will not resolve the flow again.

This means only the dest port is "reverse-NATed" (61033 -> 10000) but
the dest IP remains 2.2.2.2, and since the socket is bound to 1.1.1.1 it's
not received.
This can be verified by logging the 4-tuple of the packet in '__udp4_lib_rcv()'.

The fix is then to reset the flow when skb is received on a VRF, to let
conntrack resolve the flow again (which now will hit the earlier flow).

To reproduce: (Without the fix "Got pkt_to_nat_port" will not be printed by
  running 'bash ./repro'):
  $ cat run_in_A1.py
  import logging
  logging.getLogger("scapy.runtime").setLevel(logging.ERROR)
  from scapy.all import *
  import argparse

  def get_packet_to_send(udp_dst_port, msg_name):
      return Ether(src='11:22:33:44:55:66', dst=iface_mac)/ \
          IP(src='3.3.3.3', dst='2.2.2.2')/ \
          UDP(sport=53, dport=udp_dst_port)/ \
          Raw(f'{msg_name}\x0012345678901234567890')

  parser = argparse.ArgumentParser()
  parser.add_argument('-iface_mac', dest="iface_mac", type=str, required=True,
                      help="From run_in_A3.py")
  parser.add_argument('-socket_port', dest="socket_port", type=str,
                      required=True, help="From run_in_A3.py")
  parser.add_argument('-v1_mac', dest="v1_mac", type=str, required=True,
                      help="From script")

  args, _ = parser.parse_known_args()
  iface_mac = args.iface_mac
  socket_port = int(args.socket_port)
  v1_mac = args.v1_mac

  print(f'Source port before NAT: {socket_port}')

  while True:
      pkts = sniff(iface='_v0', store=True, count=1, timeout=10)
      if 0 == len(pkts):
          print('Something failed, rerun the script :(', flush=True)
          break
      pkt = pkts[0]
      if not pkt.haslayer('UDP'):
          continue

      pkt_sport = pkt.getlayer('UDP').sport
      print(f'Source port after NAT: {pkt_sport}', flush=True)

      pkt_to_send = get_packet_to_send(pkt_sport, 'pkt_to_nat_port')
      sendp(pkt_to_send, '_v0', verbose=False) # Will not be received

      pkt_to_send = get_packet_to_send(socket_port, 'pkt_to_socket_port')
      sendp(pkt_to_send, '_v0', verbose=False)
      break

  $ cat run_in_A2.py
  import socket
  import netifaces

  print(f"{netifaces.ifaddresses('e00000')[netifaces.AF_LINK][0]['addr']}",
        flush=True)
  s = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)
  s.setsockopt(socket.SOL_SOCKET, socket.SO_BINDTODEVICE,
               str('vrf_1' + '\0').encode('utf-8'))
  s.connect(('3.3.3.3', 53))
  print(f'{s. getsockname()[1]}', flush=True)
  s.settimeout(5)

  while True:
      try:
          # Periodically send in order to keep the conntrack entry alive.
          s.send(b'a'*40)
          resp = s.recvfrom(1024)
          msg_name = resp[0].decode('utf-8').split('\0')[0]
          print(f"Got {msg_name}", flush=True)
      except Exception as e:
          pass

  $ cat repro.sh
  ip netns del A1 2> /dev/null
  ip netns del A2 2> /dev/null
  ip netns add A1
  ip netns add A2

  ip -n A1 link add _v0 type veth peer name _v1 netns A2
  ip -n A1 link set _v0 up

  ip -n A2 link add e00000 type bond
  ip -n A2 link add lo0 type dummy
  ip -n A2 link add vrf_1 type vrf table 10001
  ip -n A2 link set vrf_1 up
  ip -n A2 link set e00000 master vrf_1

  ip -n A2 addr add 1.1.1.1/24 dev e00000
  ip -n A2 link set e00000 up
  ip -n A2 link set _v1 master e00000
  ip -n A2 link set _v1 up
  ip -n A2 link set lo0 up
  ip -n A2 addr add 2.2.2.2/32 dev lo0

  ip -n A2 neigh add 1.1.1.10 lladdr 77:77:77:77:77:77 dev e00000
  ip -n A2 route add 3.3.3.3/32 via 1.1.1.10 dev e00000 table 10001

  ip netns exec A2 iptables -t nat -A POSTROUTING -p udp -m udp --dport 53 -j \
	SNAT --to-source 2.2.2.2 -o vrf_1

  sleep 5
  ip netns exec A2 python3 run_in_A2.py > x &
  XPID=$!
  sleep 5

  IFACE_MAC=`sed -n 1p x`
  SOCKET_PORT=`sed -n 2p x`
  V1_MAC=`ip -n A2 link show _v1 | sed -n 2p | awk '{print $2'}`
  ip netns exec A1 python3 run_in_A1.py -iface_mac ${IFACE_MAC} -socket_port \
          ${SOCKET_PORT} -v1_mac ${SOCKET_PORT}
  sleep 5

  kill -9 $XPID
  wait $XPID 2> /dev/null
  ip netns del A1
  ip netns del A2
  tail x -n 2
  rm x
  set +x

Fixes: 73e20b761acf ("net: vrf: Add support for PREROUTING rules on vrf device")
Signed-off-by: Lahav Schlesinger <lschlesinger@drivenets.com>
Reviewed-by: David Ahern <dsahern@kernel.org>
Link: https://lore.kernel.org/r/20210815120002.2787653-1-lschlesinger@drivenets.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/vrf.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/net/vrf.c b/drivers/net/vrf.c
index 414afcb0a23f..b1c451d10a5d 100644
--- a/drivers/net/vrf.c
+++ b/drivers/net/vrf.c
@@ -1367,6 +1367,8 @@ static struct sk_buff *vrf_ip6_rcv(struct net_device *vrf_dev,
 	bool need_strict = rt6_need_strict(&ipv6_hdr(skb)->daddr);
 	bool is_ndisc = ipv6_ndisc_frame(skb);
 
+	nf_reset_ct(skb);
+
 	/* loopback, multicast & non-ND link-local traffic; do not push through
 	 * packet taps again. Reset pkt_type for upper layers to process skb.
 	 * For strict packets with a source LLA, determine the dst using the
@@ -1429,6 +1431,8 @@ static struct sk_buff *vrf_ip_rcv(struct net_device *vrf_dev,
 	skb->skb_iif = vrf_dev->ifindex;
 	IPCB(skb)->flags |= IPSKB_L3SLAVE;
 
+	nf_reset_ct(skb);
+
 	if (ipv4_is_multicast(ip_hdr(skb)->daddr))
 		goto out;
 
-- 
2.30.2

