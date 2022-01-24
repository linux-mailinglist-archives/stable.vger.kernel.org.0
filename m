Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C480E4999BA
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 22:46:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1455985AbiAXVhC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 16:37:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53842 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1453948AbiAXVbS (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 16:31:18 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5220CC07594F;
        Mon, 24 Jan 2022 12:20:42 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E639061382;
        Mon, 24 Jan 2022 20:20:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 04370C340E5;
        Mon, 24 Jan 2022 20:20:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643055641;
        bh=6D0Bb+Eljcrz77ri0/7cvVE6eJB+B33mWRX38x3jL6A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TrmQv6QT7CF4jlWyaX684UwdZhl+hTO98oCbjo3mqdtBOEnPISfMjdDMiVPlUnIkk
         YLgPIHEOoA34PQ1SY18QWIKPuGSRI6ZIlvkw9h0eMLOxkOUIOemAZujzzHdcklWDFx
         MdFwV3r6s4qFsqOzsH5+gFqjEHpf91fnsB+YON94=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Joseph Hwang <josephsih@chromium.org>,
        Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 216/846] Bluetooth: refactor set_exp_feature with a feature table
Date:   Mon, 24 Jan 2022 19:35:33 +0100
Message-Id: <20220124184108.379653931@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124184100.867127425@linuxfoundation.org>
References: <20220124184100.867127425@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Joseph Hwang <josephsih@chromium.org>

[ Upstream commit 93fb70bc112e922def6e50b37e20ccfce0c67c0a ]

This patch refactors the set_exp_feature with a feature table
consisting of UUIDs and the corresponding callback functions.
In this way, a new experimental feature setting function can be
simply added with its UUID and callback function.

Signed-off-by: Joseph Hwang <josephsih@chromium.org>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/bluetooth/mgmt.c | 248 +++++++++++++++++++++++++------------------
 1 file changed, 142 insertions(+), 106 deletions(-)

