Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1486A5671B3
	for <lists+stable@lfdr.de>; Tue,  5 Jul 2022 17:00:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231171AbiGEPAb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Jul 2022 11:00:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52032 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230342AbiGEPAa (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Jul 2022 11:00:30 -0400
Received: from mail-yw1-x1149.google.com (mail-yw1-x1149.google.com [IPv6:2607:f8b0:4864:20::1149])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 674BD140E6
        for <stable@vger.kernel.org>; Tue,  5 Jul 2022 08:00:29 -0700 (PDT)
Received: by mail-yw1-x1149.google.com with SMTP id 00721157ae682-31838c41186so89489237b3.23
        for <stable@vger.kernel.org>; Tue, 05 Jul 2022 08:00:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=QKuFg9afWhUipvD+WdWRILrNmuYqti5h58sgL8Ob85w=;
        b=I1hm1SyHmxcLO7/EzbgkwyhvtMLZ2oqIEFbEoFVWd6iXy9zRpmRcMlkRB48oF+revL
         ZWoUdXXELCCZ1ITOv4C9zvfjcqggfmuXkPrpSwyiZ+MZL0nsCjOEgB8dB1F+wF56qpgb
         3S0C50+n99eVaZWajRE7iLRc6cKulNgTwzcsj/aPuX+XrIyyza46XkdeLBX4mjnqnzPd
         8QjPoWGIqESpY4uzqrGlSv5Ogx+J5DsfqlP902d6jeo9x9E6zs0THNYHlkNybr3JhBY3
         MA6SkMQcDTDUlSLxzzmcs9Yo37CDIVZkLbm+dlAhLYKVSAtxqv4HKyMk9tt3BEv1c7bN
         r5yg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=QKuFg9afWhUipvD+WdWRILrNmuYqti5h58sgL8Ob85w=;
        b=wKbUgZMahMawW2AniVFeWwbxYXuL6QBw/LRw+ONIfil+/l56cZqATSFAF6K/5XyXSN
         oYB3J02S4nafP7Iwxun+s9fJpFkDgz1Ge6mjFzcu6AapXqVhj6Ujs6AJttYxWJ2cAPW3
         TBP7E5W7JqkxR/URUd18N9zVfH7rB3sreu3Bz3R+T4slGQf4DP47KcHmcK8QxC+uExr8
         7IKBSbboXCozhrt7mPlrVDWbuhj4T5ARP42b+Ip5dMkXErdaXosmH43F1VAMC5ktQL1T
         S1hgZekwcOMR7uirc3mL3TD9G+/auPBmxkljCOJ3VBnxaitkYO+Oy65vJCgTUjiDfPJP
         FN4Q==
X-Gm-Message-State: AJIora+35oOkkG4FHdPMj65QV7GNi8tY8V1DRtUC0mmD9EmxaaNg4OE5
        CtuLKnBLQJUAqoBQXv2PqHZbhTP+uMa6azu1vQ==
X-Google-Smtp-Source: AGRyM1vov+co30UkhlpMFkCv16wQz5Y36w5l/CsmBztWgrqpIsFJp2fvlSpQSueDSb7FKEdWEPgSZo1iHk9nkbZt1Q==
X-Received: from devel.c.googlers.com ([fda3:e722:ac3:cc00:31:98fb:c0a8:4ea])
 (user=varadgautam job=sendgmr) by 2002:a81:83c1:0:b0:31c:782f:7a42 with SMTP
 id t184-20020a8183c1000000b0031c782f7a42mr21651503ywf.399.1657033228690; Tue,
 05 Jul 2022 08:00:28 -0700 (PDT)
Date:   Tue,  5 Jul 2022 15:00:02 +0000
Message-Id: <20220705150002.2016207-1-varadgautam@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.37.0.rc0.161.g10f37bed90-goog
Subject: [PATCH] thermal: sysfs: Perform bounds check when storing thermal states
From:   Varad Gautam <varadgautam@google.com>
To:     linux-kernel@vger.kernel.org
Cc:     "Rafael J . Wysocki" <rafael@kernel.org>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Amit Kucheria <amitk@kernel.org>,
        Zhang Rui <rui.zhang@intel.com>, linux-pm@vger.kernel.org,
        Varad Gautam <varadgautam@google.com>, stable@vger.kernel.org
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

Check that a user-provided thermal state is within the maximum
thermal states supported by a given driver before attempting to
apply it. This prevents a subsequent OOB access in
thermal_cooling_device_stats_update() while performing
state-transition accounting on drivers that do not have this check
in their set_cur_state() handle.

Signed-off-by: Varad Gautam <varadgautam@google.com>
Cc: stable@vger.kernel.org
---
 drivers/thermal/thermal_sysfs.c | 12 +++++++++++-
 1 file changed, 11 insertions(+), 1 deletion(-)

diff --git a/drivers/thermal/thermal_sysfs.c b/drivers/thermal/thermal_sysfs.c
index 1c4aac8464a7..0c6b0223b133 100644
--- a/drivers/thermal/thermal_sysfs.c
+++ b/drivers/thermal/thermal_sysfs.c
@@ -607,7 +607,7 @@ cur_state_store(struct device *dev, struct device_attribute *attr,
 		const char *buf, size_t count)
 {
 	struct thermal_cooling_device *cdev = to_cooling_device(dev);
-	unsigned long state;
+	unsigned long state, max_state;
 	int result;
 
 	if (sscanf(buf, "%ld\n", &state) != 1)
@@ -618,10 +618,20 @@ cur_state_store(struct device *dev, struct device_attribute *attr,
 
 	mutex_lock(&cdev->lock);
 
+	result = cdev->ops->get_max_state(cdev, &max_state);
+	if (result)
+		goto unlock;
+
+	if (state > max_state) {
+		result = -EINVAL;
+		goto unlock;
+	}
+
 	result = cdev->ops->set_cur_state(cdev, state);
 	if (!result)
 		thermal_cooling_device_stats_update(cdev, state);
 
+unlock:
 	mutex_unlock(&cdev->lock);
 	return result ? result : count;
 }
-- 
2.37.0.rc0.161.g10f37bed90-goog

