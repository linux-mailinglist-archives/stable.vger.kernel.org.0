Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 19EB2655754
	for <lists+stable@lfdr.de>; Sat, 24 Dec 2022 02:33:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236593AbiLXBdu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 23 Dec 2022 20:33:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57636 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236492AbiLXBdV (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 23 Dec 2022 20:33:21 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 76B3A36C4B;
        Fri, 23 Dec 2022 17:31:16 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C976BB8213E;
        Sat, 24 Dec 2022 01:31:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9EE96C433D2;
        Sat, 24 Dec 2022 01:31:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1671845473;
        bh=o3h8QFf1heCMKB4WGULMIN1ny+WcA+y3nrdHIvaaL8Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qPulpUxOQaJyZd1F5vi8imFbZ0kpOgWUpLz8lW4XKIsDCnPav9rCqfYjGX9Wa5fJo
         iQ2BLWGIwwBp8aD6zC5uKT8Wtgt/I23zO9EyNDml7OWrnU/DwD+9zJVCJmt0gGizC+
         ST2TwHhJluhOd7xla3wbuHEIwcyaPs4QIhkkcpx+7roHHD2DD22xYDB+XU2hwQb9DM
         7iqLT8paS+VA4UR9W7/9CViOJksXF8wo46Ob+bD1Cn1lRC/f76ZFC+RPR6kSqUXbN1
         OSjev2mQydcmCE9G6XThsNcMVwlwmWVOoyQpE8vJ2rW/C3wvdhCAjehiKoaHZiNnN0
         SnD2Q6c1UyiQg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     farah kassabri <fkassabri@habana.ai>,
        Oded Gabbay <ogabbay@kernel.org>,
        Sasha Levin <sashal@kernel.org>, gregkh@linuxfoundation.org,
        osharabi@habana.ai, ynudelman@habana.ai, ttayar@habana.ai,
        dhirschfeld@habana.ai
Subject: [PATCH AUTOSEL 6.0 10/18] habanalabs: zero ts registration buff when allocated
Date:   Fri, 23 Dec 2022 20:30:26 -0500
Message-Id: <20221224013034.392810-10-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221224013034.392810-1-sashal@kernel.org>
References: <20221224013034.392810-1-sashal@kernel.org>
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

From: farah kassabri <fkassabri@habana.ai>

[ Upstream commit 679e968908a4997d02c2a7df294e97b066f9149f ]

To avoid memory corruption in kernel memory while using timestamp
registration nodes, zero the kernel buff memory when its allocated.

Signed-off-by: farah kassabri <fkassabri@habana.ai>
Reviewed-by: Oded Gabbay <ogabbay@kernel.org>
Signed-off-by: Oded Gabbay <ogabbay@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/misc/habanalabs/common/memory.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/misc/habanalabs/common/memory.c b/drivers/misc/habanalabs/common/memory.c
index 61bc1bfe984a..751f8c751b72 100644
--- a/drivers/misc/habanalabs/common/memory.c
+++ b/drivers/misc/habanalabs/common/memory.c
@@ -2097,7 +2097,7 @@ static int hl_ts_alloc_buf(struct hl_mmap_mem_buf *buf, gfp_t gfp, void *args)
 
 	/* Allocate the internal kernel buffer */
 	size = num_elements * sizeof(struct hl_user_pending_interrupt);
-	p = vmalloc(size);
+	p = vzalloc(size);
 	if (!p)
 		goto free_user_buff;
 
-- 
2.35.1

