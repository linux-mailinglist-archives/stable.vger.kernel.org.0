Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B980F313602
	for <lists+stable@lfdr.de>; Mon,  8 Feb 2021 16:05:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232577AbhBHPEl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Feb 2021 10:04:41 -0500
Received: from mail.kernel.org ([198.145.29.99]:51778 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232693AbhBHPDi (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 8 Feb 2021 10:03:38 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7529A64EB8;
        Mon,  8 Feb 2021 15:02:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1612796561;
        bh=uNdtUiPu/JXuxmabfk74niAlwlkvOOeoAi5s2CdvdPk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mVSahTkrz+xbUcAEV8JcrkAtNomqLFdpwra0/0IlwyCYuGUWPsVHeWTQ8NAcGJz/a
         yA3QVlES7BIuAy50EnFEzNRA0brXVwXMIoY8ewwfamk8lO5hU34oZLDZv1Mk4ENrQK
         nyTtuA7anUG2E6/f8/KpH5DpvmosR8ahF/pD55kw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Pete Zaitcev <zaitcev@redhat.com>,
        Jeremy Figgins <kernel@jeremyfiggins.com>
Subject: [PATCH 4.4 24/38] USB: usblp: dont call usb_set_interface if theres a single alt
Date:   Mon,  8 Feb 2021 16:00:46 +0100
Message-Id: <20210208145806.232404013@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210208145805.279815326@linuxfoundation.org>
References: <20210208145805.279815326@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jeremy Figgins <kernel@jeremyfiggins.com>

commit d8c6edfa3f4ee0d45d7ce5ef18d1245b78774b9d upstream.

Some devices, such as the Winbond Electronics Corp. Virtual Com Port
(Vendor=0416, ProdId=5011), lockup when usb_set_interface() or
usb_clear_halt() are called. This device has only a single
altsetting, so it should not be necessary to call usb_set_interface().

Acked-by: Pete Zaitcev <zaitcev@redhat.com>
Signed-off-by: Jeremy Figgins <kernel@jeremyfiggins.com>
Link: https://lore.kernel.org/r/YAy9kJhM/rG8EQXC@watson
Cc: stable <stable@vger.kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/class/usblp.c |   19 +++++++++++--------
 1 file changed, 11 insertions(+), 8 deletions(-)

--- a/drivers/usb/class/usblp.c
+++ b/drivers/usb/class/usblp.c
@@ -1349,14 +1349,17 @@ static int usblp_set_protocol(struct usb
 	if (protocol < USBLP_FIRST_PROTOCOL || protocol > USBLP_LAST_PROTOCOL)
 		return -EINVAL;
 
-	alts = usblp->protocol[protocol].alt_setting;
-	if (alts < 0)
-		return -EINVAL;
-	r = usb_set_interface(usblp->dev, usblp->ifnum, alts);
-	if (r < 0) {
-		printk(KERN_ERR "usblp: can't set desired altsetting %d on interface %d\n",
-			alts, usblp->ifnum);
-		return r;
+	/* Don't unnecessarily set the interface if there's a single alt. */
+	if (usblp->intf->num_altsetting > 1) {
+		alts = usblp->protocol[protocol].alt_setting;
+		if (alts < 0)
+			return -EINVAL;
+		r = usb_set_interface(usblp->dev, usblp->ifnum, alts);
+		if (r < 0) {
+			printk(KERN_ERR "usblp: can't set desired altsetting %d on interface %d\n",
+				alts, usblp->ifnum);
+			return r;
+		}
 	}
 
 	usblp->bidir = (usblp->protocol[protocol].epread != NULL);


