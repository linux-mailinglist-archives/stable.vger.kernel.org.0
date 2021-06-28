Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EE8D03B63EA
	for <lists+stable@lfdr.de>; Mon, 28 Jun 2021 17:00:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236684AbhF1PCT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Jun 2021 11:02:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:36472 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236530AbhF1PAO (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Jun 2021 11:00:14 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E726461D67;
        Mon, 28 Jun 2021 14:40:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1624891249;
        bh=DvyRlzxyHCj4wQICX0KomspQ0nFGNMiC2/AneUlZkGU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=eVBwfRp0eGkNNDV+pcXh2mR8icQbEySf+c7Iqhr4oJXfH5S3kLrjCypUO7BhrBxEb
         Ycc56/pBVbJ/gnbhz3mtA10zEf8t15qLPT/nuGtkPHwSOCGNd4siRNUG2azU+zzPLZ
         pGwZnHhcpYPdP48QkU5Fd9XJp6b0aUeunnsYKr0hRLw108iHc/Lx4olNGWJAzXWJRF
         UeFg2e7Tt5RMh/2Z9789iI0rNx2wGI9cUwhGrlsL3w7nUzu/suFYuuRab6ahQBOW0i
         R5HJRgT/JytpL2v3L6MJ5CJHjNYtxTZ8yg2XK9q8NMzFy6Xq7yR1aM36Owh2p77nJ6
         yVM1774dgwDJg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Alexander Duyck <alexander.h.duyck@intel.com>,
        Andrew Bowers <andrewx.bowers@intel.com>,
        Philipp Hahn <hahn@univention.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH 4.9 51/71] i40e: Be much more verbose about what we can and cannot offload
Date:   Mon, 28 Jun 2021 10:39:43 -0400
Message-Id: <20210628144003.34260-52-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210628144003.34260-1-sashal@kernel.org>
References: <20210628144003.34260-1-sashal@kernel.org>
MIME-Version: 1.0
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.9.274-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-4.9.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 4.9.274-rc1
X-KernelTest-Deadline: 2021-06-30T14:39+00:00
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Alexander Duyck <alexander.h.duyck@intel.com>

commit f114dca2533ca770aebebffb5ed56e5e7d1fb3fb upstream.

This change makes it so that we are much more robust about defining what we
can and cannot offload.  Previously we were just checking for the L4 tunnel
header length, however there are other fields we should be verifying as
there are multiple scenarios in which we cannot perform hardware offloads.

In addition the device only supports GSO as long as the MSS is 64 or
greater.  We were not checking this so an MSS less than that was resulting
in Tx hangs.

Change-ID: I5e2fd5f3075c73601b4b36327b771c64fcb6c31b
Signed-off-by: Alexander Duyck <alexander.h.duyck@intel.com>
Tested-by: Andrew Bowers <andrewx.bowers@intel.com>
Cc: Philipp Hahn <hahn@univention.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/intel/i40e/i40e_main.c | 52 +++++++++++++++++----
 1 file changed, 44 insertions(+), 8 deletions(-)

diff --git a/drivers/net/ethernet/intel/i40e/i40e_main.c b/drivers/net/ethernet/intel/i40e/i40e_main.c
index 40644657b1b7..0b1ee353f415 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_main.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_main.c
@@ -9059,10 +9059,6 @@ static int i40e_ndo_bridge_getlink(struct sk_buff *skb, u32 pid, u32 seq,
 				       0, 0, nlflags, filter_mask, NULL);
 }
 
-/* Hardware supports L4 tunnel length of 128B (=2^7) which includes
- * inner mac plus all inner ethertypes.
- */
-#define I40E_MAX_TUNNEL_HDR_LEN 128
 /**
  * i40e_features_check - Validate encapsulated packet conforms to limits
  * @skb: skb buff
@@ -9073,12 +9069,52 @@ static netdev_features_t i40e_features_check(struct sk_buff *skb,
 					     struct net_device *dev,
 					     netdev_features_t features)
 {
-	if (skb->encapsulation &&
-	    ((skb_inner_network_header(skb) - skb_transport_header(skb)) >
-	     I40E_MAX_TUNNEL_HDR_LEN))
-		return features & ~(NETIF_F_CSUM_MASK | NETIF_F_GSO_MASK);
+	size_t len;
+
+	/* No point in doing any of this if neither checksum nor GSO are
+	 * being requested for this frame.  We can rule out both by just
+	 * checking for CHECKSUM_PARTIAL
+	 */
+	if (skb->ip_summed != CHECKSUM_PARTIAL)
+		return features;
+
+	/* We cannot support GSO if the MSS is going to be less than
+	 * 64 bytes.  If it is then we need to drop support for GSO.
+	 */
+	if (skb_is_gso(skb) && (skb_shinfo(skb)->gso_size < 64))
+		features &= ~NETIF_F_GSO_MASK;
+
+	/* MACLEN can support at most 63 words */
+	len = skb_network_header(skb) - skb->data;
+	if (len & ~(63 * 2))
+		goto out_err;
+
+	/* IPLEN and EIPLEN can support at most 127 dwords */
+	len = skb_transport_header(skb) - skb_network_header(skb);
+	if (len & ~(127 * 4))
+		goto out_err;
+
+	if (skb->encapsulation) {
+		/* L4TUNLEN can support 127 words */
+		len = skb_inner_network_header(skb) - skb_transport_header(skb);
+		if (len & ~(127 * 2))
+			goto out_err;
+
+		/* IPLEN can support at most 127 dwords */
+		len = skb_inner_transport_header(skb) -
+		      skb_inner_network_header(skb);
+		if (len & ~(127 * 4))
+			goto out_err;
+	}
+
+	/* No need to validate L4LEN as TCP is the only protocol with a
+	 * a flexible value and we support all possible values supported
+	 * by TCP, which is at most 15 dwords
+	 */
 
 	return features;
+out_err:
+	return features & ~(NETIF_F_CSUM_MASK | NETIF_F_GSO_MASK);
 }
 
 static const struct net_device_ops i40e_netdev_ops = {
-- 
2.30.2

