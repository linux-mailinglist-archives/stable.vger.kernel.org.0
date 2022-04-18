Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4E2295053B8
	for <lists+stable@lfdr.de>; Mon, 18 Apr 2022 14:58:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238730AbiDRNBO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 Apr 2022 09:01:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59730 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241329AbiDRM6h (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 18 Apr 2022 08:58:37 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3ED762717F;
        Mon, 18 Apr 2022 05:38:57 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7BE25611C3;
        Mon, 18 Apr 2022 12:38:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8990BC385A8;
        Mon, 18 Apr 2022 12:38:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1650285535;
        bh=//rKemMVblAt+PsCEdWfARJOYe6AsaUC7cFKFbKkEkE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=P+ch2TAoYt2jRrvDf652aOGAh9TGCZWdgFBnp3P8Swv0PqO2X/LV1DysBQUMptCr9
         XnspFs7K5TNFkUz+V7s7IO/155xn5N0UcSKwA9ntRJL008Y8HSkO0QTrbONJJwguy0
         iSJSX8p2SGNWr5tq/FMoLJudh2Mtyuntm2R8uqW0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Cristian Marussi <cristian.marussi@arm.com>,
        Sudeep Holla <sudeep.holla@arm.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 009/105] firmware: arm_scmi: Fix sorting of retrieved clock rates
Date:   Mon, 18 Apr 2022 14:12:11 +0200
Message-Id: <20220418121145.823077625@linuxfoundation.org>
X-Mailer: git-send-email 2.35.3
In-Reply-To: <20220418121145.140991388@linuxfoundation.org>
References: <20220418121145.140991388@linuxfoundation.org>
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

From: Cristian Marussi <cristian.marussi@arm.com>

[ Upstream commit 23274739a5b6166f74d8d9cb5243d7bf6b46aab9 ]

During SCMI Clock protocol initialization, after having retrieved from the
SCMI platform all the available discrete rates for a specific clock, the
clock rates array is sorted, unfortunately using a pointer to its end as
a base instead of its start, so that sorting does not work.

Fix invocation of sort() passing as base a pointer to the start of the
retrieved clock rates array.

Link: https://lore.kernel.org/r/20220318092813.49283-1-cristian.marussi@arm.com
Fixes: dccec73de91d ("firmware: arm_scmi: Keep the discrete clock rates sorted")
Signed-off-by: Cristian Marussi <cristian.marussi@arm.com>
Signed-off-by: Sudeep Holla <sudeep.holla@arm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/firmware/arm_scmi/clock.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/firmware/arm_scmi/clock.c b/drivers/firmware/arm_scmi/clock.c
index 4645677d86f1..a45678cd9b74 100644
--- a/drivers/firmware/arm_scmi/clock.c
+++ b/drivers/firmware/arm_scmi/clock.c
@@ -202,7 +202,8 @@ scmi_clock_describe_rates_get(const struct scmi_handle *handle, u32 clk_id,
 
 	if (rate_discrete && rate) {
 		clk->list.num_rates = tot_rate_cnt;
-		sort(rate, tot_rate_cnt, sizeof(*rate), rate_cmp_func, NULL);
+		sort(clk->list.rates, tot_rate_cnt, sizeof(*rate),
+		     rate_cmp_func, NULL);
 	}
 
 	clk->rate_discrete = rate_discrete;
-- 
2.35.1



