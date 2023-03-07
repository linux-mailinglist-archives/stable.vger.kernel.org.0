Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9511D6AF2C2
	for <lists+stable@lfdr.de>; Tue,  7 Mar 2023 19:56:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233450AbjCGS4K (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Mar 2023 13:56:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59490 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230064AbjCGSzv (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Mar 2023 13:55:51 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6CFD795BF5
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 10:43:19 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 4F9FFB8199A
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 18:42:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9E315C433EF;
        Tue,  7 Mar 2023 18:42:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678214577;
        bh=zORnDqSNv9UPwq7Cqmz+9o/qYe6mD3ACLDiFyBUFARw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=OdJWySvLVXjKkJ4YDZSRSTGIPsB7SNiKABT/W0ljeD/HE+Wa4T/WrBD9ULEZkYHYu
         YChplwBuDJI84TYjalqVbp9Dt/3wWNoHNQT9wBjZy3rLpUhOdlvXz8XdZSbgQeeGh0
         PveMVq9MyijzCwrw5A8fBRNRUAgrbM7CMQKxBtwA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Tong Tiangen <tongtiangen@huawei.com>,
        "Aneesh Kumar K.V" <aneesh.kumar@linux.ibm.com>,
        Hanjun Guo <guohanjun@huawei.com>,
        Kefeng Wang <wangkefeng.wang@huawei.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.1 837/885] memory tier: release the new_memtier in find_create_memory_tier()
Date:   Tue,  7 Mar 2023 18:02:51 +0100
Message-Id: <20230307170038.209335231@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307170001.594919529@linuxfoundation.org>
References: <20230307170001.594919529@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Tong Tiangen <tongtiangen@huawei.com>

commit 93419139fa14124c1c507d804f2b28866ebee28d upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/memory-tiers.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/mm/memory-tiers.c b/mm/memory-tiers.c
index c734658c6242..e593e56e530b 100644
--- a/mm/memory-tiers.c
+++ b/mm/memory-tiers.c
@@ -211,8 +211,8 @@ static struct memory_tier *find_create_memory_tier(struct memory_dev_type *memty
 
 	ret = device_register(&new_memtier->dev);
 	if (ret) {
-		list_del(&memtier->list);
-		put_device(&memtier->dev);
+		list_del(&new_memtier->list);
+		put_device(&new_memtier->dev);
 		return ERR_PTR(ret);
 	}
 	memtier = new_memtier;
-- 
2.39.2



