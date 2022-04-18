Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DAC2A50521E
	for <lists+stable@lfdr.de>; Mon, 18 Apr 2022 14:42:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236200AbiDRMmR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 Apr 2022 08:42:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38016 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240053AbiDRMih (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 18 Apr 2022 08:38:37 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D9D8C275C2;
        Mon, 18 Apr 2022 05:29:13 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 89656B80EC1;
        Mon, 18 Apr 2022 12:29:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B82AEC385A7;
        Mon, 18 Apr 2022 12:29:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1650284951;
        bh=i9onWB9tRvxnJHS7hD+ihyIKDO/WpE3i++NR8WHGdnA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=aLBK5Bi2wIiS1P1DkdOpwAstoZOHOZ1s964rRUmU2/ECf1cNHR/O+mR0CF7VW+/HK
         ks1tAMJWOvUcDLbWyBXJgYzHEixJmze4xZ6RaTSTQPg3Eojr5I0QAdKT8LlGasreO/
         T+006/wrvwXiNGAk/clP5CTnQN5/pdW0ORzbeUCo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Cristian Marussi <cristian.marussi@arm.com>,
        Sudeep Holla <sudeep.holla@arm.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 060/189] firmware: arm_scmi: Fix sorting of retrieved clock rates
Date:   Mon, 18 Apr 2022 14:11:20 +0200
Message-Id: <20220418121202.213234033@linuxfoundation.org>
X-Mailer: git-send-email 2.35.3
In-Reply-To: <20220418121200.312988959@linuxfoundation.org>
References: <20220418121200.312988959@linuxfoundation.org>
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
index 35b56c8ba0c0..492f3a9197ec 100644
--- a/drivers/firmware/arm_scmi/clock.c
+++ b/drivers/firmware/arm_scmi/clock.c
@@ -204,7 +204,8 @@ scmi_clock_describe_rates_get(const struct scmi_protocol_handle *ph, u32 clk_id,
 
 	if (rate_discrete && rate) {
 		clk->list.num_rates = tot_rate_cnt;
-		sort(rate, tot_rate_cnt, sizeof(*rate), rate_cmp_func, NULL);
+		sort(clk->list.rates, tot_rate_cnt, sizeof(*rate),
+		     rate_cmp_func, NULL);
 	}
 
 	clk->rate_discrete = rate_discrete;
-- 
2.35.1



