Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F0C254F47D2
	for <lists+stable@lfdr.de>; Wed,  6 Apr 2022 01:44:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244905AbiDEVVg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 17:21:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52826 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1442944AbiDEPio (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 11:38:44 -0400
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 44A16F9F97;
        Tue,  5 Apr 2022 06:53:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1649166834; x=1680702834;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=mMVBDbCjUN9rOkC+keFVtKh5CLrcACEJ46Jmwn4fanQ=;
  b=ZAuKlWp8Ep1/UMxO9SvtQBHcZX7J8Ujq0KIsbpQku/H5CG7cJFpotDMh
   z2Wkx519GkqWhPCLjxsIAjIDO731ei/XOGO+CL4OiOqxD3zQB3hMN5yMD
   4wF2ddulkXq8jAhp0O7nvCKqFzGEaxpBWBpHJXcdZxUGoTMcS4s+e9mxS
   th3V8zvdzPOs659Ikz5VrHtD0nBD3sWndbyahNWy2YhCehAif5Jgwu08s
   SpkfMIhgdEY7N5lB3b0xi3szGAouplz0SfXSiYNOHazLhMuXxaHW0wMJv
   AOHvzNpbgY0GjzBw0djlYZBcNBurQbEr85/D15KLwH72QLnEQO7z4zy31
   w==;
X-IronPort-AV: E=McAfee;i="6200,9189,10307"; a="259583361"
X-IronPort-AV: E=Sophos;i="5.90,236,1643702400"; 
   d="scan'208";a="259583361"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Apr 2022 06:53:54 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.90,236,1643702400"; 
   d="scan'208";a="696938409"
Received: from black.fi.intel.com (HELO black.fi.intel.com.) ([10.237.72.28])
  by fmsmga001.fm.intel.com with ESMTP; 05 Apr 2022 06:53:52 -0700
From:   Heikki Krogerus <heikki.krogerus@linux.intel.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Jia-Ju Bai <baijiaju1990@gmail.com>,
        Jack Pham <quic_jackp@quicinc.com>, linux-usb@vger.kernel.org,
        stable@vger.kernel.org
Subject: [PATCH v1 2/2] usb: typec: ucsi: Fix role swapping
Date:   Tue,  5 Apr 2022 16:48:24 +0300
Message-Id: <20220405134824.68067-3-heikki.krogerus@linux.intel.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220405134824.68067-1-heikki.krogerus@linux.intel.com>
References: <20220405134824.68067-1-heikki.krogerus@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

All attempts to swap the roles timed out because the
completion was done without releasing the port lock. Fixing
that by releasing the lock before starting to wait for the
completion.

Link: https://lore.kernel.org/linux-usb/037de7ac-e210-bdf5-ec7a-8c0c88a0be20@gmail.com/
Fixes: ad74b8649bea ("usb: typec: ucsi: Preliminary support for alternate modes")
Reported-and-tested-by: Jia-Ju Bai <baijiaju1990@gmail.com>
Cc: stable@vger.kernel.org
Signed-off-by: Heikki Krogerus <heikki.krogerus@linux.intel.com>
---
 drivers/usb/typec/ucsi/ucsi.c | 20 +++++++++++++-------
 1 file changed, 13 insertions(+), 7 deletions(-)

diff --git a/drivers/usb/typec/ucsi/ucsi.c b/drivers/usb/typec/ucsi/ucsi.c
index 576cb0e68596f..a6045aef0d04f 100644
--- a/drivers/usb/typec/ucsi/ucsi.c
+++ b/drivers/usb/typec/ucsi/ucsi.c
@@ -958,14 +958,18 @@ static int ucsi_dr_swap(struct typec_port *port, enum typec_data_role role)
 	if (ret < 0)
 		goto out_unlock;
 
+	mutex_unlock(&con->lock);
+
 	if (!wait_for_completion_timeout(&con->complete,
-					msecs_to_jiffies(UCSI_SWAP_TIMEOUT_MS)))
-		ret = -ETIMEDOUT;
+					 msecs_to_jiffies(UCSI_SWAP_TIMEOUT_MS)))
+		return -ETIMEDOUT;
+
+	return 0;
 
 out_unlock:
 	mutex_unlock(&con->lock);
 
-	return ret < 0 ? ret : 0;
+	return ret;
 }
 
 static int ucsi_pr_swap(struct typec_port *port, enum typec_role role)
@@ -996,11 +1000,13 @@ static int ucsi_pr_swap(struct typec_port *port, enum typec_role role)
 	if (ret < 0)
 		goto out_unlock;
 
+	mutex_unlock(&con->lock);
+
 	if (!wait_for_completion_timeout(&con->complete,
-				msecs_to_jiffies(UCSI_SWAP_TIMEOUT_MS))) {
-		ret = -ETIMEDOUT;
-		goto out_unlock;
-	}
+					 msecs_to_jiffies(UCSI_SWAP_TIMEOUT_MS)))
+		return -ETIMEDOUT;
+
+	mutex_lock(&con->lock);
 
 	/* Something has gone wrong while swapping the role */
 	if (UCSI_CONSTAT_PWR_OPMODE(con->status.flags) !=
-- 
2.35.1

