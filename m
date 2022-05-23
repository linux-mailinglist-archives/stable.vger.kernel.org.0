Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 243055317BF
	for <lists+stable@lfdr.de>; Mon, 23 May 2022 22:53:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242155AbiEWRnh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 23 May 2022 13:43:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43036 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243260AbiEWRh7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 23 May 2022 13:37:59 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CFBC781982;
        Mon, 23 May 2022 10:32:12 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B5466B81222;
        Mon, 23 May 2022 17:30:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 07993C385AA;
        Mon, 23 May 2022 17:30:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1653327030;
        bh=cAqRWU3u3Ae4nsofTj45RWHjoKKjbBp3mNcaKxMcVh4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=vyb+6pG506OBRbccAGMLNu380RBt9OSbTrci+wTFA5D5jhcnKdehJ9fzF6O+XerYN
         1b3S4LjcuQK4mA9FMaLr5/UrQA8LsNIcH1rlx125+gNsogrocpHbW/mzfaDaWmN6c6
         BwoRiwRbGDXINi2vd1zulG3a2sqxHq5DAR2Q0SoM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Codrin Ciubotariu <codrin.ciubotariu@microchip.com>,
        Claudiu Beznea <claudiu.beznea@microchip.com>,
        Stephen Boyd <sboyd@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.17 099/158] clk: at91: generated: consider range when calculating best rate
Date:   Mon, 23 May 2022 19:04:16 +0200
Message-Id: <20220523165847.846401304@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220523165830.581652127@linuxfoundation.org>
References: <20220523165830.581652127@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Codrin Ciubotariu <codrin.ciubotariu@microchip.com>

[ Upstream commit d0031e6fbed955ff8d5f5bbc8fe7382482559cec ]

clk_generated_best_diff() helps in finding the parent and the divisor to
compute a rate closest to the required one. However, it doesn't take into
account the request's range for the new rate. Make sure the new rate
is within the required range.

Fixes: 8a8f4bf0c480 ("clk: at91: clk-generated: create function to find best_diff")
Signed-off-by: Codrin Ciubotariu <codrin.ciubotariu@microchip.com>
Link: https://lore.kernel.org/r/20220413071318.244912-1-codrin.ciubotariu@microchip.com
Reviewed-by: Claudiu Beznea <claudiu.beznea@microchip.com>
Signed-off-by: Stephen Boyd <sboyd@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/at91/clk-generated.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/clk/at91/clk-generated.c b/drivers/clk/at91/clk-generated.c
index 23cc8297ec4c..d429ba52a719 100644
--- a/drivers/clk/at91/clk-generated.c
+++ b/drivers/clk/at91/clk-generated.c
@@ -117,6 +117,10 @@ static void clk_generated_best_diff(struct clk_rate_request *req,
 		tmp_rate = parent_rate;
 	else
 		tmp_rate = parent_rate / div;
+
+	if (tmp_rate < req->min_rate || tmp_rate > req->max_rate)
+		return;
+
 	tmp_diff = abs(req->rate - tmp_rate);
 
 	if (*best_diff < 0 || *best_diff >= tmp_diff) {
-- 
2.35.1



