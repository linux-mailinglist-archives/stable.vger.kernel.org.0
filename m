Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D4A3F27CDE6
	for <lists+stable@lfdr.de>; Tue, 29 Sep 2020 14:47:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387542AbgI2Mrk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 29 Sep 2020 08:47:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:40112 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728530AbgI2LEG (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 29 Sep 2020 07:04:06 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C2F2E21941;
        Tue, 29 Sep 2020 11:04:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601377446;
        bh=Hco7q7e69Yo5LGxGMrHGpP4cBxSJ2N88PDO+7MEVdSY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=R8+gNfXXg58GMEx97lBFz4km8DavNayDBM/nFLhAserxVYLjO8aBPGzD/o7eYwRXQ
         Ejpo3lljKzCpXVa0QhJ3H3HqBc+6xG8fQWC7ZEYOt/XOtPBp7OPoXUBJ/vyFNm74ma
         DWrMId8I/5RybxiMdAAidHFSoCGUa1NimTvLlLF4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Alain Michaud <alainm@chromium.org>,
        Marcel Holtmann <marcel@holtmann.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.4 39/85] Bluetooth: guard against controllers sending zerod events
Date:   Tue, 29 Sep 2020 13:00:06 +0200
Message-Id: <20200929105930.180096664@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200929105928.198942536@linuxfoundation.org>
References: <20200929105928.198942536@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Alain Michaud <alainm@chromium.org>

[ Upstream commit 08bb4da90150e2a225f35e0f642cdc463958d696 ]

Some controllers have been observed to send zero'd events under some
conditions.  This change guards against this condition as well as adding
a trace to facilitate diagnosability of this condition.

Signed-off-by: Alain Michaud <alainm@chromium.org>
Signed-off-by: Marcel Holtmann <marcel@holtmann.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/bluetooth/hci_event.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/net/bluetooth/hci_event.c b/net/bluetooth/hci_event.c
index 16cf5633eae3e..04c77747a768d 100644
--- a/net/bluetooth/hci_event.c
+++ b/net/bluetooth/hci_event.c
@@ -5230,6 +5230,11 @@ void hci_event_packet(struct hci_dev *hdev, struct sk_buff *skb)
 	u8 status = 0, event = hdr->evt, req_evt = 0;
 	u16 opcode = HCI_OP_NOP;
 
+	if (!event) {
+		bt_dev_warn(hdev, "Received unexpected HCI Event 00000000");
+		goto done;
+	}
+
 	if (hdev->sent_cmd && bt_cb(hdev->sent_cmd)->hci.req_event == event) {
 		struct hci_command_hdr *cmd_hdr = (void *) hdev->sent_cmd->data;
 		opcode = __le16_to_cpu(cmd_hdr->opcode);
@@ -5441,6 +5446,7 @@ void hci_event_packet(struct hci_dev *hdev, struct sk_buff *skb)
 		req_complete_skb(hdev, status, opcode, orig_skb);
 	}
 
+done:
 	kfree_skb(orig_skb);
 	kfree_skb(skb);
 	hdev->stat.evt_rx++;
-- 
2.25.1



