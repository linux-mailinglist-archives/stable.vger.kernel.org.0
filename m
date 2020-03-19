Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7083418B4F5
	for <lists+stable@lfdr.de>; Thu, 19 Mar 2020 14:14:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729277AbgCSNOS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 19 Mar 2020 09:14:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:33672 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729273AbgCSNOR (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 19 Mar 2020 09:14:17 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AAF7B206D7;
        Thu, 19 Mar 2020 13:14:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1584623657;
        bh=6NYbwMXoJ+wlGSNvLLs16uAuTFfZ4lyBAET+75s50H8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=N2nz1PmWcT/uN1K57u3PGDdnVLWD+xgI3VTBVh2yJIQT3NhOyD/1rPLfcSp/kmVOP
         PJbpTb2HSz8y+MDNboKXK2GgfB665uLalmNuVd7CzmfM/CufHO6vwzWNNFvRe/d15S
         HhZfIb0j6AvrI2uIPz34gA/9PF8sCW8XPm247Lo0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dan Carpenter <dan.carpenter@oracle.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 4.14 10/99] net: nfc: fix bounds checking bugs on "pipe"
Date:   Thu, 19 Mar 2020 14:02:48 +0100
Message-Id: <20200319123944.592207737@linuxfoundation.org>
X-Mailer: git-send-email 2.25.2
In-Reply-To: <20200319123941.630731708@linuxfoundation.org>
References: <20200319123941.630731708@linuxfoundation.org>
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
@@ -193,13 +193,20 @@ exit:
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
@@ -387,8 +394,14 @@ void nfc_hci_event_received(struct nfc_h
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


