Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3FD3755D849
	for <lists+stable@lfdr.de>; Tue, 28 Jun 2022 15:19:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237966AbiF0LvC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Jun 2022 07:51:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49708 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237964AbiF0Lt3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 27 Jun 2022 07:49:29 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5EA04F2C;
        Mon, 27 Jun 2022 04:43:24 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id EF7AE61274;
        Mon, 27 Jun 2022 11:43:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 04FD8C341D0;
        Mon, 27 Jun 2022 11:43:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1656330203;
        bh=/23RHVTrOfPcGrYygrtoRfvlXfe9Z/ivIRH7rlkwIlk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=2ZZ/lNyaUqm58YivTWLrLq7TAMQqNvYUnSbwx0bC2ls/ATUWpV4K5zso6aDO8QJmQ
         gRIEIwWSVEKJ8TSsLPV3EMWQTX1lsWN86ZPGV+g2l4G/0FIle+KVjYp2v1fD6qs10/
         RpC9I0v3GjktvIF8mlZ7T9GT4iDnL5XMIxEn479o=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Aidan MacDonald <aidanmacdonald.0x0@gmail.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.18 091/181] regmap-irq: Fix offset/index mismatch in read_sub_irq_data()
Date:   Mon, 27 Jun 2022 13:21:04 +0200
Message-Id: <20220627111947.198281044@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220627111944.553492442@linuxfoundation.org>
References: <20220627111944.553492442@linuxfoundation.org>
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
index 4f785bc7981c..a6db605707b0 100644
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



