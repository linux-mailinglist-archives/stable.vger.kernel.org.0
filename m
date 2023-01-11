Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 52E88665179
	for <lists+stable@lfdr.de>; Wed, 11 Jan 2023 03:06:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229647AbjAKCGB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Jan 2023 21:06:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48268 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234948AbjAKCF7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 10 Jan 2023 21:05:59 -0500
Received: from mail-pj1-x102b.google.com (mail-pj1-x102b.google.com [IPv6:2607:f8b0:4864:20::102b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ACEC8256
        for <stable@vger.kernel.org>; Tue, 10 Jan 2023 18:05:57 -0800 (PST)
Received: by mail-pj1-x102b.google.com with SMTP id z1-20020a17090a66c100b00226f05b9595so447462pjl.0
        for <stable@vger.kernel.org>; Tue, 10 Jan 2023 18:05:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=qS19MD5Zbe+eJ9gIfmAabpV1LfKfinJzSfEen8dZJOE=;
        b=DNcVUKHG9cU/nPJHm64CxJPtzm3cG4CMsD19HXOfPf6VjsbcFZnaoqYOZ+nHs/NP93
         y2GJkNOxJTCkAPkNNDR4lVP7I3Nf8tab5XzO+kRDMz82tjk7XHPGLgBgSXB4NHfJTo+N
         v7BVDc0FjZCBuC3I21/210GDz60MgYQOKQxQI=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=qS19MD5Zbe+eJ9gIfmAabpV1LfKfinJzSfEen8dZJOE=;
        b=udg5uemyxRyecMdXpJnrrkDkDfsDQ3x4QMa9z5VERemz/CrejDjXyXvdq275Ak/wlZ
         QexYAlwMo8Meiqqp4COOpy+Itl8LUrUCypsNY79GHPmokJCNLnOhSb5aTZ9i35QvO7vT
         FSt0Tgq3+Pbp7hfvVHmpw0K+gYX8WDGbthXoAet1kx4hJg6KMqvBe9YU7NIRtl21USYG
         aH8Yuy9moaJHwcyIk/f8wJAoJkf7JRvsZsEUyBIoQwKGUYZX155wNa6imO7zKRyWSHH2
         Is4G2jukfot7Ix+Eg970GN7sAM4tajgY9/Q/hZBXa9vdVzbzBpiaaYedWDwbOHPAUXfx
         8XDw==
X-Gm-Message-State: AFqh2kryIbOBBkrulTd7xrUqlKXxaTVLVdfa5HXt4D5w6rUmP7EL/gk7
        tLWRoauKBZt93ZOqJvxv1CsA6Q==
X-Google-Smtp-Source: AMrXdXtzQT/6JuKQRYC+X8VwEUExfNrNm6jJEbBiSP8e0f2jsH+npBB6a3KqCJILpvKBoHa+rV6uEw==
X-Received: by 2002:a05:6a20:9588:b0:b2:549c:b0eb with SMTP id iu8-20020a056a20958800b000b2549cb0ebmr89906325pzb.36.1673402757139;
        Tue, 10 Jan 2023 18:05:57 -0800 (PST)
Received: from pmalani.c.googlers.com.com (33.5.83.34.bc.googleusercontent.com. [34.83.5.33])
        by smtp.gmail.com with ESMTPSA id z6-20020a656646000000b00477a442d450sm7336738pgv.16.2023.01.10.18.05.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 Jan 2023 18:05:56 -0800 (PST)
From:   Prashant Malani <pmalani@chromium.org>
To:     linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org
Cc:     bleung@chromium.org, Prashant Malani <pmalani@chromium.org>,
        stable@vger.kernel.org,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Guillaume Ranquet <granquet@baylibre.com>,
        Macpaul Lin <macpaul.lin@mediatek.com>,
        Pablo Sun <pablo.sun@mediatek.com>
Subject: [PATCH 1/3] usb: typec: altmodes/displayport: Add pin assignment helper
Date:   Wed, 11 Jan 2023 02:05:41 +0000
Message-Id: <20230111020546.3384569-1-pmalani@chromium.org>
X-Mailer: git-send-email 2.39.0.314.g84b9a713c41-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The code to extract a peripheral's currently supported Pin Assignments
is repeated in a couple of locations. Factor it out into a separate
function.

This will also make it easier to add fixes (we only need to update 1
location instead of 2).

Fixes: c1e5c2f0cb8a ("usb: typec: altmodes/displayport: correct pin assignment for UFP receptacles")
Cc: stable@vger.kernel.org
Cc: Heikki Krogerus <heikki.krogerus@linux.intel.com>
Signed-off-by: Prashant Malani <pmalani@chromium.org>
---

While this patch doesn't fix anything, it is required by the actual
fix (which is Patch 2/3 in this series). So, I've add the "Fixes" tag
and "Cc stable" tag to ensure that both patches are picked.

If this is the incorrect approach and there is a better way, my
apologies, and please let me know the appropriate process.

 drivers/usb/typec/altmodes/displayport.c | 22 ++++++++++++++--------
 1 file changed, 14 insertions(+), 8 deletions(-)

diff --git a/drivers/usb/typec/altmodes/displayport.c b/drivers/usb/typec/altmodes/displayport.c
index 06fb4732f8cd..f9d4a7648bc9 100644
--- a/drivers/usb/typec/altmodes/displayport.c
+++ b/drivers/usb/typec/altmodes/displayport.c
@@ -420,6 +420,18 @@ static const char * const pin_assignments[] = {
 	[DP_PIN_ASSIGN_F] = "F",
 };
 
+/*
+ * Helper function to extract a peripheral's currently supported
+ * Pin Assignments from its DisplayPort alternate mode state.
+ */
+static u8 get_current_pin_assignments(struct dp_altmode *dp)
+{
+	if (DP_CONF_CURRENTLY(dp->data.conf) == DP_CONF_DFP_D)
+		return DP_CAP_UFP_D_PIN_ASSIGN(dp->alt->vdo);
+	else
+		return DP_CAP_DFP_D_PIN_ASSIGN(dp->alt->vdo);
+}
+
 static ssize_t
 pin_assignment_store(struct device *dev, struct device_attribute *attr,
 		     const char *buf, size_t size)
@@ -446,10 +458,7 @@ pin_assignment_store(struct device *dev, struct device_attribute *attr,
 		goto out_unlock;
 	}
 
-	if (DP_CONF_CURRENTLY(dp->data.conf) == DP_CONF_DFP_D)
-		assignments = DP_CAP_UFP_D_PIN_ASSIGN(dp->alt->vdo);
-	else
-		assignments = DP_CAP_DFP_D_PIN_ASSIGN(dp->alt->vdo);
+	assignments = get_current_pin_assignments(dp);
 
 	if (!(DP_CONF_GET_PIN_ASSIGN(conf) & assignments)) {
 		ret = -EINVAL;
@@ -486,10 +495,7 @@ static ssize_t pin_assignment_show(struct device *dev,
 
 	cur = get_count_order(DP_CONF_GET_PIN_ASSIGN(dp->data.conf));
 
-	if (DP_CONF_CURRENTLY(dp->data.conf) == DP_CONF_DFP_D)
-		assignments = DP_CAP_UFP_D_PIN_ASSIGN(dp->alt->vdo);
-	else
-		assignments = DP_CAP_DFP_D_PIN_ASSIGN(dp->alt->vdo);
+	assignments = get_current_pin_assignments(dp);
 
 	for (i = 0; assignments; assignments >>= 1, i++) {
 		if (assignments & 1) {
-- 
2.39.0.314.g84b9a713c41-goog

