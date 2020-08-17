Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 07F6B246A04
	for <lists+stable@lfdr.de>; Mon, 17 Aug 2020 17:29:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729841AbgHQP3G (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Aug 2020 11:29:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:46386 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729602AbgHQP3G (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 17 Aug 2020 11:29:06 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 81E9323B99;
        Mon, 17 Aug 2020 15:29:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597678145;
        bh=6Sh+2bqw7lgK2PTohYMXUs4R2NXha6DhzDcM8Up/1F8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gMrDgvqOAkV8n2DTPaNm9naD/jOIK9/z/5tQE8CKJNAXyThRRAWMQxnd7rJtqaLhV
         PX/ZRa3nn5h3RGGuuAHgRbBbdVTxQBnOfiaQEIdjTreWCFbkQaD4BHirT0HZF6C41u
         IummZLWCMguu/FCLHnA3J6XtR8UV6pGtj1gJrwT4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Patrick Steinhardt <ps@pks.im>,
        Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
        Marcel Holtmann <marcel@holtmann.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.8 234/464] Bluetooth: Fix update of connection state in `hci_encrypt_cfm`
Date:   Mon, 17 Aug 2020 17:13:07 +0200
Message-Id: <20200817143845.007653636@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200817143833.737102804@linuxfoundation.org>
References: <20200817143833.737102804@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Patrick Steinhardt <ps@pks.im>

[ Upstream commit 339ddaa626995bc6218972ca241471f3717cc5f4 ]

Starting with the upgrade to v5.8-rc3, I've noticed I wasn't able to
connect to my Bluetooth headset properly anymore. While connecting to
the device would eventually succeed, bluetoothd seemed to be confused
about the current connection state where the state was flapping hence
and forth. Bisecting this issue led to commit 3ca44c16b0dc (Bluetooth:
Consolidate encryption handling in hci_encrypt_cfm, 2020-05-19), which
refactored `hci_encrypt_cfm` to also handle updating the connection
state.

The commit in question changed the code to call `hci_connect_cfm` inside
`hci_encrypt_cfm` and to change the connection state. But with the
conversion, we now only update the connection state if a status was set
already. In fact, the reverse should be true: the status should be
updated if no status is yet set. So let's fix the isuse by reversing the
condition.

Fixes: 3ca44c16b0dc ("Bluetooth: Consolidate encryption handling in hci_encrypt_cfm")
Signed-off-by: Patrick Steinhardt <ps@pks.im>
Acked-by:  Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Marcel Holtmann <marcel@holtmann.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/net/bluetooth/hci_core.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/net/bluetooth/hci_core.h b/include/net/bluetooth/hci_core.h
index cdd4f1db8670e..da3728871e85d 100644
--- a/include/net/bluetooth/hci_core.h
+++ b/include/net/bluetooth/hci_core.h
@@ -1387,7 +1387,7 @@ static inline void hci_encrypt_cfm(struct hci_conn *conn, __u8 status)
 	__u8 encrypt;
 
 	if (conn->state == BT_CONFIG) {
-		if (status)
+		if (!status)
 			conn->state = BT_CONNECTED;
 
 		hci_connect_cfm(conn, status);
-- 
2.25.1



