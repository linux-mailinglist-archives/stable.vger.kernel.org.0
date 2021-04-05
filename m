Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A2424353CE8
	for <lists+stable@lfdr.de>; Mon,  5 Apr 2021 10:58:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232640AbhDEI5Y (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Apr 2021 04:57:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:36650 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233160AbhDEI5S (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 5 Apr 2021 04:57:18 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 81BEB6139C;
        Mon,  5 Apr 2021 08:57:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1617613033;
        bh=ssLj9Cg97ETf0FdLZhaGx+2uhY6HKRTP2jQW5w6Pllo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=2rEqRNOXwF244248Hq0ui0H4UVsQg8G2/1KAlnTFA9bWalpHvRo1UCUsbQXmkYcox
         Nr6MGcHPBz/92qm7iS4OsGkFIujQWt4azSv28qv+8Tea1SRHdgPWCxDctruiUhp6H+
         9zoeStpc94PQe5WN9FtbCIAY04qR8akTd1ThAJEo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Vincent Palatin <vpalatin@chromium.org>
Subject: [PATCH 4.9 27/35] USB: quirks: ignore remote wake-up on Fibocom L850-GL LTE modem
Date:   Mon,  5 Apr 2021 10:54:02 +0200
Message-Id: <20210405085019.732218188@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210405085018.871387942@linuxfoundation.org>
References: <20210405085018.871387942@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Vincent Palatin <vpalatin@chromium.org>

commit 0bd860493f81eb2a46173f6f5e44cc38331c8dbd upstream.

This LTE modem (M.2 card) has a bug in its power management:
there is some kind of race condition for U3 wake-up between the host and
the device. The modem firmware sometimes crashes/locks when both events
happen at the same time and the modem fully drops off the USB bus (and
sometimes re-enumerates, sometimes just gets stuck until the next
reboot).

Tested with the modem wired to the XHCI controller on an AMD 3015Ce
platform. Without the patch, the modem dropped of the USB bus 5 times in
3 days. With the quirk, it stayed connected for a week while the
'runtime_suspended_time' counter incremented as excepted.

Signed-off-by: Vincent Palatin <vpalatin@chromium.org>
Link: https://lore.kernel.org/r/20210319124802.2315195-1-vpalatin@chromium.org
Cc: stable <stable@vger.kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/core/quirks.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/drivers/usb/core/quirks.c
+++ b/drivers/usb/core/quirks.c
@@ -321,6 +321,10 @@ static const struct usb_device_id usb_qu
 	/* DJI CineSSD */
 	{ USB_DEVICE(0x2ca3, 0x0031), .driver_info = USB_QUIRK_NO_LPM },
 
+	/* Fibocom L850-GL LTE Modem */
+	{ USB_DEVICE(0x2cb7, 0x0007), .driver_info =
+			USB_QUIRK_IGNORE_REMOTE_WAKEUP },
+
 	/* INTEL VALUE SSD */
 	{ USB_DEVICE(0x8086, 0xf1a5), .driver_info = USB_QUIRK_RESET_RESUME },
 


