Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A71A5529013
	for <lists+stable@lfdr.de>; Mon, 16 May 2022 22:43:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346735AbiEPUEW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 May 2022 16:04:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43340 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348383AbiEPT6g (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 May 2022 15:58:36 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 91EC343AE0;
        Mon, 16 May 2022 12:50:37 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 2C037B81616;
        Mon, 16 May 2022 19:50:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 70EE0C34100;
        Mon, 16 May 2022 19:50:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1652730634;
        bh=ow4X7BELWr3tuZ00ceGXC+8opjw2E6B2OH2F918kbsY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HfmosbmBYq928PKudTEnpUxgcTd1qA7Z5Wbwq/RubGON57sg+2hCDGMmoq0j+vVBN
         e3t5BPkMYgl9JfJLxVTm8haDiBRe3LWiNWETSbtd7B+MI0cjQWZMkO8Lz3MewtxZMb
         nMj6wsVdfc5zyqi58gNkme5z28SVJTI5ZMIwQtAQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Doug Anderson <dianders@chromium.org>,
        Alex Elder <elder@linaro.org>,
        Taniya Das <quic_tdas@quicinc.com>,
        Mike Tipton <quic_mdtipton@quicinc.com>,
        Stephen Boyd <swboyd@chromium.org>,
        Georgi Djakov <djakov@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 062/102] interconnect: Restore sync state by ignoring ipa-virt in provider count
Date:   Mon, 16 May 2022 21:36:36 +0200
Message-Id: <20220516193625.776136833@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220516193623.989270214@linuxfoundation.org>
References: <20220516193623.989270214@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Stephen Boyd <swboyd@chromium.org>

[ Upstream commit 20ce30fb4750f2ffc130cdcb26232b1dd87cd0a5 ]

Ignore compatible strings for the IPA virt drivers that were removed in
commits 2fb251c26560 ("interconnect: qcom: sdx55: Drop IP0
interconnects") and 2f3724930eb4 ("interconnect: qcom: sc7180: Drop IP0
interconnects") so that the sync state logic can kick in again.
Otherwise all the interconnects in the system will stay pegged at max
speeds because 'providers_count' is always going to be one larger than
the number of drivers that will ever probe on sc7180 or sdx55. This
fixes suspend on sc7180 and sdx55 devices when you don't have a
devicetree patch to remove the ipa-virt compatible node.

Cc: Bjorn Andersson <bjorn.andersson@linaro.org>
Cc: Doug Anderson <dianders@chromium.org>
Cc: Alex Elder <elder@linaro.org>
Cc: Taniya Das <quic_tdas@quicinc.com>
Cc: Mike Tipton <quic_mdtipton@quicinc.com>
Fixes: 2fb251c26560 ("interconnect: qcom: sdx55: Drop IP0 interconnects")
Fixes: 2f3724930eb4 ("interconnect: qcom: sc7180: Drop IP0 interconnects")
Signed-off-by: Stephen Boyd <swboyd@chromium.org>
Reviewed-by: Alex Elder <elder@linaro.org>
Reviewed-by: Douglas Anderson <dianders@chromium.org>
Link: https://lore.kernel.org/r/20220427013226.341209-1-swboyd@chromium.org
Signed-off-by: Georgi Djakov <djakov@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/interconnect/core.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/drivers/interconnect/core.c b/drivers/interconnect/core.c
index 9050ca1f4285..808f6e7a8048 100644
--- a/drivers/interconnect/core.c
+++ b/drivers/interconnect/core.c
@@ -1087,9 +1087,15 @@ static int of_count_icc_providers(struct device_node *np)
 {
 	struct device_node *child;
 	int count = 0;
+	const struct of_device_id __maybe_unused ignore_list[] = {
+		{ .compatible = "qcom,sc7180-ipa-virt" },
+		{ .compatible = "qcom,sdx55-ipa-virt" },
+		{}
+	};
 
 	for_each_available_child_of_node(np, child) {
-		if (of_property_read_bool(child, "#interconnect-cells"))
+		if (of_property_read_bool(child, "#interconnect-cells") &&
+		    likely(!of_match_node(ignore_list, child)))
 			count++;
 		count += of_count_icc_providers(child);
 	}
-- 
2.35.1



