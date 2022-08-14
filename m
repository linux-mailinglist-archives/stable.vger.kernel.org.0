Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F3DD35920D8
	for <lists+stable@lfdr.de>; Sun, 14 Aug 2022 17:31:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240564AbiHNPbl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 14 Aug 2022 11:31:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39054 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240428AbiHNPbB (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 14 Aug 2022 11:31:01 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1E8341AD8B;
        Sun, 14 Aug 2022 08:29:37 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 875EFB80B79;
        Sun, 14 Aug 2022 15:29:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7E28DC4347C;
        Sun, 14 Aug 2022 15:29:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1660490974;
        bh=bvxl4NfAPWoJeKXPXZQ9lKtZkp/R6dPMZbid1WSJKj0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TcuBzZgQJMQRjqen04b+Zvl30DhDkZWkpSYnckaZvI6GeewXM+zDeSUiTIkkZHzHa
         kS5UBoJ+3idMq19F4IZYeSZQdz8IWA+QT3xGNFBB0k1f3Yt/3o1aepqEmHU1CD1MX8
         I9FoZl9sjFL9tFW2A4FtQc06Jx90PYrLym0xPOJbkXA1BqxUTWTKEedBYDALl6G54S
         HU0vGzvZRmy3DEyjVFEts2UZgWXTqoMMpmUone5CKxOjBynhD/IMHhBOUd/lVPhtlk
         rnut/UW8iOIYijULEZi7T1rmEOJTU6tDLYZONij8zee5bapTlSQ+tczvRnsmk4kke/
         Yt7tyEwBUjE1Q==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        Andrew Donnellan <ajd@linux.ibm.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>, fbarrat@linux.ibm.com,
        linuxppc-dev@lists.ozlabs.org
Subject: [PATCH AUTOSEL 5.19 40/64] cxl: Fix a memory leak in an error handling path
Date:   Sun, 14 Aug 2022 11:24:13 -0400
Message-Id: <20220814152437.2374207-40-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220814152437.2374207-1-sashal@kernel.org>
References: <20220814152437.2374207-1-sashal@kernel.org>
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
index 5f0e2dcebb34..ac3795a7e1f6 100644
--- a/drivers/misc/cxl/irq.c
+++ b/drivers/misc/cxl/irq.c
@@ -350,6 +350,7 @@ int afu_allocate_irqs(struct cxl_context *ctx, u32 count)
 
 out:
 	cxl_ops->release_irq_ranges(&ctx->irqs, ctx->afu->adapter);
+	bitmap_free(ctx->irq_bitmap);
 	afu_irq_name_free(ctx);
 	return -ENOMEM;
 }
-- 
2.35.1

