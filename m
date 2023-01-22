Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 35C5D676DC5
	for <lists+stable@lfdr.de>; Sun, 22 Jan 2023 15:46:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229831AbjAVOqR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 22 Jan 2023 09:46:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52646 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229867AbjAVOqP (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 22 Jan 2023 09:46:15 -0500
Received: from mail-pl1-x630.google.com (mail-pl1-x630.google.com [IPv6:2607:f8b0:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 834B71BAF5
        for <stable@vger.kernel.org>; Sun, 22 Jan 2023 06:46:14 -0800 (PST)
Received: by mail-pl1-x630.google.com with SMTP id v23so9218960plo.1
        for <stable@vger.kernel.org>; Sun, 22 Jan 2023 06:46:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=SyqH4MZuoCYVADjinnBlJO20WdC+ReJYDP7lnzJ79lU=;
        b=Rtn+t+H45FDWvciBY8aLm3opEdjIXtVt1pfOMleNP6W5FLHSEW+N4NDqQHf0Zb0vt1
         lVAqRx4bO4C9EkVOIn0n8o6LT6Y/oHWJTvcuHCfew8GYGsS2NWZRifzk0s5S3GxcxJ99
         402pxbrkt5C1Z4n9GSZSAXTDu/vOlQQpOQ07WlE6taB/qwjYRaSAYKeW1GSjp43iiJJD
         +hyz0DZ0e0c46kQX816u8mk9XzfsNldfmiE8w8QXx68n33LCsZdhVqBeiyp21xQ946QV
         ckA7lfKInSwiGlJhEgRH3HyMM6c15/thzFs8te73TiGXQwnM21O2heTAF3E03Jb76utX
         ui3Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=SyqH4MZuoCYVADjinnBlJO20WdC+ReJYDP7lnzJ79lU=;
        b=4e+gsi/3lFKjvcWOb+ak0oFh0AFcbNefxgmBQ8LF36RHLv32XF/9d9yQBhzq5B5xeV
         cTONVGwKMQ/xXYD5zAR66/D5bwo6tKCDpmX3NRqoD2Pvpa7EB+sb2JGgrkWNpRKpGKRe
         1IcfIASaqlJQ5TgWZ7K3n7Stm5e22CE0lh0VMBr5vACp9x3ssIWucXSt1UjZqT7BqAlg
         20EZqUPL17DaZQiP6G8TJJpBhvVIOx9TZCd1oZPekBbuGM+aVXoopQC2FM+trQXROHVF
         Yps8iSn3B2M22WHwz6RC4eQ8G6FQ1mJ0Hb7uI3SQTbClxEWapIZ1SJsrze9vGx/Munkq
         8ikg==
X-Gm-Message-State: AFqh2kozKqT8CILflmZ6GBYZ5JjPMQnjxUz5aLhkd6i7hF15aEPKXCea
        UVH9LjFjdh9BJRRGqQG4q2Ala87tnTQ=
X-Google-Smtp-Source: AMrXdXvvic/iFJgIycDPOyGhl0rjc/X8p+1793e1Vf+kJP+mIEwqB/h4gCfN6sjoC+z86HEVBDwgFw==
X-Received: by 2002:a17:902:7787:b0:194:5d26:11cc with SMTP id o7-20020a170902778700b001945d2611ccmr21877034pll.6.1674398773552;
        Sun, 22 Jan 2023 06:46:13 -0800 (PST)
Received: from pek-lpggp6.wrs.com (unknown-105-121.windriver.com. [147.11.105.121])
        by smtp.gmail.com with ESMTPSA id p9-20020a170902780900b00188fc6766d6sm30210731pll.219.2023.01.22.06.46.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 22 Jan 2023 06:46:13 -0800 (PST)
From:   Kevin Hao <haokexin@gmail.com>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>,
        "Rafael J . Wysocki" <rafael.j.wysocki@intel.com>
Subject: [PATCH 5.15 v2 1/2] cpufreq: Move to_gov_attr_set() to cpufreq.h
Date:   Sun, 22 Jan 2023 22:40:54 +0800
Message-Id: <20230122144055.3275512-1-haokexin@gmail.com>
X-Mailer: git-send-email 2.38.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

commit ae26508651272695a3ab353f75ab9a8daf3da324 stream.

So it can be reused by other codes.

Signed-off-by: Kevin Hao <haokexin@gmail.com>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
---
v2: This prerequisite commit was missed in the v1.

 drivers/cpufreq/cpufreq_governor_attr_set.c | 5 -----
 include/linux/cpufreq.h                     | 5 +++++
 2 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/cpufreq/cpufreq_governor_attr_set.c b/drivers/cpufreq/cpufreq_governor_attr_set.c
index a6f365b9cc1a..771770ea0ed0 100644
--- a/drivers/cpufreq/cpufreq_governor_attr_set.c
+++ b/drivers/cpufreq/cpufreq_governor_attr_set.c
@@ -8,11 +8,6 @@
 
 #include "cpufreq_governor.h"
 
-static inline struct gov_attr_set *to_gov_attr_set(struct kobject *kobj)
-{
-	return container_of(kobj, struct gov_attr_set, kobj);
-}
-
 static inline struct governor_attr *to_gov_attr(struct attribute *attr)
 {
 	return container_of(attr, struct governor_attr, attr);
diff --git a/include/linux/cpufreq.h b/include/linux/cpufreq.h
index 66a1f495f01a..025391be1b19 100644
--- a/include/linux/cpufreq.h
+++ b/include/linux/cpufreq.h
@@ -643,6 +643,11 @@ struct gov_attr_set {
 /* sysfs ops for cpufreq governors */
 extern const struct sysfs_ops governor_sysfs_ops;
 
+static inline struct gov_attr_set *to_gov_attr_set(struct kobject *kobj)
+{
+	return container_of(kobj, struct gov_attr_set, kobj);
+}
+
 void gov_attr_set_init(struct gov_attr_set *attr_set, struct list_head *list_node);
 void gov_attr_set_get(struct gov_attr_set *attr_set, struct list_head *list_node);
 unsigned int gov_attr_set_put(struct gov_attr_set *attr_set, struct list_head *list_node);
-- 
2.38.1

