Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 22CE23E393F
	for <lists+stable@lfdr.de>; Sun,  8 Aug 2021 08:52:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230418AbhHHGwt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 8 Aug 2021 02:52:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:37996 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230419AbhHHGwm (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 8 Aug 2021 02:52:42 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5950A60F42;
        Sun,  8 Aug 2021 06:52:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1628405541;
        bh=lesswNYGhXvszj7jkBC2WYVJ4MeLA4Q70sC70OyyO9Q=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=iOG91Cf01ZT9Sab8ko9TXxiUl3Y5QW7clrGd2nHWlDS2L9pn76virDaIUfnA9eRMJ
         LETddNXeh5h1vX8ZB2ABauhWudONF0Ic2OX+6EJVkledIA0bY5kRc5u6+Ms1r5jJwA
         VADfnpBR17Wl7WFsInCumzOrjNNL/WDiTnfQIWpM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: Linux 4.9.279
Date:   Sun,  8 Aug 2021 08:52:10 +0200
Message-Id: <162840552957176@kroah.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <1628405529193137@kroah.com>
References: <1628405529193137@kroah.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

diff --git a/Makefile b/Makefile
index 82fc1c747592..b88bc8d14ca3 100644
--- a/Makefile
+++ b/Makefile
@@ -1,6 +1,6 @@
 VERSION = 4
 PATCHLEVEL = 9
-SUBLEVEL = 278
+SUBLEVEL = 279
 EXTRAVERSION =
 NAME = Roaring Lionus
 
diff --git a/drivers/net/usb/r8152.c b/drivers/net/usb/r8152.c
index 64fdea332886..96f6edcb0062 100644
--- a/drivers/net/usb/r8152.c
+++ b/drivers/net/usb/r8152.c
@@ -3347,9 +3347,10 @@ static int rtl8152_close(struct net_device *netdev)
 		tp->rtl_ops.down(tp);
 
 		mutex_unlock(&tp->control);
+	}
 
+	if (!res)
 		usb_autopm_put_interface(tp->intf);
-	}
 
 	free_all_mem(tp);
 
