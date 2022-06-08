Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DA04F543DF3
	for <lists+stable@lfdr.de>; Wed,  8 Jun 2022 22:56:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234478AbiFHUzE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 8 Jun 2022 16:55:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49704 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235543AbiFHUyj (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 8 Jun 2022 16:54:39 -0400
Received: from mail-io1-xd2d.google.com (mail-io1-xd2d.google.com [IPv6:2607:f8b0:4864:20::d2d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A37301E0AF0
        for <stable@vger.kernel.org>; Wed,  8 Jun 2022 13:54:22 -0700 (PDT)
Received: by mail-io1-xd2d.google.com with SMTP id s23so20202498iog.13
        for <stable@vger.kernel.org>; Wed, 08 Jun 2022 13:54:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=TAWsCFXAiNGBzRzuZRzRnQnc+viWHypGoewv9gdqHUU=;
        b=sNk9teN9Qf3vUQSRPrVslovamoNREUpMdmxirjeEqtjqbHNUu08q7ftn76HztCda2J
         PVsy9fbHnhMWyaNSb3B5RvRL/YiIPGB+DwtosnZNYOVuCSsLft/y2+HAB4B1BEXKMXoK
         WsoDChvujhvOY6EIb8IGNtlrmaF4yBJH7I6Ua+TYWEWREEfmqfA2Yk2J/8pdsX92UM17
         0CqSnJVmyGWATR9smVoQfV9t3Rnlva+uReRKK6LChLIRVH5NGqp64N63qfbyehc1t+k1
         tVIO+bZSQ8sw1SuHqJaTWnY0nq8khXL0dRE4s/hdvWzMjbIvfN574qKBy2apZTcYZvfq
         0mzg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=TAWsCFXAiNGBzRzuZRzRnQnc+viWHypGoewv9gdqHUU=;
        b=5etriK/KjVeieIqJtV+RqZcP7l6y2Z0XuYwVWjA5SPW25rENpy7rKufaAqaQBFxnwt
         jJ/JXAiHqGi/NdhomQLaqUWmrCX+5SKutD4SWaCgCSiNd24IQ/zGu8YiTJt4FZR3U/xj
         1H17OTW0KyNw6Q15ogBT+uFyUMjrLQ7OcpR6wy/jM5at3pHAFaE4IVLxPYVrdnXBuUKd
         Xhn5DfX6JF5JvyCYUhFEG7WaegfTfCNT88fz7Oxvq2/oKRTNccZnLz1s6ttj1Aq9fFQu
         JhWD7b3eZYwtSi+1pOh84H3h26yOK4oqysEkrRpwiN/L5/g9sos57gFiVV1vkLG9vxbP
         kTHQ==
X-Gm-Message-State: AOAM532MW9CV7Y04GUH8s0fIKyLUpLTMKnZe1hGYbtsjm0deDdzPa8nr
        r630HvpuJLbOFv5UMvucpB9iL78Jt+oFKw==
X-Google-Smtp-Source: ABdhPJxI/Rt9RUan1pmxArRKtLo8k8wMNrbbdYSGIVz73ZTvUyPKV7gMP/LKRZH1c55iaXSv0m7wjg==
X-Received: by 2002:a5d:9543:0:b0:668:7deb:ee4d with SMTP id a3-20020a5d9543000000b006687debee4dmr17238744ios.181.1654721660532;
        Wed, 08 Jun 2022 13:54:20 -0700 (PDT)
Received: from localhost.localdomain (c-73-185-129-58.hsd1.mn.comcast.net. [73.185.129.58])
        by smtp.gmail.com with ESMTPSA id a18-20020a6b6d12000000b0066938e02579sm6033370iod.38.2022.06.08.13.54.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 08 Jun 2022 13:54:20 -0700 (PDT)
From:   Alex Elder <elder@linaro.org>
To:     stable@vger.kernel.org
Cc:     Stephen Boyd <swboyd@chromium.org>, elder@linaro.org,
        dianders@chromium.org, bjorn.andersson@linaro.org,
        djakov@kernel.org, quic_mdtipton@quicinc.com, quic_tdas@quicinc.com
Subject: [PATCH v5.10.x 2/2] interconnect: Restore sync state by ignoring ipa-virt in provider count
Date:   Wed,  8 Jun 2022 15:54:15 -0500
Message-Id: <20220608205415.185248-3-elder@linaro.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220608205415.185248-1-elder@linaro.org>
References: <20220608205415.185248-1-elder@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
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
---
 drivers/interconnect/core.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/interconnect/core.c b/drivers/interconnect/core.c
index 7887941730dbb..ceb6cdc20484e 100644
--- a/drivers/interconnect/core.c
+++ b/drivers/interconnect/core.c
@@ -1084,9 +1084,14 @@ static int of_count_icc_providers(struct device_node *np)
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
-- 
2.34.1

