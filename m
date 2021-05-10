Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1F0B43786F8
	for <lists+stable@lfdr.de>; Mon, 10 May 2021 13:32:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233435AbhEJLMb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 May 2021 07:12:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:36488 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235768AbhEJLGF (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 10 May 2021 07:06:05 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2B536613D3;
        Mon, 10 May 2021 10:56:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620644169;
        bh=vmRwiyypgVbsZ/+3FOlU9DN916jLITD/t3fXolfSu7k=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=OLsZ1KAokE8yAH498jokP9E3NdLxh730g7PSrPAy8FUtEo+EAsTSz70moNQd8jEF/
         F1X9v9QgRI+3AxEW2ebbqzlmiKE99ZDdfdRMPeYACaloNbETThOVpn7LFRiTG5CT7v
         I28peqptxfNP3Pm1lusfajxrwGLAvxuDfI+4jw5M=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Robert Foss <robert.foss@linaro.org>,
        Takashi Iwai <tiwai@suse.de>, Sean Young <sean@mess.org>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        Stefan Seyfried <seife+kernel@b1-systems.com>
Subject: [PATCH 5.11 314/342] media: dvb-usb: Fix use-after-free access
Date:   Mon, 10 May 2021 12:21:44 +0200
Message-Id: <20210510102020.488034321@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210510102010.096403571@linuxfoundation.org>
References: <20210510102010.096403571@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Takashi Iwai <tiwai@suse.de>

commit c49206786ee252f28b7d4d155d1fff96f145a05d upstream.

dvb_usb_device_init() copies the properties to the own data, so that
the callers can release the original properties later (as done in the
commit 299c7007e936 ("media: dw2102: Fix memleak on sequence of
probes")).  However, it also stores dev->desc pointer that is a
reference to the original properties data.  Since dev->desc is
referred later, it may result in use-after-free, in the worst case,
leading to a kernel Oops as reported.

This patch addresses the problem by allocating and copying the
properties at first, then get the desc from the copied properties.

Reported-and-tested-by: Stefan Seyfried <seife+kernel@b1-systems.com>
BugLink: http://bugzilla.opensuse.org/show_bug.cgi?id=1181104

Reviewed-by: Robert Foss <robert.foss@linaro.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sean Young <sean@mess.org>
Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/media/usb/dvb-usb/dvb-usb-init.c |   23 +++++++++++++----------
 1 file changed, 13 insertions(+), 10 deletions(-)

--- a/drivers/media/usb/dvb-usb/dvb-usb-init.c
+++ b/drivers/media/usb/dvb-usb/dvb-usb-init.c
@@ -267,27 +267,30 @@ int dvb_usb_device_init(struct usb_inter
 	if (du != NULL)
 		*du = NULL;
 
-	if ((desc = dvb_usb_find_device(udev, props, &cold)) == NULL) {
+	d = kzalloc(sizeof(*d), GFP_KERNEL);
+	if (!d) {
+		err("no memory for 'struct dvb_usb_device'");
+		return -ENOMEM;
+	}
+
+	memcpy(&d->props, props, sizeof(struct dvb_usb_device_properties));
+
+	desc = dvb_usb_find_device(udev, &d->props, &cold);
+	if (!desc) {
 		deb_err("something went very wrong, device was not found in current device list - let's see what comes next.\n");
-		return -ENODEV;
+		ret = -ENODEV;
+		goto error;
 	}
 
 	if (cold) {
 		info("found a '%s' in cold state, will try to load a firmware", desc->name);
 		ret = dvb_usb_download_firmware(udev, props);
 		if (!props->no_reconnect || ret != 0)
-			return ret;
+			goto error;
 	}
 
 	info("found a '%s' in warm state.", desc->name);
-	d = kzalloc(sizeof(struct dvb_usb_device), GFP_KERNEL);
-	if (d == NULL) {
-		err("no memory for 'struct dvb_usb_device'");
-		return -ENOMEM;
-	}
-
 	d->udev = udev;
-	memcpy(&d->props, props, sizeof(struct dvb_usb_device_properties));
 	d->desc = desc;
 	d->owner = owner;
 


