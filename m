Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A6CF65E9F72
	for <lists+stable@lfdr.de>; Mon, 26 Sep 2022 12:25:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235361AbiIZKZq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Sep 2022 06:25:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32868 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235698AbiIZKYl (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 26 Sep 2022 06:24:41 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DC2334D829;
        Mon, 26 Sep 2022 03:18:06 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 8D616B80926;
        Mon, 26 Sep 2022 10:17:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CC904C433D6;
        Mon, 26 Sep 2022 10:17:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1664187442;
        bh=lhoE/cFx/P8/ivf4LvyubzIl1QwD9KbA+ytQn9KVuEY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Tn2UlCQL0SL5oiQkihb9WyBlZJnBT8TpW6ClWt7K+3sKXHLb2vbWHNtihlOR4zJEX
         EXLh4k3usQfkPf1JcUUK5+uCyiwfqvguTwQwZavQDUQXMublJd0niVMhoMwMfkrYGT
         uerpEfDyz41hnpFe9Y5mWYQBKhhfyaYuOTdd5ECc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Sergey Shtylyov <s.shtylyov@omp.ru>,
        Rob Herring <robh@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 01/58] of: fdt: fix off-by-one error in unflatten_dt_nodes()
Date:   Mon, 26 Sep 2022 12:11:20 +0200
Message-Id: <20220926100741.483470129@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20220926100741.430882406@linuxfoundation.org>
References: <20220926100741.430882406@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sergey Shtylyov <s.shtylyov@omp.ru>

[ Upstream commit 2f945a792f67815abca26fa8a5e863ccf3fa1181 ]

Commit 78c44d910d3e ("drivers/of: Fix depth when unflattening devicetree")
forgot to fix up the depth check in the loop body in unflatten_dt_nodes()
which makes it possible to overflow the nps[] buffer...

Found by Linux Verification Center (linuxtesting.org) with the SVACE static
analysis tool.

Fixes: 78c44d910d3e ("drivers/of: Fix depth when unflattening devicetree")
Signed-off-by: Sergey Shtylyov <s.shtylyov@omp.ru>
Signed-off-by: Rob Herring <robh@kernel.org>
Link: https://lore.kernel.org/r/7c354554-006f-6b31-c195-cdfe4caee392@omp.ru
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/of/fdt.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/of/fdt.c b/drivers/of/fdt.c
index 9fecac72c358..7c284ca0212c 100644
--- a/drivers/of/fdt.c
+++ b/drivers/of/fdt.c
@@ -392,7 +392,7 @@ static int unflatten_dt_nodes(const void *blob,
 	for (offset = 0;
 	     offset >= 0 && depth >= initial_depth;
 	     offset = fdt_next_node(blob, offset, &depth)) {
-		if (WARN_ON_ONCE(depth >= FDT_MAX_DEPTH))
+		if (WARN_ON_ONCE(depth >= FDT_MAX_DEPTH - 1))
 			continue;
 
 		if (!IS_ENABLED(CONFIG_OF_KOBJ) &&
-- 
2.35.1



