Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id ACCD213319F
	for <lists+stable@lfdr.de>; Tue,  7 Jan 2020 22:02:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727536AbgAGVC2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jan 2020 16:02:28 -0500
Received: from mail.kernel.org ([198.145.29.99]:42052 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727234AbgAGVC0 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 7 Jan 2020 16:02:26 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CC94C222D9;
        Tue,  7 Jan 2020 21:02:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1578430945;
        bh=Pf+OGz+1yK/rXxvQjEg7VSpjfIaC0mFgSTEUWmZv348=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Q5gttiroUJM9KD/2JNtZFhaY9o+k5o3pjdHKTY9h3mDBpIdpy7YLm7Ylx6XCr+9P1
         6iSJCZ2lL4UU/Gtb0TlLL3zJ8Tjno7nIdrPBojxZOKU9PqdbiSaWV/lJzA5IkqSYRF
         hgqT5iL24nKtHfFbWoucR9SkS+lLvTK6yob6xz2o=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Navid Emamdoost <navid.emamdoost@gmail.com>,
        Marcel Holtmann <marcel@holtmann.org>
Subject: [PATCH 5.4 160/191] Bluetooth: Fix memory leak in hci_connect_le_scan
Date:   Tue,  7 Jan 2020 21:54:40 +0100
Message-Id: <20200107205341.538631171@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200107205332.984228665@linuxfoundation.org>
References: <20200107205332.984228665@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Navid Emamdoost <navid.emamdoost@gmail.com>

commit d088337c38a5cd8f0230fbf2d514ff7672f9d0d3 upstream.

In the implementation of hci_connect_le_scan() when conn is added via
hci_conn_add(), if hci_explicit_conn_params_set() fails the allocated
memory for conn is leaked. Use hci_conn_del() to release it.

Fixes: f75113a26008 ("Bluetooth: add hci_connect_le_scan")
Signed-off-by: Navid Emamdoost <navid.emamdoost@gmail.com>
Signed-off-by: Marcel Holtmann <marcel@holtmann.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 net/bluetooth/hci_conn.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/net/bluetooth/hci_conn.c
+++ b/net/bluetooth/hci_conn.c
@@ -1176,8 +1176,10 @@ struct hci_conn *hci_connect_le_scan(str
 	if (!conn)
 		return ERR_PTR(-ENOMEM);
 
-	if (hci_explicit_conn_params_set(hdev, dst, dst_type) < 0)
+	if (hci_explicit_conn_params_set(hdev, dst, dst_type) < 0) {
+		hci_conn_del(conn);
 		return ERR_PTR(-EBUSY);
+	}
 
 	conn->state = BT_CONNECT;
 	set_bit(HCI_CONN_SCANNING, &conn->flags);


