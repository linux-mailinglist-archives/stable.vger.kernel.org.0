Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9BB6713323C
	for <lists+stable@lfdr.de>; Tue,  7 Jan 2020 22:09:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728626AbgAGVI1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jan 2020 16:08:27 -0500
Received: from mail.kernel.org ([198.145.29.99]:60816 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729691AbgAGVI1 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 7 Jan 2020 16:08:27 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 14699222D9;
        Tue,  7 Jan 2020 21:08:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1578431306;
        bh=0CCvKei3nHFFJwXyo+dF672ro9QzS7d5NDIs9AzPEq4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LpPF2im5phnlmcuhBKddYQU9eVNIl60ajVSrRuTQi4j/6prTmZvhYKHpcjUv0iS6O
         eU5meTTmIRtvw5bg62eJutnXKEo0dpfxw4k7WVpiYMxvjrw9n4f3lc4Glu6tuYe37Y
         +LFvLMD+HtPbELOgBVOoB3flF4iX0LIiJ0iySXgo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Oliver Neukum <oneukum@suse.com>,
        Marcel Holtmann <marcel@holtmann.org>
Subject: [PATCH 4.19 086/115] Bluetooth: btusb: fix PM leak in error case of setup
Date:   Tue,  7 Jan 2020 21:54:56 +0100
Message-Id: <20200107205306.230937692@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200107205240.283674026@linuxfoundation.org>
References: <20200107205240.283674026@linuxfoundation.org>
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
@@ -1138,7 +1138,7 @@ static int btusb_open(struct hci_dev *hd
 	if (data->setup_on_usb) {
 		err = data->setup_on_usb(hdev);
 		if (err < 0)
-			return err;
+			goto setup_fail;
 	}
 
 	data->intf->needs_remote_wakeup = 1;
@@ -1170,6 +1170,7 @@ done:
 
 failed:
 	clear_bit(BTUSB_INTR_RUNNING, &data->flags);
+setup_fail:
 	usb_autopm_put_interface(data->intf);
 	return err;
 }


