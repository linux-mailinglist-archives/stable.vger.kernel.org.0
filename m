Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8C21756FE2C
	for <lists+stable@lfdr.de>; Mon, 11 Jul 2022 12:05:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234518AbiGKKE5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Jul 2022 06:04:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33422 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234599AbiGKKEO (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 11 Jul 2022 06:04:14 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 97BC26E8A8;
        Mon, 11 Jul 2022 02:30:00 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 2CD01B80E8B;
        Mon, 11 Jul 2022 09:29:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 96627C341C8;
        Mon, 11 Jul 2022 09:29:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1657531798;
        bh=maPocCFDUREvXM9pIbr4oBu9Z1mY1qtMxmnH6+RDnnw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NzJqY58bcTfB9IE6A1aYRtYFLRATNQAi2q6fzitnqkIE0UkBmPkeJQ40cR7+cNnLf
         C9htqRTc5XfWPn4XLzAgbeZr7/KhA0y6MMwBumR0vItOnKsk7HK33iqW2QjjXJ0EMS
         V2ac8aUFV59ABE7Oj60BnovQNZqu/5wzMN00hweg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        Vinod Koul <vkoul@kernel.org>
Subject: [PATCH 5.15 224/230] dmaengine: lgm: Fix an error handling path in intel_ldma_probe()
Date:   Mon, 11 Jul 2022 11:08:00 +0200
Message-Id: <20220711090610.455446478@linuxfoundation.org>
X-Mailer: git-send-email 2.37.0
In-Reply-To: <20220711090604.055883544@linuxfoundation.org>
References: <20220711090604.055883544@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Christophe JAILLET <christophe.jaillet@wanadoo.fr>

commit 1dbe67b9faea0bc340cce894018076679c16cb71 upstream.

ldma_clk_disable() calls both:
	clk_disable_unprepare(d->core_clk);
	reset_control_assert(d->rst);

So, should devm_reset_control_get_optional() fail, core_clk should not
be prepare_enable'd before it, otherwise it will never be
disable_unprepare'd.

Reorder the code to handle the error handling path as expected.

Fixes: 32d31c79a1a4 ("dmaengine: Add Intel LGM SoC DMA support.")
Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Link: https://lore.kernel.org/r/18504549bc4d2b62a72a02cb22a2e4d8e6a58720.1653241224.git.christophe.jaillet@wanadoo.fr
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/dma/lgm/lgm-dma.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/dma/lgm/lgm-dma.c
+++ b/drivers/dma/lgm/lgm-dma.c
@@ -1593,11 +1593,12 @@ static int intel_ldma_probe(struct platf
 	d->core_clk = devm_clk_get_optional(dev, NULL);
 	if (IS_ERR(d->core_clk))
 		return PTR_ERR(d->core_clk);
-	clk_prepare_enable(d->core_clk);
 
 	d->rst = devm_reset_control_get_optional(dev, NULL);
 	if (IS_ERR(d->rst))
 		return PTR_ERR(d->rst);
+
+	clk_prepare_enable(d->core_clk);
 	reset_control_deassert(d->rst);
 
 	ret = devm_add_action_or_reset(dev, ldma_clk_disable, d);


