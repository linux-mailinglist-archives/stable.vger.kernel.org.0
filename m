Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4CF1C521AED
	for <lists+stable@lfdr.de>; Tue, 10 May 2022 16:01:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244629AbiEJOFr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 May 2022 10:05:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49912 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244729AbiEJOEq (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 10 May 2022 10:04:46 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0623D980B5;
        Tue, 10 May 2022 06:40:45 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B46F3615C8;
        Tue, 10 May 2022 13:40:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B1605C385A6;
        Tue, 10 May 2022 13:40:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1652190044;
        bh=5RCcXThUFzSNyUhsvTR0v2sb3kkSfTl2uoQ6d7Azquw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VRUKDYTMlQxAnyykIKvmtdSCB7yreCHQEHiWt0eJ/c7P9ldoTaIek+tEn5bEQ1E2k
         wn+rr4O1nYlatNvIvX/szPZTOSuxCc9GW9/ID/gNLEjeN6/1pRQYpJNa+hHsuWKvjK
         Avm5/a+UICk/1vRduKFNm+j4+ZhVr3uJZF/XSZRI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hector Martin <marcan@marcan.st>,
        Sven Peter <sven@svenpeter.dev>,
        Joerg Roedel <jroedel@suse.de>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.17 110/140] iommu/dart: Add missing module owner to ops structure
Date:   Tue, 10 May 2022 15:08:20 +0200
Message-Id: <20220510130744.748791643@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220510130741.600270947@linuxfoundation.org>
References: <20220510130741.600270947@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Hector Martin <marcan@marcan.st>

[ Upstream commit 2ac2fab52917ae82cbca97cf6e5d2993530257ed ]

This is required to make loading this as a module work.

Signed-off-by: Hector Martin <marcan@marcan.st>
Fixes: 46d1fb072e76 ("iommu/dart: Add DART iommu driver")
Reviewed-by: Sven Peter <sven@svenpeter.dev>
Link: https://lore.kernel.org/r/20220502092238.30486-1-marcan@marcan.st
Signed-off-by: Joerg Roedel <jroedel@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iommu/apple-dart.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/iommu/apple-dart.c b/drivers/iommu/apple-dart.c
index 6c111bd8283d..68821f86b063 100644
--- a/drivers/iommu/apple-dart.c
+++ b/drivers/iommu/apple-dart.c
@@ -782,6 +782,7 @@ static const struct iommu_ops apple_dart_iommu_ops = {
 	.get_resv_regions = apple_dart_get_resv_regions,
 	.put_resv_regions = generic_iommu_put_resv_regions,
 	.pgsize_bitmap = -1UL, /* Restricted during dart probe */
+	.owner = THIS_MODULE,
 };
 
 static irqreturn_t apple_dart_irq(int irq, void *dev)
-- 
2.35.1



