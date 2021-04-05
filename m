Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C7A0A354058
	for <lists+stable@lfdr.de>; Mon,  5 Apr 2021 12:36:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240819AbhDEJRS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Apr 2021 05:17:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:39100 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239626AbhDEJRM (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 5 Apr 2021 05:17:12 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B51FA60FE4;
        Mon,  5 Apr 2021 09:17:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1617614226;
        bh=2Zqk0R2I0xocC5foxilnpakK8Ni9eF3ISSkUmSVZNKk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=14xNnHGYy/CQmTcAUFy7/M03rjDOcbUmJjlK6Z2tZ9BZ1DPvW1SW9djd7ryUm0jA+
         OgqqW8Zw0lByC1FvC41KcQIbAfyyNhkmHR8w7V0hnhOuwY5wKyrB4QcU48XHbNJtn8
         mLGMgnLcFlNciBVtiHXbkgYdl0aHZiNHrAmL4vqM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        syzbot+3dea30b047f41084de66@syzkaller.appspotmail.com,
        Shuah Khan <skhan@linuxfoundation.org>
Subject: [PATCH 5.11 130/152] usbip: vhci_hcd fix shift out-of-bounds in vhci_hub_control()
Date:   Mon,  5 Apr 2021 10:54:39 +0200
Message-Id: <20210405085038.456266406@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210405085034.233917714@linuxfoundation.org>
References: <20210405085034.233917714@linuxfoundation.org>
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


