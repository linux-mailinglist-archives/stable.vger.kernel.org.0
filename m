Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CB4B732509C
	for <lists+stable@lfdr.de>; Thu, 25 Feb 2021 14:42:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230174AbhBYNhT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 25 Feb 2021 08:37:19 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:25895 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229644AbhBYNhT (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 25 Feb 2021 08:37:19 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1614260153;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=hp0WGFEK2LjqWu9jp/JzM4u9QKjhqK/0dT4+HKtoLkA=;
        b=R7FUT8GhMqi2x04P5KL81ko7iD/LOblyUHKX84UFYX0RB0C3RUCcNiI8hF2LylAuhQg9iO
        +VqW5hqCWBkKIfU+DrJmVhBY+f8EAvGdiXWPc77IFHmZYW2sbg5Rs0mda/nFPJRYD7hy8H
        AAHy+3BeYj8imroYqB778cMSbDsqTWs=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-306-HWj4nSf4MIWDec4a32es9Q-1; Thu, 25 Feb 2021 08:35:49 -0500
X-MC-Unique: HWj4nSf4MIWDec4a32es9Q-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 7CD4C1009626;
        Thu, 25 Feb 2021 13:35:48 +0000 (UTC)
Received: from x1.localdomain (ovpn-112-2.ams2.redhat.com [10.36.112.2])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 37C6D63622;
        Thu, 25 Feb 2021 13:35:47 +0000 (UTC)
From:   Hans de Goede <hdegoede@redhat.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Hans de Goede <hdegoede@redhat.com>, stable@vger.kernel.org,
        Hui Wang <hui.wang@canonical.com>,
        Marcel Holtmann <marcel@holtmann.org>
Subject: [PATCH stable 1/1] Bluetooth: btusb: Some Qualcomm Bluetooth adapters stop working
Date:   Thu, 25 Feb 2021 14:35:45 +0100
Message-Id: <20210225133545.86680-2-hdegoede@redhat.com>
In-Reply-To: <20210225133545.86680-1-hdegoede@redhat.com>
References: <20210225133545.86680-1-hdegoede@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Hui Wang <hui.wang@canonical.com>

commit 234f414efd1164786269849b4fbb533d6c9cdbbf upstream.

This issue starts from linux-5.10-rc1, I reproduced this issue on my
Dell Inspiron 7447 with BT adapter 0cf3:e005, the kernel will print
out: "Bluetooth: hci0: don't support firmware rome 0x31010000", and
someone else also reported the similar issue to bugzilla #211571.

I found this is a regression introduced by 'commit b40f58b97386
("Bluetooth: btusb: Add Qualcomm Bluetooth SoC WCN6855 support"), the
patch assumed that if high ROM version is not zero, it is an adapter
on WCN6855, but many old adapters don't need to load rampatch or nvm,
and they have non-zero high ROM version.

To fix it, let the driver match the rom_version in the
qca_devices_table first, if there is no entry matched, check the
high ROM version, if it is not zero, we assume this adapter is ready
to work and no need to load rampatch and nvm like previously.

BugLink: https://bugzilla.kernel.org/show_bug.cgi?id=211571
Fixes: b40f58b97386 ("Bluetooth: btusb: Add Qualcomm Bluetooth SoC WCN6855 support")
Signed-off-by: Hui Wang <hui.wang@canonical.com>
Signed-off-by: Marcel Holtmann <marcel@holtmann.org>
---
 drivers/bluetooth/btusb.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/bluetooth/btusb.c b/drivers/bluetooth/btusb.c
index 9f958699141e..1c942869baac 100644
--- a/drivers/bluetooth/btusb.c
+++ b/drivers/bluetooth/btusb.c
@@ -3689,6 +3689,13 @@ static int btusb_setup_qca(struct hci_dev *hdev)
 			info = &qca_devices_table[i];
 	}
 	if (!info) {
+		/* If the rom_version is not matched in the qca_devices_table
+		 * and the high ROM version is not zero, we assume this chip no
+		 * need to load the rampatch and nvm.
+		 */
+		if (ver_rom & ~0xffffU)
+			return 0;
+
 		bt_dev_err(hdev, "don't support firmware rome 0x%x", ver_rom);
 		return -ENODEV;
 	}
-- 
2.30.1

