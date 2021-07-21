Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E65C63D0996
	for <lists+stable@lfdr.de>; Wed, 21 Jul 2021 09:17:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234399AbhGUGg6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 21 Jul 2021 02:36:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:57218 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234804AbhGUGg2 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 21 Jul 2021 02:36:28 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A04A361029;
        Wed, 21 Jul 2021 07:17:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626851825;
        bh=E/dOMI1CdHl52MYVIUTJjcRqU3UC0GnbzXRCACpGljY=;
        h=Subject:To:From:Date:From;
        b=TKGDtqCHFcbcKqxEHnTk5bkQ0ZtwcvCcFr8EAc0cMQJLyFGNrIKrjujOeYmnfEMGG
         jfnNFMu4pCEgq48eEQIbEBx0Z+wT+tRfFWolQH8zvMBs8I2S7whkTVLcLnauxX9jpe
         oA7KGMfUb2cqCayK/qRawtAsNPo0Lr+SNlIx+Wz0=
Subject: patch "usb: typec: stusb160x: Don't block probing of consumer of "connector"" added to usb-linus
To:     amelie.delaunay@foss.st.com, gregkh@linuxfoundation.org,
        stable@vger.kernel.org
From:   <gregkh@linuxfoundation.org>
Date:   Wed, 21 Jul 2021 09:16:55 +0200
Message-ID: <162685181546122@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    usb: typec: stusb160x: Don't block probing of consumer of "connector"

to my usb git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/usb.git
in the usb-linus branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will hopefully also be merged in Linus's tree for the
next -rc kernel release.

If you have any questions about this process, please let me know.


From 6b63376722d9e1b915a2948e9b30f4ba2712e3f5 Mon Sep 17 00:00:00 2001
From: Amelie Delaunay <amelie.delaunay@foss.st.com>
Date: Fri, 16 Jul 2021 14:07:18 +0200
Subject: usb: typec: stusb160x: Don't block probing of consumer of "connector"
 nodes

Similar as with tcpm this patch lets fw_devlink know not to wait on the
fwnode to be populated as a struct device.

Without this patch, USB functionality can be broken on some previously
supported boards.

Fixes: 28ec344bb891 ("usb: typec: tcpm: Don't block probing of consumers of "connector" nodes")
Cc: stable <stable@vger.kernel.org>
Signed-off-by: Amelie Delaunay <amelie.delaunay@foss.st.com>
Link: https://lore.kernel.org/r/20210716120718.20398-3-amelie.delaunay@foss.st.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/typec/stusb160x.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/drivers/usb/typec/stusb160x.c b/drivers/usb/typec/stusb160x.c
index 3d3848e7c2c2..e7745d1c2a5c 100644
--- a/drivers/usb/typec/stusb160x.c
+++ b/drivers/usb/typec/stusb160x.c
@@ -685,6 +685,15 @@ static int stusb160x_probe(struct i2c_client *client)
 	if (!fwnode)
 		return -ENODEV;
 
+	/*
+	 * This fwnode has a "compatible" property, but is never populated as a
+	 * struct device. Instead we simply parse it to read the properties.
+	 * This it breaks fw_devlink=on. To maintain backward compatibility
+	 * with existing DT files, we work around this by deleting any
+	 * fwnode_links to/from this fwnode.
+	 */
+	fw_devlink_purge_absent_suppliers(fwnode);
+
 	/*
 	 * When both VDD and VSYS power supplies are present, the low power
 	 * supply VSYS is selected when VSYS voltage is above 3.1 V.
-- 
2.32.0


