Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CC830499F8B
	for <lists+stable@lfdr.de>; Tue, 25 Jan 2022 00:19:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1841502AbiAXW7P (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 17:59:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39502 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1588125AbiAXWbl (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 17:31:41 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6F966C047CDA;
        Mon, 24 Jan 2022 12:57:06 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0E74760907;
        Mon, 24 Jan 2022 20:57:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C4738C340E5;
        Mon, 24 Jan 2022 20:57:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643057825;
        bh=V/5o8Qpy4uFlBy2z+Ab0c2iMVN4l55rv5Fr6U+80WS4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=q3y83igKQKn+0Zsep+5tq1NSWKazlwb57I61OgY3qJBYM489LCzk1I0AyVV2yCvlG
         NYcQiA7FYcuO9VoYEDexuc6GfVbulQWyw4MSovkZqxrxoAvBctlgK8FaMdX1Heoiux
         A/0GblW/s80umU3XK8MdyOOzqtSyx+cVLlGsdVdI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Tedd Ho-Jeong An <tedd.an@intel.com>,
        Marcel Holtmann <marcel@holtmann.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.16 0084/1039] Bluetooth: mgmt: Fix Experimental Feature Changed event
Date:   Mon, 24 Jan 2022 19:31:13 +0100
Message-Id: <20220124184127.976219279@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124184125.121143506@linuxfoundation.org>
References: <20220124184125.121143506@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Tedd Ho-Jeong An <tedd.an@intel.com>

[ Upstream commit b15bfa4df63529150df9ff0585675f728436e0c1 ]

This patch fixes the controller index in the Experimental Features
Changed event for the offload_codec and the quality_report features to
use the actual hdev index instead of non-controller index(0xffff) so the
client can receive the event and know which controller the event is for.

Fixes: ad93315183285 ("Bluetooth: Add offload feature under experimental flag")
Fixes: ae7d925b5c043 ("Bluetooth: Support the quality report events")
Signed-off-by: Tedd Ho-Jeong An <tedd.an@intel.com>
Signed-off-by: Marcel Holtmann <marcel@holtmann.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/bluetooth/mgmt.c | 15 +++++++++------
 1 file changed, 9 insertions(+), 6 deletions(-)

diff --git a/net/bluetooth/mgmt.c b/net/bluetooth/mgmt.c
index 3e5283607b97c..44683443300ce 100644
--- a/net/bluetooth/mgmt.c
+++ b/net/bluetooth/mgmt.c
@@ -3927,7 +3927,9 @@ static int exp_debug_feature_changed(bool enabled, struct sock *skip)
 }
 #endif
 
-static int exp_quality_report_feature_changed(bool enabled, struct sock *skip)
+static int exp_quality_report_feature_changed(bool enabled,
+					      struct hci_dev *hdev,
+					      struct sock *skip)
 {
 	struct mgmt_ev_exp_feature_changed ev;
 
@@ -3935,7 +3937,7 @@ static int exp_quality_report_feature_changed(bool enabled, struct sock *skip)
 	memcpy(ev.uuid, quality_report_uuid, 16);
 	ev.flags = cpu_to_le32(enabled ? BIT(0) : 0);
 
-	return mgmt_limited_event(MGMT_EV_EXP_FEATURE_CHANGED, NULL,
+	return mgmt_limited_event(MGMT_EV_EXP_FEATURE_CHANGED, hdev,
 				  &ev, sizeof(ev),
 				  HCI_MGMT_EXP_FEATURE_EVENTS, skip);
 }
@@ -4156,14 +4158,15 @@ static int set_quality_report_func(struct sock *sk, struct hci_dev *hdev,
 				&rp, sizeof(rp));
 
 	if (changed)
-		exp_quality_report_feature_changed(val, sk);
+		exp_quality_report_feature_changed(val, hdev, sk);
 
 unlock_quality_report:
 	hci_req_sync_unlock(hdev);
 	return err;
 }
 
-static int exp_offload_codec_feature_changed(bool enabled, struct sock *skip)
+static int exp_offload_codec_feature_changed(bool enabled, struct hci_dev *hdev,
+					     struct sock *skip)
 {
 	struct mgmt_ev_exp_feature_changed ev;
 
@@ -4171,7 +4174,7 @@ static int exp_offload_codec_feature_changed(bool enabled, struct sock *skip)
 	memcpy(ev.uuid, offload_codecs_uuid, 16);
 	ev.flags = cpu_to_le32(enabled ? BIT(0) : 0);
 
-	return mgmt_limited_event(MGMT_EV_EXP_FEATURE_CHANGED, NULL,
+	return mgmt_limited_event(MGMT_EV_EXP_FEATURE_CHANGED, hdev,
 				  &ev, sizeof(ev),
 				  HCI_MGMT_EXP_FEATURE_EVENTS, skip);
 }
@@ -4229,7 +4232,7 @@ static int set_offload_codec_func(struct sock *sk, struct hci_dev *hdev,
 				&rp, sizeof(rp));
 
 	if (changed)
-		exp_offload_codec_feature_changed(val, sk);
+		exp_offload_codec_feature_changed(val, hdev, sk);
 
 	return err;
 }
-- 
2.34.1



