Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8847A4ED632
	for <lists+stable@lfdr.de>; Thu, 31 Mar 2022 10:49:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233288AbiCaIvc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 31 Mar 2022 04:51:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48386 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233271AbiCaIva (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 31 Mar 2022 04:51:30 -0400
Received: from mail-pg1-x549.google.com (mail-pg1-x549.google.com [IPv6:2607:f8b0:4864:20::549])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3C24B26C1
        for <stable@vger.kernel.org>; Thu, 31 Mar 2022 01:49:41 -0700 (PDT)
Received: by mail-pg1-x549.google.com with SMTP id b7-20020a633407000000b0038413d39ca9so11893592pga.4
        for <stable@vger.kernel.org>; Thu, 31 Mar 2022 01:49:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=BHo+rnUti0j2t1iwI+B3pswuRDsmr8usqTuUebYkomI=;
        b=q30idgXLoXmWDmg7wYTzGwkiUCmloZFfA9WfT5Uc7ICAqiBgFXvJ2CX8CCYJufTfbB
         4HVd1MrC51NA70P4lxKj98tSVFhMnhXfSkknNN0JTu+0rQ725Rg2u+K/N0w2iTpbzzsb
         S0GdqTolwLZ1hh0XiDljBEibQtlaqcOCPY2+2/d3AwLMlr40q0i3cNS3/p3EH2E9S+//
         CJ5v2fTUeQwGTFbVDw0d8x6MEHtKi/tMo7fPpWahKmH7EseqkBJbz364vXftuA6b5Wt2
         7WwV1mR0L7O7QITsR7LudlNSEYAZrI8mTNVgj8XhpNSxfO+2h2KVYG5xQDFrOyxVu8ZM
         cXxQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=BHo+rnUti0j2t1iwI+B3pswuRDsmr8usqTuUebYkomI=;
        b=hCK6QrGyZ7VNHv/srZy1pkcHfOgko+Lc9hP+h+TCng5PueMAN7cVy39J58ZlvJWlri
         vgIOsPXwVbIkwejl2+injWUA9IuLJ6K8EzqQzyawaCdwH+VmTSEfFQGwSH2JaFtyE0Cn
         cpC2bDUSefaz7hGbuhPxSlzwg5Zx6WdIim5DnkNPA4NdRevJLuuw7Va/koMvEUMAvwjd
         m7hNFXP6ds0b7DFwBoMhZS1KeY86V8rcv/jyXL89+gK1xC+ai1pjMNU+ORWoruIZ+nZP
         blr/ZbFW6X9+jRpARueEflFTK5GbgRjxgB5SJjcPBsDaX57WhKj32j+COmIvtDiUFgdx
         /kYA==
X-Gm-Message-State: AOAM530BPZgOoz3h7JMkztDscwh8IhcX0HmT1HK2fBp2k+a2qPoZ/z9o
        y6SpSWxKBwUdOUpnh2U8+NqfRD8WIDqgFQ==
X-Google-Smtp-Source: ABdhPJyYOlly6gF65k4ogqYtSJDpCyT1q7cgvfyknXmNjuldFpEq3S/Ac4y+7NA2tw311V38zrehVc23Werf6A==
X-Received: from wonchungspecialist.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:1440])
 (user=wonchung job=sendgmr) by 2002:a17:90b:3b8f:b0:1c7:b62e:8e87 with SMTP
 id pc15-20020a17090b3b8f00b001c7b62e8e87mr4974069pjb.156.1648716580627; Thu,
 31 Mar 2022 01:49:40 -0700 (PDT)
Date:   Thu, 31 Mar 2022 08:49:18 +0000
Message-Id: <20220331084918.2592699-1-wonchung@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.35.1.1021.g381101b075-goog
Subject: [PATCH v3] misc/mei: Add NULL check to component match callback functions
From:   Won Chung <wonchung@google.com>
To:     Tomas Winkler <tomas.winkler@intel.com>
Cc:     Heikki Krogerus <heikki.krogerus@linux.intel.com>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        Benson Leung <bleung@chromium.org>,
        Prashant Malani <pmalani@chromium.org>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Won Chung <wonchung@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=ham autolearn_force=no version=3.4.6
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
Suggested-by: Heikki Krogerus <heikki.krogerus@linux.intel.com>
Suggested-by: Mika Westerberg <mika.westerberg@linux.intel.com>
Signed-off-by: Won Chung <wonchung@google.com>
Cc: stable@vger.kernel.org
---
Changes from v2:
- Correctly add "Suggested-by" tag
- Add "Cc: stable@vger.kernel.org"

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

