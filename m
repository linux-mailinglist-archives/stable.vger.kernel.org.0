Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B1D6149934A
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 21:34:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356857AbiAXUco (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 15:32:44 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:59196 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344555AbiAXUWx (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 15:22:53 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 2E8CCB80FA1;
        Mon, 24 Jan 2022 20:22:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4AA11C340E5;
        Mon, 24 Jan 2022 20:22:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643055770;
        bh=9ChZlTwI84NfQP4O3pQKbJA5EkmXR+lHMMoaN8VW+L4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Bqdwh/9NHX6InlWieepLWYnI5IyxBkKWlgFmFcewi/FwuenC1uMawCnzoqH75u692
         UT2Kg0D1qDb1l7HGBgDu0pvVDopPLLJjpimaqC1A2mUCJmcZ26b3WbZiaMcDR/rZjB
         fYhi6HDoGUJcgVzv0Am/3pY5ShUyFqQJOU52yJWE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
        Marcel Holtmann <marcel@holtmann.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 217/846] Bluetooth: MGMT: Use hci_dev_test_and_{set,clear}_flag
Date:   Mon, 24 Jan 2022 19:35:34 +0100
Message-Id: <20220124184108.416306932@linuxfoundation.org>
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
index d7306c1ffbef5..f09f0a78eb7be 100644
--- a/net/bluetooth/mgmt.c
+++ b/net/bluetooth/mgmt.c
@@ -3919,10 +3919,10 @@ static int set_zero_key_func(struct sock *sk, struct hci_dev *hdev,
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
@@ -4017,15 +4017,15 @@ static int set_rpa_resolution_func(struct sock *sk, struct hci_dev *hdev,
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



