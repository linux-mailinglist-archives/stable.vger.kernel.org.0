Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 02F4442BB12
	for <lists+stable@lfdr.de>; Wed, 13 Oct 2021 11:04:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233158AbhJMJGb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 13 Oct 2021 05:06:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:35960 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234117AbhJMJGb (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 13 Oct 2021 05:06:31 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9593A61053;
        Wed, 13 Oct 2021 09:04:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1634115868;
        bh=vY7C3t5bPKFnW09/W8BGqFgbLA+26agA8d7jItcT7Io=;
        h=Subject:To:From:Date:From;
        b=ISIzOsB8g8bJ1CzKXxdUVg5GcrhTxzqEMf129V/RvXUXCOP77Q+thWBgnljgrw72l
         RHQo2yPxwZaSvz/zoD6f1Qzm/BUUVJ15YdkBBHDFPXfufi0csIG2ThBcuY5yeCGIAq
         yDQOzHgT2GKkdYfN8WAqG2Chb/y/XTZ4hglPAXuo=
Subject: patch "mei: hbm: drop hbm responses on early shutdown" added to char-misc-linus
To:     alexander.usyskin@intel.com, gregkh@linuxfoundation.org,
        stable@vger.kernel.org, tomas.winkler@intel.com
From:   <gregkh@linuxfoundation.org>
Date:   Wed, 13 Oct 2021 11:04:25 +0200
Message-ID: <1634115865147175@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    mei: hbm: drop hbm responses on early shutdown

to my char-misc git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/char-misc.git
in the char-misc-linus branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will hopefully also be merged in Linus's tree for the
next -rc kernel release.

If you have any questions about this process, please let me know.


From 6d7163f2c49fda5658e43105a96b555c89a4548d Mon Sep 17 00:00:00 2001
From: Alexander Usyskin <alexander.usyskin@intel.com>
Date: Wed, 13 Oct 2021 10:45:52 +0300
Subject: mei: hbm: drop hbm responses on early shutdown

Drop HBM responses also in the early shutdown phase where
the usual traffic is allowed.
Extend the rule that drop HBM responses received during the shutdown phase
by also in MEI_DEV_POWERING_DOWN state.
This resolves the stall if the driver is stopping in the middle
of the link init or link reset.

Fixes: da3eb47c90d4 ("mei: hbm: drop hbm responses on shutdown")
Fixes: 36edb1407c3c ("mei: allow clients on bus to communicate in remove callback")
Cc: <stable@vger.kernel.org> # v5.12+
Signed-off-by: Alexander Usyskin <alexander.usyskin@intel.com>
Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
Link: https://lore.kernel.org/r/20211013074552.2278419-1-tomas.winkler@intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/misc/mei/hbm.c | 12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

diff --git a/drivers/misc/mei/hbm.c b/drivers/misc/mei/hbm.c
index 99b5c1ecc444..be41843df75b 100644
--- a/drivers/misc/mei/hbm.c
+++ b/drivers/misc/mei/hbm.c
@@ -1298,7 +1298,8 @@ int mei_hbm_dispatch(struct mei_device *dev, struct mei_msg_hdr *hdr)
 
 		if (dev->dev_state != MEI_DEV_INIT_CLIENTS ||
 		    dev->hbm_state != MEI_HBM_STARTING) {
-			if (dev->dev_state == MEI_DEV_POWER_DOWN) {
+			if (dev->dev_state == MEI_DEV_POWER_DOWN ||
+			    dev->dev_state == MEI_DEV_POWERING_DOWN) {
 				dev_dbg(dev->dev, "hbm: start: on shutdown, ignoring\n");
 				return 0;
 			}
@@ -1381,7 +1382,8 @@ int mei_hbm_dispatch(struct mei_device *dev, struct mei_msg_hdr *hdr)
 
 		if (dev->dev_state != MEI_DEV_INIT_CLIENTS ||
 		    dev->hbm_state != MEI_HBM_DR_SETUP) {
-			if (dev->dev_state == MEI_DEV_POWER_DOWN) {
+			if (dev->dev_state == MEI_DEV_POWER_DOWN ||
+			    dev->dev_state == MEI_DEV_POWERING_DOWN) {
 				dev_dbg(dev->dev, "hbm: dma setup response: on shutdown, ignoring\n");
 				return 0;
 			}
@@ -1448,7 +1450,8 @@ int mei_hbm_dispatch(struct mei_device *dev, struct mei_msg_hdr *hdr)
 
 		if (dev->dev_state != MEI_DEV_INIT_CLIENTS ||
 		    dev->hbm_state != MEI_HBM_CLIENT_PROPERTIES) {
-			if (dev->dev_state == MEI_DEV_POWER_DOWN) {
+			if (dev->dev_state == MEI_DEV_POWER_DOWN ||
+			    dev->dev_state == MEI_DEV_POWERING_DOWN) {
 				dev_dbg(dev->dev, "hbm: properties response: on shutdown, ignoring\n");
 				return 0;
 			}
@@ -1490,7 +1493,8 @@ int mei_hbm_dispatch(struct mei_device *dev, struct mei_msg_hdr *hdr)
 
 		if (dev->dev_state != MEI_DEV_INIT_CLIENTS ||
 		    dev->hbm_state != MEI_HBM_ENUM_CLIENTS) {
-			if (dev->dev_state == MEI_DEV_POWER_DOWN) {
+			if (dev->dev_state == MEI_DEV_POWER_DOWN ||
+			    dev->dev_state == MEI_DEV_POWERING_DOWN) {
 				dev_dbg(dev->dev, "hbm: enumeration response: on shutdown, ignoring\n");
 				return 0;
 			}
-- 
2.33.0


