Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5653E3E393A
	for <lists+stable@lfdr.de>; Sun,  8 Aug 2021 08:52:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230237AbhHHGwc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 8 Aug 2021 02:52:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:37770 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230201AbhHHGwb (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 8 Aug 2021 02:52:31 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3C58560F42;
        Sun,  8 Aug 2021 06:52:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1628405532;
        bh=Jt3UQFm7KwGGX1221j30xmUtudvwLvPFhB1WGJXAKs0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=sis3wbNW7jkK1y5Dsx1AtOojcWpfj5qPzXviCwEx8RqT1CReqWuddZ3vqmNd5o9yH
         1julQZ5HbL2AoBoJeVGCzfXsTWIzpCZQJ1+rf2oAZDCXEw5giSy6+qQnj3xcO6wMjT
         JmRbw8Z8obicOEBv8BIueT8PVLOwiGDu0a82IoA4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: Linux 4.4.279
Date:   Sun,  8 Aug 2021 08:52:05 +0200
Message-Id: <162840552416368@kroah.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <1628405524248245@kroah.com>
References: <1628405524248245@kroah.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

diff --git a/Makefile b/Makefile
index e3e65d04e39c..7dc479e9a665 100644
--- a/Makefile
+++ b/Makefile
@@ -1,6 +1,6 @@
 VERSION = 4
 PATCHLEVEL = 4
-SUBLEVEL = 278
+SUBLEVEL = 279
 EXTRAVERSION =
 NAME = Blurry Fish Butt
 
diff --git a/drivers/net/usb/r8152.c b/drivers/net/usb/r8152.c
index 5baaa8291624..ebf6d4cf09ea 100644
--- a/drivers/net/usb/r8152.c
+++ b/drivers/net/usb/r8152.c
@@ -3159,9 +3159,10 @@ static int rtl8152_close(struct net_device *netdev)
 		tp->rtl_ops.down(tp);
 
 		mutex_unlock(&tp->control);
+	}
 
+	if (!res)
 		usb_autopm_put_interface(tp->intf);
-	}
 
 	free_all_mem(tp);
 
diff --git a/fs/btrfs/compression.c b/fs/btrfs/compression.c
index bae05c5c75ba..92601775ec5e 100644
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
index c478924198d5..041e719543fe 100644
--- a/net/bluetooth/hci_core.c
+++ b/net/bluetooth/hci_core.c
@@ -1666,6 +1666,14 @@ int hci_dev_do_close(struct hci_dev *hdev)
 
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
 
 	hci_req_cancel(hdev, ENODEV);
@@ -1738,14 +1746,6 @@ int hci_dev_do_close(struct hci_dev *hdev)
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
index 2e1d850a7f2a..1c2bf97ca168 100644
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
index 7665154c85c2..58989a5ba362 100644
--- a/net/core/skbuff.c
+++ b/net/core/skbuff.c
@@ -2243,8 +2243,11 @@ skb_zerocopy_headlen(const struct sk_buff *from)
 
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
