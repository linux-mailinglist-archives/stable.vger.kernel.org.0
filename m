Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D68FF3786FA
	for <lists+stable@lfdr.de>; Mon, 10 May 2021 13:32:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233921AbhEJLMf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 May 2021 07:12:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:36656 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235778AbhEJLGH (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 10 May 2021 07:06:07 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8FD4961432;
        Mon, 10 May 2021 10:56:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620644172;
        bh=Ef1iNY3LV1+geSqjKTWCHHmqZlGPYGe+YirmUhwHamY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Sm0Halp/S3GuH0CWjxRklCw6TO3tORozRAE8k1EHb+PhMmE412sYOwhVajz83jpiA
         bRzGkxj1YcUAi8nSgjp3YajDIaYsPJlAAKGpnfm45JZolm+WlhfAU0cZNFrLnrtZb+
         +TvC4VW6tCabUUUEX+dPjyCGdAlaatKj16o+UURM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Takashi Iwai <tiwai@suse.de>,
        Sean Young <sean@mess.org>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Subject: [PATCH 5.11 315/342] media: dvb-usb: Fix memory leak at error in dvb_usb_device_init()
Date:   Mon, 10 May 2021 12:21:45 +0200
Message-Id: <20210510102020.529138871@linuxfoundation.org>
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

commit 13a79f14ab285120bc4977e00a7c731e8143f548 upstream.

dvb_usb_device_init() allocates a dvb_usb_device object, but it
doesn't release the object by itself even at errors.  The object is
released in the callee side (dvb_usb_init()) in some error cases via
dvb_usb_exit() call, but it also missed the object free in other error
paths.  And, the caller (it's only dvb_usb_device_init()) doesn't seem
caring the resource management as well, hence those memories are
leaked.

This patch assures releasing the memory at the error path in
dvb_usb_device_init().  Now dvb_usb_init() frees the resources it
allocated but leaves the passed dvb_usb_device object intact.  In
turn, the dvb_usb_device object is released in dvb_usb_device_init()
instead.
We could use dvb_usb_exit() function for releasing everything in the
callee (as it was used for some error cases in the original code), but
releasing the passed object in the callee is non-intuitive and
error-prone.  So I took this approach (which is more standard in Linus
kernel code) although it ended with a bit more open codes.

Along with the change, the patch makes sure that USB intfdata is reset
and don't return the bogus pointer to the caller of
dvb_usb_device_init() at the error path, too.

Cc: <stable@vger.kernel.org>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sean Young <sean@mess.org>
Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/media/usb/dvb-usb/dvb-usb-init.c |   47 ++++++++++++++++++++-----------
 1 file changed, 31 insertions(+), 16 deletions(-)

--- a/drivers/media/usb/dvb-usb/dvb-usb-init.c
+++ b/drivers/media/usb/dvb-usb/dvb-usb-init.c
@@ -170,22 +170,20 @@ static int dvb_usb_init(struct dvb_usb_d
 
 		if (d->props.priv_init != NULL) {
 			ret = d->props.priv_init(d);
-			if (ret != 0) {
-				kfree(d->priv);
-				d->priv = NULL;
-				return ret;
-			}
+			if (ret != 0)
+				goto err_priv_init;
 		}
 	}
 
 	/* check the capabilities and set appropriate variables */
 	dvb_usb_device_power_ctrl(d, 1);
 
-	if ((ret = dvb_usb_i2c_init(d)) ||
-		(ret = dvb_usb_adapter_init(d, adapter_nums))) {
-		dvb_usb_exit(d);
-		return ret;
-	}
+	ret = dvb_usb_i2c_init(d);
+	if (ret)
+		goto err_i2c_init;
+	ret = dvb_usb_adapter_init(d, adapter_nums);
+	if (ret)
+		goto err_adapter_init;
 
 	if ((ret = dvb_usb_remote_init(d)))
 		err("could not initialize remote control.");
@@ -193,6 +191,17 @@ static int dvb_usb_init(struct dvb_usb_d
 	dvb_usb_device_power_ctrl(d, 0);
 
 	return 0;
+
+err_adapter_init:
+	dvb_usb_adapter_exit(d);
+err_i2c_init:
+	dvb_usb_i2c_exit(d);
+	if (d->priv && d->props.priv_destroy)
+		d->props.priv_destroy(d);
+err_priv_init:
+	kfree(d->priv);
+	d->priv = NULL;
+	return ret;
 }
 
 /* determine the name and the state of the just found USB device */
@@ -296,15 +305,21 @@ int dvb_usb_device_init(struct usb_inter
 
 	usb_set_intfdata(intf, d);
 
-	if (du != NULL)
+	ret = dvb_usb_init(d, adapter_nums);
+	if (ret) {
+		info("%s error while loading driver (%d)", desc->name, ret);
+		goto error;
+	}
+
+	if (du)
 		*du = d;
 
-	ret = dvb_usb_init(d, adapter_nums);
+	info("%s successfully initialized and connected.", desc->name);
+	return 0;
 
-	if (ret == 0)
-		info("%s successfully initialized and connected.", desc->name);
-	else
-		info("%s error while loading driver (%d)", desc->name, ret);
+ error:
+	usb_set_intfdata(intf, NULL);
+	kfree(d);
 	return ret;
 }
 EXPORT_SYMBOL(dvb_usb_device_init);


