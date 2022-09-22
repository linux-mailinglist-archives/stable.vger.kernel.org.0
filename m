Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 255F15E6652
	for <lists+stable@lfdr.de>; Thu, 22 Sep 2022 16:59:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231543AbiIVO7c (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 22 Sep 2022 10:59:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42080 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231928AbiIVO7R (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 22 Sep 2022 10:59:17 -0400
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 679EBEFF59;
        Thu, 22 Sep 2022 07:59:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1663858748; x=1695394748;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=J+MofFu/9hh4F9OVzhNTVMGdV7rUkF3YVT2GbTGNLB4=;
  b=QFW0bjBeMWIBtiryDiJB6G7iYnqSxBInBkX552dQUb1o9hyJyggbkJnc
   DzQY0Fo1eGcAcrjN74/suZYYuciLw8pa1tYCJtoBn8bNwmzf5u4a2brxp
   S/2h5i3M6LDnlVQkwfX060GZ90EN7+N3GNQitWlNBipouRoX4MK1Bvsiw
   w5trcHpWZ1SpKQYmvBVgrG5FajlPS1QtdPO14w7O1OWmvRZlpGGkl1tbB
   4QfZi5DpY298fFtjSXstAVyGhZC+tSTFOQ/+zCK7T1RqqKPd8kkGX6sgL
   qYTBDCroAqIP78JsE2OI2J+Uif9cVUWzh0Fb7ETTBPxvKpwW1ImuxCuEq
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10478"; a="287399796"
X-IronPort-AV: E=Sophos;i="5.93,335,1654585200"; 
   d="scan'208";a="287399796"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Sep 2022 07:59:07 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.93,335,1654585200"; 
   d="scan'208";a="762210732"
Received: from black.fi.intel.com (HELO black.fi.intel.com.) ([10.237.72.28])
  by fmsmga001.fm.intel.com with ESMTP; 22 Sep 2022 07:59:06 -0700
From:   Heikki Krogerus <heikki.krogerus@linux.intel.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-usb@vger.kernel.org, Paul Menzel <pmenzel@molgen.mpg.de>,
        stable@vger.kernel.org
Subject: [PATCH v1] usb: typec: ucsi: Remove incorrect warning
Date:   Thu, 22 Sep 2022 17:59:24 +0300
Message-Id: <20220922145924.80667-1-heikki.krogerus@linux.intel.com>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Sink only devices do not have any source capabilities, so
the driver should not warn about that. Also DRP (Dual Role
Power) capable devices, such as USB Type-C docking stations,
do not return any source capabilities unless they are
plugged to a power supply themselves.

Fixes: 1f4642b72be7 ("usb: typec: ucsi: Retrieve all the PDOs instead of just the first 4")
Reported-by: Paul Menzel <pmenzel@molgen.mpg.de>
Cc: <stable@vger.kernel.org>
Signed-off-by: Heikki Krogerus <heikki.krogerus@linux.intel.com>
---
 drivers/usb/typec/ucsi/ucsi.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/usb/typec/ucsi/ucsi.c b/drivers/usb/typec/ucsi/ucsi.c
index 7f2624f427241..6364f0d467ea3 100644
--- a/drivers/usb/typec/ucsi/ucsi.c
+++ b/drivers/usb/typec/ucsi/ucsi.c
@@ -588,8 +588,6 @@ static int ucsi_get_pdos(struct ucsi_connector *con, int is_partner,
 				num_pdos * sizeof(u32));
 	if (ret < 0 && ret != -ETIMEDOUT)
 		dev_err(ucsi->dev, "UCSI_GET_PDOS failed (%d)\n", ret);
-	if (ret == 0 && offset == 0)
-		dev_warn(ucsi->dev, "UCSI_GET_PDOS returned 0 bytes\n");
 
 	return ret;
 }
-- 
2.35.1

