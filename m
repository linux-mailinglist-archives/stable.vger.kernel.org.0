Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 21A6465D5AC
	for <lists+stable@lfdr.de>; Wed,  4 Jan 2023 15:31:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234818AbjADObE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 Jan 2023 09:31:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53178 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229449AbjADObB (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 4 Jan 2023 09:31:01 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BBB172DC3
        for <stable@vger.kernel.org>; Wed,  4 Jan 2023 06:31:00 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 613C4B81674
        for <stable@vger.kernel.org>; Wed,  4 Jan 2023 14:30:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A625CC433EF;
        Wed,  4 Jan 2023 14:30:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672842658;
        bh=dqQHZK+EOM/vxMxuzzeMuzTq7m+zQlP4/3vDkNoRrsE=;
        h=Subject:To:Cc:From:Date:From;
        b=VLTzy1bkSAzpc4MIW/GyJeaf8ORJwgz+bU4hSidvOkipO5rHK9XPSuW1TCpmAnMbj
         nAqVAqBqi5fMlCux/l/rVEht0hbwSeqzhVxtopIJkMdAZ7q5g7fWyA0aPHzm6iuGbM
         knX9tnw/HHRXuE+hNyhXNU8XiCr4mfcAbdzXhqw4=
Subject: FAILED: patch "[PATCH] driver core: Fix bus_type.match() error handling in" failed to apply to 4.14-stable tree
To:     isaacmanjarres@google.com, gregkh@linuxfoundation.org,
        saravanak@google.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Wed, 04 Jan 2023 15:30:50 +0100
Message-ID: <16728426501987@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.14-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

Possible dependencies:

27c0d217340e ("driver core: Fix bus_type.match() error handling in __driver_attach()")
eb7fbc9fb118 ("driver core: Add missing '\n' in log messages")
64c775fb4b21 ("driver core: Rename deferred_probe_timeout and make it global")
0e9f8d09d280 ("driver core: Remove driver_deferred_probe_check_state_continue()")
e2cec7d68537 ("driver core: Set deferred_probe_timeout to a longer default if CONFIG_MODULES is set")
c8c43cee29f6 ("driver core: Fix driver_deferred_probe_check_state() logic")
4c002c978b7f ("device.h: move 'struct driver' stuff out to device/driver.h")
a8ae608529ab ("device.h: move 'struct class' stuff out to device/class.h")
5aee2bf2629d ("device.h: move 'struct bus' stuff out to device/bus.h")
fc5a251d0fd7 ("driver core: Add sync_state driver/bus callback")
e2ae9bcc4aaa ("driver core: Add support for linking devices during device addition")
372a67c0c5ef ("driver core: Add fwnode_to_dev() to look up device from fwnode")
bfb3943bed67 ("Revert "driver core: Add support for linking devices during device addition"")
33cbfe544993 ("Revert "driver core: Add edit_links() callback for drivers"")
bcca686c11cd ("Revert "driver core: Add sync_state driver/bus callback"")
1f573cce48a2 ("device.h: Fix warnings for mismatched parameter names in comments")
97e2551de3f9 ("Merge tag 'dev_groups_all_drivers' into driver-core-next")

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 27c0d217340e47ec995557f61423ef415afba987 Mon Sep 17 00:00:00 2001
From: "Isaac J. Manjarres" <isaacmanjarres@google.com>
Date: Tue, 20 Sep 2022 17:14:13 -0700
Subject: [PATCH] driver core: Fix bus_type.match() error handling in
 __driver_attach()

When a driver registers with a bus, it will attempt to match with every
device on the bus through the __driver_attach() function. Currently, if
the bus_type.match() function encounters an error that is not
-EPROBE_DEFER, __driver_attach() will return a negative error code, which
causes the driver registration logic to stop trying to match with the
remaining devices on the bus.

This behavior is not correct; a failure while matching a driver to a
device does not mean that the driver won't be able to match and bind
with other devices on the bus. Update the logic in __driver_attach()
to reflect this.

Fixes: 656b8035b0ee ("ARM: 8524/1: driver cohandle -EPROBE_DEFER from bus_type.match()")
Cc: stable@vger.kernel.org
Cc: Saravana Kannan <saravanak@google.com>
Signed-off-by: Isaac J. Manjarres <isaacmanjarres@google.com>
Link: https://lore.kernel.org/r/20220921001414.4046492-1-isaacmanjarres@google.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

diff --git a/drivers/base/dd.c b/drivers/base/dd.c
index 4001e22617ab..e9b2f9c25efe 100644
--- a/drivers/base/dd.c
+++ b/drivers/base/dd.c
@@ -1162,7 +1162,11 @@ static int __driver_attach(struct device *dev, void *data)
 		return 0;
 	} else if (ret < 0) {
 		dev_dbg(dev, "Bus failed to match device: %d\n", ret);
-		return ret;
+		/*
+		 * Driver could not match with device, but may match with
+		 * another device on the bus.
+		 */
+		return 0;
 	} /* ret > 0 means positive match */
 
 	if (driver_allows_async_probing(drv)) {

