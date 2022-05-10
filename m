Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6DDF15219B3
	for <lists+stable@lfdr.de>; Tue, 10 May 2022 15:48:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241149AbiEJNus (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 May 2022 09:50:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56474 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244946AbiEJNrI (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 10 May 2022 09:47:08 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4068B2B25E;
        Tue, 10 May 2022 06:32:50 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 034EEB81DA0;
        Tue, 10 May 2022 13:32:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 60311C385A6;
        Tue, 10 May 2022 13:32:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1652189567;
        bh=Oe3TttIwRhAC186u7dwRFfWEnIRrbnIBd82Sell4Og0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VrMSghyfmItZeomAnQXj/yWfx+MZ+RG3QgzJQtRRxYjEHAIGKOtpCnDcR/SfZTcM8
         KJElC8o16EK0ekh98hnCxYmupQiVVG9FgLWKPV4nHmaiDqgMneMYYlUveqRxbuspSz
         +6GyVjEozjx59qSquvWqlsImTu5TdGSFOWG7JBLg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hector Martin <marcan@marcan.st>,
        Sven Peter <sven@svenpeter.dev>,
        Joerg Roedel <jroedel@suse.de>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 093/135] iommu/dart: Add missing module owner to ops structure
Date:   Tue, 10 May 2022 15:07:55 +0200
Message-Id: <20220510130743.078569575@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220510130740.392653815@linuxfoundation.org>
References: <20220510130740.392653815@linuxfoundation.org>
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
index 9c9bbccc00bd..baba4571c815 100644
--- a/drivers/iommu/apple-dart.c
+++ b/drivers/iommu/apple-dart.c
@@ -757,6 +757,7 @@ static const struct iommu_ops apple_dart_iommu_ops = {
 	.of_xlate = apple_dart_of_xlate,
 	.def_domain_type = apple_dart_def_domain_type,
 	.pgsize_bitmap = -1UL, /* Restricted during dart probe */
+	.owner = THIS_MODULE,
 };
 
 static irqreturn_t apple_dart_irq(int irq, void *dev)
-- 
2.35.1



