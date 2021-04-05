Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8A450353D45
	for <lists+stable@lfdr.de>; Mon,  5 Apr 2021 10:59:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234113AbhDEI7Y (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Apr 2021 04:59:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:40214 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236891AbhDEI7X (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 5 Apr 2021 04:59:23 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E84006124C;
        Mon,  5 Apr 2021 08:59:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1617613157;
        bh=Yx3v3+Luu+n6Ib+g+kDFy7A8Xaf5dJ3/wdBGWY4YD/E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HHQnV366cdYfR/7BjXMEcNREQHce9hScvPE2yOyiQEgg7gMTzRzuxZN/EiBszN3ju
         YvSn/52SMA8BOWoGnwmMrZYrjLaAajltBWgWv96BvrSLiGXKAclg1T7OlHQ5VYCvCg
         tZA3UdwOZSr83dnhRv2mPHfAZR3M2ULzFf0S5c5I=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        syzbot+3dea30b047f41084de66@syzkaller.appspotmail.com,
        Shuah Khan <skhan@linuxfoundation.org>
Subject: [PATCH 4.14 41/52] usbip: vhci_hcd fix shift out-of-bounds in vhci_hub_control()
Date:   Mon,  5 Apr 2021 10:54:07 +0200
Message-Id: <20210405085023.317033272@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210405085021.996963957@linuxfoundation.org>
References: <20210405085021.996963957@linuxfoundation.org>
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
@@ -608,6 +608,8 @@ static int vhci_hub_control(struct usb_h
 				pr_err("invalid port number %d\n", wIndex);
 				goto error;
 			}
+			if (wValue >= 32)
+				goto error;
 			if (hcd->speed == HCD_USB3) {
 				if ((vhci_hcd->port_status[rhport] &
 				     USB_SS_PORT_STAT_POWER) != 0) {


