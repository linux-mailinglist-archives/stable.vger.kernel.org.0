Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D94BB7F230
	for <lists+stable@lfdr.de>; Fri,  2 Aug 2019 11:46:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405460AbfHBJqD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 2 Aug 2019 05:46:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:50082 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2405471AbfHBJqD (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 2 Aug 2019 05:46:03 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 18EFC216C8;
        Fri,  2 Aug 2019 09:46:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1564739162;
        bh=6rAfEz0VaxnRmTfVyrHrl5rArO9Sto31J1SKv7Io9EQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qdeFOlysktMMYlgwJLzFMrcsQuTK9ZxwQBdxOkPA+HRnGLy/ZQaIQrN+gKxjfyFO1
         o+tYP1RmbJxBxMPlhwzIAHbZynq/GDPfwrBpPWnUeeJBNjurqKS+DMKCyzArAuhAlT
         5LCnSflvpfIuiCph5MjW33pv8gCN/7AN7cmRmNhQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Szymon Janc <szymon.janc@codecoup.pl>,
        Maarten Fonville <maarten.fonville@gmail.com>,
        Marcel Holtmann <marcel@holtmann.org>
Subject: [PATCH 4.9 122/223] Bluetooth: Add SMP workaround Microsoft Surface Precision Mouse bug
Date:   Fri,  2 Aug 2019 11:35:47 +0200
Message-Id: <20190802092247.058386240@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190802092238.692035242@linuxfoundation.org>
References: <20190802092238.692035242@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Szymon Janc <szymon.janc@codecoup.pl>

commit 1d87b88ba26eabd4745e158ecfd87c93a9b51dc2 upstream.

Microsoft Surface Precision Mouse provides bogus identity address when
pairing. It connects with Static Random address but provides Public
Address in SMP Identity Address Information PDU. Address has same
value but type is different. Workaround this by dropping IRK if ID
address discrepancy is detected.

> HCI Event: LE Meta Event (0x3e) plen 19
      LE Connection Complete (0x01)
        Status: Success (0x00)
        Handle: 75
        Role: Master (0x00)
        Peer address type: Random (0x01)
        Peer address: E0:52:33:93:3B:21 (Static)
        Connection interval: 50.00 msec (0x0028)
        Connection latency: 0 (0x0000)
        Supervision timeout: 420 msec (0x002a)
        Master clock accuracy: 0x00

....

> ACL Data RX: Handle 75 flags 0x02 dlen 12
      SMP: Identity Address Information (0x09) len 7
        Address type: Public (0x00)
        Address: E0:52:33:93:3B:21

Signed-off-by: Szymon Janc <szymon.janc@codecoup.pl>
Tested-by: Maarten Fonville <maarten.fonville@gmail.com>
Bugzilla: https://bugzilla.kernel.org/show_bug.cgi?id=199461
Cc: stable@vger.kernel.org
Signed-off-by: Marcel Holtmann <marcel@holtmann.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 net/bluetooth/smp.c |   13 +++++++++++++
 1 file changed, 13 insertions(+)

--- a/net/bluetooth/smp.c
+++ b/net/bluetooth/smp.c
@@ -2514,6 +2514,19 @@ static int smp_cmd_ident_addr_info(struc
 		goto distribute;
 	}
 
+	/* Drop IRK if peer is using identity address during pairing but is
+	 * providing different address as identity information.
+	 *
+	 * Microsoft Surface Precision Mouse is known to have this bug.
+	 */
+	if (hci_is_identity_address(&hcon->dst, hcon->dst_type) &&
+	    (bacmp(&info->bdaddr, &hcon->dst) ||
+	     info->addr_type != hcon->dst_type)) {
+		bt_dev_err(hcon->hdev,
+			   "ignoring IRK with invalid identity address");
+		goto distribute;
+	}
+
 	bacpy(&smp->id_addr, &info->bdaddr);
 	smp->id_addr_type = info->addr_type;
 


