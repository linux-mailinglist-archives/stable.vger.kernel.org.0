Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6ECF159DEEF
	for <lists+stable@lfdr.de>; Tue, 23 Aug 2022 14:34:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1359339AbiHWMDm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Aug 2022 08:03:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47520 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230168AbiHWMAS (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 23 Aug 2022 08:00:18 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 88BB4D7D2A;
        Tue, 23 Aug 2022 02:35:03 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B6A74B81C53;
        Tue, 23 Aug 2022 09:34:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2203DC433C1;
        Tue, 23 Aug 2022 09:34:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1661247256;
        bh=g97XD/pgPbqJ4VwO4uV+VBUuGwCDEvgLc1WAUiTfTeI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=IPQBqip7GhQ4C+pj5FS7+zdqUNdcZgUoDCn7m7BZgO/K/2u6MfSfejMnDUW1KMwe6
         pcQIov4RiRkDwJ01KbPIK4HMCrOX2fw9g+cOQYA/Y1QrMEIYpmOevDZQc1jiBTmFpG
         bzWkFrODkFZ/hZtrFQOgx+Cf5u3ZyScd5sVm0XuQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Andrew Donnellan <ajd@linux.ibm.com>,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 360/389] cxl: Fix a memory leak in an error handling path
Date:   Tue, 23 Aug 2022 10:27:18 +0200
Message-Id: <20220823080130.587686861@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220823080115.331990024@linuxfoundation.org>
References: <20220823080115.331990024@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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
index 4cb829d5d873..2e4dcfebf19a 100644
--- a/drivers/misc/cxl/irq.c
+++ b/drivers/misc/cxl/irq.c
@@ -349,6 +349,7 @@ int afu_allocate_irqs(struct cxl_context *ctx, u32 count)
 
 out:
 	cxl_ops->release_irq_ranges(&ctx->irqs, ctx->afu->adapter);
+	bitmap_free(ctx->irq_bitmap);
 	afu_irq_name_free(ctx);
 	return -ENOMEM;
 }
-- 
2.35.1



