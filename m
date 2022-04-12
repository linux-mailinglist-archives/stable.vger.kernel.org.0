Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A064F4FD67E
	for <lists+stable@lfdr.de>; Tue, 12 Apr 2022 12:21:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1377231AbiDLHtL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 Apr 2022 03:49:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45808 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357860AbiDLHkt (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 12 Apr 2022 03:40:49 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EC22E3A182;
        Tue, 12 Apr 2022 00:17:02 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4863D617D2;
        Tue, 12 Apr 2022 07:17:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 50AE8C385A6;
        Tue, 12 Apr 2022 07:17:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649747821;
        bh=QglxR7xqTgao+Mu3n8Nk9NbuD0NuJMjSZJ6+4whERrI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rrO3PYIEqIwOXpkIxLIPAsVCdsmDpMuAEsT4qbBGXj2bZ+Neq1MDOpheZMC1gu/+p
         nrfVfvNFZVJ+EyFZ/GJ0+hLieVYiqrw5Dr4UTfIsVu+msvTmnwLOjPvaLDZXmUKhgI
         oPF4prDsEDFicL23yGcn1asMRVBY8klhHU9tZoxE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Axel Lin <axel.lin@ingics.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.17 218/343] regulator: rtq2134: Fix missing active_discharge_on setting
Date:   Tue, 12 Apr 2022 08:30:36 +0200
Message-Id: <20220412062957.635055412@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220412062951.095765152@linuxfoundation.org>
References: <20220412062951.095765152@linuxfoundation.org>
User-Agent: quilt/0.66
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

From: Axel Lin <axel.lin@ingics.com>

[ Upstream commit 17049bf9de55a42ee96fd34520aff8a484677675 ]

The active_discharge_on setting was missed, so output discharge resistor
is always disabled. Fix it.

Fixes: 0555d41497de ("regulator: rtq2134: Add support for Richtek RTQ2134 SubPMIC")
Signed-off-by: Axel Lin <axel.lin@ingics.com>
Link: https://lore.kernel.org/r/20220404022514.449231-1-axel.lin@ingics.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/regulator/rtq2134-regulator.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/regulator/rtq2134-regulator.c b/drivers/regulator/rtq2134-regulator.c
index f21e3f8b21f2..8e13dea354a2 100644
--- a/drivers/regulator/rtq2134-regulator.c
+++ b/drivers/regulator/rtq2134-regulator.c
@@ -285,6 +285,7 @@ static const unsigned int rtq2134_buck_ramp_delay_table[] = {
 		.enable_mask = RTQ2134_VOUTEN_MASK, \
 		.active_discharge_reg = RTQ2134_REG_BUCK##_id##_CFG0, \
 		.active_discharge_mask = RTQ2134_ACTDISCHG_MASK, \
+		.active_discharge_on = RTQ2134_ACTDISCHG_MASK, \
 		.ramp_reg = RTQ2134_REG_BUCK##_id##_RSPCFG, \
 		.ramp_mask = RTQ2134_RSPUP_MASK, \
 		.ramp_delay_table = rtq2134_buck_ramp_delay_table, \
-- 
2.35.1



