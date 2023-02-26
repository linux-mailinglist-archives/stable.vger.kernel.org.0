Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7FBE46A2CF4
	for <lists+stable@lfdr.de>; Sun, 26 Feb 2023 02:37:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229507AbjBZBhk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 25 Feb 2023 20:37:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47296 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229470AbjBZBhj (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 25 Feb 2023 20:37:39 -0500
Received: from smtp-fw-6001.amazon.com (smtp-fw-6001.amazon.com [52.95.48.154])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 727EB11EA1;
        Sat, 25 Feb 2023 17:37:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1677375458; x=1708911458;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=VN9+lKpIv8OFPEcx6C6zFpPockwjmo2bbc4mI4drChU=;
  b=agMyv5n/xH0t7jZeTsPah1ijEaVIrVNbDVyS15RkowlqX7z5QGYjcU3N
   8429CVCwSXf+LP0FTqIprH63V2Ypqw/ztdFN2PfvbbtXP2IKzmG5BsLLJ
   ApvWSEiSn/JatbzLWXnRIQonJ6/cNhnIpCw7szXtQlfkBNSg2g8QEmH2H
   s=;
X-IronPort-AV: E=Sophos;i="5.97,328,1669075200"; 
   d="scan'208";a="303015007"
Received: from iad12-co-svc-p1-lb1-vlan2.amazon.com (HELO email-inbound-relay-pdx-2b-m6i4x-cadc3fbd.us-west-2.amazon.com) ([10.43.8.2])
  by smtp-border-fw-6001.iad6.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Feb 2023 01:37:37 +0000
Received: from EX13MTAUWB001.ant.amazon.com (pdx1-ws-svc-p6-lb9-vlan2.pdx.amazon.com [10.236.137.194])
        by email-inbound-relay-pdx-2b-m6i4x-cadc3fbd.us-west-2.amazon.com (Postfix) with ESMTPS id C71F7A2992;
        Sun, 26 Feb 2023 01:37:35 +0000 (UTC)
Received: from EX19D010UWA004.ant.amazon.com (10.13.138.204) by
 EX13MTAUWB001.ant.amazon.com (10.43.161.249) with Microsoft SMTP Server (TLS)
 id 15.0.1497.45; Sun, 26 Feb 2023 01:37:34 +0000
Received: from u9aa42af9e4c55a.ant.amazon.com (10.106.100.27) by
 EX19D010UWA004.ant.amazon.com (10.13.138.204) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.24; Sun, 26 Feb 2023 01:37:34 +0000
From:   Munehisa Kamata <kamatam@amazon.com>
To:     <thierry.reding@gmail.com>
CC:     <u.kleine-koenig@pengutronix.de>, <tobetter@gmail.com>,
        <linux-pwm@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Munehisa Kamata <kamatam@amazon.com>, <stable@vger.kernel.org>
Subject: [PATCH] pwm: core: Zero-initialize the temp state
Date:   Sat, 25 Feb 2023 17:37:21 -0800
Message-ID: <20230226013722.1802842-1-kamatam@amazon.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.106.100.27]
X-ClientProxiedBy: EX19D031UWC003.ant.amazon.com (10.13.139.252) To
 EX19D010UWA004.ant.amazon.com (10.13.138.204)
X-Spam-Status: No, score=-11.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Zero-initialize the on-stack structure to avoid unexpected behaviors. Some
drivers may not set or initialize all the values in pwm_state through their
.get_state() callback and therefore some random values may remain there and
be set into pwm->state eventually.

This actually caused regression on ODROID-N2+ as reported in [1]; kernel
fails to boot due to random panic or hang-up.

[1] https://forum.odroid.com/viewtopic.php?f=177&t=46360

Fixes: c73a3107624d ("pwm: Handle .get_state() failures")
Cc: stable@vger.kernel.org # 6.2
Signed-off-by: Munehisa Kamata <kamatam@amazon.com>
---
 drivers/pwm/core.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/pwm/core.c b/drivers/pwm/core.c
index e01147f66e15..6eac8022a2c2 100644
--- a/drivers/pwm/core.c
+++ b/drivers/pwm/core.c
@@ -117,6 +117,7 @@ static int pwm_device_request(struct pwm_device *pwm, const char *label)
 	if (pwm->chip->ops->get_state) {
 		struct pwm_state state;
 
+		memset(&state, 0, sizeof(struct pwm_state));
 		err = pwm->chip->ops->get_state(pwm->chip, pwm, &state);
 		trace_pwm_get(pwm, &state, err);
 
-- 
2.25.1

