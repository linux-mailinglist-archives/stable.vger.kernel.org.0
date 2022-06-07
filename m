Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 92DCB541B2A
	for <lists+stable@lfdr.de>; Tue,  7 Jun 2022 23:43:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1381023AbiFGVmm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 17:42:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52074 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1381301AbiFGVk0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 17:40:26 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ACCAE232377;
        Tue,  7 Jun 2022 12:06:33 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 63091B82182;
        Tue,  7 Jun 2022 19:06:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CDC28C385A5;
        Tue,  7 Jun 2022 19:06:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654628791;
        bh=ygdYPuMUgBOhxnz9oYloPim/aXSmTjxLzeGUoSJ8knM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Pv3uXzSOLIsFDf+Lmqe0ykuyG0ZI/wyGKpu1IdZA23ZrbplFJnqN1bePjf7T7cUrL
         /rjZrrO6P8UAbzc2TaRhldMCY5iC8aV2hxFkpERdSlrA6MT4U+kZxDw2/qvBd9kQp4
         vFNfYVsJT/SwuZCP5pNpshAyLGKkwGJsDDQFn1Ng=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Niels Dossche <dossche.niels@gmail.com>,
        Marcel Holtmann <marcel@holtmann.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.18 455/879] Bluetooth: protect le accept and resolv lists with hdev->lock
Date:   Tue,  7 Jun 2022 18:59:33 +0200
Message-Id: <20220607165016.077001742@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220607165002.659942637@linuxfoundation.org>
References: <20220607165002.659942637@linuxfoundation.org>
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

From: Niels Dossche <dossche.niels@gmail.com>

[ Upstream commit 5e2b6064cbc5fd582396768c5f9583f65085e368 ]

Concurrent operations from events on le_{accept,resolv}_list are
currently unprotected by hdev->lock.
Most existing code do already protect the lists with that lock.
This can be observed in hci_debugfs and hci_sync.
Add the protection for these events too.

Fixes: b950aa88638c ("Bluetooth: Add definitions and track LE resolve list modification")
Fixes: 0f36b589e4ee ("Bluetooth: Track LE white list modification via HCI commands")
Signed-off-by: Niels Dossche <dossche.niels@gmail.com>
Signed-off-by: Marcel Holtmann <marcel@holtmann.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/bluetooth/hci_event.c | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/net/bluetooth/hci_event.c b/net/bluetooth/hci_event.c
index a835ce6f8430..0270e597c285 100644
--- a/net/bluetooth/hci_event.c
+++ b/net/bluetooth/hci_event.c
@@ -1835,7 +1835,9 @@ static u8 hci_cc_le_clear_accept_list(struct hci_dev *hdev, void *data,
 	if (rp->status)
 		return rp->status;
 
+	hci_dev_lock(hdev);
 	hci_bdaddr_list_clear(&hdev->le_accept_list);
+	hci_dev_unlock(hdev);
 
 	return rp->status;
 }
@@ -1855,8 +1857,10 @@ static u8 hci_cc_le_add_to_accept_list(struct hci_dev *hdev, void *data,
 	if (!sent)
 		return rp->status;
 
+	hci_dev_lock(hdev);
 	hci_bdaddr_list_add(&hdev->le_accept_list, &sent->bdaddr,
 			    sent->bdaddr_type);
+	hci_dev_unlock(hdev);
 
 	return rp->status;
 }
@@ -1876,8 +1880,10 @@ static u8 hci_cc_le_del_from_accept_list(struct hci_dev *hdev, void *data,
 	if (!sent)
 		return rp->status;
 
+	hci_dev_lock(hdev);
 	hci_bdaddr_list_del(&hdev->le_accept_list, &sent->bdaddr,
 			    sent->bdaddr_type);
+	hci_dev_unlock(hdev);
 
 	return rp->status;
 }
@@ -1949,9 +1955,11 @@ static u8 hci_cc_le_add_to_resolv_list(struct hci_dev *hdev, void *data,
 	if (!sent)
 		return rp->status;
 
+	hci_dev_lock(hdev);
 	hci_bdaddr_list_add_with_irk(&hdev->le_resolv_list, &sent->bdaddr,
 				sent->bdaddr_type, sent->peer_irk,
 				sent->local_irk);
+	hci_dev_unlock(hdev);
 
 	return rp->status;
 }
@@ -1971,8 +1979,10 @@ static u8 hci_cc_le_del_from_resolv_list(struct hci_dev *hdev, void *data,
 	if (!sent)
 		return rp->status;
 
+	hci_dev_lock(hdev);
 	hci_bdaddr_list_del_with_irk(&hdev->le_resolv_list, &sent->bdaddr,
 			    sent->bdaddr_type);
+	hci_dev_unlock(hdev);
 
 	return rp->status;
 }
@@ -1987,7 +1997,9 @@ static u8 hci_cc_le_clear_resolv_list(struct hci_dev *hdev, void *data,
 	if (rp->status)
 		return rp->status;
 
+	hci_dev_lock(hdev);
 	hci_bdaddr_list_clear(&hdev->le_resolv_list);
+	hci_dev_unlock(hdev);
 
 	return rp->status;
 }
-- 
2.35.1



