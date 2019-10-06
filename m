Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0BE5ACD6CD
	for <lists+stable@lfdr.de>; Sun,  6 Oct 2019 19:51:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727365AbfJFRu4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 6 Oct 2019 13:50:56 -0400
Received: from mail.kernel.org ([198.145.29.99]:48974 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727278AbfJFRuz (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 6 Oct 2019 13:50:55 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 28CE3214D9;
        Sun,  6 Oct 2019 17:45:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1570383938;
        bh=13uzURmxxxIWX1FXpgkisWa47mmY45csoVlRHGI7GxI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZpE3Hhd41v9UHNjNxomYYOrmxW/rAcbHNSSrxdkTxFxq7HvqrK/yLt82CTLtpGA8h
         M9vXpfVpvHStiVzVrj6In7BCzng8+CHEEwSeOdJGLQoPXufRWM4bvUvp4A4IzXi8+k
         Fb5gzDXmXNVhYVHHxT4pEsLt0Bb7ACM6l0d/KkNc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.3 151/166] net: dsa: sja1105: Fix sleeping while atomic in .port_hwtstamp_set
Date:   Sun,  6 Oct 2019 19:21:57 +0200
Message-Id: <20191006171225.622979998@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191006171212.850660298@linuxfoundation.org>
References: <20191006171212.850660298@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Vladimir Oltean <olteanv@gmail.com>

[ Upstream commit 3e8db7e56082156a37b71d7334860c10fcea8025 ]

Currently this stack trace can be seen with CONFIG_DEBUG_ATOMIC_SLEEP=y:

[   41.568348] BUG: sleeping function called from invalid context at kernel/locking/mutex.c:909
[   41.576757] in_atomic(): 1, irqs_disabled(): 0, pid: 208, name: ptp4l
[   41.583212] INFO: lockdep is turned off.
[   41.587123] CPU: 1 PID: 208 Comm: ptp4l Not tainted 5.3.0-rc6-01445-ge950f2d4bc7f-dirty #1827
[   41.599873] [<c0313d7c>] (unwind_backtrace) from [<c030e13c>] (show_stack+0x10/0x14)
[   41.607584] [<c030e13c>] (show_stack) from [<c1212d50>] (dump_stack+0xd4/0x100)
[   41.614863] [<c1212d50>] (dump_stack) from [<c037dfc8>] (___might_sleep+0x1c8/0x2b4)
[   41.622574] [<c037dfc8>] (___might_sleep) from [<c122ea90>] (__mutex_lock+0x48/0xab8)
[   41.630368] [<c122ea90>] (__mutex_lock) from [<c122f51c>] (mutex_lock_nested+0x1c/0x24)
[   41.638340] [<c122f51c>] (mutex_lock_nested) from [<c0c6fe08>] (sja1105_static_config_reload+0x30/0x27c)
[   41.647779] [<c0c6fe08>] (sja1105_static_config_reload) from [<c0c7015c>] (sja1105_hwtstamp_set+0x108/0x1cc)
[   41.657562] [<c0c7015c>] (sja1105_hwtstamp_set) from [<c0feb650>] (dev_ifsioc+0x18c/0x330)
[   41.665788] [<c0feb650>] (dev_ifsioc) from [<c0febbd8>] (dev_ioctl+0x320/0x6e8)
[   41.673064] [<c0febbd8>] (dev_ioctl) from [<c0f8b1f4>] (sock_ioctl+0x334/0x5e8)
[   41.680340] [<c0f8b1f4>] (sock_ioctl) from [<c05404a8>] (do_vfs_ioctl+0xb0/0xa10)
[   41.687789] [<c05404a8>] (do_vfs_ioctl) from [<c0540e3c>] (ksys_ioctl+0x34/0x58)
[   41.695151] [<c0540e3c>] (ksys_ioctl) from [<c0301000>] (ret_fast_syscall+0x0/0x28)
[   41.702768] Exception stack(0xe8495fa8 to 0xe8495ff0)
[   41.707796] 5fa0:                   beff4a8c 00000001 00000011 000089b0 beff4a8c beff4a80
[   41.715933] 5fc0: beff4a8c 00000001 0000000c 00000036 b6fa98c8 004e19c1 00000001 00000000
[   41.724069] 5fe0: 004dcedc beff4a6c 004c0738 b6e7af4c
[   41.729860] BUG: scheduling while atomic: ptp4l/208/0x00000002
[   41.735682] INFO: lockdep is turned off.

Enabling RX timestamping will logically disturb the fastpath (processing
of meta frames). Replace bool hwts_rx_en with a bit that is checked
atomically from the fastpath and temporarily unset from the sleepable
context during a change of the RX timestamping process (a destructive
operation anyways, requires switch reset).
If found unset, the fastpath (net/dsa/tag_sja1105.c) will just drop any
received meta frame and not take the meta_lock at all.

Fixes: a602afd200f5 ("net: dsa: sja1105: Expose PTP timestamping ioctls to userspace")
Signed-off-by: Vladimir Oltean <olteanv@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/dsa/sja1105/sja1105_main.c |   19 +++++++++++--------
 include/linux/dsa/sja1105.h            |    4 +++-
 net/dsa/tag_sja1105.c                  |   12 +++++++++++-
 3 files changed, 25 insertions(+), 10 deletions(-)

--- a/drivers/net/dsa/sja1105/sja1105_main.c
+++ b/drivers/net/dsa/sja1105/sja1105_main.c
@@ -1875,7 +1875,9 @@ static int sja1105_set_ageing_time(struc
 	return sja1105_static_config_reload(priv);
 }
 
-/* Caller must hold priv->tagger_data.meta_lock */
+/* Must be called only with priv->tagger_data.state bit
+ * SJA1105_HWTS_RX_EN cleared
+ */
 static int sja1105_change_rxtstamping(struct sja1105_private *priv,
 				      bool on)
 {
@@ -1932,16 +1934,17 @@ static int sja1105_hwtstamp_set(struct d
 		break;
 	}
 
-	if (rx_on != priv->tagger_data.hwts_rx_en) {
-		spin_lock(&priv->tagger_data.meta_lock);
+	if (rx_on != test_bit(SJA1105_HWTS_RX_EN, &priv->tagger_data.state)) {
+		clear_bit(SJA1105_HWTS_RX_EN, &priv->tagger_data.state);
+
 		rc = sja1105_change_rxtstamping(priv, rx_on);
-		spin_unlock(&priv->tagger_data.meta_lock);
 		if (rc < 0) {
 			dev_err(ds->dev,
 				"Failed to change RX timestamping: %d\n", rc);
-			return -EFAULT;
+			return rc;
 		}
-		priv->tagger_data.hwts_rx_en = rx_on;
+		if (rx_on)
+			set_bit(SJA1105_HWTS_RX_EN, &priv->tagger_data.state);
 	}
 
 	if (copy_to_user(ifr->ifr_data, &config, sizeof(config)))
@@ -1960,7 +1963,7 @@ static int sja1105_hwtstamp_get(struct d
 		config.tx_type = HWTSTAMP_TX_ON;
 	else
 		config.tx_type = HWTSTAMP_TX_OFF;
-	if (priv->tagger_data.hwts_rx_en)
+	if (test_bit(SJA1105_HWTS_RX_EN, &priv->tagger_data.state))
 		config.rx_filter = HWTSTAMP_FILTER_PTP_V2_L2_EVENT;
 	else
 		config.rx_filter = HWTSTAMP_FILTER_NONE;
@@ -2009,7 +2012,7 @@ static bool sja1105_port_rxtstamp(struct
 	struct sja1105_private *priv = ds->priv;
 	struct sja1105_tagger_data *data = &priv->tagger_data;
 
-	if (!data->hwts_rx_en)
+	if (!test_bit(SJA1105_HWTS_RX_EN, &data->state))
 		return false;
 
 	/* We need to read the full PTP clock to reconstruct the Rx
--- a/include/linux/dsa/sja1105.h
+++ b/include/linux/dsa/sja1105.h
@@ -31,6 +31,8 @@
 #define SJA1105_META_SMAC			0x222222222222ull
 #define SJA1105_META_DMAC			0x0180C200000Eull
 
+#define SJA1105_HWTS_RX_EN			0
+
 /* Global tagger data: each struct sja1105_port has a reference to
  * the structure defined in struct sja1105_private.
  */
@@ -42,7 +44,7 @@ struct sja1105_tagger_data {
 	 * from taggers running on multiple ports on SMP systems
 	 */
 	spinlock_t meta_lock;
-	bool hwts_rx_en;
+	unsigned long state;
 };
 
 struct sja1105_skb_cb {
--- a/net/dsa/tag_sja1105.c
+++ b/net/dsa/tag_sja1105.c
@@ -155,7 +155,11 @@ static struct sk_buff
 	/* Step 1: A timestampable frame was received.
 	 * Buffer it until we get its meta frame.
 	 */
-	if (is_link_local && sp->data->hwts_rx_en) {
+	if (is_link_local) {
+		if (!test_bit(SJA1105_HWTS_RX_EN, &sp->data->state))
+			/* Do normal processing. */
+			return skb;
+
 		spin_lock(&sp->data->meta_lock);
 		/* Was this a link-local frame instead of the meta
 		 * that we were expecting?
@@ -186,6 +190,12 @@ static struct sk_buff
 	} else if (is_meta) {
 		struct sk_buff *stampable_skb;
 
+		/* Drop the meta frame if we're not in the right state
+		 * to process it.
+		 */
+		if (!test_bit(SJA1105_HWTS_RX_EN, &sp->data->state))
+			return NULL;
+
 		spin_lock(&sp->data->meta_lock);
 
 		stampable_skb = sp->data->stampable_skb;


