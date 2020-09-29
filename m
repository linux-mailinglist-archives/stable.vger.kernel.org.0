Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CE76D27C811
	for <lists+stable@lfdr.de>; Tue, 29 Sep 2020 13:58:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731369AbgI2L6i (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 29 Sep 2020 07:58:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:38788 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729353AbgI2Llu (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 29 Sep 2020 07:41:50 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6D941206E5;
        Tue, 29 Sep 2020 11:41:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601379709;
        bh=RK3AbwBa2NgsAA07P5kgrjrF7BKAX7Rf4zov5MVkw7w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ErdshAdHxmOvn2CkclmdThva2INsJwwvFQzdCLm/o+R55NU6kMQ4GHNs+suGDAKX/
         xhFjq0yWKlBShRlmTKL85frw3Aab5/YD2FWF1wfA8Eb3wmO+nN0nxiOGyQZTzERtIe
         2XGcuMz2u5v20tJKOLm2Oe4ph/xuw6K/kH0775gY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Sonny Sasaka <sonnysasaka@chromium.org>,
        Marcel Holtmann <marcel@holtmann.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 254/388] Bluetooth: Handle Inquiry Cancel error after Inquiry Complete
Date:   Tue, 29 Sep 2020 12:59:45 +0200
Message-Id: <20200929110022.768881965@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200929110010.467764689@linuxfoundation.org>
References: <20200929110010.467764689@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sonny Sasaka <sonnysasaka@chromium.org>

[ Upstream commit adf1d6926444029396861413aba8a0f2a805742a ]

After sending Inquiry Cancel command to the controller, it is possible
that Inquiry Complete event comes before Inquiry Cancel command complete
event. In this case the Inquiry Cancel command will have status of
Command Disallowed since there is no Inquiry session to be cancelled.
This case should not be treated as error, otherwise we can reach an
inconsistent state.

Example of a btmon trace when this happened:

< HCI Command: Inquiry Cancel (0x01|0x0002) plen 0
> HCI Event: Inquiry Complete (0x01) plen 1
        Status: Success (0x00)
> HCI Event: Command Complete (0x0e) plen 4
      Inquiry Cancel (0x01|0x0002) ncmd 1
        Status: Command Disallowed (0x0c)

Signed-off-by: Sonny Sasaka <sonnysasaka@chromium.org>
Signed-off-by: Marcel Holtmann <marcel@holtmann.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/bluetooth/hci_event.c | 19 +++++++++++++++++--
 1 file changed, 17 insertions(+), 2 deletions(-)

diff --git a/net/bluetooth/hci_event.c b/net/bluetooth/hci_event.c
index 1bbeb14b8b64e..fd436e5d7b542 100644
--- a/net/bluetooth/hci_event.c
+++ b/net/bluetooth/hci_event.c
@@ -41,12 +41,27 @@
 
 /* Handle HCI Event packets */
 
-static void hci_cc_inquiry_cancel(struct hci_dev *hdev, struct sk_buff *skb)
+static void hci_cc_inquiry_cancel(struct hci_dev *hdev, struct sk_buff *skb,
+				  u8 *new_status)
 {
 	__u8 status = *((__u8 *) skb->data);
 
 	BT_DBG("%s status 0x%2.2x", hdev->name, status);
 
+	/* It is possible that we receive Inquiry Complete event right
+	 * before we receive Inquiry Cancel Command Complete event, in
+	 * which case the latter event should have status of Command
+	 * Disallowed (0x0c). This should not be treated as error, since
+	 * we actually achieve what Inquiry Cancel wants to achieve,
+	 * which is to end the last Inquiry session.
+	 */
+	if (status == 0x0c && !test_bit(HCI_INQUIRY, &hdev->flags)) {
+		bt_dev_warn(hdev, "Ignoring error of Inquiry Cancel command");
+		status = 0x00;
+	}
+
+	*new_status = status;
+
 	if (status)
 		return;
 
@@ -3142,7 +3157,7 @@ static void hci_cmd_complete_evt(struct hci_dev *hdev, struct sk_buff *skb,
 
 	switch (*opcode) {
 	case HCI_OP_INQUIRY_CANCEL:
-		hci_cc_inquiry_cancel(hdev, skb);
+		hci_cc_inquiry_cancel(hdev, skb, status);
 		break;
 
 	case HCI_OP_PERIODIC_INQ:
-- 
2.25.1



