Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8870C2E424B
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 16:20:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2440179AbgL1PUf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 10:20:35 -0500
Received: from mail.kernel.org ([198.145.29.99]:36026 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2436891AbgL1OCe (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 09:02:34 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2E004207B2;
        Mon, 28 Dec 2020 14:02:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609164138;
        bh=D5vp5OR8sOIWk8YMV/+FYP1tuVdQY8hf7x0hSvQDiDE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JiQ3JUDewkAoTdoKtQ6l5z9tEcE+pKjnLY4cJpJfaXd7igrWM0lJ3+wTn5JxFqp7x
         mq+uvA6K+qgRmH3ZLAbMfXqB3wlvQATG3qdfxzSpsbh7MfIFx7ioNaW2c6ThEJsbeu
         K57m13tICCXkXSvY6GLKurrJEPP5+mVPImRfzr+Q=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Sathish Narasimman <sathish.narasimman@intel.com>,
        Marcel Holtmann <marcel@holtmann.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 073/717] Bluetooth: Fix: LL PRivacy BLE device fails to connect
Date:   Mon, 28 Dec 2020 13:41:11 +0100
Message-Id: <20201228125024.491274333@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201228125020.963311703@linuxfoundation.org>
References: <20201228125020.963311703@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sathish Narasimman <nsathish41@gmail.com>

[ Upstream commit 1fb17dfc258ff6208f7873cc7b8e40e27515d2d5 ]

When adding device to white list the device is added to resolving list
also. It has to be added only when HCI_ENABLE_LL_PRIVACY flag is set.
HCI_ENABLE_LL_PRIVACY flag has to be tested before adding/deleting devices
to resolving list. use_ll_privacy macro is used only to check if controller
supports LL_Privacy.

https://bugzilla.kernel.org/show_bug.cgi?id=209745

Fixes: 0eee35bdfa3b ("Bluetooth: Update resolving list when updating whitelist")
Signed-off-by: Sathish Narasimman <sathish.narasimman@intel.com>
Signed-off-by: Marcel Holtmann <marcel@holtmann.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/bluetooth/hci_request.c | 12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

diff --git a/net/bluetooth/hci_request.c b/net/bluetooth/hci_request.c
index 6f12bab4d2fa6..610ed0817bd77 100644
--- a/net/bluetooth/hci_request.c
+++ b/net/bluetooth/hci_request.c
@@ -698,7 +698,8 @@ static void del_from_white_list(struct hci_request *req, bdaddr_t *bdaddr,
 		   cp.bdaddr_type);
 	hci_req_add(req, HCI_OP_LE_DEL_FROM_WHITE_LIST, sizeof(cp), &cp);
 
-	if (use_ll_privacy(req->hdev)) {
+	if (use_ll_privacy(req->hdev) &&
+	    hci_dev_test_flag(req->hdev, HCI_ENABLE_LL_PRIVACY)) {
 		struct smp_irk *irk;
 
 		irk = hci_find_irk_by_addr(req->hdev, bdaddr, bdaddr_type);
@@ -732,7 +733,8 @@ static int add_to_white_list(struct hci_request *req,
 		return -1;
 
 	/* White list can not be used with RPAs */
-	if (!allow_rpa && !use_ll_privacy(hdev) &&
+	if (!allow_rpa &&
+	    !hci_dev_test_flag(hdev, HCI_ENABLE_LL_PRIVACY) &&
 	    hci_find_irk_by_addr(hdev, &params->addr, params->addr_type)) {
 		return -1;
 	}
@@ -750,7 +752,8 @@ static int add_to_white_list(struct hci_request *req,
 		   cp.bdaddr_type);
 	hci_req_add(req, HCI_OP_LE_ADD_TO_WHITE_LIST, sizeof(cp), &cp);
 
-	if (use_ll_privacy(hdev)) {
+	if (use_ll_privacy(hdev) &&
+	    hci_dev_test_flag(hdev, HCI_ENABLE_LL_PRIVACY)) {
 		struct smp_irk *irk;
 
 		irk = hci_find_irk_by_addr(hdev, &params->addr,
@@ -812,7 +815,8 @@ static u8 update_white_list(struct hci_request *req)
 		}
 
 		/* White list can not be used with RPAs */
-		if (!allow_rpa && !use_ll_privacy(hdev) &&
+		if (!allow_rpa &&
+		    !hci_dev_test_flag(hdev, HCI_ENABLE_LL_PRIVACY) &&
 		    hci_find_irk_by_addr(hdev, &b->bdaddr, b->bdaddr_type)) {
 			return 0x00;
 		}
-- 
2.27.0