diff --git a/drivers/spi/spi-mt65xx.c b/drivers/spi/spi-mt65xx.c
index 419aecb94274..dd0bf25d4550 100644
--- a/drivers/spi/spi-mt65xx.c
+++ b/drivers/spi/spi-mt65xx.c
@@ -337,24 +337,15 @@ static int mtk_spi_fifo_transfer(struct spi_master *master,
 	mtk_spi_prepare_transfer(master, xfer);
 	mtk_spi_setup_packet(master);
 
-	cnt = xfer->len / 4;
-	if (xfer->tx_buf)
+	if (xfer->tx_buf) {
+		cnt = xfer->len / 4;
 		iowrite32_rep(mdata->base + SPI_TX_DATA_REG, xfer->tx_buf, cnt);
-
-	if (xfer->rx_buf)
-		ioread32_rep(mdata->base + SPI_RX_DATA_REG, xfer->rx_buf, cnt);
-
-	remainder = xfer->len % 4;
-	if (remainder > 0) {
-		reg_val = 0;
-		if (xfer->tx_buf) {
+		remainder = xfer->len % 4;
+		if (remainder > 0) {
+			reg_val = 0;
 			memcpy(&reg_val, xfer->tx_buf + (cnt * 4), remainder);
 			writel(reg_val, mdata->base + SPI_TX_DATA_REG);
 		}
-		if (xfer->rx_buf) {
-			reg_val = readl(mdata->base + SPI_RX_DATA_REG);
-			memcpy(xfer->rx_buf + (cnt * 4), &reg_val, remainder);
-		}
 	}
 
 	mtk_spi_enable_transfer(master);
diff --git a/fs/btrfs/compression.c b/fs/btrfs/compression.c
index d4d8b7e36b2f..2534e44cfd40 100644
--- a/fs/btrfs/compression.c
+++ b/fs/btrfs/compression.c
@@ -290,7 +290,7 @@ static void end_compressed_bio_write(struct bio *bio)
 					 cb->start,
 					 cb->start + cb->len - 1,
 					 NULL,
-					 bio->bi_error ? 0 : 1);
+					 !cb->errors);
 	cb->compressed_pages[0]->mapping = NULL;
 
 	end_compressed_writeback(inode, cb);
diff --git a/include/linux/mfd/rt5033-private.h b/include/linux/mfd/rt5033-private.h
index 1b63fc2f42d1..52d53d134f72 100644
--- a/include/linux/mfd/rt5033-private.h
+++ b/include/linux/mfd/rt5033-private.h
@@ -203,13 +203,13 @@ enum rt5033_reg {
 #define RT5033_REGULATOR_BUCK_VOLTAGE_MIN		1000000U
 #define RT5033_REGULATOR_BUCK_VOLTAGE_MAX		3000000U
 #define RT5033_REGULATOR_BUCK_VOLTAGE_STEP		100000U
-#define RT5033_REGULATOR_BUCK_VOLTAGE_STEP_NUM		32
+#define RT5033_REGULATOR_BUCK_VOLTAGE_STEP_NUM		21
 
 /* RT5033 regulator LDO output voltage uV */
 #define RT5033_REGULATOR_LDO_VOLTAGE_MIN		1200000U
 #define RT5033_REGULATOR_LDO_VOLTAGE_MAX		3000000U
 #define RT5033_REGULATOR_LDO_VOLTAGE_STEP		100000U
-#define RT5033_REGULATOR_LDO_VOLTAGE_STEP_NUM		32
+#define RT5033_REGULATOR_LDO_VOLTAGE_STEP_NUM		19
 
 /* RT5033 regulator SAFE LDO output voltage uV */
 #define RT5033_REGULATOR_SAFE_LDO_VOLTAGE		4900000U
diff --git a/net/bluetooth/hci_core.c b/net/bluetooth/hci_core.c
index 50b9a0bbe5df..839c534bdcdb 100644
--- a/net/bluetooth/hci_core.c
+++ b/net/bluetooth/hci_core.c
@@ -1533,6 +1533,14 @@ int hci_dev_do_close(struct hci_dev *hdev)
 
 	BT_DBG("%s %p", hdev->name, hdev);
 
+	if (!hci_dev_test_flag(hdev, HCI_UNREGISTER) &&
+	    !hci_dev_test_flag(hdev, HCI_USER_CHANNEL) &&
+	    test_bit(HCI_UP, &hdev->flags)) {
+		/* Execute vendor specific shutdown routine */
+		if (hdev->shutdown)
+			hdev->shutdown(hdev);
+	}
+
 	cancel_delayed_work(&hdev->power_off);
 
 	hci_request_cancel_all(hdev);
@@ -1600,14 +1608,6 @@ int hci_dev_do_close(struct hci_dev *hdev)
 		clear_bit(HCI_INIT, &hdev->flags);
 	}
 
-	if (!hci_dev_test_flag(hdev, HCI_UNREGISTER) &&
-	    !hci_dev_test_flag(hdev, HCI_USER_CHANNEL) &&
-	    test_bit(HCI_UP, &hdev->flags)) {
-		/* Execute vendor specific shutdown routine */
-		if (hdev->shutdown)
-			hdev->shutdown(hdev);
-	}
-
 	/* flush cmd  work */
 	flush_work(&hdev->cmd_work);
 
diff --git a/net/can/raw.c b/net/can/raw.c
index 2bb50b1535c2..082965c8dcaf 100644
--- a/net/can/raw.c
+++ b/net/can/raw.c
@@ -541,10 +541,18 @@ static int raw_setsockopt(struct socket *sock, int level, int optname,
 				return -EFAULT;
 		}
 
+		rtnl_lock();
 		lock_sock(sk);
 
-		if (ro->bound && ro->ifindex)
+		if (ro->bound && ro->ifindex) {
 			dev = dev_get_by_index(&init_net, ro->ifindex);
+			if (!dev) {
+				if (count > 1)
+					kfree(filter);
+				err = -ENODEV;
+				goto out_fil;
+			}
+		}
 
 		if (ro->bound) {
 			/* (try to) register the new filters */
@@ -581,6 +589,7 @@ static int raw_setsockopt(struct socket *sock, int level, int optname,
 			dev_put(dev);
 
 		release_sock(sk);
+		rtnl_unlock();
 
 		break;
 
@@ -593,10 +602,16 @@ static int raw_setsockopt(struct socket *sock, int level, int optname,
 
 		err_mask &= CAN_ERR_MASK;
 
+		rtnl_lock();
 		lock_sock(sk);
 
-		if (ro->bound && ro->ifindex)
+		if (ro->bound && ro->ifindex) {
 			dev = dev_get_by_index(&init_net, ro->ifindex);
+			if (!dev) {
+				err = -ENODEV;
+				goto out_err;
+			}
+		}
 
 		/* remove current error mask */
 		if (ro->bound) {
@@ -618,6 +633,7 @@ static int raw_setsockopt(struct socket *sock, int level, int optname,
 			dev_put(dev);
 
 		release_sock(sk);
+		rtnl_unlock();
 
 		break;
 
diff --git a/net/core/skbuff.c b/net/core/skbuff.c
index 076444dac96d..0e34f5ad6216 100644
--- a/net/core/skbuff.c
+++ b/net/core/skbuff.c
@@ -2288,8 +2288,11 @@ skb_zerocopy_headlen(const struct sk_buff *from)
 
 	if (!from->head_frag ||
 	    skb_headlen(from) < L1_CACHE_BYTES ||
-	    skb_shinfo(from)->nr_frags >= MAX_SKB_FRAGS)
+	    skb_shinfo(from)->nr_frags >= MAX_SKB_FRAGS) {
 		hlen = skb_headlen(from);
+		if (!hlen)
+			hlen = from->len;
+	}
 
 	if (skb_has_frag_list(from))
 		hlen = from->len;
