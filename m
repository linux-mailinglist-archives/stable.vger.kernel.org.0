Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6F11755C831
	for <lists+stable@lfdr.de>; Tue, 28 Jun 2022 14:55:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236567AbiF0Lil (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Jun 2022 07:38:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34842 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236640AbiF0Lhr (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 27 Jun 2022 07:37:47 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 80A379FC5;
        Mon, 27 Jun 2022 04:34:21 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 193B060DB5;
        Mon, 27 Jun 2022 11:34:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2AA43C3411D;
        Mon, 27 Jun 2022 11:34:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1656329660;
        bh=x4/dr29uEtkimduHGg5JIOxOjZHgrTFGzZarPmv2Skc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=iFzDepm7GcAGxaHsrdtreUGq7TnTjE4YQtKIjylKeFN3nkRZvYSiOzxbP9P3sDIWK
         Cq/4F/s3ruKGL5EfqnL+wkW2FuBu0t5Mkd70lB7BV8EoNlWRMeIfCgmYiHoCcSarTo
         7tfcb6qHA4AFtPLGwo0/N7ssE1K/u6D5KU0nckEU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Aidan MacDonald <aidanmacdonald.0x0@gmail.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 071/135] regmap-irq: Fix offset/index mismatch in read_sub_irq_data()
Date:   Mon, 27 Jun 2022 13:21:18 +0200
Message-Id: <20220627111940.221390939@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220627111938.151743692@linuxfoundation.org>
References: <20220627111938.151743692@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Aidan MacDonald <aidanmacdonald.0x0@gmail.com>

[ Upstream commit 3f05010f243be06478a9b11cfce0ce994f5a0890 ]

We need to divide the sub-irq status register offset by register
stride to get an index for the status buffer to avoid an out of
bounds write when the register stride is greater than 1.

Fixes: a2d21848d921 ("regmap: regmap-irq: Add main status register support")
Signed-off-by: Aidan MacDonald <aidanmacdonald.0x0@gmail.com>
Link: https://lore.kernel.org/r/20220620200644.1961936-3-aidanmacdonald.0x0@gmail.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/base/regmap/regmap-irq.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/base/regmap/regmap-irq.c b/drivers/base/regmap/regmap-irq.c
index cd12078ed51b..3aac960ae30a 100644
--- a/drivers/base/regmap/regmap-irq.c
+++ b/drivers/base/regmap/regmap-irq.c
@@ -387,6 +387,7 @@ static inline int read_sub_irq_data(struct regmap_irq_chip_data *data,
 		subreg = &chip->sub_reg_offsets[b];
 		for (i = 0; i < subreg->num_regs; i++) {
 			unsigned int offset = subreg->offset[i];
+			unsigned int index = offset / map->reg_stride;
 
 			if (chip->not_fixed_stride)
 				ret = regmap_read(map,
@@ -395,7 +396,7 @@ static inline int read_sub_irq_data(struct regmap_irq_chip_data *data,
 			else
 				ret = regmap_read(map,
 						chip->status_base + offset,
-						&data->status_buf[offset]);
+						&data->status_buf[index]);
 
 			if (ret)
 				break;
-- 
2.35.1



