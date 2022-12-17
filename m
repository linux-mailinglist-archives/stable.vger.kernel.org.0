Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F347464FAC2
	for <lists+stable@lfdr.de>; Sat, 17 Dec 2022 16:45:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230076AbiLQPfL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 17 Dec 2022 10:35:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37940 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230288AbiLQPdm (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 17 Dec 2022 10:33:42 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A9A07167C0;
        Sat, 17 Dec 2022 07:29:24 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 6BC2CB80123;
        Sat, 17 Dec 2022 15:29:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1228EC433F0;
        Sat, 17 Dec 2022 15:29:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1671290962;
        bh=qR0vw+uQELOwhOUev5/wnJO2JEk9ykAYOvrnAJzGcKs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=g5eyvnlKw8jePeaONi5vrZ4UCwL1qh1Mtu6ZqIC8hOfx9pbBjKHXXXtar1NR+UiVT
         yXR43aeB35nzXQ5JpYixu4gT4yGKe4S9PamHzYzSVFd5AGbB5ZdyQ7at1rIj2ebOTf
         Vfxnjw5rR2C4/rE94RYVhggFCP6KwJ5UWE/TNiGgphA9fRfCgrs/YPeOxq5+P57z5o
         RTpjB934NIWD+57n5ETVm8RxsYsec1hUUQN+CTuKg9an7w0A+okYFZkpBVMH1Em4hr
         +LLqfKP2gL2omOERsg9wVHfLwIKyOG16quwqMSnGAneeOTS2SarlVg8OaHQmP5QGx/
         dSJtzBhpz78iQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Zheng Yejian <zhengyejian1@huawei.com>,
        Hanjun Guo <guohanjun@huawei.com>,
        Randy Dunlap <rdunlap@infradead.org>,
        Vlastimil Babka <vbabka@suse.cz>,
        Zhang Jinhao <zhangjinhao2@huawei.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Sasha Levin <sashal@kernel.org>, dave@stgolabs.net,
        tangmeng@uniontech.com, willy@infradead.org
Subject: [PATCH AUTOSEL 5.15 09/10] acct: fix potential integer overflow in encode_comp_t()
Date:   Sat, 17 Dec 2022 10:28:59 -0500
Message-Id: <20221217152902.98870-9-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221217152902.98870-1-sashal@kernel.org>
References: <20221217152902.98870-1-sashal@kernel.org>
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
index 23a7ab8e6cbc..2b5cc63eb295 100644
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

