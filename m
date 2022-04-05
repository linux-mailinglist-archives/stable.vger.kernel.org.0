Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BD2E44F47C9
	for <lists+stable@lfdr.de>; Wed,  6 Apr 2022 01:43:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237072AbiDEVUv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 17:20:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41558 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1442935AbiDEPim (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 11:38:42 -0400
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4AF55F94E4;
        Tue,  5 Apr 2022 06:53:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1649166832; x=1680702832;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=SaiqlB+LlGtj1lMotqQPMQSwVEwcf6O9FoBb7YiUMiY=;
  b=eYf/56QUeJbjiSDbvQVHVmnX6X2f1SVBFMSh/yUYl2fpV337RxWTltun
   H/T6JxgM0u0AikoISHw2nti+tFqD33TSz6I7HdVhIBf0sVEo9yvYXhhhd
   WGvQVC9c6pzdapaLG3tYu8Q6Jtm7FQgtOe0CK/oSaux1r40eE8bQNEb6A
   AaNU9Bfp3+uk8ZJI3JzLttbOhFI7Fbjp5VW8u1XmGzzYr22frveyoXizG
   B4sgtS4Bpog8fJeaev4jE+z9dyKzxoc6SBNSwtscBgSrPakX8A+TYZb9l
   cmbsjc6xRkh/4zgJ+YnAFz0SPWEzHrJLCmG0xsEjnpLxaRx7GVkYYbG1C
   g==;
X-IronPort-AV: E=McAfee;i="6200,9189,10307"; a="259583358"
X-IronPort-AV: E=Sophos;i="5.90,236,1643702400"; 
   d="scan'208";a="259583358"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Apr 2022 06:53:51 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.90,236,1643702400"; 
   d="scan'208";a="696938401"
Received: from black.fi.intel.com (HELO black.fi.intel.com.) ([10.237.72.28])
  by fmsmga001.fm.intel.com with ESMTP; 05 Apr 2022 06:53:49 -0700
From:   Heikki Krogerus <heikki.krogerus@linux.intel.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Jia-Ju Bai <baijiaju1990@gmail.com>,
        Jack Pham <quic_jackp@quicinc.com>, linux-usb@vger.kernel.org,
        stable@vger.kernel.org
Subject: [PATCH v1 1/2] usb: typec: ucsi: Fix reuse of completion structure
Date:   Tue,  5 Apr 2022 16:48:23 +0300
Message-Id: <20220405134824.68067-2-heikki.krogerus@linux.intel.com>
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

The role swapping completion variable is reused, so it needs
to be reinitialised every time. Otherwise it will be marked
as done after the first time it's used and completing
immediately.

Link: https://lore.kernel.org/linux-usb/20220325203959.GA19752@jackp-linux.qualcomm.com/
Fixes: 6df475f804e6 ("usb: typec: ucsi: Start using struct typec_operations")
Reported-and-suggested-by: Jack Pham <quic_jackp@quicinc.com>
Cc: stable@vger.kernel.org
Signed-off-by: Heikki Krogerus <heikki.krogerus@linux.intel.com>
---
 drivers/usb/typec/ucsi/ucsi.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/usb/typec/ucsi/ucsi.c b/drivers/usb/typec/ucsi/ucsi.c
index f0c2fa19f3e0f..576cb0e68596f 100644
--- a/drivers/usb/typec/ucsi/ucsi.c
+++ b/drivers/usb/typec/ucsi/ucsi.c
@@ -949,6 +949,8 @@ static int ucsi_dr_swap(struct typec_port *port, enum typec_data_role role)
 	     role == TYPEC_HOST))
 		goto out_unlock;
 
+	reinit_completion(&con->complete);
+
 	command = UCSI_SET_UOR | UCSI_CONNECTOR_NUMBER(con->num);
 	command |= UCSI_SET_UOR_ROLE(role);
 	command |= UCSI_SET_UOR_ACCEPT_ROLE_SWAPS;
@@ -985,6 +987,8 @@ static int ucsi_pr_swap(struct typec_port *port, enum typec_role role)
 	if (cur_role == role)
 		goto out_unlock;
 
+	reinit_completion(&con->complete);
+
 	command = UCSI_SET_PDR | UCSI_CONNECTOR_NUMBER(con->num);
 	command |= UCSI_SET_PDR_ROLE(role);
 	command |= UCSI_SET_PDR_ACCEPT_ROLE_SWAPS;
-- 
2.35.1

