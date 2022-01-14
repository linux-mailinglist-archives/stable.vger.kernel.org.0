Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9646748E639
	for <lists+stable@lfdr.de>; Fri, 14 Jan 2022 09:25:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240751AbiANIYf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 14 Jan 2022 03:24:35 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:33082 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240192AbiANIWk (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 14 Jan 2022 03:22:40 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 38A3761E2C;
        Fri, 14 Jan 2022 08:22:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 19659C36AEC;
        Fri, 14 Jan 2022 08:22:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1642148557;
        bh=MFJZOy3GRMX4/xbzCsR2FxLlhKoMFHSYMCGxzsfZ1jk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nIlTHIloiOKVwFrzYGq/GFoPp0H0lTuJgeqO9rz0GNuDcgORIqKbOFaK5tXBnxux7
         upZ3C51we9C+HkGnRrhB8DH32nkBl84rXcB3hu13jPGfyw2QVnOuYW+w6x/suiYX0o
         /EcHPri5ENhxEkjoVHnC6UUY0LPvuadzEVy4+gWI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Zeal Robot <zealci@zte.com.cn>,
        David Yang <davidcomponentone@gmail.com>,
        Marcel Holtmann <marcel@holtmann.org>
Subject: [PATCH 5.16 06/37] Bluetooth: btusb: Fix application of sizeof to pointer
Date:   Fri, 14 Jan 2022 09:16:20 +0100
Message-Id: <20220114081545.066721531@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220114081544.849748488@linuxfoundation.org>
References: <20220114081544.849748488@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: David Yang <davidcomponentone@gmail.com>

commit dc1650fc94a8566fb89f3fd14a26d1cec7865f16 upstream.

The coccinelle check report:
"./drivers/bluetooth/btusb.c:2239:36-42:
ERROR: application of sizeof to pointer".
Using the real size to fix it.

Fixes: 5a87679ffd443 ("Bluetooth: btusb: Support public address configuration for MediaTek Chip.")
Reported-by: Zeal Robot <zealci@zte.com.cn>
Signed-off-by: David Yang <davidcomponentone@gmail.com>
Signed-off-by: Marcel Holtmann <marcel@holtmann.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/bluetooth/btusb.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/bluetooth/btusb.c
+++ b/drivers/bluetooth/btusb.c
@@ -2238,7 +2238,7 @@ static int btusb_set_bdaddr_mtk(struct h
 	struct sk_buff *skb;
 	long ret;
 
-	skb = __hci_cmd_sync(hdev, 0xfc1a, sizeof(bdaddr), bdaddr, HCI_INIT_TIMEOUT);
+	skb = __hci_cmd_sync(hdev, 0xfc1a, 6, bdaddr, HCI_INIT_TIMEOUT);
 	if (IS_ERR(skb)) {
 		ret = PTR_ERR(skb);
 		bt_dev_err(hdev, "changing Mediatek device address failed (%ld)",


