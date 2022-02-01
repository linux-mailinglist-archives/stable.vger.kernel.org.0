Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 557214A5E37
	for <lists+stable@lfdr.de>; Tue,  1 Feb 2022 15:26:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239225AbiBAO0h (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Feb 2022 09:26:37 -0500
Received: from nef2.ens.fr ([129.199.96.40]:51997 "EHLO nef.ens.fr"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S239209AbiBAO0h (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 1 Feb 2022 09:26:37 -0500
X-ENS-nef-client:   129.199.1.22 ( name = clipper-gw.ens.fr )
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=ens.fr; s=default;
        t=1643725594; bh=rMbD/p+V5OOxRJjg+z2/EXmNq1sqnJ9dWhwaiY/rVss=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Z0kQcK46ligBMbQ+Wne7TDkhSce4fWjM8WYkIwXMz/6/PkaVRxL7jOEyqMgkCZB/f
         lJeKZMqJOY5SBs6KVy0pyVyZsQ8OEue15ipq3eEYWNLWUTzfToadtzBEPqlx1A0nTW
         +aOcVHfbgT7QUHmk1esu1QkfU6Xl+apTNVqwNhz8=
Received: from clipper.ens.fr (clipper-gw.ens.fr [129.199.1.22])
          by nef.ens.fr (8.14.4/1.01.28121999) with ESMTP id 211EQYip025295
          ; Tue, 1 Feb 2022 15:26:34 +0100
Received: from  optiplex-7.sg.lan using smtps by clipper.ens.fr (8.14.4/jb-1.1)
       id 211EQRw4028881 ; Tue, 1 Feb 2022 15:26:34 +0100 (authenticated user gbertholon)
X-ENS-Received:  (maths.r-prg.net.univ-paris7.fr [81.194.27.158])
From:   Guillaume Bertholon <guillaume.bertholon@ens.fr>
To:     gregkh@linuxfoundation.org
Cc:     guillaume.bertholon@ens.fr, stable@vger.kernel.org
Subject: [PATCH stable 4.4] Bluetooth: MGMT: Fix misplaced BT_HS check
Date:   Tue,  1 Feb 2022 15:24:50 +0100
Message-Id: <1643725490-5917-1-git-send-email-guillaume.bertholon@ens.fr>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <YfUqikHXokp75E00@kroah.com>
References: <YfUqikHXokp75E00@kroah.com>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.4.3 (nef.ens.fr [129.199.96.32]); Tue, 01 Feb 2022 15:26:34 +0100 (CET)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The upstream commit b560a208cda0 ("Bluetooth: MGMT: Fix not checking if
BT_HS is enabled") inserted a new check in the `set_hs` function.
However, its backported version in stable (commit 5abe9f99f512
("Bluetooth: MGMT: Fix not checking if BT_HS is enabled")),
added the check in `set_link_security` instead.

This patch restores the intent of the upstream commit by moving back the
BT_HS check to `set_hs`.

Fixes: 5abe9f99f512 ("Bluetooth: MGMT: Fix not checking if BT_HS is enabled")
Signed-off-by: Guillaume Bertholon <guillaume.bertholon@ens.fr>
---
 net/bluetooth/mgmt.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/net/bluetooth/mgmt.c b/net/bluetooth/mgmt.c
index 4a95c89..621329c 100644
--- a/net/bluetooth/mgmt.c
+++ b/net/bluetooth/mgmt.c
@@ -2285,10 +2285,6 @@ static int set_link_security(struct sock *sk, struct hci_dev *hdev, void *data,

 	BT_DBG("request for %s", hdev->name);

-	if (!IS_ENABLED(CONFIG_BT_HS))
-		return mgmt_cmd_status(sk, hdev->id, MGMT_OP_SET_HS,
-				       MGMT_STATUS_NOT_SUPPORTED);
-
 	status = mgmt_bredr_support(hdev);
 	if (status)
 		return mgmt_cmd_status(sk, hdev->id, MGMT_OP_SET_LINK_SECURITY,
@@ -2438,6 +2434,10 @@ static int set_hs(struct sock *sk, struct hci_dev *hdev, void *data, u16 len)

 	BT_DBG("request for %s", hdev->name);

+	if (!IS_ENABLED(CONFIG_BT_HS))
+		return mgmt_cmd_status(sk, hdev->id, MGMT_OP_SET_HS,
+				       MGMT_STATUS_NOT_SUPPORTED);
+
 	status = mgmt_bredr_support(hdev);
 	if (status)
 		return mgmt_cmd_status(sk, hdev->id, MGMT_OP_SET_HS, status);
--
2.7.4

