Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2B6605F938B
	for <lists+stable@lfdr.de>; Mon, 10 Oct 2022 01:36:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231262AbiJIXgd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 9 Oct 2022 19:36:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45158 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231214AbiJIXgM (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 9 Oct 2022 19:36:12 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E189A4F3A9;
        Sun,  9 Oct 2022 16:07:56 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 90FCAB80DE9;
        Sun,  9 Oct 2022 22:24:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7C27CC43150;
        Sun,  9 Oct 2022 22:24:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1665354261;
        bh=oSEwHrF3uLuQvDbP2ocyulp2gLrZ/bx2nS2MuGBDTI4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Q50tgDpeV/OyP6+FWMmVkpRVH0LQrLs8aYfKnybRfbpf8evsLJGUs4gfGiebthBQj
         v5H/ga3laHcqafl8loyYXr7ydHMpJvQj55a71ENBsflGNNI5vit8Ntca/Kr0QuWxNZ
         GCZm9lBZZtVubL+Y/jYedBcCo1w2QKTX7p7aLqWdLfvFcL/FUwV2v2K7QXi4o/7eiS
         3nG1vGimVvD6ZDNrf/MelQgSQqztUIMIesvA3wxMxFba7EReMJgguh6reMByfiFSwz
         JkwIwD18jC1I/jdadb45GgRCw8HH0jhaRgWDBGQVLEVqyzCmRicJ4Zl0+JKbSs1XQz
         u/msN/pRM9cAw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Xin Liu <liuxin350@huawei.com>,
        Andrii Nakryiko <andrii@kernel.org>,
        Sasha Levin <sashal@kernel.org>, ast@kernel.org,
        daniel@iogearbox.net, bpf@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 28/29] libbpf: Fix overrun in netlink attribute iteration
Date:   Sun,  9 Oct 2022 18:23:03 -0400
Message-Id: <20221009222304.1218873-28-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221009222304.1218873-1-sashal@kernel.org>
References: <20221009222304.1218873-1-sashal@kernel.org>
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
index 1e69c0c8d413..faa6256d857a 100644
--- a/tools/lib/bpf/nlattr.c
+++ b/tools/lib/bpf/nlattr.c
@@ -31,7 +31,7 @@ static struct nlattr *nla_next(const struct nlattr *nla, int *remaining)
 
 static int nla_ok(const struct nlattr *nla, int remaining)
 {
-	return remaining >= sizeof(*nla) &&
+	return remaining >= (int)sizeof(*nla) &&
 	       nla->nla_len >= sizeof(*nla) &&
 	       nla->nla_len <= remaining;
 }
-- 
2.35.1

