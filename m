Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 69B1D5F9287
	for <lists+stable@lfdr.de>; Mon, 10 Oct 2022 00:49:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233120AbiJIWt5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 9 Oct 2022 18:49:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56660 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233213AbiJIWsL (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 9 Oct 2022 18:48:11 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E424A21B5;
        Sun,  9 Oct 2022 15:24:38 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 672AF60CF5;
        Sun,  9 Oct 2022 22:22:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EB095C43470;
        Sun,  9 Oct 2022 22:22:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1665354178;
        bh=2Sj7O+erMHJGAMzPNnqV1KY//aM847UrlErlhJZbn0A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=IRl3SprXVddMbSHbvvBZEcQlgDd0hmmv3kWfj3enqPnSP8dfJ+t3bpdVZwnDQ2TmG
         azgyuOhoLqJUAc37dEYVtvQdqZSpDndKyeeRkxioVo0zMc2crX6Tq/Ma/wNI04Ljtv
         2C01q+JAx1RJ8rhKM1yk7m6BfXH8UQNdhaME0Kh8uDzGBfR//mXzkAgp8w47MBB2N9
         NXtuXcxMF3Wy6cwMZ8/xP9YMogvYrPYPs5/8ir0jrD5DsB89NuEJQH/UDxEr4SRbWa
         FxSFvrT5suqvlP5PFKsHS26Awq102oNH12edrYX/EsRU8SUWC2CMyVDGUujwOGJT6J
         5vgPBE0iBghnA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Xin Liu <liuxin350@huawei.com>,
        Andrii Nakryiko <andrii@kernel.org>,
        Sasha Levin <sashal@kernel.org>, ast@kernel.org,
        daniel@iogearbox.net, bpf@vger.kernel.org
Subject: [PATCH AUTOSEL 5.10 33/34] libbpf: Fix overrun in netlink attribute iteration
Date:   Sun,  9 Oct 2022 18:21:27 -0400
Message-Id: <20221009222129.1218277-33-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221009222129.1218277-1-sashal@kernel.org>
References: <20221009222129.1218277-1-sashal@kernel.org>
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

From: Xin Liu <liuxin350@huawei.com>

[ Upstream commit 51e05a8cf8eb34da7473823b7f236a77adfef0b4 ]

I accidentally found that a change in commit 1045b03e07d8 ("netlink: fix
overrun in attribute iteration") was not synchronized to the function
`nla_ok` in tools/lib/bpf/nlattr.c, I think it is necessary to modify,
this patch will do it.

Signed-off-by: Xin Liu <liuxin350@huawei.com>
Signed-off-by: Andrii Nakryiko <andrii@kernel.org>
Link: https://lore.kernel.org/bpf/20220930090708.62394-1-liuxin350@huawei.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/lib/bpf/nlattr.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/lib/bpf/nlattr.c b/tools/lib/bpf/nlattr.c
index b607fa9852b1..8f00a2ee5762 100644
--- a/tools/lib/bpf/nlattr.c
+++ b/tools/lib/bpf/nlattr.c
@@ -32,7 +32,7 @@ static struct nlattr *nla_next(const struct nlattr *nla, int *remaining)
 
 static int nla_ok(const struct nlattr *nla, int remaining)
 {
-	return remaining >= sizeof(*nla) &&
+	return remaining >= (int)sizeof(*nla) &&
 	       nla->nla_len >= sizeof(*nla) &&
 	       nla->nla_len <= remaining;
 }
-- 
2.35.1

