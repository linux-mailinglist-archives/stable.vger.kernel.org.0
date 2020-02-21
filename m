Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8BF98167234
	for <lists+stable@lfdr.de>; Fri, 21 Feb 2020 09:01:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731192AbgBUIBV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 21 Feb 2020 03:01:21 -0500
Received: from mail.kernel.org ([198.145.29.99]:33630 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731189AbgBUIBV (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 21 Feb 2020 03:01:21 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id F2C6E24656;
        Fri, 21 Feb 2020 08:01:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1582272080;
        bh=iDQyywFR+dChoJUBor0d1LE6DJzQ1gIxwq0QVn6i2Ds=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=AQPH6w/Q7jVWqhGM22v3iWAfYblGQ86XV7FHtRJ081Wb0hhtyeTWUdglJXBv3MYEd
         ahemLSFD3PYfSe+KYlq7nt7PNSHmzemb39iuarxDNBEx3VFAeEaUbn0S6NraybzG1I
         AsZFbPmwcnuen4Dpsf5ehIm5udd0fCHyhIoOSt5c=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Stepan Horacek <shoracek@redhat.com>,
        Paolo Abeni <pabeni@redhat.com>,
        =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.4 001/344] core: Dont skip generic XDP program execution for cloned SKBs
Date:   Fri, 21 Feb 2020 08:36:40 +0100
Message-Id: <20200221072349.461654816@linuxfoundation.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200221072349.335551332@linuxfoundation.org>
References: <20200221072349.335551332@linuxfoundation.org>
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: "Toke Høiland-Jørgensen" <toke@redhat.com>

[ Upstream commit ad1e03b2b3d4430baaa109b77bc308dc73050de3 ]

The current generic XDP handler skips execution of XDP programs entirely if
an SKB is marked as cloned. This leads to some surprising behaviour, as
packets can end up being cloned in various ways, which will make an XDP
program not see all the traffic on an interface.

This was discovered by a simple test case where an XDP program that always
returns XDP_DROP is installed on a veth device. When combining this with
the Scapy packet sniffer (which uses an AF_PACKET) socket on the sending
side, SKBs reliably end up in the cloned state, causing them to be passed
through to the receiving interface instead of being dropped. A minimal
reproducer script for this is included below.

This patch fixed the issue by simply triggering the existing linearisation
code for cloned SKBs instead of skipping the XDP program execution. This
behaviour is in line with the behaviour of the native XDP implementation
for the veth driver, which will reallocate and copy the SKB data if the SKB
is marked as shared.

Reproducer Python script (requires BCC and Scapy):

from scapy.all import TCP, IP, Ether, sendp, sniff, AsyncSniffer, Raw, UDP
from bcc import BPF
import time, sys, subprocess, shlex

SKB_MODE = (1 << 1)
DRV_MODE = (1 << 2)
PYTHON=sys.executable

def client():
    time.sleep(2)
    # Sniffing on the sender causes skb_cloned() to be set
    s = AsyncSniffer()
    s.start()

    for p in range(10):
        sendp(Ether(dst="aa:aa:aa:aa:aa:aa", src="cc:cc:cc:cc:cc:cc")/IP()/UDP()/Raw("Test"),
              verbose=False)
        time.sleep(0.1)

    s.stop()
    return 0

def server(mode):
    prog = BPF(text="int dummy_drop(struct xdp_md *ctx) {return XDP_DROP;}")
    func = prog.load_func("dummy_drop", BPF.XDP)
    prog.attach_xdp("a_to_b", func, mode)

    time.sleep(1)

    s = sniff(iface="a_to_b", count=10, timeout=15)
    if len(s):
        print(f"Got {len(s)} packets - should have gotten 0")
        return 1
    else:
        print("Got no packets - as expected")
        return 0

if len(sys.argv) < 2:
    print(f"Usage: {sys.argv[0]} <skb|drv>")
    sys.exit(1)

if sys.argv[1] == "client":
    sys.exit(client())
elif sys.argv[1] == "server":
    mode = SKB_MODE if sys.argv[2] == 'skb' else DRV_MODE
    sys.exit(server(mode))
else:
    try:
        mode = sys.argv[1]
        if mode not in ('skb', 'drv'):
            print(f"Usage: {sys.argv[0]} <skb|drv>")
            sys.exit(1)
        print(f"Running in {mode} mode")

        for cmd in [
                'ip netns add netns_a',
                'ip netns add netns_b',
                'ip -n netns_a link add a_to_b type veth peer name b_to_a netns netns_b',
                # Disable ipv6 to make sure there's no address autoconf traffic
                'ip netns exec netns_a sysctl -qw net.ipv6.conf.a_to_b.disable_ipv6=1',
                'ip netns exec netns_b sysctl -qw net.ipv6.conf.b_to_a.disable_ipv6=1',
                'ip -n netns_a link set dev a_to_b address aa:aa:aa:aa:aa:aa',
                'ip -n netns_b link set dev b_to_a address cc:cc:cc:cc:cc:cc',
                'ip -n netns_a link set dev a_to_b up',
                'ip -n netns_b link set dev b_to_a up']:
            subprocess.check_call(shlex.split(cmd))

        server = subprocess.Popen(shlex.split(f"ip netns exec netns_a {PYTHON} {sys.argv[0]} server {mode}"))
        client = subprocess.Popen(shlex.split(f"ip netns exec netns_b {PYTHON} {sys.argv[0]} client"))

        client.wait()
        server.wait()
        sys.exit(server.returncode)

    finally:
        subprocess.run(shlex.split("ip netns delete netns_a"))
        subprocess.run(shlex.split("ip netns delete netns_b"))

Fixes: d445516966dc ("net: xdp: support xdp generic on virtual devices")
Reported-by: Stepan Horacek <shoracek@redhat.com>
Suggested-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Toke HÃ¸iland-JÃ¸rgensen <toke@redhat.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/core/dev.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -4256,14 +4256,14 @@ static u32 netif_receive_generic_xdp(str
 	/* Reinjected packets coming from act_mirred or similar should
 	 * not get XDP generic processing.
 	 */
-	if (skb_cloned(skb) || skb_is_tc_redirected(skb))
+	if (skb_is_tc_redirected(skb))
 		return XDP_PASS;
 
 	/* XDP packets must be linear and must have sufficient headroom
 	 * of XDP_PACKET_HEADROOM bytes. This is the guarantee that also
 	 * native XDP provides, thus we need to do it here as well.
 	 */
-	if (skb_is_nonlinear(skb) ||
+	if (skb_cloned(skb) || skb_is_nonlinear(skb) ||
 	    skb_headroom(skb) < XDP_PACKET_HEADROOM) {
 		int hroom = XDP_PACKET_HEADROOM - skb_headroom(skb);
 		int troom = skb->tail + skb->data_len - skb->end;


