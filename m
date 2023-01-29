Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EAD9368021D
	for <lists+stable@lfdr.de>; Sun, 29 Jan 2023 23:05:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229523AbjA2WFv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 29 Jan 2023 17:05:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36758 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232647AbjA2WFu (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 29 Jan 2023 17:05:50 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 984E4113C8;
        Sun, 29 Jan 2023 14:05:49 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 5636EB80D1A;
        Sun, 29 Jan 2023 22:05:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EC6F0C433D2;
        Sun, 29 Jan 2023 22:05:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1675029947;
        bh=TvBlRqkIBqN7t39Rr7524fjGtfo3RUXa2GJpVyCJwqY=;
        h=Date:To:From:Subject:From;
        b=SwuYonsMKSgJ5K/IcImL5XGMoX4x67zVPRWV69nCPmTSYWbwPye0phk2jp3kU1D+y
         n1TY9kuQtmmHRQDsPuUG9B822MoL5MO9ON6zSuHou1i4cuUFK4MFkeOX0IiY6HJ2NS
         awpcJI1wuh+KSok6xj17ZHf8EqoppmSpe34RGWoM=
Date:   Sun, 29 Jan 2023 14:05:46 -0800
To:     mm-commits@vger.kernel.org, wangkefeng.wang@huawei.com,
        stable@vger.kernel.org, guohanjun@huawei.com,
        aneesh.kumar@linux.ibm.com, tongtiangen@huawei.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + memory-tier-release-the-new_memtier-in-find_create_memory_tier.patch added to mm-unstable branch
Message-Id: <20230129220546.EC6F0C433D2@smtp.kernel.org>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch titled
     Subject: memory tier: release the new_memtier in find_create_memory_tier()
has been added to the -mm mm-unstable branch.  Its filename is
     memory-tier-release-the-new_memtier-in-find_create_memory_tier.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/memory-tier-release-the-new_memtier-in-find_create_memory_tier.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: Tong Tiangen <tongtiangen@huawei.com>
Subject: memory tier: release the new_memtier in find_create_memory_tier()
Date: Sun, 29 Jan 2023 04:06:51 +0000

In find_create_memory_tier(), if failed to register device, then we should
release new_memtier from the tier list and put device instead of memtier.

Link: https://lkml.kernel.org/r/20230129040651.1329208-1-tongtiangen@huawei.com
Fixes: 9832fb87834e ("mm/demotion: expose memory tier details via sysfs")
Signed-off-by: Tong Tiangen <tongtiangen@huawei.com>
Cc: Aneesh Kumar K.V <aneesh.kumar@linux.ibm.com>
Cc: Hanjun Guo <guohanjun@huawei.com>
Cc: Kefeng Wang <wangkefeng.wang@huawei.com>
Cc: Guohanjun <guohanjun@huawei.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


--- a/mm/memory-tiers.c~memory-tier-release-the-new_memtier-in-find_create_memory_tier
+++ a/mm/memory-tiers.c
@@ -211,8 +211,8 @@ static struct memory_tier *find_create_m
 
 	ret = device_register(&new_memtier->dev);
 	if (ret) {
-		list_del(&memtier->list);
-		put_device(&memtier->dev);
+		list_del(&new_memtier->list);
+		put_device(&new_memtier->dev);
 		return ERR_PTR(ret);
 	}
 	memtier = new_memtier;
_

Patches currently in -mm which might be from tongtiangen@huawei.com are

memory-tier-release-the-new_memtier-in-find_create_memory_tier.patch

