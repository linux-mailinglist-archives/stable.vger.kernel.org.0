Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A75FB99CFF
	for <lists+stable@lfdr.de>; Thu, 22 Aug 2019 19:39:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391551AbfHVRiw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 22 Aug 2019 13:38:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:45812 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2391535AbfHVRYW (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 22 Aug 2019 13:24:22 -0400
Received: from localhost (wsip-184-188-36-2.sd.sd.cox.net [184.188.36.2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B777C21743;
        Thu, 22 Aug 2019 17:24:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1566494661;
        bh=JhDJFf/uCjrXkIsJfuzBaAiGGlV24nhfnGt6L1EGX+8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MXhQ1eWwrgLX24cWdfz9wDrysJsxgYeqnToKCwQkMsf6DQmzkmaslYchqE31gOWvq
         fV1H9lH8HLn2xEbk6Ml8trPJk7nfRP/QXB/QGquFT86KswKMDCq0ZosFIcx+Z4putc
         p7d/bCLVUl8/f+k+jR6OVHheisQWMV1InUl33PBc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Oliver Neukum <oneukum@suse.com>,
        syzbot+1b2449b7b5dc240d107a@syzkaller.appspotmail.com
Subject: [PATCH 4.9 084/103] usb: cdc-acm: make sure a refcount is taken early enough
Date:   Thu, 22 Aug 2019 10:19:12 -0700
Message-Id: <20190822171732.543001370@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20190822171728.445189830@linuxfoundation.org>
References: <20190822171728.445189830@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Oliver Neukum <oneukum@suse.com>

commit c52873e5a1ef72f845526d9f6a50704433f9c625 upstream.

destroy() will decrement the refcount on the interface, so that
it needs to be taken so early that it never undercounts.

Fixes: 7fb57a019f94e ("USB: cdc-acm: Fix potential deadlock (lockdep warning)")
Cc: stable <stable@vger.kernel.org>
Reported-and-tested-by: syzbot+1b2449b7b5dc240d107a@syzkaller.appspotmail.com
Signed-off-by: Oliver Neukum <oneukum@suse.com>
Link: https://lore.kernel.org/r/20190808142119.7998-1-oneukum@suse.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/usb/class/cdc-acm.c |   12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

--- a/drivers/usb/class/cdc-acm.c
+++ b/drivers/usb/class/cdc-acm.c
@@ -1264,10 +1264,6 @@ made_compressed_probe:
 	if (acm == NULL)
 		goto alloc_fail;
 
-	minor = acm_alloc_minor(acm);
-	if (minor < 0)
-		goto alloc_fail1;
-
 	ctrlsize = usb_endpoint_maxp(epctrl);
 	readsize = usb_endpoint_maxp(epread) *
 				(quirks == SINGLE_RX_URB ? 1 : 2);
@@ -1275,6 +1271,13 @@ made_compressed_probe:
 	acm->writesize = usb_endpoint_maxp(epwrite) * 20;
 	acm->control = control_interface;
 	acm->data = data_interface;
+
+	usb_get_intf(acm->control); /* undone in destruct() */
+
+	minor = acm_alloc_minor(acm);
+	if (minor < 0)
+		goto alloc_fail1;
+
 	acm->minor = minor;
 	acm->dev = usb_dev;
 	if (h.usb_cdc_acm_descriptor)
@@ -1420,7 +1423,6 @@ skip_countries:
 	usb_driver_claim_interface(&acm_driver, data_interface, acm);
 	usb_set_intfdata(data_interface, acm);
 
-	usb_get_intf(control_interface);
 	tty_dev = tty_port_register_device(&acm->port, acm_tty_driver, minor,
 			&control_interface->dev);
 	if (IS_ERR(tty_dev)) {


