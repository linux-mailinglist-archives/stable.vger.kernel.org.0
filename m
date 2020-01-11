Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C82BB137D04
	for <lists+stable@lfdr.de>; Sat, 11 Jan 2020 10:52:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728768AbgAKJwm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 11 Jan 2020 04:52:42 -0500
Received: from mail.kernel.org ([198.145.29.99]:38512 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728761AbgAKJwm (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 11 Jan 2020 04:52:42 -0500
Received: from localhost (unknown [62.119.166.9])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4487A20842;
        Sat, 11 Jan 2020 09:52:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1578736361;
        bh=5Ft2cQbHVsulpSA3g5RUKP6BSvv0SmITywB9Fxp/S1Q=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=D1TZyWwpLdZMWOXR53U+vLrifU48pA6Khdc3wHrmDDDpGZD6siwnT9YJzX+Cg0/mc
         e/cM1rYXOvJOMi2nfpsVfQFO6L1IJAuBv8EWo8CSHy6/JEcqR7UmjyZL9bcoVB2FU6
         3oEzD7ReOMuli0kAEPigz0utCDSQpyjxN7tlih+0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Oliver Neukum <oneukum@suse.com>,
        Marcel Holtmann <marcel@holtmann.org>
Subject: [PATCH 4.4 23/59] Bluetooth: btusb: fix PM leak in error case of setup
Date:   Sat, 11 Jan 2020 10:49:32 +0100
Message-Id: <20200111094843.410392208@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200111094835.417654274@linuxfoundation.org>
References: <20200111094835.417654274@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Oliver Neukum <oneukum@suse.com>

commit 3d44a6fd0775e6215e836423e27f8eedf8c871ea upstream.

If setup() fails a reference for runtime PM has already
been taken. Proper use of the error handling in btusb_open()is needed.
You cannot just return.

Fixes: ace31982585a3 ("Bluetooth: btusb: Add setup callback for chip init on USB")
Signed-off-by: Oliver Neukum <oneukum@suse.com>
Signed-off-by: Marcel Holtmann <marcel@holtmann.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/bluetooth/btusb.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/bluetooth/btusb.c
+++ b/drivers/bluetooth/btusb.c
@@ -1056,7 +1056,7 @@ static int btusb_open(struct hci_dev *hd
 	if (data->setup_on_usb) {
 		err = data->setup_on_usb(hdev);
 		if (err < 0)
-			return err;
+			goto setup_fail;
 	}
 
 	err = usb_autopm_get_interface(data->intf);
@@ -1092,6 +1092,7 @@ done:
 
 failed:
 	clear_bit(BTUSB_INTR_RUNNING, &data->flags);
+setup_fail:
 	usb_autopm_put_interface(data->intf);
 	return err;
 }