diff --git a/net/bluetooth/mgmt.c b/net/bluetooth/mgmt.c
index cea01e275f1ea..d7306c1ffbef5 100644
--- a/net/bluetooth/mgmt.c
+++ b/net/bluetooth/mgmt.c
@@ -3806,7 +3806,7 @@ static const u8 rpa_resolution_uuid[16] = {
 static int read_exp_features_info(struct sock *sk, struct hci_dev *hdev,
 				  void *data, u16 data_len)
 {
-	char buf[62];	/* Enough space for 3 features */
+	char buf[62];   /* Enough space for 3 features */
 	struct mgmt_rp_read_exp_features_info *rp = (void *)buf;
 	u16 idx = 0;
 	u32 flags;
@@ -3892,150 +3892,186 @@ static int exp_debug_feature_changed(bool enabled, struct sock *skip)
 }
 #endif
 
-static int set_exp_feature(struct sock *sk, struct hci_dev *hdev,
-			   void *data, u16 data_len)
+#define EXP_FEAT(_uuid, _set_func)	\
+{					\
+	.uuid = _uuid,			\
+	.set_func = _set_func,		\
+}
+
+/* The zero key uuid is special. Multiple exp features are set through it. */
+static int set_zero_key_func(struct sock *sk, struct hci_dev *hdev,
+			     struct mgmt_cp_set_exp_feature *cp, u16 data_len)
 {
-	struct mgmt_cp_set_exp_feature *cp = data;
 	struct mgmt_rp_set_exp_feature rp;
 
-	bt_dev_dbg(hdev, "sock %p", sk);
-
-	if (!memcmp(cp->uuid, ZERO_KEY, 16)) {
-		memset(rp.uuid, 0, 16);
-		rp.flags = cpu_to_le32(0);
+	memset(rp.uuid, 0, 16);
+	rp.flags = cpu_to_le32(0);
 
 #ifdef CONFIG_BT_FEATURE_DEBUG
-		if (!hdev) {
-			bool changed = bt_dbg_get();
+	if (!hdev) {
+		bool changed = bt_dbg_get();
 
-			bt_dbg_set(false);
+		bt_dbg_set(false);
 
-			if (changed)
-				exp_debug_feature_changed(false, sk);
-		}
+		if (changed)
+			exp_debug_feature_changed(false, sk);
+	}
 #endif
 
-		if (hdev && use_ll_privacy(hdev) && !hdev_is_powered(hdev)) {
-			bool changed = hci_dev_test_flag(hdev,
-							 HCI_ENABLE_LL_PRIVACY);
+	if (hdev && use_ll_privacy(hdev) && !hdev_is_powered(hdev)) {
+		bool changed = hci_dev_test_flag(hdev, HCI_ENABLE_LL_PRIVACY);
 
-			hci_dev_clear_flag(hdev, HCI_ENABLE_LL_PRIVACY);
+		hci_dev_clear_flag(hdev, HCI_ENABLE_LL_PRIVACY);
 
-			if (changed)
-				exp_ll_privacy_feature_changed(false, hdev, sk);
-		}
+		if (changed)
+			exp_ll_privacy_feature_changed(false, hdev, sk);
+	}
 
-		hci_sock_set_flag(sk, HCI_MGMT_EXP_FEATURE_EVENTS);
+	hci_sock_set_flag(sk, HCI_MGMT_EXP_FEATURE_EVENTS);
 
-		return mgmt_cmd_complete(sk, hdev ? hdev->id : MGMT_INDEX_NONE,
-					 MGMT_OP_SET_EXP_FEATURE, 0,
-					 &rp, sizeof(rp));
-	}
+	return mgmt_cmd_complete(sk, hdev ? hdev->id : MGMT_INDEX_NONE,
+				 MGMT_OP_SET_EXP_FEATURE, 0,
+				 &rp, sizeof(rp));
+}
 
 #ifdef CONFIG_BT_FEATURE_DEBUG
-	if (!memcmp(cp->uuid, debug_uuid, 16)) {
-		bool val, changed;
-		int err;
+static int set_debug_func(struct sock *sk, struct hci_dev *hdev,
+			  struct mgmt_cp_set_exp_feature *cp, u16 data_len)
+{
+	struct mgmt_rp_set_exp_feature rp;
 
-		/* Command requires to use the non-controller index */
-		if (hdev)
-			return mgmt_cmd_status(sk, hdev->id,
-					       MGMT_OP_SET_EXP_FEATURE,
-					       MGMT_STATUS_INVALID_INDEX);
+	bool val, changed;
+	int err;
 
-		/* Parameters are limited to a single octet */
-		if (data_len != MGMT_SET_EXP_FEATURE_SIZE + 1)
-			return mgmt_cmd_status(sk, MGMT_INDEX_NONE,
-					       MGMT_OP_SET_EXP_FEATURE,
-					       MGMT_STATUS_INVALID_PARAMS);
+	/* Command requires to use the non-controller index */
+	if (hdev)
+		return mgmt_cmd_status(sk, hdev->id,
+				       MGMT_OP_SET_EXP_FEATURE,
+				       MGMT_STATUS_INVALID_INDEX);
 
-		/* Only boolean on/off is supported */
-		if (cp->param[0] != 0x00 && cp->param[0] != 0x01)
-			return mgmt_cmd_status(sk, MGMT_INDEX_NONE,
-					       MGMT_OP_SET_EXP_FEATURE,
-					       MGMT_STATUS_INVALID_PARAMS);
+	/* Parameters are limited to a single octet */
+	if (data_len != MGMT_SET_EXP_FEATURE_SIZE + 1)
+		return mgmt_cmd_status(sk, MGMT_INDEX_NONE,
+				       MGMT_OP_SET_EXP_FEATURE,
+				       MGMT_STATUS_INVALID_PARAMS);
 
-		val = !!cp->param[0];
-		changed = val ? !bt_dbg_get() : bt_dbg_get();
-		bt_dbg_set(val);
+	/* Only boolean on/off is supported */
+	if (cp->param[0] != 0x00 && cp->param[0] != 0x01)
+		return mgmt_cmd_status(sk, MGMT_INDEX_NONE,
+				       MGMT_OP_SET_EXP_FEATURE,
+				       MGMT_STATUS_INVALID_PARAMS);
 
-		memcpy(rp.uuid, debug_uuid, 16);
-		rp.flags = cpu_to_le32(val ? BIT(0) : 0);
+	val = !!cp->param[0];
+	changed = val ? !bt_dbg_get() : bt_dbg_get();
+	bt_dbg_set(val);
 
-		hci_sock_set_flag(sk, HCI_MGMT_EXP_FEATURE_EVENTS);
+	memcpy(rp.uuid, debug_uuid, 16);
+	rp.flags = cpu_to_le32(val ? BIT(0) : 0);
 
-		err = mgmt_cmd_complete(sk, MGMT_INDEX_NONE,
-					MGMT_OP_SET_EXP_FEATURE, 0,
-					&rp, sizeof(rp));
+	hci_sock_set_flag(sk, HCI_MGMT_EXP_FEATURE_EVENTS);
 
-		if (changed)
-			exp_debug_feature_changed(val, sk);
+	err = mgmt_cmd_complete(sk, MGMT_INDEX_NONE,
+				MGMT_OP_SET_EXP_FEATURE, 0,
+				&rp, sizeof(rp));
 
-		return err;
-	}
+	if (changed)
+		exp_debug_feature_changed(val, sk);
+
+	return err;
+}
 #endif
 
-	if (!memcmp(cp->uuid, rpa_resolution_uuid, 16)) {
-		bool val, changed;
-		int err;
-		u32 flags;
+static int set_rpa_resolution_func(struct sock *sk, struct hci_dev *hdev,
+				   struct mgmt_cp_set_exp_feature *cp,
+				   u16 data_len)
+{
+	struct mgmt_rp_set_exp_feature rp;
+	bool val, changed;
+	int err;
+	u32 flags;
+
+	/* Command requires to use the controller index */
+	if (!hdev)
+		return mgmt_cmd_status(sk, MGMT_INDEX_NONE,
+				       MGMT_OP_SET_EXP_FEATURE,
+				       MGMT_STATUS_INVALID_INDEX);
 
-		/* Command requires to use the controller index */
-		if (!hdev)
-			return mgmt_cmd_status(sk, MGMT_INDEX_NONE,
-					       MGMT_OP_SET_EXP_FEATURE,
-					       MGMT_STATUS_INVALID_INDEX);
+	/* Changes can only be made when controller is powered down */
+	if (hdev_is_powered(hdev))
+		return mgmt_cmd_status(sk, hdev->id,
+				       MGMT_OP_SET_EXP_FEATURE,
+				       MGMT_STATUS_REJECTED);
 
-		/* Changes can only be made when controller is powered down */
-		if (hdev_is_powered(hdev))
-			return mgmt_cmd_status(sk, hdev->id,
-					       MGMT_OP_SET_EXP_FEATURE,
-					       MGMT_STATUS_REJECTED);
+	/* Parameters are limited to a single octet */
+	if (data_len != MGMT_SET_EXP_FEATURE_SIZE + 1)
+		return mgmt_cmd_status(sk, hdev->id,
+				       MGMT_OP_SET_EXP_FEATURE,
+				       MGMT_STATUS_INVALID_PARAMS);
 
-		/* Parameters are limited to a single octet */
-		if (data_len != MGMT_SET_EXP_FEATURE_SIZE + 1)
-			return mgmt_cmd_status(sk, hdev->id,
-					       MGMT_OP_SET_EXP_FEATURE,
-					       MGMT_STATUS_INVALID_PARAMS);
+	/* Only boolean on/off is supported */
+	if (cp->param[0] != 0x00 && cp->param[0] != 0x01)
+		return mgmt_cmd_status(sk, hdev->id,
+				       MGMT_OP_SET_EXP_FEATURE,
+				       MGMT_STATUS_INVALID_PARAMS);
 
-		/* Only boolean on/off is supported */
-		if (cp->param[0] != 0x00 && cp->param[0] != 0x01)
-			return mgmt_cmd_status(sk, hdev->id,
-					       MGMT_OP_SET_EXP_FEATURE,
-					       MGMT_STATUS_INVALID_PARAMS);
+	val = !!cp->param[0];
 
-		val = !!cp->param[0];
+	if (val) {
+		changed = !hci_dev_test_flag(hdev, HCI_ENABLE_LL_PRIVACY);
+		hci_dev_set_flag(hdev, HCI_ENABLE_LL_PRIVACY);
+		hci_dev_clear_flag(hdev, HCI_ADVERTISING);
 
-		if (val) {
-			changed = !hci_dev_test_flag(hdev,
-						     HCI_ENABLE_LL_PRIVACY);
-			hci_dev_set_flag(hdev, HCI_ENABLE_LL_PRIVACY);
-			hci_dev_clear_flag(hdev, HCI_ADVERTISING);
+		/* Enable LL privacy + supported settings changed */
+		flags = BIT(0) | BIT(1);
+	} else {
+		changed = hci_dev_test_flag(hdev, HCI_ENABLE_LL_PRIVACY);
+		hci_dev_clear_flag(hdev, HCI_ENABLE_LL_PRIVACY);
 
-			/* Enable LL privacy + supported settings changed */
-			flags = BIT(0) | BIT(1);
-		} else {
-			changed = hci_dev_test_flag(hdev,
-						    HCI_ENABLE_LL_PRIVACY);
-			hci_dev_clear_flag(hdev, HCI_ENABLE_LL_PRIVACY);
+		/* Disable LL privacy + supported settings changed */
+		flags = BIT(1);
+	}
 
-			/* Disable LL privacy + supported settings changed */
-			flags = BIT(1);
-		}
+	memcpy(rp.uuid, rpa_resolution_uuid, 16);
+	rp.flags = cpu_to_le32(flags);
 
-		memcpy(rp.uuid, rpa_resolution_uuid, 16);
-		rp.flags = cpu_to_le32(flags);
+	hci_sock_set_flag(sk, HCI_MGMT_EXP_FEATURE_EVENTS);
 
-		hci_sock_set_flag(sk, HCI_MGMT_EXP_FEATURE_EVENTS);
+	err = mgmt_cmd_complete(sk, hdev->id,
+				MGMT_OP_SET_EXP_FEATURE, 0,
+				&rp, sizeof(rp));
 
-		err = mgmt_cmd_complete(sk, hdev->id,
-					MGMT_OP_SET_EXP_FEATURE, 0,
-					&rp, sizeof(rp));
+	if (changed)
+		exp_ll_privacy_feature_changed(val, hdev, sk);
 
-		if (changed)
-			exp_ll_privacy_feature_changed(val, hdev, sk);
+	return err;
+}
 
-		return err;
+static const struct mgmt_exp_feature {
+	const u8 *uuid;
+	int (*set_func)(struct sock *sk, struct hci_dev *hdev,
+			struct mgmt_cp_set_exp_feature *cp, u16 data_len);
+} exp_features[] = {
+	EXP_FEAT(ZERO_KEY, set_zero_key_func),
+#ifdef CONFIG_BT_FEATURE_DEBUG
+	EXP_FEAT(debug_uuid, set_debug_func),
+#endif
+	EXP_FEAT(rpa_resolution_uuid, set_rpa_resolution_func),
+
+	/* end with a null feature */
+	EXP_FEAT(NULL, NULL)
+};
+
+static int set_exp_feature(struct sock *sk, struct hci_dev *hdev,
+			   void *data, u16 data_len)
+{
+	struct mgmt_cp_set_exp_feature *cp = data;
+	size_t i = 0;
+
+	bt_dev_dbg(hdev, "sock %p", sk);
+
+	for (i = 0; exp_features[i].uuid; i++) {
+		if (!memcmp(cp->uuid, exp_features[i].uuid, 16))
+			return exp_features[i].set_func(sk, hdev, cp, data_len);
 	}
 
 	return mgmt_cmd_status(sk, hdev ? hdev->id : MGMT_INDEX_NONE,
-- 
2.34.1



