Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A19F24ECE95
	for <lists+stable@lfdr.de>; Wed, 30 Mar 2022 23:20:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233332AbiC3VTG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 30 Mar 2022 17:19:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43938 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232416AbiC3VTF (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 30 Mar 2022 17:19:05 -0400
Received: from mail-pj1-x1049.google.com (mail-pj1-x1049.google.com [IPv6:2607:f8b0:4864:20::1049])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1D14B59391
        for <stable@vger.kernel.org>; Wed, 30 Mar 2022 14:17:20 -0700 (PDT)
Received: by mail-pj1-x1049.google.com with SMTP id k11-20020a17090a658b00b001c9ef91ee64so1945960pjj.7
        for <stable@vger.kernel.org>; Wed, 30 Mar 2022 14:17:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=/g82k/yLueQhmfK5T8wtfFe4TaWb3pB9z1BLHTV6OJE=;
        b=j21uT8/pXmhxq6ckzyD7U2D1dwXi6tKugXYMhZw2nm4rpUFdNmCmbqk4iHZmSRo4Bx
         u2KCGC+TUYDFyH9zVujbfBX1r2pccMGEKaF/KFvl4fS6cr7YXF8uN8ADF8xvNiZJg067
         SrS2pigJnxnkv1alMvwNmeKMbOs9xe4g/2FqaQBhk7LZIrHobbp5nPydFHC/7+Z4fzgo
         R5bkdBK582OFRDTu0NYQ8pC2PuUWzZAibXi+tQ8b11y/hJEadv6p/uOWL6GS0p//BVrp
         NU7ZrpuJ3eBPKKNcq+GOvMdwcipXd/ca53DWflyKil/YqphkEI+AMcEno9CVXcR3tCOe
         y0Iw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=/g82k/yLueQhmfK5T8wtfFe4TaWb3pB9z1BLHTV6OJE=;
        b=s8qpwo1Y1Yaz7rDMTLeonIerBRJFZeHkhuSKvFmoiZ1HHpP2if5MvlICad57qr0nY3
         uIrub937qZixQ/cKzVxb+pct6+Y7Oass6GwZWMIASFmcfJ+4vlktJnFKSLvZxYoYmau5
         CUcU4bLFUUlanLtoJfB8dAZp3oqOKY9CjPMyRiAsVMef9v1XODD+SNDIe8koSF5mRixK
         Xcdioq+LHnynUwn8YJoEEu5HD5KQKaW0mxiDuWuBol8ZnxG+4znBlVQQq92pFG7yEY2W
         +4QiPyiiVPtARcwU/yawsOjYZHh2FyrkwMgeBVV1421CFVJdXKMhPbgWUcjnVvl1ztoG
         5X9g==
X-Gm-Message-State: AOAM532pteF+Rx079L3rzoqVQ/aAbxPeP26E+VXxswlJ6c+3Xe52q3Pe
        xmswIGmeGoyMt4/uTpknqOXC9TggFxQJIQ==
X-Google-Smtp-Source: ABdhPJyj6MgKePd9IGXRGMOEDrYZUUs0KNEGd9MFx+MzvMwl6JlgtuEbbYak68UFhDwNIuTWzT+v5AaANfhLOw==
X-Received: from wonchungspecialist.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:1440])
 (user=wonchung job=sendgmr) by 2002:a17:902:f54c:b0:154:6794:ab18 with SMTP
 id h12-20020a170902f54c00b001546794ab18mr1758684plf.118.1648675039601; Wed,
 30 Mar 2022 14:17:19 -0700 (PDT)
Date:   Wed, 30 Mar 2022 21:17:12 +0000
Message-Id: <20220330211712.2067044-1-wonchung@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.35.1.1021.g381101b075-goog
Subject: [PATCH v2] misc/mei: Add NULL check to component match callback functions
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

