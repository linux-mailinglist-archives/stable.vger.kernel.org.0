Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 66B9E29016F
	for <lists+stable@lfdr.de>; Fri, 16 Oct 2020 11:18:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405796AbgJPJOd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 16 Oct 2020 05:14:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:38952 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2394309AbgJPJJ7 (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 16 Oct 2020 05:09:59 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7490E20878;
        Fri, 16 Oct 2020 09:09:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602839399;
        bh=0bxhwK+WBdHdh0kJ5s/LGYwIn3ijEEAXqpwc05p9ThI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RuTwztvkqUfdPnTnNwZdcjgzKbUWQKfpt4awe4z6zFuv2a7LqqdppH8UhbuVJlLTr
         /Y3BfTnafyp5eiRG2Z2oGI7zBiA7A5euLgqtfOIEb8ie5TvCdF7pPhBwbJgEvXuLSH
         EWG6hMSiC62SE/J0PXUYnb8IwxSX93v1NXV+KKGk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Patrick Steinhardt <ps@pks.im>,
        Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
        Marcel Holtmann <marcel@holtmann.org>
Subject: [PATCH 5.4 10/22] Bluetooth: Fix update of connection state in `hci_encrypt_cfm`
Date:   Fri, 16 Oct 2020 11:07:38 +0200
Message-Id: <20201016090437.822409472@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201016090437.308349327@linuxfoundation.org>
References: <20201016090437.308349327@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Patrick Steinhardt <ps@pks.im>

commit 339ddaa626995bc6218972ca241471f3717cc5f4 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 include/net/bluetooth/hci_core.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/include/net/bluetooth/hci_core.h
+++ b/include/net/bluetooth/hci_core.h
@@ -1314,7 +1314,7 @@ static inline void hci_encrypt_cfm(struc
 	__u8 encrypt;
 
 	if (conn->state == BT_CONFIG) {
-		if (status)
+		if (!status)
 			conn->state = BT_CONNECTED;
 
 		hci_connect_cfm(conn, status);


