Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C6CFD604029
	for <lists+stable@lfdr.de>; Wed, 19 Oct 2022 11:43:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234316AbiJSJnM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 19 Oct 2022 05:43:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45968 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234868AbiJSJlp (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 19 Oct 2022 05:41:45 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EB553559D;
        Wed, 19 Oct 2022 02:18:07 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id AF06561873;
        Wed, 19 Oct 2022 08:51:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C2E0CC433C1;
        Wed, 19 Oct 2022 08:51:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666169501;
        bh=JG8aswyTxj+PG1imCI7E1yc8Njj0+tfR7kirz+dwzUg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PJjeyq/PLW6FJSe0u7ezCfDhdt1eAkZSXCVsA8WbyhneaASXZ6nxy3+EqdFlCMwKI
         ztdIb3Om5+tNmrwRvgFEgQuLtdTW/hac8PurlDBKZYWjj+4VvFCz9BlotQDe8CQrZE
         eIZyWTFY00BUJQUpBc/mObxhQ04XVRLhKz8a46tY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Xin Liu <liuxin350@huawei.com>,
        Weibin Kong <kongweibin2@huawei.com>,
        Andrii Nakryiko <andrii@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 299/862] libbpf: Fix NULL pointer exception in API btf_dump__dump_type_data
Date:   Wed, 19 Oct 2022 10:26:26 +0200
Message-Id: <20221019083303.226230896@linuxfoundation.org>
X-Mailer: git-send-email 2.38.0
In-Reply-To: <20221019083249.951566199@linuxfoundation.org>
References: <20221019083249.951566199@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Xin Liu <liuxin350@huawei.com>

[ Upstream commit 7620bffbf72cd66a5d18e444a143b5b5989efa87 ]

We found that function btf_dump__dump_type_data can be called by the
user as an API, but in this function, the `opts` parameter may be used
as a null pointer.This causes `opts->indent_str` to trigger a NULL
pointer exception.

Fixes: 2ce8450ef5a3 ("libbpf: add bpf_object__open_{file, mem} w/ extensible opts")
Signed-off-by: Xin Liu <liuxin350@huawei.com>
Signed-off-by: Weibin Kong <kongweibin2@huawei.com>
Signed-off-by: Andrii Nakryiko <andrii@kernel.org>
Link: https://lore.kernel.org/bpf/20220917084809.30770-1-liuxin350@huawei.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/lib/bpf/btf_dump.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/lib/bpf/btf_dump.c b/tools/lib/bpf/btf_dump.c
index 627edb5bb6de..4221f73a74d0 100644
--- a/tools/lib/bpf/btf_dump.c
+++ b/tools/lib/bpf/btf_dump.c
@@ -2385,7 +2385,7 @@ int btf_dump__dump_type_data(struct btf_dump *d, __u32 id,
 	d->typed_dump->indent_lvl = OPTS_GET(opts, indent_level, 0);
 
 	/* default indent string is a tab */
-	if (!opts->indent_str)
+	if (!OPTS_GET(opts, indent_str, NULL))
 		d->typed_dump->indent_str[0] = '\t';
 	else
 		libbpf_strlcpy(d->typed_dump->indent_str, opts->indent_str,
-- 
2.35.1



