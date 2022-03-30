Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 629584ECE73
	for <lists+stable@lfdr.de>; Wed, 30 Mar 2022 23:06:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351238AbiC3Uuo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 30 Mar 2022 16:50:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54688 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351252AbiC3Uub (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 30 Mar 2022 16:50:31 -0400
Received: from mail-pg1-x54a.google.com (mail-pg1-x54a.google.com [IPv6:2607:f8b0:4864:20::54a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 891284615F
        for <stable@vger.kernel.org>; Wed, 30 Mar 2022 13:48:29 -0700 (PDT)
Received: by mail-pg1-x54a.google.com with SMTP id t24-20020a632258000000b003988eed18b2so3016189pgm.22
        for <stable@vger.kernel.org>; Wed, 30 Mar 2022 13:48:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=/g82k/yLueQhmfK5T8wtfFe4TaWb3pB9z1BLHTV6OJE=;
        b=ZLwfiXegtOpdGKQO5+Awr7UqpHxHq7YWpZLHThKlwygdWHkEdfaQhUwBLXkLorgM8e
         VYG9ldW0nT4Snd9SE3sUP5QbAHJZ77MNQT7dfwjvysO3vT5GISBhm4O1LtHn7dI1zwR6
         orVt/ljchxeEjsT7wFoyMXoNx7+f2n608RHnJRA1r0+bxut21Y+rddwzSWjabl9TwtHA
         gh/RjUGC5dl9viJn+UvoywL+R7hV4PnFQQvhHcW+MJ+k89ab8tIOFRfQg5BwMc5kry1Q
         nvVFaUXDRz/FxjzHC60onq/gJvaNvb1meWYkjjvzlcAZ4hs6Ir8fbFeYU4IwgU0af40I
         SEKA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=/g82k/yLueQhmfK5T8wtfFe4TaWb3pB9z1BLHTV6OJE=;
        b=GH5XP1B/bPjuTSiN2YvD984Zm/PLla/q3TzOGezBCZKaW6uJckdiDrQVOgCkYvFZPh
         a7L9DAUOPyewbkW2XGV2pdHclSdVtyQtucArP73OdL34A/uImobDj0WjjpW8VIjdfwMz
         0g+JgWfY7dNfL4BftZPukoxKqccshto9BHLnWjIbLqZ71RjD3w2Sj1Y9R2+PfxgUx5rZ
         UHWfvzuPAVKYDnLW4KSui17Ds+iITHkSnsNpWvYnyns0jhvGdRX9edMdCyLg5AsvlPwy
         iGUNi92rqc4ykF/mH9YPFAcTSxayn0uKut4PEE5qtqtLmtuo5/qGo8Ee4JM9e2VPIVIF
         HjXA==
X-Gm-Message-State: AOAM5337kVgH6fTK422P/JpT8eyxf6clD+7EePUMT62WguDn04tzsdgn
        7VLh6p5PAligSL797OLwsXqtn/StQK5WqA==
X-Google-Smtp-Source: ABdhPJwo/TJxx9dwkuOJqRMDbdr8r/HZtULbQKNklDf3TJsj8fxT4i77GccosAsp1qcKZt/IiSQxwD6gUT4Cjg==
X-Received: from wonchungspecialist.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:1440])
 (user=wonchung job=sendgmr) by 2002:a17:90b:4c44:b0:1c7:1326:ec90 with SMTP
 id np4-20020a17090b4c4400b001c71326ec90mr1666161pjb.87.1648673309036; Wed, 30
 Mar 2022 13:48:29 -0700 (PDT)
Date:   Wed, 30 Mar 2022 20:48:09 +0000
Message-Id: <20220330204809.2061497-1-wonchung@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.35.1.1021.g381101b075-goog
Subject: [PATCH v2] misc/mei: Add NULL check to component match callback functions
From:   Won Chung <wonchung@google.com>
To:     Tomas Winkler <tomas.winkler@intel.com>
Cc:     Heikki Krogerus <heikki.krogerus@linux.intel.com>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        Benson Leung <bleung@google.com>,
        Prashant Malani <pmalani@google.com>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Won Chung <wonchung@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Component match callback functions need to check if expected data is
passed to them. Without this check, it can cause a NULL pointer
dereference when another driver registers a component before i915
drivers have their component master fully bind.

Fixes: 1e8d19d9b0dfc ("mei: hdcp: bind only with i915 on the same PCH")
Fixes: c2004ce99ed73 ("mei: pxp: export pavp client to me client bus")
Signed-off-by: Heikki Krogerus <heikki.krogerus@linux.intel.com>
Signed-off-by: Mika Westerberg <mika.westerberg@linux.intel.com>
Signed-off-by: Won Chung <wonchung@google.com>
---
Changes from v1:
- Add "Fixes" tag
- Send to stable@vger.kernel.org

 drivers/misc/mei/hdcp/mei_hdcp.c | 2 +-
 drivers/misc/mei/pxp/mei_pxp.c   | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/misc/mei/hdcp/mei_hdcp.c b/drivers/misc/mei/hdcp/mei_hdcp.c
index ec2a4fce8581..843dbc2b21b1 100644
--- a/drivers/misc/mei/hdcp/mei_hdcp.c
+++ b/drivers/misc/mei/hdcp/mei_hdcp.c
@@ -784,7 +784,7 @@ static int mei_hdcp_component_match(struct device *dev, int subcomponent,
 {
 	struct device *base = data;
 
-	if (strcmp(dev->driver->name, "i915") ||
+	if (!base || !dev->driver || strcmp(dev->driver->name, "i915") ||
 	    subcomponent != I915_COMPONENT_HDCP)
 		return 0;
 
diff --git a/drivers/misc/mei/pxp/mei_pxp.c b/drivers/misc/mei/pxp/mei_pxp.c
index f7380d387bab..e32a81da8af6 100644
--- a/drivers/misc/mei/pxp/mei_pxp.c
+++ b/drivers/misc/mei/pxp/mei_pxp.c
@@ -131,7 +131,7 @@ static int mei_pxp_component_match(struct device *dev, int subcomponent,
 {
 	struct device *base = data;
 
-	if (strcmp(dev->driver->name, "i915") ||
+	if (!base || !dev->driver || strcmp(dev->driver->name, "i915") ||
 	    subcomponent != I915_COMPONENT_PXP)
 		return 0;
 
-- 
2.35.1.1021.g381101b075-goog

