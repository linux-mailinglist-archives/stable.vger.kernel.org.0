Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A804D681288
	for <lists+stable@lfdr.de>; Mon, 30 Jan 2023 15:22:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237694AbjA3OWL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 30 Jan 2023 09:22:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41324 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237717AbjA3OVy (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 30 Jan 2023 09:21:54 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B3C7F2F7AE
        for <stable@vger.kernel.org>; Mon, 30 Jan 2023 06:20:41 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 255996104A
        for <stable@vger.kernel.org>; Mon, 30 Jan 2023 14:20:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1495AC433EF;
        Mon, 30 Jan 2023 14:20:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1675088403;
        bh=JDU3GiYudntjq13yWE6def9ZLGThxEoAzAbiWzPFh7E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=osG2EC/pBYS44n1O0k4Jxvf0WR7jiut4ol+8plA/yxWWN/FsjR2zlGOM3QrZSjRIf
         DZxpTnqkJbYjCvXplf5jpOTe3nXlSI85bUY7yZ+wba9JFC73GTYBuaahOkigWCuCHX
         1tMevFDhZdTWD6g0BNdNyKjhj4CDVCZEXlDwV2lY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Kevin Hao <haokexin@gmail.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Subject: [PATCH 5.15 198/204] cpufreq: Move to_gov_attr_set() to cpufreq.h
Date:   Mon, 30 Jan 2023 14:52:43 +0100
Message-Id: <20230130134325.278464775@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230130134316.327556078@linuxfoundation.org>
References: <20230130134316.327556078@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Kevin Hao <haokexin@gmail.com>

commit ae26508651272695a3ab353f75ab9a8daf3da324 upstream.

So it can be reused by other codes.

Signed-off-by: Kevin Hao <haokexin@gmail.com>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/cpufreq/cpufreq_governor_attr_set.c |    5 -----
 include/linux/cpufreq.h                     |    5 +++++
 2 files changed, 5 insertions(+), 5 deletions(-)

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


