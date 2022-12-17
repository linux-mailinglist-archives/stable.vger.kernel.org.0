Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1D5E364F9FA
	for <lists+stable@lfdr.de>; Sat, 17 Dec 2022 16:32:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230382AbiLQPcb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 17 Dec 2022 10:32:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37296 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230259AbiLQPbW (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 17 Dec 2022 10:31:22 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4B484193E3;
        Sat, 17 Dec 2022 07:28:47 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E8383B802C8;
        Sat, 17 Dec 2022 15:28:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 78E56C433F0;
        Sat, 17 Dec 2022 15:28:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1671290924;
        bh=SUJBw4+DYl7yZy510RN/erYq4QOUqjRd4IEOBFkRAfE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Xx6Lfok/82rtxiG9qXdotcqKo7DbbCJy4KksOqT7Vbo8wOVEuR1kenSSLOgB2Lm8K
         5jXmUo1zHrFCazgzWNPHkVpGgGS17yuttMmpIsRanyY/2H1FNIsFaus4tlZe2avUkq
         oCNgnLyRVGhvOa44a6L1LQGLMEtzOsLVil6fZFtiOd17VviTdt/EQmMbuUJxd+TTUb
         MeLbaCik144WHIy4jlQqlS3X7BP2gi7pcJ/YMy1pk0F+joLmFbAlSTmAJluM94b9sp
         72IQKBJXlSYOtugXxGvFZaMhnnFvAlQCNeOQLUkYB+3YdquPHqx3Ea4nZF0eDM8IXi
         tRie0McHudmqw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Zheng Yejian <zhengyejian1@huawei.com>,
        Hanjun Guo <guohanjun@huawei.com>,
        Randy Dunlap <rdunlap@infradead.org>,
        Vlastimil Babka <vbabka@suse.cz>,
        Zhang Jinhao <zhangjinhao2@huawei.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Sasha Levin <sashal@kernel.org>, tangmeng@uniontech.com,
        willy@infradead.org, mcgrof@kernel.org
Subject: [PATCH AUTOSEL 6.0 12/16] acct: fix potential integer overflow in encode_comp_t()
Date:   Sat, 17 Dec 2022 10:28:15 -0500
Message-Id: <20221217152821.98618-12-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221217152821.98618-1-sashal@kernel.org>
References: <20221217152821.98618-1-sashal@kernel.org>
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
index 13706356ec54..67bde1633d8f 100644
--- a/kernel/acct.c
+++ b/kernel/acct.c
@@ -350,6 +350,8 @@ static comp_t encode_comp_t(unsigned long value)
 		exp++;
 	}
 
+	if (exp > (((comp_t) ~0U) >> MANTSIZE))
+		return (comp_t) ~0U;
 	/*
 	 * Clean it up and polish it off.
 	 */
-- 
2.35.1

