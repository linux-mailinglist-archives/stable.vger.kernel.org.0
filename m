Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CFE4953186A
	for <lists+stable@lfdr.de>; Mon, 23 May 2022 22:54:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239939AbiEWRNK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 23 May 2022 13:13:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34856 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240515AbiEWRMa (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 23 May 2022 13:12:30 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 45BEE62BCA;
        Mon, 23 May 2022 10:11:41 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 45A7DB811F6;
        Mon, 23 May 2022 17:10:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5AC49C385A9;
        Mon, 23 May 2022 17:10:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1653325832;
        bh=8HqcDKgm30aIgAcb6f1MOQJAQLF0KAE4hGTUo6ovBM8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=yErxJKDBn5tLhXHvmsbUU1/69TFu8biRo2oE5Zw1mYevzc8GZx8zX89ggBispOvQa
         XWlbeDPl59caCnHneiFyCIi6d/o2TarEZT2hzW97yAvYwON50b1Ya+8NKNlCI657lf
         BX2bUdKZvvXgXXaR1UybAJ52ZLjXH7XasoTluDNQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Codrin Ciubotariu <codrin.ciubotariu@microchip.com>,
        Claudiu Beznea <claudiu.beznea@microchip.com>,
        Stephen Boyd <sboyd@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 25/44] clk: at91: generated: consider range when calculating best rate
Date:   Mon, 23 May 2022 19:05:09 +0200
Message-Id: <20220523165757.738972522@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220523165752.797318097@linuxfoundation.org>
References: <20220523165752.797318097@linuxfoundation.org>
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
index ea23002be4de..b397556c34d9 100644
--- a/drivers/clk/at91/clk-generated.c
+++ b/drivers/clk/at91/clk-generated.c
@@ -119,6 +119,10 @@ static void clk_generated_best_diff(struct clk_rate_request *req,
 		tmp_rate = parent_rate;
 	else
 		tmp_rate = parent_rate / div;
+
+	if (tmp_rate < req->min_rate || tmp_rate > req->max_rate)
+		return;
+
 	tmp_diff = abs(req->rate - tmp_rate);
 
 	if (*best_diff < 0 || *best_diff > tmp_diff) {
-- 
2.35.1



