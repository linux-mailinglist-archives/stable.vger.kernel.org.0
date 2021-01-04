Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D58FF2E9947
	for <lists+stable@lfdr.de>; Mon,  4 Jan 2021 16:56:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727785AbhADPzv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 4 Jan 2021 10:55:51 -0500
Received: from mail.kernel.org ([198.145.29.99]:35598 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727784AbhADPzv (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 4 Jan 2021 10:55:51 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 42E122250F;
        Mon,  4 Jan 2021 15:55:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609775706;
        bh=+TZQagKTU4XOSQaIPzlZSdVWhyUyrNZpBjYyPYgB22o=;
        h=Subject:To:From:Date:From;
        b=q0HWviywfG7Ko6aQGFCMABmPMr06i6yPtqNTys57odBIdCiQst9TbGEPNTzwhaeK5
         TNoHa0KzXxCqNu7QbLa0UhPEasBxoDd6Z1mMdqQ/8UxuwGikVlckdlOZSZIxDVeypl
         kwrN7EWZxCFjJIpGPc5f2JC5o6qnmzheUD0DOniE=
Subject: patch "usb: gadget: configfs: Preserve function ordering after bind failure" added to usb-linus
To:     cchiluve@codeaurora.org, gregkh@linuxfoundation.org,
        jackp@codeaurora.org, peter.chen@nxp.com, stable@vger.kernel.org
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 04 Jan 2021 16:56:32 +0100
Message-ID: <16097757925158@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    usb: gadget: configfs: Preserve function ordering after bind failure

to my usb git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/usb.git
in the usb-linus branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will hopefully also be merged in Linus's tree for the
next -rc kernel release.

If you have any questions about this process, please let me know.


From 6cd0fe91387917be48e91385a572a69dfac2f3f7 Mon Sep 17 00:00:00 2001
From: Chandana Kishori Chiluveru <cchiluve@codeaurora.org>
Date: Tue, 29 Dec 2020 14:44:43 -0800
Subject: usb: gadget: configfs: Preserve function ordering after bind failure

When binding the ConfigFS gadget to a UDC, the functions in each
configuration are added in list order. However, if usb_add_function()
fails, the failed function is put back on its configuration's
func_list and purge_configs_funcs() is called to further clean up.

purge_configs_funcs() iterates over the configurations and functions
in forward order, calling unbind() on each of the previously added
functions. But after doing so, each function gets moved to the
tail of the configuration's func_list. This results in reshuffling
the original order of the functions within a configuration such
that the failed function now appears first even though it may have
originally appeared in the middle or even end of the list. At this
point if the ConfigFS gadget is attempted to re-bind to the UDC,
the functions will be added in a different order than intended,
with the only recourse being to remove and relink the functions all
over again.

An example of this as follows:

ln -s functions/mass_storage.0 configs/c.1
ln -s functions/ncm.0 configs/c.1
ln -s functions/ffs.adb configs/c.1	# oops, forgot to start adbd
echo "<udc device>" > UDC		# fails
start adbd
echo "<udc device>" > UDC		# now succeeds, but...
					# bind order is
					# "ADB", mass_storage, ncm

[30133.118289] configfs-gadget gadget: adding 'Mass Storage Function'/ffffff810af87200 to config 'c'/ffffff817d6a2520
[30133.119875] configfs-gadget gadget: adding 'cdc_network'/ffffff80f48d1a00 to config 'c'/ffffff817d6a2520
[30133.119974] using random self ethernet address
[30133.120002] using random host ethernet address
[30133.139604] usb0: HOST MAC 3e:27:46:ba:3e:26
[30133.140015] usb0: MAC 6e:28:7e:42:66:6a
[30133.140062] configfs-gadget gadget: adding 'Function FS Gadget'/ffffff80f3868438 to config 'c'/ffffff817d6a2520
[30133.140081] configfs-gadget gadget: adding 'Function FS Gadget'/ffffff80f3868438 --> -19
[30133.140098] configfs-gadget gadget: unbind function 'Mass Storage Function'/ffffff810af87200
[30133.140119] configfs-gadget gadget: unbind function 'cdc_network'/ffffff80f48d1a00
[30133.173201] configfs-gadget a600000.dwc3: failed to start g1: -19
[30136.661933] init: starting service 'adbd'...
[30136.700126] read descriptors
[30136.700413] read strings
[30138.574484] configfs-gadget gadget: adding 'Function FS Gadget'/ffffff80f3868438 to config 'c'/ffffff817d6a2520
[30138.575497] configfs-gadget gadget: adding 'Mass Storage Function'/ffffff810af87200 to config 'c'/ffffff817d6a2520
[30138.575554] configfs-gadget gadget: adding 'cdc_network'/ffffff80f48d1a00 to config 'c'/ffffff817d6a2520
[30138.575631] using random self ethernet address
[30138.575660] using random host ethernet address
[30138.595338] usb0: HOST MAC 2e:cf:43:cd:ca:c8
[30138.597160] usb0: MAC 6a:f0:9f:ee:82:a0
[30138.791490] configfs-gadget gadget: super-speed config #1: c

Fix this by reversing the iteration order of the functions in
purge_config_funcs() when unbinding them, and adding them back to
the config's func_list at the head instead of the tail. This
ensures that we unbind and unwind back to the original list order.

Fixes: 88af8bbe4ef7 ("usb: gadget: the start of the configfs interface")
Signed-off-by: Chandana Kishori Chiluveru <cchiluve@codeaurora.org>
Signed-off-by: Jack Pham <jackp@codeaurora.org>
Reviewed-by: Peter Chen <peter.chen@nxp.com>
Link: https://lore.kernel.org/r/20201229224443.31623-1-jackp@codeaurora.org
Cc: stable <stable@vger.kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/gadget/configfs.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/usb/gadget/configfs.c b/drivers/usb/gadget/configfs.c
index d9743f4b56c3..408a5332a975 100644
--- a/drivers/usb/gadget/configfs.c
+++ b/drivers/usb/gadget/configfs.c
@@ -1255,9 +1255,9 @@ static void purge_configs_funcs(struct gadget_info *gi)
 
 		cfg = container_of(c, struct config_usb_cfg, c);
 
-		list_for_each_entry_safe(f, tmp, &c->functions, list) {
+		list_for_each_entry_safe_reverse(f, tmp, &c->functions, list) {
 
-			list_move_tail(&f->list, &cfg->func_list);
+			list_move(&f->list, &cfg->func_list);
 			if (f->unbind) {
 				dev_dbg(&gi->cdev.gadget->dev,
 					"unbind function '%s'/%p\n",
-- 
2.30.0


