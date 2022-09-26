Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 974AA5E9F18
	for <lists+stable@lfdr.de>; Mon, 26 Sep 2022 12:19:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235011AbiIZKT0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Sep 2022 06:19:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44056 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235120AbiIZKSg (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 26 Sep 2022 06:18:36 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D0A723F30C;
        Mon, 26 Sep 2022 03:15:16 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 706DB60C05;
        Mon, 26 Sep 2022 10:15:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 74B9CC433C1;
        Mon, 26 Sep 2022 10:15:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1664187314;
        bh=CG9aAULDUhtiAPLE9alwsdWAAH+xFtD0LK43un1xG8A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MblFZi+5kUTzhhGUdcrJZx+SZbtTdQnPQJIhnLSFp+sZ+ZqQRyDhipsPYa1Nu/t+J
         IgEeBb/KvRXPjTiofKzUo76VTkXrDdtNLbRmsJhqp7dxNUFr5OQm4lwLqLlk8i+8z4
         hJAociYXjFa2raXYFN1HWon48tqo7gZAELhFWRJQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Sergey Shtylyov <s.shtylyov@omp.ru>,
        Rob Herring <robh@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 01/40] of: fdt: fix off-by-one error in unflatten_dt_nodes()
Date:   Mon, 26 Sep 2022 12:11:29 +0200
Message-Id: <20220926100738.249994311@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20220926100738.148626940@linuxfoundation.org>
References: <20220926100738.148626940@linuxfoundation.org>
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
index 512d3a8439c9..cc9b8c699da4 100644
--- a/drivers/of/fdt.c
+++ b/drivers/of/fdt.c
@@ -425,7 +425,7 @@ static int unflatten_dt_nodes(const void *blob,
 	for (offset = 0;
 	     offset >= 0 && depth >= initial_depth;
 	     offset = fdt_next_node(blob, offset, &depth)) {
-		if (WARN_ON_ONCE(depth >= FDT_MAX_DEPTH))
+		if (WARN_ON_ONCE(depth >= FDT_MAX_DEPTH - 1))
 			continue;
 
 		fpsizes[depth+1] = populate_node(blob, offset, &mem,
-- 
2.35.1



