Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 11ABC324D5F
	for <lists+stable@lfdr.de>; Thu, 25 Feb 2021 11:02:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233693AbhBYJ6r (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 25 Feb 2021 04:58:47 -0500
Received: from mail.kernel.org ([198.145.29.99]:34110 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234158AbhBYJ4i (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 25 Feb 2021 04:56:38 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id EEF9364F0D;
        Thu, 25 Feb 2021 09:54:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614246857;
        bh=AM0VwAM248I11PFNRkNnsugVBeUvdAPwU4cg/Y93yy4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UTJLlPEC4M4mmFa0u4UVXOgnW4CAtSY41E7X62T6zxwXcstaL1bxAO/1F7QgnoEQY
         j582yPUaPvKJshLTg9aIRNzGeXRlZsONSo+3cy3oJVk8SK5bzfKKjU7umdWaGafEuT
         K6BahUTSdVp4KjNZna94PYpef5jZvblnE/dVvXy4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hui Wang <hui.wang@canonical.com>,
        Marcel Holtmann <marcel@holtmann.org>,
        Salvatore Bonaccorso <carnil@debian.org>
Subject: [PATCH 5.11 06/12] Bluetooth: btusb: Some Qualcomm Bluetooth adapters stop working
Date:   Thu, 25 Feb 2021 10:53:40 +0100
Message-Id: <20210225092515.298883603@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210225092515.015261674@linuxfoundation.org>
References: <20210225092515.015261674@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
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
Cc: Salvatore Bonaccorso <carnil@debian.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/bluetooth/btusb.c |    7 +++++++
 1 file changed, 7 insertions(+)

--- a/drivers/bluetooth/btusb.c
+++ b/drivers/bluetooth/btusb.c
@@ -4065,6 +4065,13 @@ static int btusb_setup_qca(struct hci_de
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


