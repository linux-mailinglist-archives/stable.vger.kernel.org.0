Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6E590682EFA
	for <lists+stable@lfdr.de>; Tue, 31 Jan 2023 15:15:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232458AbjAaOPW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 31 Jan 2023 09:15:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49552 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232178AbjAaOPO (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 31 Jan 2023 09:15:14 -0500
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B0A6F4E500;
        Tue, 31 Jan 2023 06:15:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1675174513; x=1706710513;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=qofIi4J/WDgnzxuUFsZeX30i77ieCjMSAit43TlIBbk=;
  b=Nr/Iu/tzM8JCl+1HX9srI60ERbFUNJ58hO4RhwzQLqGWTfoBt5k+goj+
   5/9YIiTeh9RPCHPnQQLebz2Qyoe/RPLt1tG2fy/OoDO6cgT3AlPTmE744
   1ESdm4gtM8cXRCnWVLo0svJQh2ccnAEqXFiecGXJrM/E5JSb+171wSRWK
   K8p//ryr22twIH2SYfV2FC/fdBGm2tBaDDzhEfIiLM+ecNBvgJrVanwPi
   QfMT9lM9+dn84FHEE9980RScgadJo3JnPhFTt2MN0K1yizUWvFcm6TU9N
   7m5akf5+3k/VoWoqg71LcticGw7+SooNlB3CjWCqNU3t7WOxXUIqAP86u
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10606"; a="325550161"
X-IronPort-AV: E=Sophos;i="5.97,261,1669104000"; 
   d="scan'208";a="325550161"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Jan 2023 06:14:43 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10606"; a="807142307"
X-IronPort-AV: E=Sophos;i="5.97,261,1669104000"; 
   d="scan'208";a="807142307"
Received: from black.fi.intel.com (HELO black.fi.intel.com.) ([10.237.72.28])
  by fmsmga001.fm.intel.com with ESMTP; 31 Jan 2023 06:14:41 -0800
From:   Heikki Krogerus <heikki.krogerus@linux.intel.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     oliver@diereehs.de, fancieux@outlook.com, speranskiy@gmx.com,
        linux-usb@vger.kernel.org, stable@vger.kernel.org
Subject: [PATCH] usb: typec: ucsi: Don't attempt to resume the ports before they exist
Date:   Tue, 31 Jan 2023 16:15:18 +0200
Message-Id: <20230131141518.78215-1-heikki.krogerus@linux.intel.com>
X-Mailer: git-send-email 2.39.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This will fix null pointer dereference that was caused by
the driver attempting to resume ports that were not yet
registered.

Fixes: e0dced9c7d47 ("usb: typec: ucsi: Resume in separate work")
Cc: <stable@vger.kernel.org>
Link: https://bugzilla.kernel.org/show_bug.cgi?id=216697
Signed-off-by: Heikki Krogerus <heikki.krogerus@linux.intel.com>
---
 drivers/usb/typec/ucsi/ucsi.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/drivers/usb/typec/ucsi/ucsi.c b/drivers/usb/typec/ucsi/ucsi.c
index 00fc8672098f3..f632350f6dcb2 100644
--- a/drivers/usb/typec/ucsi/ucsi.c
+++ b/drivers/usb/typec/ucsi/ucsi.c
@@ -1400,6 +1400,9 @@ static int ucsi_init(struct ucsi *ucsi)
 		con->port = NULL;
 	}
 
+	kfree(ucsi->connector);
+	ucsi->connector = NULL;
+
 err_reset:
 	memset(&ucsi->cap, 0, sizeof(ucsi->cap));
 	ucsi_reset_ppm(ucsi);
@@ -1431,7 +1434,8 @@ static void ucsi_resume_work(struct work_struct *work)
 
 int ucsi_resume(struct ucsi *ucsi)
 {
-	queue_work(system_long_wq, &ucsi->resume_work);
+	if (ucsi->connector)
+		queue_work(system_long_wq, &ucsi->resume_work);
 	return 0;
 }
 EXPORT_SYMBOL_GPL(ucsi_resume);
@@ -1551,6 +1555,9 @@ void ucsi_unregister(struct ucsi *ucsi)
 	/* Disable notifications */
 	ucsi->ops->async_write(ucsi, UCSI_CONTROL, &cmd, sizeof(cmd));
 
+	if (!ucsi->connector)
+		return;
+
 	for (i = 0; i < ucsi->cap.num_connectors; i++) {
 		cancel_work_sync(&ucsi->connector[i].work);
 		ucsi_unregister_partner(&ucsi->connector[i]);
-- 
2.39.1

