Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DE6CD1B68EE
	for <lists+stable@lfdr.de>; Fri, 24 Apr 2020 01:19:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728048AbgDWXTE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 Apr 2020 19:19:04 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:48862 "EHLO
        shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728250AbgDWXGg (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 23 Apr 2020 19:06:36 -0400
Received: from [192.168.4.242] (helo=deadeye)
        by shadbolt.decadent.org.uk with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <ben@decadent.org.uk>)
        id 1jRkvP-0004f3-4P; Fri, 24 Apr 2020 00:06:31 +0100
Received: from ben by deadeye with local (Exim 4.93)
        (envelope-from <ben@decadent.org.uk>)
        id 1jRkvM-00E6lc-GL; Fri, 24 Apr 2020 00:06:28 +0100
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From:   Ben Hutchings <ben@decadent.org.uk>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC:     akpm@linux-foundation.org, Denis Kirjanov <kda@linux-powerpc.org>,
        "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>,
        "Tilman Schmidt" <tilman@imap.cc>,
        "Johan Hovold" <johan@kernel.org>
Date:   Fri, 24 Apr 2020 00:05:09 +0100
Message-ID: <lsq.1587683028.102497951@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
X-Patchwork-Hint: ignore
Subject: [PATCH 3.16 082/245] staging: gigaset: fix illegal free on probe
 errors
In-Reply-To: <lsq.1587683027.831233700@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.242
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

3.16.83-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Johan Hovold <johan@kernel.org>

commit 84f60ca7b326ed8c08582417493982fe2573a9ad upstream.

The driver failed to initialise its receive-buffer pointer, something
which could lead to an illegal free on late probe errors.

Fix this by making sure to clear all driver data at allocation.

Fixes: 2032e2c2309d ("usb_gigaset: code cleanup")
Cc: Tilman Schmidt <tilman@imap.cc>
Signed-off-by: Johan Hovold <johan@kernel.org>
Link: https://lore.kernel.org/r/20191202085610.12719-3-johan@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
[bwh: Backported to 3.16: adjust filename]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/isdn/gigaset/usb-gigaset.c | 6 +-----
 1 file changed, 1 insertion(+), 5 deletions(-)

--- a/drivers/isdn/gigaset/usb-gigaset.c
+++ b/drivers/isdn/gigaset/usb-gigaset.c
@@ -578,8 +578,7 @@ static int gigaset_initcshw(struct cards
 {
 	struct usb_cardstate *ucs;
 
-	cs->hw.usb = ucs =
-		kmalloc(sizeof(struct usb_cardstate), GFP_KERNEL);
+	cs->hw.usb = ucs = kzalloc(sizeof(struct usb_cardstate), GFP_KERNEL);
 	if (!ucs) {
 		pr_err("out of memory\n");
 		return -ENOMEM;
@@ -591,9 +590,6 @@ static int gigaset_initcshw(struct cards
 	ucs->bchars[3] = 0;
 	ucs->bchars[4] = 0x11;
 	ucs->bchars[5] = 0x13;
-	ucs->bulk_out_buffer = NULL;
-	ucs->bulk_out_urb = NULL;
-	ucs->read_urb = NULL;
 	tasklet_init(&cs->write_tasklet,
 		     gigaset_modem_fill, (unsigned long) cs);
 

