Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3AFC44110AB
	for <lists+stable@lfdr.de>; Mon, 20 Sep 2021 10:08:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233987AbhITIKA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Sep 2021 04:10:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:60944 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235329AbhITIJx (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 Sep 2021 04:09:53 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9033561077;
        Mon, 20 Sep 2021 08:08:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1632125307;
        bh=53Ylm+GW6QFHrrkD3tiZEQCakoiv59eWbIguawOeNoM=;
        h=Subject:To:Cc:From:Date:From;
        b=AWUZHmYczBX6V/0bPaiEH+Z/hFp5nnBPNVouol3WzX86g7EDvijnwSosWDws3PxwF
         7mdY/qa+liFAszgc8UmTp/CzEeFSKaEEgx6l1vjdV/Ss8xnfeqf/yzRGXritBvWuYp
         JSdKbM/c+tDdOv5ZGZ6Zjum5aN5Ph2I64ZoM/rG4=
Subject: FAILED: patch "[PATCH] igc: fix tunnel offloading" failed to apply to 5.10-stable tree
To:     pabeni@redhat.com, anthony.l.nguyen@intel.com, davem@davemloft.net,
        nechamax.kraus@linux.intel.com, sasha.neftin@intel.com,
        vinschen@redhat.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 20 Sep 2021 10:08:24 +0200
Message-ID: <1632125304178128@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.10-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 40ee363c844fcb6ae0f1f5cfea68aed7e268c2f4 Mon Sep 17 00:00:00 2001
From: Paolo Abeni <pabeni@redhat.com>
Date: Wed, 15 Sep 2021 10:19:07 -0700
Subject: [PATCH] igc: fix tunnel offloading

Checking tunnel offloading, it turns out that offloading doesn't work
as expected.  The following script allows to reproduce the issue.
Call it as `testscript DEVICE LOCALIP REMOTEIP NETMASK'

=== SNIP ===
if [ $# -ne 4 ]
then
  echo "Usage $0 DEVICE LOCALIP REMOTEIP NETMASK"
  exit 1
fi
DEVICE="$1"
LOCAL_ADDRESS="$2"
REMOTE_ADDRESS="$3"
NWMASK="$4"
echo "Driver: $(ethtool -i ${DEVICE} | awk '/^driver:/{print $2}') "
ethtool -k "${DEVICE}" | grep tx-udp
echo
echo "Set up NIC and tunnel..."
ip addr add "${LOCAL_ADDRESS}/${NWMASK}" dev "${DEVICE}"
ip link set "${DEVICE}" up
sleep 2
ip link add vxlan1 type vxlan id 42 \
		   remote "${REMOTE_ADDRESS}" \
		   local "${LOCAL_ADDRESS}" \
		   dstport 0 \
		   dev "${DEVICE}"
ip addr add fc00::1/64 dev vxlan1
ip link set vxlan1 up
sleep 2
rm -f vxlan.pcap
echo "Running tcpdump and iperf3..."
( nohup tcpdump -i any -w vxlan.pcap >/dev/null 2>&1 ) &
sleep 2
iperf3 -c fc00::2 >/dev/null
pkill tcpdump
echo
echo -n "Max. Paket Size: "
tcpdump -r vxlan.pcap -nnle 2>/dev/null \
| grep "${LOCAL_ADDRESS}.*> ${REMOTE_ADDRESS}.*OTV" \
| awk '{print $8}' | awk -F ':' '{print $1}' \
| sort -n | tail -1
echo
ip link del vxlan1
ip addr del ${LOCAL_ADDRESS}/${NWMASK} dev "${DEVICE}"
=== SNAP ===

The expected outcome is

  Max. Paket Size: 64904

This is what you see on igb, the code igc has been taken from.
However, on igc the output is

  Max. Paket Size: 1516

so the GSO aggregate packets are segmented by the kernel before calling
igc_xmit_frame.  Inside the subsequent call to igc_tso, the check for
skb_is_gso(skb) fails and the function returns prematurely.

It turns out that this occurs because the feature flags aren't set
entirely correctly in igc_probe.  In contrast to the original code
from igb_probe, igc_probe neglects to set the flags required to allow
tunnel offloading.

Setting the same flags as igb fixes the issue on igc.

Fixes: 34428dff3679 ("igc: Add GSO partial support")
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Tested-by: Corinna Vinschen <vinschen@redhat.com>
Acked-by: Sasha Neftin <sasha.neftin@intel.com>
Tested-by: Nechama Kraus <nechamax.kraus@linux.intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Signed-off-by: David S. Miller <davem@davemloft.net>

diff --git a/drivers/net/ethernet/intel/igc/igc_main.c b/drivers/net/ethernet/intel/igc/igc_main.c
index b877efae61df..0e19b4d02e62 100644
--- a/drivers/net/ethernet/intel/igc/igc_main.c
+++ b/drivers/net/ethernet/intel/igc/igc_main.c
@@ -6350,7 +6350,9 @@ static int igc_probe(struct pci_dev *pdev,
 	if (pci_using_dac)
 		netdev->features |= NETIF_F_HIGHDMA;
 
-	netdev->vlan_features |= netdev->features;
+	netdev->vlan_features |= netdev->features | NETIF_F_TSO_MANGLEID;
+	netdev->mpls_features |= NETIF_F_HW_CSUM;
+	netdev->hw_enc_features |= netdev->vlan_features;
 
 	/* MTU range: 68 - 9216 */
 	netdev->min_mtu = ETH_MIN_MTU;

