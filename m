Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9A6DD2ABB60
	for <lists+stable@lfdr.de>; Mon,  9 Nov 2020 14:28:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731859AbgKIN1k (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 9 Nov 2020 08:27:40 -0500
Received: from mail.kernel.org ([198.145.29.99]:41394 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730936AbgKINOy (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 9 Nov 2020 08:14:54 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AC71820789;
        Mon,  9 Nov 2020 13:14:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604927694;
        bh=IKUOtr0yilLf9dxxAef+6Dslwi73ppjukWN35zDq1wU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=B6uLo373puvrh0TvFGjIfmjzrJfwws1uCqbKUK1yfVSZI99T5J/bMjKBWiIQ/o4T1
         psrzGnfsS4gCSH28epzya7JCehZRabaU05Vnq2jL/HufTWPXrnfDQn7QrEsO96kWQf
         vc9jqWpVk3fa3fZ453XaqvbUP2vySvKQZCXudFvI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Hans de Goede <jwrdegoede@fedoraproject.org>,
        Alan Stern <stern@rowland.harvard.edu>,
        Julien Humbert <julroy67@gmail.com>
Subject: [PATCH 5.4 76/85] USB: Add NO_LPM quirk for Kingston flash drive
Date:   Mon,  9 Nov 2020 13:56:13 +0100
Message-Id: <20201109125026.227113509@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201109125022.614792961@linuxfoundation.org>
References: <20201109125022.614792961@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Alan Stern <stern@rowland.harvard.edu>

commit afaa2e745a246c5ab95103a65b1ed00101e1bc63 upstream.

In Bugzilla #208257, Julien Humbert reports that a 32-GB Kingston
flash drive spontaneously disconnects and reconnects, over and over.
Testing revealed that disabling Link Power Management for the drive
fixed the problem.

This patch adds a quirk entry for that drive to turn off LPM permanently.

CC: Hans de Goede <jwrdegoede@fedoraproject.org>
CC: <stable@vger.kernel.org>
Reported-and-tested-by: Julien Humbert <julroy67@gmail.com>
Signed-off-by: Alan Stern <stern@rowland.harvard.edu>
Link: https://lore.kernel.org/r/20201102145821.GA1478741@rowland.harvard.edu
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/usb/core/quirks.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/usb/core/quirks.c
+++ b/drivers/usb/core/quirks.c
@@ -378,6 +378,9 @@ static const struct usb_device_id usb_qu
 	{ USB_DEVICE(0x0926, 0x3333), .driver_info =
 			USB_QUIRK_CONFIG_INTF_STRINGS },
 
+	/* Kingston DataTraveler 3.0 */
+	{ USB_DEVICE(0x0951, 0x1666), .driver_info = USB_QUIRK_NO_LPM },
+
 	/* X-Rite/Gretag-Macbeth Eye-One Pro display colorimeter */
 	{ USB_DEVICE(0x0971, 0x2000), .driver_info = USB_QUIRK_NO_SET_INTF },
 


