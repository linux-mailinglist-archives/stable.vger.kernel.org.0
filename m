Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3CB4A64FA61
	for <lists+stable@lfdr.de>; Sat, 17 Dec 2022 16:45:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230459AbiLQPiL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 17 Dec 2022 10:38:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45640 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231379AbiLQPhb (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 17 Dec 2022 10:37:31 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7126627CF5;
        Sat, 17 Dec 2022 07:30:32 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D8AFB60C20;
        Sat, 17 Dec 2022 15:30:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 01E22C433EF;
        Sat, 17 Dec 2022 15:30:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1671291027;
        bh=caxgmjtgxjZKoLQLy+1Hct9sya6Wbi6VZ+xjJLZxB1A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=aILg4jmsCWmBerMwXW8W0LiSa9Se94YLUUQAN/2ffn4+2y6zzh9H4Ws0wB7tbdtaZ
         XUlXDAP4ue+/2j+c83CYjv7QBJ2pURKX8oa9nPYn7h2MXMiFQ2383UDgVEA5U4lp2V
         HhI1ulizQzTGEsT3VoPu1TqfIlrl8x47DMINpi2acEO+7wQW7INpmq8JEJ80gPG1v9
         91XmEPS6smvldgnZeYnk/QCWGXmMtODzhbVTu5xhNTBJGXztjXOdTRd4wYrjJwukI0
         jrlvTH5OD3n23XFnEIavNNDzhdoTj/dLstkrgT8yHGZtROS6dLzg+WDDHfXWaoMivm
         dqQ1EuivWno+w==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Zheng Yejian <zhengyejian1@huawei.com>,
        Hanjun Guo <guohanjun@huawei.com>,
        Randy Dunlap <rdunlap@infradead.org>,
        Vlastimil Babka <vbabka@suse.cz>,
        Zhang Jinhao <zhangjinhao2@huawei.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Sasha Levin <sashal@kernel.org>, mcgrof@kernel.org,
        Liam.Howlett@Oracle.com, tangmeng@uniontech.com,
        willy@infradead.org
Subject: [PATCH AUTOSEL 4.19 7/8] acct: fix potential integer overflow in encode_comp_t()
Date:   Sat, 17 Dec 2022 10:30:09 -0500
Message-Id: <20221217153012.99273-7-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221217153012.99273-1-sashal@kernel.org>
References: <20221217153012.99273-1-sashal@kernel.org>
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
index 81f9831a7859..6d98aed403ba 100644
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

