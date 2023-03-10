Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 760E96B49FB
	for <lists+stable@lfdr.de>; Fri, 10 Mar 2023 16:17:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234141AbjCJPR0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 10 Mar 2023 10:17:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56948 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234108AbjCJPRJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 10 Mar 2023 10:17:09 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4A1F13BD9D
        for <stable@vger.kernel.org>; Fri, 10 Mar 2023 07:08:16 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 53E1561A2A
        for <stable@vger.kernel.org>; Fri, 10 Mar 2023 14:51:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 17323C433D2;
        Fri, 10 Mar 2023 14:51:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678459891;
        bh=4vDGlHjjAZ7lkA9qagRZTFX/d5ouXNPzzQJxDo+ctmE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Ne9AH65XEqdvqRxWnGxW3w3yTHtxJKZXyausHlJgyo0jhzlLQUh4iUz8jTSmKqJvl
         YV5xJtJ8LuxGR2eG16wSA2/MC6wp+TRSKUl3ZE+DfCtE00Jsy+syFvATqaatjpZix4
         vH4lylMP1KJL4/40s/VtJAnkl6j0NzNN8XPsosMc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Tom Lendacky <thomas.lendacky@amd.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 114/529] crypto: ccp - Flush the SEV-ES TMR memory before giving it to firmware
Date:   Fri, 10 Mar 2023 14:34:17 +0100
Message-Id: <20230310133810.279427252@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230310133804.978589368@linuxfoundation.org>
References: <20230310133804.978589368@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Tom Lendacky <thomas.lendacky@amd.com>

[ Upstream commit 46a334a98f585ef78d51d8f5736596887bdd7f54 ]

Perform a cache flush on the SEV-ES TMR memory after allocation to prevent
any possibility of the firmware encountering an error should dirty cache
lines be present. Use clflush_cache_range() to flush the SEV-ES TMR memory.

Fixes: 97f9ac3db661 ("crypto: ccp - Add support for SEV-ES to the PSP driver")
Signed-off-by: Tom Lendacky <thomas.lendacky@amd.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/crypto/ccp/sev-dev.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/crypto/ccp/sev-dev.c b/drivers/crypto/ccp/sev-dev.c
index 8a900226d73a3..856d867f46ebb 100644
--- a/drivers/crypto/ccp/sev-dev.c
+++ b/drivers/crypto/ccp/sev-dev.c
@@ -23,6 +23,7 @@
 #include <linux/gfp.h>
 
 #include <asm/smp.h>
+#include <asm/cacheflush.h>
 
 #include "psp-dev.h"
 #include "sev-dev.h"
@@ -1067,7 +1068,10 @@ void sev_pci_init(void)
 
 	/* Obtain the TMR memory area for SEV-ES use */
 	sev_es_tmr = sev_fw_alloc(SEV_ES_TMR_SIZE);
-	if (!sev_es_tmr)
+	if (sev_es_tmr)
+		/* Must flush the cache before giving it to the firmware */
+		clflush_cache_range(sev_es_tmr, SEV_ES_TMR_SIZE);
+	else
 		dev_warn(sev->dev,
 			 "SEV: TMR allocation failed, SEV-ES support unavailable\n");
 
-- 
2.39.2



