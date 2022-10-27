Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6491860F09B
	for <lists+stable@lfdr.de>; Thu, 27 Oct 2022 08:51:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233963AbiJ0Gv3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 27 Oct 2022 02:51:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60346 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233773AbiJ0Gv2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 27 Oct 2022 02:51:28 -0400
Received: from alexa-out-sd-01.qualcomm.com (alexa-out-sd-01.qualcomm.com [199.106.114.38])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BC4F1E09A2;
        Wed, 26 Oct 2022 23:51:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=quicinc.com; i=@quicinc.com; q=dns/txt; s=qcdkim;
  t=1666853486; x=1698389486;
  h=from:to:cc:subject:date:message-id:mime-version;
  bh=FQowr2WuDUlHUVuh8cb7EZP4GgKfYZcz55Rl/V7SGY8=;
  b=Vxa+qIiuvL7Ghj1eWrLO/F1eOGrFmXUfZDwtwZFhObi7AfB4nqBO1vtn
   QAJ+7W4mMIjtbEaV0b9F0Yi/9xS+xVsvtzPNG9D9l25DPYekHEDKZxLSP
   MU5p7Hbli+I9NQjtZXZ7hJHgO5oJrg6bw2Vnu3Rs+0o3p4C5OpKE4eKll
   A=;
Received: from unknown (HELO ironmsg04-sd.qualcomm.com) ([10.53.140.144])
  by alexa-out-sd-01.qualcomm.com with ESMTP; 26 Oct 2022 23:51:25 -0700
X-QCInternal: smtphost
Received: from unknown (HELO nasanex01a.na.qualcomm.com) ([10.52.223.231])
  by ironmsg04-sd.qualcomm.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Oct 2022 23:51:25 -0700
Received: from aiquny2-gv.qualcomm.com (10.80.80.8) by
 nasanex01a.na.qualcomm.com (10.52.223.231) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.29; Wed, 26 Oct 2022 23:51:23 -0700
From:   Maria Yu <quic_aiquny@quicinc.com>
To:     <linus.walleij@linaro.org>
CC:     Maria Yu <quic_aiquny@quicinc.com>, <linux-gpio@vger.kernel.org>,
        <stable@vger.kernel.org>
Subject: [PATCH] pinctrl: core: Make p->state in order in pinctrl_commit_state
Date:   Thu, 27 Oct 2022 14:51:10 +0800
Message-ID: <20221027065110.9395-1-quic_aiquny@quicinc.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.80.80.8]
X-ClientProxiedBy: nasanex01a.na.qualcomm.com (10.52.223.231) To
 nasanex01a.na.qualcomm.com (10.52.223.231)
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

We've got a dump that current cpu is in pinctrl_commit_state, the
old_state != p->state while the stack is still in the process of
pinmux_disable_setting. So it means even if the current p->state is
changed in new state, the settings are not yet up-to-date enabled
complete yet.

Currently p->state in different value to synchronize the
pinctrl_commit_state behaviors. The p->state will have transaction like
old_state -> NULL -> new_state. When in old_state, it will try to
disable all the all state settings. And when after new state settings
enabled, p->state will changed to the new state after that. So use
smp_mb to synchronize the p->state variable and the settings in order.
---
 drivers/pinctrl/core.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/pinctrl/core.c b/drivers/pinctrl/core.c
index 9e57f4c62e60..cd917a5b1a0a 100644
--- a/drivers/pinctrl/core.c
+++ b/drivers/pinctrl/core.c
@@ -1256,6 +1256,7 @@ static int pinctrl_commit_state(struct pinctrl *p, struct pinctrl_state *state)
 		}
 	}
 
+	smp_mb();
 	p->state = NULL;
 
 	/* Apply all the settings for the new state - pinmux first */
@@ -1305,6 +1306,7 @@ static int pinctrl_commit_state(struct pinctrl *p, struct pinctrl_state *state)
 			pinctrl_link_add(setting->pctldev, p->dev);
 	}
 
+	smp_mb();
 	p->state = state;
 
 	return 0;
-- 
2.17.1

