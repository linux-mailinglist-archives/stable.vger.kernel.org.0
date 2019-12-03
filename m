Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 39DC9111BFA
	for <lists+stable@lfdr.de>; Tue,  3 Dec 2019 23:39:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727790AbfLCWjK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Dec 2019 17:39:10 -0500
Received: from mail.kernel.org ([198.145.29.99]:48910 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727798AbfLCWjI (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 3 Dec 2019 17:39:08 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AB87A207DD;
        Tue,  3 Dec 2019 22:39:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1575412748;
        bh=Bl5HF763uz37dvHlnO+fYfAMU1dfaMnL3BK6UUDKfgE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DTkOKbPo5XBEwISpnh9doLBQMqMyhrcliqrzrP0BkoczzqOmf/4OUk/ElKbecnPpK
         LrtjHXIL5dWsS2b8h6OoTXT6Npw+lDptvuT10oDtqvHSvsTmma/34meJvEwwyjWc/V
         07co0CfcKl4HesCZQbIUlg2vqHb9bOuWU/VnfQoY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Alexander Usyskin <alexander.usyskin@intel.com>,
        Tomas Winkler <tomas.winkler@intel.com>
Subject: [PATCH 5.4 12/46] mei: bus: prefix device names on bus with the bus name
Date:   Tue,  3 Dec 2019 23:35:32 +0100
Message-Id: <20191203212727.053014834@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191203212705.175425505@linuxfoundation.org>
References: <20191203212705.175425505@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Alexander Usyskin <alexander.usyskin@intel.com>

commit 7a2b9e6ec84588b0be65cc0ae45a65bac431496b upstream.

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
Link: https://lore.kernel.org/r/20191105150514.14010-1-tomas.winkler@intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/misc/mei/bus.c |    9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

--- a/drivers/misc/mei/bus.c
+++ b/drivers/misc/mei/bus.c
@@ -873,15 +873,16 @@ static const struct device_type mei_cl_d
 
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


