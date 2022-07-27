Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5CB3C58312A
	for <lists+stable@lfdr.de>; Wed, 27 Jul 2022 19:47:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238249AbiG0Rrc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 27 Jul 2022 13:47:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51350 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243055AbiG0RrB (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 27 Jul 2022 13:47:01 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 24F7A8C8F4;
        Wed, 27 Jul 2022 09:53:54 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 4D69CB821BE;
        Wed, 27 Jul 2022 16:53:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AD1EBC433B5;
        Wed, 27 Jul 2022 16:53:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1658940829;
        bh=zkO/9ryiqC/LNgFhXI//VGH66ltD+m2e3mz8jrIhSMc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rpImecHESHFHnv/+v+92Xl9U1KIG3SbeLpnwOZlC0ddfoYqz1stkVJNwlkCX3QIPB
         7P4Cr3floM+K0JPtwtTUPnJQT38UKtlyrg9+gwAOwm2LOpe4z/UBNdQGzc6b6G34T2
         +PFgh0L7we79fb/KfeDIAEGgr/RpKa29mgpDVfxI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Herve Codina <herve.codina@bootlin.com>,
        Claudiu Beznea <claudiu.beznea@microchip.com>,
        Michael Walle <michael@walle.cc>,
        Stephen Boyd <sboyd@kernel.org>
Subject: [PATCH 5.18 138/158] clk: lan966x: Fix the lan966x clock gate register address
Date:   Wed, 27 Jul 2022 18:13:22 +0200
Message-Id: <20220727161026.906148348@linuxfoundation.org>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20220727161021.428340041@linuxfoundation.org>
References: <20220727161021.428340041@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Herve Codina <herve.codina@bootlin.com>

commit 25c2a075eb6a3031813b6051bd10dfc22c36a2a4 upstream.

The register address used for the clock gate register is the base
register address coming from first reg map (ie. the generic
clock registers) instead of the second reg map defining the clock
gate register.

Use the correct clock gate register address.

Fixes: 5ad5915dea00 ("clk: lan966x: Extend lan966x clock driver for clock gating support")
Signed-off-by: Herve Codina <herve.codina@bootlin.com>
Link: https://lore.kernel.org/r/20220704102845.168438-2-herve.codina@bootlin.com
Reviewed-by: Claudiu Beznea <claudiu.beznea@microchip.com>
Tested-by: Michael Walle <michael@walle.cc>
Signed-off-by: Stephen Boyd <sboyd@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/clk/clk-lan966x.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/clk/clk-lan966x.c
+++ b/drivers/clk/clk-lan966x.c
@@ -213,7 +213,7 @@ static int lan966x_gate_clk_register(str
 
 		hw_data->hws[i] =
 			devm_clk_hw_register_gate(dev, clk_gate_desc[idx].name,
-						  "lan966x", 0, base,
+						  "lan966x", 0, gate_base,
 						  clk_gate_desc[idx].bit_idx,
 						  0, &clk_gate_lock);
 


