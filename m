Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AD1B8353F35
	for <lists+stable@lfdr.de>; Mon,  5 Apr 2021 12:35:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239405AbhDEJKk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Apr 2021 05:10:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:56932 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239000AbhDEJKh (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 5 Apr 2021 05:10:37 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 961BE613A8;
        Mon,  5 Apr 2021 09:10:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1617613828;
        bh=2Zqk0R2I0xocC5foxilnpakK8Ni9eF3ISSkUmSVZNKk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lGCXQz8fZVIbWTJa/KKm+5KKrYte3yXXEkn7vtnHsEt8Z7Uwqh5Jo4U+Mp3PzUd4E
         17WyxxYWEeQRuQ44xxrkosVk6FlnZ6Bbclm5aAZ1PoJuCUbOnoXjj8y5EE4KvezE5L
         wdlPopabRCwCVM+8o+gpkrh0x7Hdw+rpIKyGr7E0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        syzbot+3dea30b047f41084de66@syzkaller.appspotmail.com,
        Shuah Khan <skhan@linuxfoundation.org>
Subject: [PATCH 5.10 105/126] usbip: vhci_hcd fix shift out-of-bounds in vhci_hub_control()
Date:   Mon,  5 Apr 2021 10:54:27 +0200
Message-Id: <20210405085034.525372275@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210405085031.040238881@linuxfoundation.org>
References: <20210405085031.040238881@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Shuah Khan <skhan@linuxfoundation.org>

commit 1cc5ed25bdade86de2650a82b2730108a76de20c upstream.

Fix shift out-of-bounds in vhci_hub_control() SetPortFeature handling.

UBSAN: shift-out-of-bounds in drivers/usb/usbip/vhci_hcd.c:605:42
shift exponent 768 is too large for 32-bit type 'int'

Reported-by: syzbot+3dea30b047f41084de66@syzkaller.appspotmail.com
Cc: stable@vger.kernel.org
Signed-off-by: Shuah Khan <skhan@linuxfoundation.org>
Link: https://lore.kernel.org/r/20210324230654.34798-1-skhan@linuxfoundation.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/usbip/vhci_hcd.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/usb/usbip/vhci_hcd.c
+++ b/drivers/usb/usbip/vhci_hcd.c
@@ -594,6 +594,8 @@ static int vhci_hub_control(struct usb_h
 				pr_err("invalid port number %d\n", wIndex);
 				goto error;
 			}
+			if (wValue >= 32)
+				goto error;
 			if (hcd->speed == HCD_USB3) {
 				if ((vhci_hcd->port_status[rhport] &
 				     USB_SS_PORT_STAT_POWER) != 0) {


