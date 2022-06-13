Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 452E5549602
	for <lists+stable@lfdr.de>; Mon, 13 Jun 2022 18:34:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1383541AbiFMO0h (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Jun 2022 10:26:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49912 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1383828AbiFMOYI (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Jun 2022 10:24:08 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B422646B3D;
        Mon, 13 Jun 2022 04:45:26 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4BDC3612A8;
        Mon, 13 Jun 2022 11:45:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 31B31C34114;
        Mon, 13 Jun 2022 11:45:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1655120725;
        bh=mkALKT5czTPfwxXCIDxiwR2hqDhIt407IFJI16w/K7A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WvLMzaiL402YEil6v6GU3oDFQaGvqZbhSJ44OZGdpd1RFdZacodG9Q0ZkYugnF6sP
         tyRIgF42p1qvEhA42Yl6qbaCLd0WLiX/FODjg8GhbtYSlrJPi6wCA6q9TwcEBpAK9m
         1KiC7f39hjBU+MHLg6TaJjf9P9Jo8xj7eVSHm9aw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Stephen Rothwell <sfr@canb.auug.org.au>,
        Sudip Mukherjee <sudipm.mukherjee@gmail.com>,
        Yury Norov <yury.norov@gmail.com>,
        Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
        Marcel Holtmann <marcel@holtmann.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.17 134/298] bluetooth: dont use bitmaps for random flag accesses
Date:   Mon, 13 Jun 2022 12:10:28 +0200
Message-Id: <20220613094929.007631777@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220613094924.913340374@linuxfoundation.org>
References: <20220613094924.913340374@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Linus Torvalds <torvalds@linux-foundation.org>

[ Upstream commit e1cff7002b716bd0b5f5f4afd4273c99aa8644be ]

The bluetooth code uses our bitmap infrastructure for the two bits (!)
of connection setup flags, and in the process causes odd problems when
it converts between a bitmap and just the regular values of said bits.

It's completely pointless to do things like bitmap_to_arr32() to convert
a bitmap into a u32.  It shoudln't have been a bitmap in the first
place.  The reason to use bitmaps is if you have arbitrary number of
bits you want to manage (not two!), or if you rely on the atomicity
guarantees of the bitmap setting and clearing.

The code could use an "atomic_t" and use "atomic_or/andnot()" to set and
clear the bit values, but considering that it then copies the bitmaps
around with "bitmap_to_arr32()" and friends, there clearly cannot be a
lot of atomicity requirements.

So just use a regular integer.

In the process, this avoids the warnings about erroneous use of
bitmap_from_u64() which were triggered on 32-bit architectures when
conversion from a u64 would access two words (and, surprise, surprise,
only one word is needed - and indeed overkill - for a 2-bit bitmap).

That was always problematic, but the compiler seems to notice it and
warn about the invalid pattern only after commit 0a97953fd221 ("lib: add
bitmap_{from,to}_arr64") changed the exact implementation details of
'bitmap_from_u64()', as reported by Sudip Mukherjee and Stephen Rothwell.

Fixes: fe92ee6425a2 ("Bluetooth: hci_core: Rework hci_conn_params flags")
Link: https://lore.kernel.org/all/YpyJ9qTNHJzz0FHY@debian/
Link: https://lore.kernel.org/all/20220606080631.0c3014f2@canb.auug.org.au/
Link: https://lore.kernel.org/all/20220605162537.1604762-1-yury.norov@gmail.com/
Reported-by: Stephen Rothwell <sfr@canb.auug.org.au>
Reported-by: Sudip Mukherjee <sudipm.mukherjee@gmail.com>
Reviewed-by: Yury Norov <yury.norov@gmail.com>
Cc: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Cc: Marcel Holtmann <marcel@holtmann.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/net/bluetooth/hci_core.h | 17 ++++++---------
 net/bluetooth/hci_core.c         |  4 ++--
 net/bluetooth/hci_request.c      |  2 +-
 net/bluetooth/hci_sync.c         |  6 +++---
 net/bluetooth/mgmt.c             | 37 ++++++++++++--------------------
 5 files changed, 27 insertions(+), 39 deletions(-)

diff --git a/include/net/bluetooth/hci_core.h b/include/net/bluetooth/hci_core.h
index 4524920e4895..f397b0a3d631 100644
--- a/include/net/bluetooth/hci_core.h
+++ b/include/net/bluetooth/hci_core.h
@@ -155,21 +155,18 @@ struct bdaddr_list_with_irk {
 	u8 local_irk[16];
 };
 
+/* Bitmask of connection flags */
 enum hci_conn_flags {
-	HCI_CONN_FLAG_REMOTE_WAKEUP,
-	HCI_CONN_FLAG_DEVICE_PRIVACY,
-
-	__HCI_CONN_NUM_FLAGS,
+	HCI_CONN_FLAG_REMOTE_WAKEUP = 1,
+	HCI_CONN_FLAG_DEVICE_PRIVACY = 2,
 };
-
-/* Make sure number of flags doesn't exceed sizeof(current_flags) */
-static_assert(__HCI_CONN_NUM_FLAGS < 32);
+typedef u8 hci_conn_flags_t;
 
 struct bdaddr_list_with_flags {
 	struct list_head list;
 	bdaddr_t bdaddr;
 	u8 bdaddr_type;
-	DECLARE_BITMAP(flags, __HCI_CONN_NUM_FLAGS);
+	hci_conn_flags_t flags;
 };
 
 struct bt_uuid {
@@ -567,7 +564,7 @@ struct hci_dev {
 	struct rfkill		*rfkill;
 
 	DECLARE_BITMAP(dev_flags, __HCI_NUM_FLAGS);
-	DECLARE_BITMAP(conn_flags, __HCI_CONN_NUM_FLAGS);
+	hci_conn_flags_t	conn_flags;
 
 	__s8			adv_tx_power;
 	__u8			adv_data[HCI_MAX_EXT_AD_LENGTH];
@@ -763,7 +760,7 @@ struct hci_conn_params {
 
 	struct hci_conn *conn;
 	bool explicit_connect;
-	DECLARE_BITMAP(flags, __HCI_CONN_NUM_FLAGS);
+	hci_conn_flags_t flags;
 	u8  privacy_mode;
 };
 
diff --git a/net/bluetooth/hci_core.c b/net/bluetooth/hci_core.c
index 9e9713f7ddb8..f1feb9204063 100644
--- a/net/bluetooth/hci_core.c
+++ b/net/bluetooth/hci_core.c
@@ -2153,7 +2153,7 @@ int hci_bdaddr_list_add_with_flags(struct list_head *list, bdaddr_t *bdaddr,
 
 	bacpy(&entry->bdaddr, bdaddr);
 	entry->bdaddr_type = type;
-	bitmap_from_u64(entry->flags, flags);
+	entry->flags = flags;
 
 	list_add(&entry->list, list);
 
@@ -2633,7 +2633,7 @@ int hci_register_dev(struct hci_dev *hdev)
 	 * callback.
 	 */
 	if (hdev->wakeup)
-		set_bit(HCI_CONN_FLAG_REMOTE_WAKEUP, hdev->conn_flags);
+		hdev->conn_flags |= HCI_CONN_FLAG_REMOTE_WAKEUP;
 
 	hci_sock_dev_event(hdev, HCI_DEV_REG);
 	hci_dev_hold(hdev);
diff --git a/net/bluetooth/hci_request.c b/net/bluetooth/hci_request.c
index f4afe482e300..95689982eedb 100644
--- a/net/bluetooth/hci_request.c
+++ b/net/bluetooth/hci_request.c
@@ -482,7 +482,7 @@ static int add_to_accept_list(struct hci_request *req,
 
 	/* During suspend, only wakeable devices can be in accept list */
 	if (hdev->suspended &&
-	    !test_bit(HCI_CONN_FLAG_REMOTE_WAKEUP, params->flags))
+	    !(params->flags & HCI_CONN_FLAG_REMOTE_WAKEUP))
 		return 0;
 
 	*num_entries += 1;
diff --git a/net/bluetooth/hci_sync.c b/net/bluetooth/hci_sync.c
index 6b8d1cd65de4..351c2390164d 100644
--- a/net/bluetooth/hci_sync.c
+++ b/net/bluetooth/hci_sync.c
@@ -1637,7 +1637,7 @@ static int hci_le_set_privacy_mode_sync(struct hci_dev *hdev,
 	 * indicates that LL Privacy has been enabled and
 	 * HCI_OP_LE_SET_PRIVACY_MODE is supported.
 	 */
-	if (!test_bit(HCI_CONN_FLAG_DEVICE_PRIVACY, params->flags))
+	if (!(params->flags & HCI_CONN_FLAG_DEVICE_PRIVACY))
 		return 0;
 
 	irk = hci_find_irk_by_addr(hdev, &params->addr, params->addr_type);
@@ -1666,7 +1666,7 @@ static int hci_le_add_accept_list_sync(struct hci_dev *hdev,
 
 	/* During suspend, only wakeable devices can be in acceptlist */
 	if (hdev->suspended &&
-	    !test_bit(HCI_CONN_FLAG_REMOTE_WAKEUP, params->flags))
+	    !(params->flags & HCI_CONN_FLAG_REMOTE_WAKEUP))
 		return 0;
 
 	/* Select filter policy to accept all advertising */
@@ -4856,7 +4856,7 @@ static int hci_update_event_filter_sync(struct hci_dev *hdev)
 	hci_clear_event_filter_sync(hdev);
 
 	list_for_each_entry(b, &hdev->accept_list, list) {
-		if (!test_bit(HCI_CONN_FLAG_REMOTE_WAKEUP, b->flags))
+		if (!(b->flags & HCI_CONN_FLAG_REMOTE_WAKEUP))
 			continue;
 
 		bt_dev_dbg(hdev, "Adding event filters for %pMR", &b->bdaddr);
diff --git a/net/bluetooth/mgmt.c b/net/bluetooth/mgmt.c
index 16cd2e7a10da..943cdc9ec763 100644
--- a/net/bluetooth/mgmt.c
+++ b/net/bluetooth/mgmt.c
@@ -4009,10 +4009,11 @@ static int exp_ll_privacy_feature_changed(bool enabled, struct hci_dev *hdev,
 	memcpy(ev.uuid, rpa_resolution_uuid, 16);
 	ev.flags = cpu_to_le32((enabled ? BIT(0) : 0) | BIT(1));
 
+	// Do we need to be atomic with the conn_flags?
 	if (enabled && privacy_mode_capable(hdev))
-		set_bit(HCI_CONN_FLAG_DEVICE_PRIVACY, hdev->conn_flags);
+		hdev->conn_flags |= HCI_CONN_FLAG_DEVICE_PRIVACY;
 	else
-		clear_bit(HCI_CONN_FLAG_DEVICE_PRIVACY, hdev->conn_flags);
+		hdev->conn_flags &= ~HCI_CONN_FLAG_DEVICE_PRIVACY;
 
 	return mgmt_limited_event(MGMT_EV_EXP_FEATURE_CHANGED, hdev,
 				  &ev, sizeof(ev),
@@ -4431,8 +4432,7 @@ static int get_device_flags(struct sock *sk, struct hci_dev *hdev, void *data,
 
 	hci_dev_lock(hdev);
 
-	bitmap_to_arr32(&supported_flags, hdev->conn_flags,
-			__HCI_CONN_NUM_FLAGS);
+	supported_flags = hdev->conn_flags;
 
 	memset(&rp, 0, sizeof(rp));
 
@@ -4443,8 +4443,7 @@ static int get_device_flags(struct sock *sk, struct hci_dev *hdev, void *data,
 		if (!br_params)
 			goto done;
 
-		bitmap_to_arr32(&current_flags, br_params->flags,
-				__HCI_CONN_NUM_FLAGS);
+		current_flags = br_params->flags;
 	} else {
 		params = hci_conn_params_lookup(hdev, &cp->addr.bdaddr,
 						le_addr_type(cp->addr.type));
@@ -4452,8 +4451,7 @@ static int get_device_flags(struct sock *sk, struct hci_dev *hdev, void *data,
 		if (!params)
 			goto done;
 
-		bitmap_to_arr32(&current_flags, params->flags,
-				__HCI_CONN_NUM_FLAGS);
+		current_flags = params->flags;
 	}
 
 	bacpy(&rp.addr.bdaddr, &cp->addr.bdaddr);
@@ -4498,8 +4496,8 @@ static int set_device_flags(struct sock *sk, struct hci_dev *hdev, void *data,
 		   &cp->addr.bdaddr, cp->addr.type,
 		   __le32_to_cpu(current_flags));
 
-	bitmap_to_arr32(&supported_flags, hdev->conn_flags,
-			__HCI_CONN_NUM_FLAGS);
+	// We should take hci_dev_lock() early, I think.. conn_flags can change
+	supported_flags = hdev->conn_flags;
 
 	if ((supported_flags | current_flags) != supported_flags) {
 		bt_dev_warn(hdev, "Bad flag given (0x%x) vs supported (0x%0x)",
@@ -4515,7 +4513,7 @@ static int set_device_flags(struct sock *sk, struct hci_dev *hdev, void *data,
 							      cp->addr.type);
 
 		if (br_params) {
-			bitmap_from_u64(br_params->flags, current_flags);
+			br_params->flags = current_flags;
 			status = MGMT_STATUS_SUCCESS;
 		} else {
 			bt_dev_warn(hdev, "No such BR/EDR device %pMR (0x%x)",
@@ -4525,15 +4523,11 @@ static int set_device_flags(struct sock *sk, struct hci_dev *hdev, void *data,
 		params = hci_conn_params_lookup(hdev, &cp->addr.bdaddr,
 						le_addr_type(cp->addr.type));
 		if (params) {
-			DECLARE_BITMAP(flags, __HCI_CONN_NUM_FLAGS);
-
-			bitmap_from_u64(flags, current_flags);
-
 			/* Devices using RPAs can only be programmed in the
 			 * acceptlist LL Privacy has been enable otherwise they
 			 * cannot mark HCI_CONN_FLAG_REMOTE_WAKEUP.
 			 */
-			if (test_bit(HCI_CONN_FLAG_REMOTE_WAKEUP, flags) &&
+			if ((current_flags & HCI_CONN_FLAG_REMOTE_WAKEUP) &&
 			    !use_ll_privacy(hdev) &&
 			    hci_find_irk_by_addr(hdev, &params->addr,
 						 params->addr_type)) {
@@ -4542,14 +4536,13 @@ static int set_device_flags(struct sock *sk, struct hci_dev *hdev, void *data,
 				goto unlock;
 			}
 
-			bitmap_from_u64(params->flags, current_flags);
+			params->flags = current_flags;
 			status = MGMT_STATUS_SUCCESS;
 
 			/* Update passive scan if HCI_CONN_FLAG_DEVICE_PRIVACY
 			 * has been set.
 			 */
-			if (test_bit(HCI_CONN_FLAG_DEVICE_PRIVACY,
-				     params->flags))
+			if (params->flags & HCI_CONN_FLAG_DEVICE_PRIVACY)
 				hci_update_passive_scan(hdev);
 		} else {
 			bt_dev_warn(hdev, "No such LE device %pMR (0x%x)",
@@ -7150,8 +7143,7 @@ static int add_device(struct sock *sk, struct hci_dev *hdev,
 		params = hci_conn_params_lookup(hdev, &cp->addr.bdaddr,
 						addr_type);
 		if (params)
-			bitmap_to_arr32(&current_flags, params->flags,
-					__HCI_CONN_NUM_FLAGS);
+			current_flags = params->flags;
 	}
 
 	err = hci_cmd_sync_queue(hdev, add_device_sync, NULL, NULL);
@@ -7160,8 +7152,7 @@ static int add_device(struct sock *sk, struct hci_dev *hdev,
 
 added:
 	device_added(sk, hdev, &cp->addr.bdaddr, cp->addr.type, cp->action);
-	bitmap_to_arr32(&supported_flags, hdev->conn_flags,
-			__HCI_CONN_NUM_FLAGS);
+	supported_flags = hdev->conn_flags;
 	device_flags_changed(NULL, hdev, &cp->addr.bdaddr, cp->addr.type,
 			     supported_flags, current_flags);
 
-- 
2.35.1



