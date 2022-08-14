Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 61F1A5922CC
	for <lists+stable@lfdr.de>; Sun, 14 Aug 2022 17:53:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241978AbiHNPw0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 14 Aug 2022 11:52:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40550 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242012AbiHNPuz (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 14 Aug 2022 11:50:55 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 00A9B17A86;
        Sun, 14 Aug 2022 08:36:27 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 91ABF60DC5;
        Sun, 14 Aug 2022 15:36:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1B83EC43140;
        Sun, 14 Aug 2022 15:36:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1660491387;
        bh=BvpZ9+z3PwhwVDxWUyHfXYsBLSq0+ghAeah0uQ9gcoE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UMDztyuswrP5f8rhzP8VhAtokUHbNH4e3SRgurl2KxOroYl9mBaWLPXb8xRaQ19gO
         uWVwEYDUnrZp5xlj9L4kYxHOhoQ9etca2gLNw5l0fUz1BSUtkCWULFIepDVeAzR+z/
         Imm8CFyEgEA+kker/PBuIZsVoTPDICwBcFAgY9C57EUsQ45Qt2g3Pe5OqC1naEslo9
         B6hW0cZk9TZy57xcL0vPVpUAYMTgCqDZAUtxwmqA+0IgoZOEkMCLdmfqGJ5QXL0v0y
         qeHM25+04SMM66ameXRY3fXmGpWORcbWRZUMSmlylUcTJwNPiFSJBP3C+ec83weVjy
         gONXD1VjIJhyg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        Andrew Donnellan <ajd@linux.ibm.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>, fbarrat@linux.ibm.com,
        linuxppc-dev@lists.ozlabs.org
Subject: [PATCH AUTOSEL 4.19 08/13] cxl: Fix a memory leak in an error handling path
Date:   Sun, 14 Aug 2022 11:36:05 -0400
Message-Id: <20220814153610.2380234-8-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220814153610.2380234-1-sashal@kernel.org>
References: <20220814153610.2380234-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Christophe JAILLET <christophe.jaillet@wanadoo.fr>

[ Upstream commit 3a15b45b5454da862376b5d69a4967f5c6fa1368 ]

A bitmap_zalloc() must be balanced by a corresponding bitmap_free() in the
error handling path of afu_allocate_irqs().

Acked-by: Andrew Donnellan <ajd@linux.ibm.com>
Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Link: https://lore.kernel.org/r/ce5869418f5838187946eb6b11a52715a93ece3d.1657566849.git.christophe.jaillet@wanadoo.fr
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/misc/cxl/irq.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/misc/cxl/irq.c b/drivers/misc/cxl/irq.c
index ce08a9f22308..0dbe78383f8f 100644
--- a/drivers/misc/cxl/irq.c
+++ b/drivers/misc/cxl/irq.c
@@ -353,6 +353,7 @@ int afu_allocate_irqs(struct cxl_context *ctx, u32 count)
 
 out:
 	cxl_ops->release_irq_ranges(&ctx->irqs, ctx->afu->adapter);
+	bitmap_free(ctx->irq_bitmap);
 	afu_irq_name_free(ctx);
 	return -ENOMEM;
 }
-- 
2.35.1

