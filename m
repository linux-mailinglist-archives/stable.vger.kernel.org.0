Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 542AF48E5DB
	for <lists+stable@lfdr.de>; Fri, 14 Jan 2022 09:22:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237187AbiANIVh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 14 Jan 2022 03:21:37 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:59600 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237335AbiANIUi (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 14 Jan 2022 03:20:38 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 120E661E3C;
        Fri, 14 Jan 2022 08:20:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DC240C36AE9;
        Fri, 14 Jan 2022 08:20:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1642148437;
        bh=mtGQdNUmJGXJ3Z+IhjXfdAWu7wOPEfHxyVDRmkJdbXM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=o4ezfkD13fevYEsSq7N5/Xz5Qouu8LbCiafTdnxNZzw+cKdwSR6725/h821a0AXgm
         gTbHA6OhxA6RYqEPGTDoVDBXshrWYLZgBZpcY3FjF9zPWHa68xyZqM0JdPeJQ0tNAA
         /TkJlJYujhUJsSrWGmw8UyvBrgSDsr7bAMC3bzUE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Aditya Garg <gargaditya08@live.com>,
        Orlando Chamberlain <redecorating@protonmail.com>,
        Marcel Holtmann <marcel@holtmann.org>
Subject: [PATCH 5.15 25/41] Bluetooth: add quirk disabling LE Read Transmit Power
Date:   Fri, 14 Jan 2022 09:16:25 +0100
Message-Id: <20220114081545.992518490@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220114081545.158363487@linuxfoundation.org>
References: <20220114081545.158363487@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Aditya Garg <gargaditya08@live.com>

commit d2f8114f9574509580a8506d2ef72e7e43d1a5bd upstream.

Some devices have a bug causing them to not work if they query
LE tx power on startup. Thus we add a quirk in order to not query it
and default min/max tx power values to HCI_TX_POWER_INVALID.

Signed-off-by: Aditya Garg <gargaditya08@live.com>
Reported-by: Orlando Chamberlain <redecorating@protonmail.com>
Tested-by: Orlando Chamberlain <redecorating@protonmail.com>
Link:
https://lore.kernel.org/r/4970a940-211b-25d6-edab-21a815313954@protonmail.com
Fixes: 7c395ea521e6 ("Bluetooth: Query LE tx power on startup")
Cc: stable@vger.kernel.org
Signed-off-by: Marcel Holtmann <marcel@holtmann.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/net/bluetooth/hci.h |    9 +++++++++
 net/bluetooth/hci_core.c    |    3 ++-
 2 files changed, 11 insertions(+), 1 deletion(-)

--- a/include/net/bluetooth/hci.h
+++ b/include/net/bluetooth/hci.h
@@ -246,6 +246,15 @@ enum {
 	 * HCI after resume.
 	 */
 	HCI_QUIRK_NO_SUSPEND_NOTIFIER,
+
+	/*
+	 * When this quirk is set, LE tx power is not queried on startup
+	 * and the min/max tx power values default to HCI_TX_POWER_INVALID.
+	 *
+	 * This quirk can be set before hci_register_dev is called or
+	 * during the hdev->setup vendor callback.
+	 */
+	HCI_QUIRK_BROKEN_READ_TRANSMIT_POWER,
 };
 
 /* HCI device flags */
--- a/net/bluetooth/hci_core.c
+++ b/net/bluetooth/hci_core.c
@@ -742,7 +742,8 @@ static int hci_init3_req(struct hci_requ
 			hci_req_add(req, HCI_OP_LE_READ_ADV_TX_POWER, 0, NULL);
 		}
 
-		if (hdev->commands[38] & 0x80) {
+		if ((hdev->commands[38] & 0x80) &&
+		    !test_bit(HCI_QUIRK_BROKEN_READ_TRANSMIT_POWER, &hdev->quirks)) {
 			/* Read LE Min/Max Tx Power*/
 			hci_req_add(req, HCI_OP_LE_READ_TRANSMIT_POWER,
 				    0, NULL);


