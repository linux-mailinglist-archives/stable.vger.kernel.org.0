Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6F93464FAC9
	for <lists+stable@lfdr.de>; Sat, 17 Dec 2022 16:45:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231143AbiLQPgc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 17 Dec 2022 10:36:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37448 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230416AbiLQPfV (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 17 Dec 2022 10:35:21 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9607B1742A;
        Sat, 17 Dec 2022 07:29:46 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 56AE2B80123;
        Sat, 17 Dec 2022 15:29:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E4FE4C43396;
        Sat, 17 Dec 2022 15:29:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1671290984;
        bh=vk0rEk4KEdQ9pp2rYAjGKe4A74Kz/oXEyEoQyQqwR1o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Vikb3agLXK7th8kfK3rHOOTWyb/89EEgqHG0A6/KwrZOMU99gm23LShzQ/yriJJCa
         bzVZFAdGwzZakE5vx5qN/aFtoFixz6X7HHF9iThgk26VgkOxanheVIY5QEc73poTZS
         i4FwrC5LYe9X6pM5mep8YcoFqxsLxk+K80zX23c8vvLVg0XEcd9jEfs7AlVz9Pna8u
         PK9c03vDcD86qDouskPyqVuGvMMwY0SjlAgRHt9LfZCnfvvdTOHfUedj6tIK0a630E
         xda4vDxWr2pM0ePEtQKoBtvUNIDZyDrADL+9mWmTsqMueojgwP9u1nIg9N9Vi1XS3n
         XrROR9W9nHBRg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Zheng Yejian <zhengyejian1@huawei.com>,
        Hanjun Guo <guohanjun@huawei.com>,
        Randy Dunlap <rdunlap@infradead.org>,
        Vlastimil Babka <vbabka@suse.cz>,
        Zhang Jinhao <zhangjinhao2@huawei.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Sasha Levin <sashal@kernel.org>, mcgrof@kernel.org,
        willy@infradead.org, tangmeng@uniontech.com
Subject: [PATCH AUTOSEL 5.10 8/9] acct: fix potential integer overflow in encode_comp_t()
Date:   Sat, 17 Dec 2022 10:29:25 -0500
Message-Id: <20221217152927.99012-8-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221217152927.99012-1-sashal@kernel.org>
References: <20221217152927.99012-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Zheng Yejian <zhengyejian1@huawei.com>

[ Upstream commit c5f31c655bcc01b6da53b836ac951c1556245305 ]

The integer overflow is descripted with following codes:
  > 317 static comp_t encode_comp_t(u64 value)
  > 318 {
  > 319         int exp, rnd;
    ......
  > 341         exp <<= MANTSIZE;
  > 342         exp += value;
  > 343         return exp;
  > 344 }

Currently comp_t is defined as type of '__u16', but the variable 'exp' is
type of 'int', so overflow would happen when variable 'exp' in line 343 is
greater than 65535.

Link: https://lkml.kernel.org/r/20210515140631.369106-3-zhengyejian1@huawei.com
Signed-off-by: Zheng Yejian <zhengyejian1@huawei.com>
Cc: Hanjun Guo <guohanjun@huawei.com>
Cc: Randy Dunlap <rdunlap@infradead.org>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Zhang Jinhao <zhangjinhao2@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/acct.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/kernel/acct.c b/kernel/acct.c
index f175df8f6aa4..12f7dacf560e 100644
--- a/kernel/acct.c
+++ b/kernel/acct.c
@@ -331,6 +331,8 @@ static comp_t encode_comp_t(unsigned long value)
 		exp++;
 	}
 
+	if (exp > (((comp_t) ~0U) >> MANTSIZE))
+		return (comp_t) ~0U;
 	/*
 	 * Clean it up and polish it off.
 	 */
-- 
2.35.1

