Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3DACB59DF24
	for <lists+stable@lfdr.de>; Tue, 23 Aug 2022 14:34:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353038AbiHWKM5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Aug 2022 06:12:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34236 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352946AbiHWKJn (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 23 Aug 2022 06:09:43 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0CC1D7DF6E;
        Tue, 23 Aug 2022 01:55:55 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9D1F661561;
        Tue, 23 Aug 2022 08:55:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9ACB8C433D6;
        Tue, 23 Aug 2022 08:55:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1661244954;
        bh=BvpZ9+z3PwhwVDxWUyHfXYsBLSq0+ghAeah0uQ9gcoE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QZz3L2AXR5uqp2lmp8A1BjhdVOo5Ea+9FxF1T5HLg2p2/AxRuabHRPMtgINeQTZvv
         a0i42epi0iGVMAXbawrtdzRwIVbndISkZlYHuogg2XrzGxpSUMwS4zmvyQVmVEset0
         wNrgIf5d8icfXdApSBooDk4r9Rm4bD9dlxL9ml8Y=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Andrew Donnellan <ajd@linux.ibm.com>,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 217/229] cxl: Fix a memory leak in an error handling path
Date:   Tue, 23 Aug 2022 10:26:18 +0200
Message-Id: <20220823080101.396665634@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220823080053.202747790@linuxfoundation.org>
References: <20220823080053.202747790@linuxfoundation.org>
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



