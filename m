Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 481D12D9EFE
	for <lists+stable@lfdr.de>; Mon, 14 Dec 2020 19:30:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2408782AbgLNS1x (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Dec 2020 13:27:53 -0500
Received: from mail.kernel.org ([198.145.29.99]:45998 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2502298AbgLNRiC (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 14 Dec 2020 12:38:02 -0500
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Authentication-Results: mail.kernel.org; dkim=permerror (bad message/signature format)
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Maxime Ripard <mripard@kernel.org>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Subject: [PATCH 5.9 076/105] media: pulse8-cec: fix duplicate free at disconnect or probe error
Date:   Mon, 14 Dec 2020 18:28:50 +0100
Message-Id: <20201214172558.926155685@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201214172555.280929671@linuxfoundation.org>
References: <20201214172555.280929671@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Hans Verkuil <hverkuil-cisco@xs4all.nl>

commit 024e01dead12c2b9fbe31216f2099401ebb78a4a upstream.

Commit 601282d65b96 ("media: pulse8-cec: use adap_free callback") used
the adap_free callback to clean up on disconnect. What I forgot was that
in the probe it will call cec_delete_adapter() followed by kfree(pulse8)
if an error occurs. But by using the adap_free callback,
cec_delete_adapter() is already freeing the pulse8 struct.

This wasn't noticed since normally the probe works fine, but Pulse-Eight
published a new firmware version that caused a probe error, so now it
hits this bug. This affects firmware version 12, but probably any
version >= 10.

Commit aa9eda76129c ("media: pulse8-cec: close serio in disconnect, not
adap_free") made this worse by adding the line 'pulse8->serio = NULL'
right after the call to cec_unregister_adapter in the disconnect()
function. Unfortunately, cec_unregister_adapter will typically call
cec_delete_adapter (unless a filehandle to the cec device is still
open), which frees the pulse8 struct. So now it will also crash on a
simple unplug of the Pulse-Eight device.

With this fix both the unplug issue and a probe() error situation are
handled correctly again.

It will still fail to probe() with a v12 firmware, that's something
to look at separately.

Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Reported-by: Maxime Ripard <mripard@kernel.org>
Tested-by: Maxime Ripard <mripard@kernel.org>
Fixes: aa9eda76129c ("media: pulse8-cec: close serio in disconnect, not adap_free")
Fixes: 601282d65b96 ("media: pulse8-cec: use adap_free callback")
Cc: <stable@vger.kernel.org>
Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/media/cec/usb/pulse8/pulse8-cec.c |    9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

--- a/drivers/media/cec/usb/pulse8/pulse8-cec.c
+++ b/drivers/media/cec/usb/pulse8/pulse8-cec.c
@@ -650,7 +650,6 @@ static void pulse8_disconnect(struct ser
 	struct pulse8 *pulse8 = serio_get_drvdata(serio);
 
 	cec_unregister_adapter(pulse8->adap);
-	pulse8->serio = NULL;
 	serio_set_drvdata(serio, NULL);
 	serio_close(serio);
 }
@@ -830,8 +829,10 @@ static int pulse8_connect(struct serio *
 	pulse8->adap = cec_allocate_adapter(&pulse8_cec_adap_ops, pulse8,
 					    dev_name(&serio->dev), caps, 1);
 	err = PTR_ERR_OR_ZERO(pulse8->adap);
-	if (err < 0)
-		goto free_device;
+	if (err < 0) {
+		kfree(pulse8);
+		return err;
+	}
 
 	pulse8->dev = &serio->dev;
 	serio_set_drvdata(serio, pulse8);
@@ -874,8 +875,6 @@ close_serio:
 	serio_close(serio);
 delete_adap:
 	cec_delete_adapter(pulse8->adap);
-free_device:
-	kfree(pulse8);
 	return err;
 }
 


