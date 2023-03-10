Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 353266B40AF
	for <lists+stable@lfdr.de>; Fri, 10 Mar 2023 14:45:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229523AbjCJNo6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 10 Mar 2023 08:44:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43086 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230195AbjCJNox (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 10 Mar 2023 08:44:53 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CDA9F87A0C
        for <stable@vger.kernel.org>; Fri, 10 Mar 2023 05:44:52 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 723A6617CB
        for <stable@vger.kernel.org>; Fri, 10 Mar 2023 13:44:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 63F9EC433D2;
        Fri, 10 Mar 2023 13:44:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678455891;
        bh=0sMP6g/a/9ZpoYbQSM8nb0evnlGRG2epWHW6D+u5S8I=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=A7R1xrmWNoQbCC8agtn4mM7xx/OM7NGWCEc4k9feCTy4in1XLm3v5E7fJTKJfOIqs
         sKPnUTSW5fofvDc06AUXahj7mkwONJK26D7Ws+ya80ZOcxFkYQ4VZFDQLffNHvnzYf
         ZdLEye5DFUWdl8jkivQCxTbn46cO8qXswu6sDYA4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Alan Stern <stern@rowland.harvard.edu>,
        Troels Liebe Bentsen <troels@connectedcars.dk>
Subject: [PATCH 4.14 011/193] USB: core: Dont hold device lock while reading the "descriptors" sysfs file
Date:   Fri, 10 Mar 2023 14:36:33 +0100
Message-Id: <20230310133711.307709237@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230310133710.926811681@linuxfoundation.org>
References: <20230310133710.926811681@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Alan Stern <stern@rowland.harvard.edu>

commit 45bf39f8df7f05efb83b302c65ae3b9bc92b7065 upstream.

Ever since commit 83e83ecb79a8 ("usb: core: get config and string
descriptors for unauthorized devices") was merged in 2013, there has
been no mechanism for reallocating the rawdescriptors buffers in
struct usb_device after the initial enumeration.  Before that commit,
the buffers would be deallocated when a device was deauthorized and
reallocated when it was authorized and enumerated.

This means that the locking in the read_descriptors() routine is not
needed, since the buffers it reads will never be reallocated while the
routine is running.  This locking can interfere with user programs
trying to read a hub's descriptors via sysfs while new child devices
of the hub are being initialized, since the hub is locked during this
procedure.

Since the locking in read_descriptors() hasn't been needed for over
nine years, we can remove it.

Reported-and-tested-by: Troels Liebe Bentsen <troels@connectedcars.dk>
Signed-off-by: Alan Stern <stern@rowland.harvard.edu>
CC: stable@vger.kernel.org
Link: https://lore.kernel.org/r/Y9l+wDTRbuZABzsE@rowland.harvard.edu
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/core/hub.c   |    5 ++---
 drivers/usb/core/sysfs.c |    5 -----
 2 files changed, 2 insertions(+), 8 deletions(-)

--- a/drivers/usb/core/hub.c
+++ b/drivers/usb/core/hub.c
@@ -2322,9 +2322,8 @@ static int usb_enumerate_device_otg(stru
  * usb_enumerate_device - Read device configs/intfs/otg (usbcore-internal)
  * @udev: newly addressed device (in ADDRESS state)
  *
- * This is only called by usb_new_device() and usb_authorize_device()
- * and FIXME -- all comments that apply to them apply here wrt to
- * environment.
+ * This is only called by usb_new_device() -- all comments that apply there
+ * apply here wrt to environment.
  *
  * If the device is WUSB and not authorized, we don't attempt to read
  * the string descriptors, as they will be errored out by the device
--- a/drivers/usb/core/sysfs.c
+++ b/drivers/usb/core/sysfs.c
@@ -865,11 +865,7 @@ read_descriptors(struct file *filp, stru
 	size_t srclen, n;
 	int cfgno;
 	void *src;
-	int retval;
 
-	retval = usb_lock_device_interruptible(udev);
-	if (retval < 0)
-		return -EINTR;
 	/* The binary attribute begins with the device descriptor.
 	 * Following that are the raw descriptor entries for all the
 	 * configurations (config plus subsidiary descriptors).
@@ -894,7 +890,6 @@ read_descriptors(struct file *filp, stru
 			off -= srclen;
 		}
 	}
-	usb_unlock_device(udev);
 	return count - nleft;
 }
 


