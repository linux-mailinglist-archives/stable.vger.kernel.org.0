Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0B4CF3A6153
	for <lists+stable@lfdr.de>; Mon, 14 Jun 2021 12:44:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233840AbhFNKqN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Jun 2021 06:46:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:50444 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233820AbhFNKoD (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 14 Jun 2021 06:44:03 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D13EB61446;
        Mon, 14 Jun 2021 10:36:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1623666969;
        bh=0PEOkMy6BleViziz664TLBeeJPhIJrUK18ritYu7c/I=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=zfQRXPk3Sn2IYtD1E5SR9e1bof94fu3jnLjkK/oa2gcSa5Gu2cuWUXu+n8WwCRoRm
         +chPVSKjjCF/Snn9zGEj3aeUr+xxh1xp+8bkEUu0XpWkaIgl23kMMDC3RAXl1aEkja
         1eAjGrttWzw3UpQuSjmsxPTh5xoewNZjIIH8Yz8k=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Felipe Balbi <balbi@kernel.org>,
        =?UTF-8?q?Maciej=20=C5=BBenczykowski?= <maze@google.com>
Subject: [PATCH 4.19 48/67] usb: fix various gadget panics on 10gbps cabling
Date:   Mon, 14 Jun 2021 12:27:31 +0200
Message-Id: <20210614102645.408498498@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210614102643.797691914@linuxfoundation.org>
References: <20210614102643.797691914@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Maciej Żenczykowski <maze@google.com>

commit 032e288097a553db5653af552dd8035cd2a0ba96 upstream.

usb_assign_descriptors() is called with 5 parameters,
the last 4 of which are the usb_descriptor_header for:
  full-speed (USB1.1 - 12Mbps [including USB1.0 low-speed @ 1.5Mbps),
  high-speed (USB2.0 - 480Mbps),
  super-speed (USB3.0 - 5Gbps),
  super-speed-plus (USB3.1 - 10Gbps).

The differences between full/high/super-speed descriptors are usually
substantial (due to changes in the maximum usb block size from 64 to 512
to 1024 bytes and other differences in the specs), while the difference
between 5 and 10Gbps descriptors may be as little as nothing
(in many cases the same tuning is simply good enough).

However if a gadget driver calls usb_assign_descriptors() with
a NULL descriptor for super-speed-plus and is then used on a max 10gbps
configuration, the kernel will crash with a null pointer dereference,
when a 10gbps capable device port + cable + host port combination shows up.
(This wouldn't happen if the gadget max-speed was set to 5gbps, but
it of course defaults to the maximum, and there's no real reason to
artificially limit it)

The fix is to simply use the 5gbps descriptor as the 10gbps descriptor,
if a 10gbps descriptor wasn't provided.

Obviously this won't fix the problem if the 5gbps descriptor is also
NULL, but such cases can't be so trivially solved (and any such gadgets
are unlikely to be used with USB3 ports any way).

Cc: Felipe Balbi <balbi@kernel.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Maciej Żenczykowski <maze@google.com>
Cc: stable <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20210609024459.1126080-1-zenczykowski@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/gadget/config.c |    8 ++++++++
 1 file changed, 8 insertions(+)

--- a/drivers/usb/gadget/config.c
+++ b/drivers/usb/gadget/config.c
@@ -164,6 +164,14 @@ int usb_assign_descriptors(struct usb_fu
 {
 	struct usb_gadget *g = f->config->cdev->gadget;
 
+	/* super-speed-plus descriptor falls back to super-speed one,
+	 * if such a descriptor was provided, thus avoiding a NULL
+	 * pointer dereference if a 5gbps capable gadget is used with
+	 * a 10gbps capable config (device port + cable + host port)
+	 */
+	if (!ssp)
+		ssp = ss;
+
 	if (fs) {
 		f->fs_descriptors = usb_copy_descriptors(fs);
 		if (!f->fs_descriptors)


