Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 887855F911A
	for <lists+stable@lfdr.de>; Mon, 10 Oct 2022 00:30:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232340AbiJIWac (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 9 Oct 2022 18:30:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60924 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232108AbiJIW1f (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 9 Oct 2022 18:27:35 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 66CC23AB02;
        Sun,  9 Oct 2022 15:18:53 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 73259B80DCD;
        Sun,  9 Oct 2022 22:18:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 746E5C43470;
        Sun,  9 Oct 2022 22:18:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1665353932;
        bh=iOp5sUohYYKlU8xKhB8swSLrL8/OASDUJXxbMxBidxc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=O49kmdwWbenAW9bsC/Pc5m87a6Ehkz2GDeKjG6+6cfHgfSHIO4y3kaG8LMDys8DMR
         5Vo3LbuATFIr9MjMTE6G0aHBbxT8fk0sYLrBcal0ThvkQJo+rkx9942ZVxvyK9FfnZ
         PUEadnW4Zzj4oLNzWMFP2LN9gq45PkHRMvh+1XvLj9da3MkS7YYX2Y1hqFwYsI+f5I
         0R1lt1v9TZYQrRx1LuNFF6qJ/W+UdOfhsUmvXZT+p1Jr89rkG6bMSf4LplqxAf/7PH
         F3iYe2ElDiclEV5fVUcK91+VSMffouBd45PVUP3MRO01UzlNry0M3cUBRazMr+h/Im
         idcdp3XMcgohw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Xin Liu <liuxin350@huawei.com>,
        Andrii Nakryiko <andrii@kernel.org>,
        Sasha Levin <sashal@kernel.org>, ast@kernel.org,
        daniel@iogearbox.net, bpf@vger.kernel.org
Subject: [PATCH AUTOSEL 5.19 69/73] libbpf: Fix overrun in netlink attribute iteration
Date:   Sun,  9 Oct 2022 18:14:47 -0400
Message-Id: <20221009221453.1216158-69-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221009221453.1216158-1-sashal@kernel.org>
References: <20221009221453.1216158-1-sashal@kernel.org>
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

