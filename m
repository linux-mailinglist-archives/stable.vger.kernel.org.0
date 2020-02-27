Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 98B6C171CA5
	for <lists+stable@lfdr.de>; Thu, 27 Feb 2020 15:14:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389069AbgB0OOE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 27 Feb 2020 09:14:04 -0500
Received: from mail.kernel.org ([198.145.29.99]:53138 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389065AbgB0OOE (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 27 Feb 2020 09:14:04 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1CD2D24691;
        Thu, 27 Feb 2020 14:14:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1582812843;
        bh=Y+oO0v4pPjWCM/PYx1KrCQTKLulyQAEUeZpbuxHDaAE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=s94e/sdo9Vmtq2Q6NHY5OJsfKStCk7z9yMI61ULG7YjfabMtwQuP00fP9XcGY/1OG
         VJLOXlyJbQ1TCmD70nbDnnkSF6PDrH3wfVf8KbJFDbwGyEnI3xjjcoibyeRgWpYx8k
         x5373L5+5fz+cRh3SOj27BBAuGQ8RvNV58d21HxY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Richard Dodd <richard.o.dodd@gmail.com>
Subject: [PATCH 5.5 038/150] USB: Fix novation SourceControl XL after suspend
Date:   Thu, 27 Feb 2020 14:36:15 +0100
Message-Id: <20200227132238.424190248@linuxfoundation.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200227132232.815448360@linuxfoundation.org>
References: <20200227132232.815448360@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Richard Dodd <richard.o.dodd@gmail.com>

commit b692056db8ecc7f452b934f016c17348282b7699 upstream.

Currently, the SourceControl will stay in power-down mode after resuming
from suspend. This patch resets the device after suspend to power it up.

Signed-off-by: Richard Dodd <richard.o.dodd@gmail.com>
Cc: stable <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20200212142220.36892-1-richard.o.dodd@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/usb/core/quirks.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/usb/core/quirks.c
+++ b/drivers/usb/core/quirks.c
@@ -449,6 +449,9 @@ static const struct usb_device_id usb_qu
 	/* INTEL VALUE SSD */
 	{ USB_DEVICE(0x8086, 0xf1a5), .driver_info = USB_QUIRK_RESET_RESUME },
 
+	/* novation SoundControl XL */
+	{ USB_DEVICE(0x1235, 0x0061), .driver_info = USB_QUIRK_RESET_RESUME },
+
 	{ }  /* terminating entry must be last */
 };
 


