Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0B8CA5492D9
	for <lists+stable@lfdr.de>; Mon, 13 Jun 2022 18:31:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240944AbiFMMta (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Jun 2022 08:49:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34198 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357577AbiFMMtF (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Jun 2022 08:49:05 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7FC7362A3C;
        Mon, 13 Jun 2022 04:11:50 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6DA8860B6B;
        Mon, 13 Jun 2022 11:11:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7F796C34114;
        Mon, 13 Jun 2022 11:11:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1655118694;
        bh=YP+r8NsOlTXW2d7RbwUjxMYxl+IUDMWpsp0BdIt/vHE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Ib704iZKUMtnj143DQv7yfNLHVLMyx8hDnTev4XGLi49i9lownVxdtieXs9T2tGfK
         Ozjm2Oq/amCXKz1WFqNRrLzhlLV4YMONcFTK6ujWIAuAh/A4dbAEEcUUnI0sPuZI2k
         pN+7sVLrOaOzSsjn8SPXk2Xgl4Rfxve/g22r6ZIk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Doug Anderson <dianders@chromium.org>,
        Alex Elder <elder@linaro.org>,
        Taniya Das <quic_tdas@quicinc.com>,
        Mike Tipton <quic_mdtipton@quicinc.com>,
        Stephen Boyd <swboyd@chromium.org>,
        Georgi Djakov <djakov@kernel.org>
Subject: [PATCH 5.10 169/172] interconnect: Restore sync state by ignoring ipa-virt in provider count
Date:   Mon, 13 Jun 2022 12:12:09 +0200
Message-Id: <20220613094923.400137096@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220613094850.166931805@linuxfoundation.org>
References: <20220613094850.166931805@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Stephen Boyd <swboyd@chromium.org>

commit 20ce30fb4750f2ffc130cdcb26232b1dd87cd0a5 upstream.

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
Cc: <stable@vger.kernel.org>	# 5.10.x
Fixes: 2fb251c26560 ("interconnect: qcom: sdx55: Drop IP0 interconnects")
Fixes: 2f3724930eb4 ("interconnect: qcom: sc7180: Drop IP0 interconnects")
Signed-off-by: Stephen Boyd <swboyd@chromium.org>
Reviewed-by: Alex Elder <elder@linaro.org>
Reviewed-by: Douglas Anderson <dianders@chromium.org>
Link: https://lore.kernel.org/r/20220427013226.341209-1-swboyd@chromium.org
Signed-off-by: Georgi Djakov <djakov@kernel.org>
Signed-off-by: Alex Elder <elder@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/interconnect/core.c |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

--- a/drivers/interconnect/core.c
+++ b/drivers/interconnect/core.c
@@ -1084,9 +1084,14 @@ static int of_count_icc_providers(struct
 {
 	struct device_node *child;
 	int count = 0;
+	const struct of_device_id __maybe_unused ignore_list[] = {
+		{ .compatible = "qcom,sc7180-ipa-virt" },
+		{}
+	};
 
 	for_each_available_child_of_node(np, child) {
-		if (of_property_read_bool(child, "#interconnect-cells"))
+		if (of_property_read_bool(child, "#interconnect-cells") &&
+		    likely(!of_match_node(ignore_list, child)))
 			count++;
 		count += of_count_icc_providers(child);
 	}


