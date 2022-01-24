Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8C57949A9DE
	for <lists+stable@lfdr.de>; Tue, 25 Jan 2022 05:29:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1323758AbiAYD3i (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 22:29:38 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:55816 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347659AbiAXVFl (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 16:05:41 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 51D4461330;
        Mon, 24 Jan 2022 21:05:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5E7F0C36AF5;
        Mon, 24 Jan 2022 21:05:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643058339;
        bh=Pdf2vX0fM8uHjw0cU5dwaYEfrFReNSKQeS1x5sAOKP0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=U+HtmkLAy0lua9CdWWiQ2V3bwuh1iAy+Mgsv9c/r+7XLh1i0oIXgXuvP0qNtT+J5X
         O61VrKojAROmOiSIiMqRKDBz8SQM+9Q4GaELe/PEZqfYAMFQ11+PBpB/hB9WW7S8IB
         1OxKrHpEIBycL7z+o91MdOcKU4BBFMoFqFpXQj4I=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
        Marcel Holtmann <marcel@holtmann.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.16 0256/1039] Bluetooth: MGMT: Use hci_dev_test_and_{set,clear}_flag
Date:   Mon, 24 Jan 2022 19:34:05 +0100
Message-Id: <20220124184133.921819876@linuxfoundation.org>
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

From: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>

[ Upstream commit 6f59f991b4e735323f099ac6490e725ae8c750a5 ]

This make use of hci_dev_test_and_{set,clear}_flag instead of doing 2
operations in a row.

Fixes: cbbdfa6f33198 ("Bluetooth: Enable controller RPA resolution using Experimental feature")
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Marcel Holtmann <marcel@holtmann.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/bluetooth/mgmt.c | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/net/bluetooth/mgmt.c b/net/bluetooth/mgmt.c
index 44683443300ce..c068d05e9616f 100644
--- a/net/bluetooth/mgmt.c
+++ b/net/bluetooth/mgmt.c
@@ -3969,10 +3969,10 @@ static int set_zero_key_func(struct sock *sk, struct hci_dev *hdev,
 #endif
 
 	if (hdev && use_ll_privacy(hdev) && !hdev_is_powered(hdev)) {
-		bool changed = hci_dev_test_flag(hdev, HCI_ENABLE_LL_PRIVACY);
-
-		hci_dev_clear_flag(hdev, HCI_ENABLE_LL_PRIVACY);
+		bool changed;
 
+		changed = hci_dev_test_and_clear_flag(hdev,
+						      HCI_ENABLE_LL_PRIVACY);
 		if (changed)
 			exp_ll_privacy_feature_changed(false, hdev, sk);
 	}
@@ -4067,15 +4067,15 @@ static int set_rpa_resolution_func(struct sock *sk, struct hci_dev *hdev,
 	val = !!cp->param[0];
 
 	if (val) {
-		changed = !hci_dev_test_flag(hdev, HCI_ENABLE_LL_PRIVACY);
-		hci_dev_set_flag(hdev, HCI_ENABLE_LL_PRIVACY);
+		changed = !hci_dev_test_and_set_flag(hdev,
+						     HCI_ENABLE_LL_PRIVACY);
 		hci_dev_clear_flag(hdev, HCI_ADVERTISING);
 
 		/* Enable LL privacy + supported settings changed */
 		flags = BIT(0) | BIT(1);
 	} else {
-		changed = hci_dev_test_flag(hdev, HCI_ENABLE_LL_PRIVACY);
-		hci_dev_clear_flag(hdev, HCI_ENABLE_LL_PRIVACY);
+		changed = hci_dev_test_and_clear_flag(hdev,
+						      HCI_ENABLE_LL_PRIVACY);
 
 		/* Disable LL privacy + supported settings changed */
 		flags = BIT(1);
-- 
2.34.1



