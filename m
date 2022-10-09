Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EF31D5F91FA
	for <lists+stable@lfdr.de>; Mon, 10 Oct 2022 00:44:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232290AbiJIWoX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 9 Oct 2022 18:44:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37600 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232342AbiJIWn3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 9 Oct 2022 18:43:29 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BF644419B0;
        Sun,  9 Oct 2022 15:22:33 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D99AAB80DD0;
        Sun,  9 Oct 2022 22:21:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BCCB9C433D6;
        Sun,  9 Oct 2022 22:21:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1665354078;
        bh=iOp5sUohYYKlU8xKhB8swSLrL8/OASDUJXxbMxBidxc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=AYaTr/0mJyotcQ+mlLsfLZHGDcvSnzQysDH0wfFCYMrFDh+SgqWqACpKhZKiAKqw3
         kGs3xFFOcUjkGq/fCigT9Wge5whOAty+Lfz3Ogvpk0AWSri1BpaQ436rnT9BoLmSVR
         kG0UfY7XeKyK8PZbRz6fbaU5oWFz8bD7K8P+KeZtgE9WdQjaktUFyWJFE5zcqtSzMq
         CD2RVdCSP1c5NsMz9K5HBkJvJW7WFamT1xsr/mnRvwxgYM5y7qMs+yZ5bEAC1P3O1Y
         JlhsasbH7bc5y+nvsxWKVp/HpGAprour6emixu7s5rUbq+fIWUpalcw8+dcaZUJugr
         pNMTcPBKldnQQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Xin Liu <liuxin350@huawei.com>,
        Andrii Nakryiko <andrii@kernel.org>,
        Sasha Levin <sashal@kernel.org>, ast@kernel.org,
        daniel@iogearbox.net, bpf@vger.kernel.org
Subject: [PATCH AUTOSEL 5.15 45/46] libbpf: Fix overrun in netlink attribute iteration
Date:   Sun,  9 Oct 2022 18:19:10 -0400
Message-Id: <20221009221912.1217372-45-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221009221912.1217372-1-sashal@kernel.org>
References: <20221009221912.1217372-1-sashal@kernel.org>
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
index f57e77a6e40f..3900d052ed19 100644
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

