Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5D4506A7322
	for <lists+stable@lfdr.de>; Wed,  1 Mar 2023 19:13:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230101AbjCASNF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 1 Mar 2023 13:13:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47844 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230090AbjCASND (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 1 Mar 2023 13:13:03 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 37166E9
        for <stable@vger.kernel.org>; Wed,  1 Mar 2023 10:12:59 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E0EB4B810DD
        for <stable@vger.kernel.org>; Wed,  1 Mar 2023 18:12:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 42B43C433D2;
        Wed,  1 Mar 2023 18:12:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1677694376;
        bh=H+vbaKlF3niASkEneadwpflGYI2XXmOl/UHe6nopHvM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lU9Ikr99lrv56kxpG2+AsApnyUpIucf5dYYf8Io4W2OReutjoLuWBwf7DZesVEoai
         nfFrfJJvp8pFA56qNK1DWoKyi7TDo77lear/YEIZh0ts1uth4DqD76UXwJ3eknDIsE
         /0acGPmtIOZSkFyt5njWdIg3QCU2wYGopE7S8XbM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Alan Stern <stern@rowland.harvard.edu>,
        Troels Liebe Bentsen <troels@connectedcars.dk>
Subject: [PATCH 6.1 42/42] USB: core: Dont hold device lock while reading the "descriptors" sysfs file
Date:   Wed,  1 Mar 2023 19:09:03 +0100
Message-Id: <20230301180658.935092474@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230301180657.003689969@linuxfoundation.org>
References: <20230301180657.003689969@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
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
@@ -2389,9 +2389,8 @@ static int usb_enumerate_device_otg(stru
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
@@ -868,11 +868,7 @@ read_descriptors(struct file *filp, stru
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
@@ -897,7 +893,6 @@ read_descriptors(struct file *filp, stru
 			off -= srclen;
 		}
 	}
-	usb_unlock_device(udev);
 	return count - nleft;
 }
 


