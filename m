Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B5AC06915EC
	for <lists+stable@lfdr.de>; Fri, 10 Feb 2023 01:56:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231273AbjBJA4L (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 9 Feb 2023 19:56:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45036 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231233AbjBJAyu (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 9 Feb 2023 19:54:50 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7303C6ADC6;
        Thu,  9 Feb 2023 16:53:56 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0FE8761C32;
        Fri, 10 Feb 2023 00:53:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6BE3AC433D2;
        Fri, 10 Feb 2023 00:53:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1675990435;
        bh=MS1rqPeO1aEeewqtUr+a0NRCZiTtFqwuj/ljrnFbKto=;
        h=Date:To:From:Subject:From;
        b=1/hBAfbvCTUeFZ4SQJzpZB7I53JRoOGQfm1Afo5H94DY42tGxiVjVYirXw2UzRKLO
         62QvhGX17yyTF5IKYuRkIuFwqBkgtKjDc6siJ/VxWEWk5rfxEEmE1zfVy0ftalCAg8
         RGJY/OVvDcLbcWNiXQxf22N9nATD5jzwLLzeaSUQ=
Date:   Thu, 09 Feb 2023 16:53:54 -0800
To:     mm-commits@vger.kernel.org, wangkefeng.wang@huawei.com,
        stable@vger.kernel.org, guohanjun@huawei.com,
        aneesh.kumar@linux.ibm.com, tongtiangen@huawei.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] memory-tier-release-the-new_memtier-in-find_create_memory_tier.patch removed from -mm tree
Message-Id: <20230210005355.6BE3AC433D2@smtp.kernel.org>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The quilt patch titled
     Subject: memory tier: release the new_memtier in find_create_memory_tier()
has been removed from the -mm tree.  Its filename was
     memory-tier-release-the-new_memtier-in-find_create_memory_tier.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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

 mm/memory-tiers.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

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


