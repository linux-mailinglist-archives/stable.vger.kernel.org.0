Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 05903EFD0E
	for <lists+stable@lfdr.de>; Tue,  5 Nov 2019 13:19:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730816AbfKEMTi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Nov 2019 07:19:38 -0500
Received: from mga09.intel.com ([134.134.136.24]:9770 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726612AbfKEMTi (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 5 Nov 2019 07:19:38 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga102.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 05 Nov 2019 04:19:36 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.68,271,1569308400"; 
   d="scan'208";a="200359807"
Received: from twinkler-lnx.jer.intel.com ([10.12.91.155])
  by fmsmga008.fm.intel.com with ESMTP; 05 Nov 2019 04:19:34 -0800
From:   Tomas Winkler <tomas.winkler@intel.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Alexander Usyskin <alexander.usyskin@intel.com>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Tomas Winkler <tomas.winkler@intel.com>
Subject: [char-misc 1/2] mei: bus: prefix device names on bus with the bus name
Date:   Tue,  5 Nov 2019 17:05:13 +0200
Message-Id: <20191105150514.14010-1-tomas.winkler@intel.com>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Alexander Usyskin <alexander.usyskin@intel.com>

Add parent device name to the name of devices on bus to avoid
device names collisions for same client UUID available
from different MEI heads. Namely this prevents sysfs collision under
/sys/bus/mei/device/

In the device part leave just UUID other parameters that are
required for device matching are not required here and are
just bloating the name.

Cc: <stable@vger.kernel.org>
Signed-off-by: Alexander Usyskin <alexander.usyskin@intel.com>
Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
---
 drivers/misc/mei/bus.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/drivers/misc/mei/bus.c b/drivers/misc/mei/bus.c
index 985bd4fd3328..53bb394ccba6 100644
--- a/drivers/misc/mei/bus.c
+++ b/drivers/misc/mei/bus.c
@@ -873,15 +873,16 @@ static const struct device_type mei_cl_device_type = {
 
 /**
  * mei_cl_bus_set_name - set device name for me client device
+ *  <controller>-<client device>
+ *  Example: 0000:00:16.0-55213584-9a29-4916-badf-0fb7ed682aeb
  *
  * @cldev: me client device
  */
 static inline void mei_cl_bus_set_name(struct mei_cl_device *cldev)
 {
-	dev_set_name(&cldev->dev, "mei:%s:%pUl:%02X",
-		     cldev->name,
-		     mei_me_cl_uuid(cldev->me_cl),
-		     mei_me_cl_ver(cldev->me_cl));
+	dev_set_name(&cldev->dev, "%s-%pUl",
+		     dev_name(cldev->bus->dev),
+		     mei_me_cl_uuid(cldev->me_cl));
 }
 
 /**
-- 
2.21.0

