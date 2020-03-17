Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2F8C5188022
	for <lists+stable@lfdr.de>; Tue, 17 Mar 2020 12:07:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728572AbgCQLH2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 17 Mar 2020 07:07:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:49134 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727711AbgCQLH1 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 17 Mar 2020 07:07:27 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1FEF02073C;
        Tue, 17 Mar 2020 11:07:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1584443247;
        bh=DLZr9X0dUzjdBDR77VJICOcHsghNExY8GdcrmKIiK/U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ifg3cFWzFdv5lWW9SdMPPDUIjeRBIb11LWSDT3Y7JnUOwmu1Z1O4WE7GRNYTVNxXa
         VaUAEOULImq3y+/JLOzPw79s8gtASpd/+IeoYZtqZf0jhh+2Aj7h8mUbuY0CFtLih+
         ZAD7bV19HrUgny2MbfUYJifUQIb7yChsxg8Qq6C4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dan Carpenter <dan.carpenter@oracle.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.5 023/151] net: nfc: fix bounds checking bugs on "pipe"
Date:   Tue, 17 Mar 2020 11:53:53 +0100
Message-Id: <20200317103328.424462990@linuxfoundation.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200317103326.593639086@linuxfoundation.org>
References: <20200317103326.593639086@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dan Carpenter <dan.carpenter@oracle.com>

[ Upstream commit a3aefbfe45751bf7b338c181b97608e276b5bb73 ]

This is similar to commit 674d9de02aa7 ("NFC: Fix possible memory
corruption when handling SHDLC I-Frame commands") and commit d7ee81ad09f0
("NFC: nci: Add some bounds checking in nci_hci_cmd_received()") which
added range checks on "pipe".

The "pipe" variable comes skb->data[0] in nfc_hci_msg_rx_work().
It's in the 0-255 range.  We're using it as the array index into the
hdev->pipes[] array which has NFC_HCI_MAX_PIPES (128) members.

Fixes: 118278f20aa8 ("NFC: hci: Add pipes table to reference them with a tuple {gate, host}")
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/nfc/hci/core.c |   19 ++++++++++++++++---
 1 file changed, 16 insertions(+), 3 deletions(-)

--- a/net/nfc/hci/core.c
+++ b/net/nfc/hci/core.c
@@ -181,13 +181,20 @@ exit:
 void nfc_hci_cmd_received(struct nfc_hci_dev *hdev, u8 pipe, u8 cmd,
 			  struct sk_buff *skb)
 {
-	u8 gate = hdev->pipes[pipe].gate;
 	u8 status = NFC_HCI_ANY_OK;
 	struct hci_create_pipe_resp *create_info;
 	struct hci_delete_pipe_noti *delete_info;
 	struct hci_all_pipe_cleared_noti *cleared_info;
+	u8 gate;
 
-	pr_debug("from gate %x pipe %x cmd %x\n", gate, pipe, cmd);
+	pr_debug("from pipe %x cmd %x\n", pipe, cmd);
+
+	if (pipe >= NFC_HCI_MAX_PIPES) {
+		status = NFC_HCI_ANY_E_NOK;
+		goto exit;
+	}
+
+	gate = hdev->pipes[pipe].gate;
 
 	switch (cmd) {
 	case NFC_HCI_ADM_NOTIFY_PIPE_CREATED:
@@ -375,8 +382,14 @@ void nfc_hci_event_received(struct nfc_h
 			    struct sk_buff *skb)
 {
 	int r = 0;
-	u8 gate = hdev->pipes[pipe].gate;
+	u8 gate;
+
+	if (pipe >= NFC_HCI_MAX_PIPES) {
+		pr_err("Discarded event %x to invalid pipe %x\n", event, pipe);
+		goto exit;
+	}
 
+	gate = hdev->pipes[pipe].gate;
 	if (gate == NFC_HCI_INVALID_GATE) {
 		pr_err("Discarded event %x to unopened pipe %x\n", event, pipe);
 		goto exit;


