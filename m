Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CD2F353CA01
	for <lists+stable@lfdr.de>; Fri,  3 Jun 2022 14:30:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229785AbiFCMad (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 3 Jun 2022 08:30:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58682 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244374AbiFCMab (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 3 Jun 2022 08:30:31 -0400
Received: from mail-il1-x136.google.com (mail-il1-x136.google.com [IPv6:2607:f8b0:4864:20::136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 196503A5E0
        for <stable@vger.kernel.org>; Fri,  3 Jun 2022 05:30:30 -0700 (PDT)
Received: by mail-il1-x136.google.com with SMTP id a15so6277286ilq.12
        for <stable@vger.kernel.org>; Fri, 03 Jun 2022 05:30:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=XGR7ndlJcdZp2sgQYaXVYmxgPAStTzfabROT3s1gmT0=;
        b=py4LXNVSi3R92l/L5BVAV1zoFBn+vKiu1f74gZzG0+XE9bmPvJwxIGAE+CPvUpvF7U
         NL0m4ICYtpm6KohsVxawz89kMhKwXZkK5cAxk0e19xAf731oqDrsN80nZeE3m0Pf31Ww
         eALV6pyQ8h8dSKO6ozp1F5IVMDOkbI1SYt7UwXgzHnt1qMUa5F3rYHWbi9MlQYjo4j2O
         VcMUfSFinVTPVSLedo2tpqdAAM7RpxP4cIhkuJp5n7CrGZck3aaEJHwb295DLaVCaNxV
         4KFm4zGI/DtBL6nrgruXhJHAR6EU5JG98LZQtHm8mtmdLG1t5PZFpcmUVgHuj3/JwiBt
         M5tA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=XGR7ndlJcdZp2sgQYaXVYmxgPAStTzfabROT3s1gmT0=;
        b=FRr9+kJw75A47vcGGu+k5MDb9LXkowr1g+zs+P0oPcZvbamICl/P+hwlHVyEtPJRrB
         SmIrh9lkJfomw6G6+zErQYCwSN77Ulpx+bYIEJbM29LDhzV1j9AXLGgDV5ZDJ+0qRtf0
         UwZzE0G+CfIY+nTyqiZy/7YG/P/OZc/hdDZ+W8jqeBUZ3pE8JgoqfZFRIQQPNXXcQG0O
         8MKiHbvnbFUI1YyMOiGOj7pY+iXPQX6/4f5k7MSHpAaSG9m+enacTJqHhj2F7Ec6bSHr
         GUpAe080vHA3XMhYRENSr6KjcDdmWFs1T854TiTGHGL2CbTYAco7iHo81mcrxCanYRYj
         nPow==
X-Gm-Message-State: AOAM532y3HEcpU7fyIz281Oc4R784H1wuDSyIgBsgEjWqqR2zgJBKCHr
        XmvBTauos189e/YLe4f1wXRx0p3nlOY3ew==
X-Google-Smtp-Source: ABdhPJwhVeKCNaXomlrR3vDdOdfM0scvPIGRObn43L2BXxPS5z4aMu895RVsGuF/MSy168BRiNR8NA==
X-Received: by 2002:a92:c6c3:0:b0:2d3:adb5:5a9f with SMTP id v3-20020a92c6c3000000b002d3adb55a9fmr5887046ilm.120.1654259429335;
        Fri, 03 Jun 2022 05:30:29 -0700 (PDT)
Received: from presto.localdomain (c-73-185-129-58.hsd1.mn.comcast.net. [73.185.129.58])
        by smtp.gmail.com with ESMTPSA id r15-20020a92ce8f000000b002d1a16ef24dsm2721068ilo.82.2022.06.03.05.30.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 03 Jun 2022 05:30:28 -0700 (PDT)
From:   Alex Elder <elder@linaro.org>
To:     stable@vger.kernel.org
Cc:     davem@davemloft.net
Subject: [PATCH] net: ipa: compute proper aggregation limit
Date:   Fri,  3 Jun 2022 07:30:24 -0500
Message-Id: <20220603123024.27609-3-elder@linaro.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20220603123024.27609-1-elder@linaro.org>
References: <20220603123024.27609-1-elder@linaro.org>
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

commit c5794097b269f15961ed78f7f27b50e51766dec9 upstream.

The aggregation byte limit for an endpoint is currently computed
based on the endpoint's receive buffer size.

However, some bytes at the front of each receive buffer are reserved
on the assumption that--as with SKBs--it might be useful to insert
data (such as headers) before what lands in the buffer.

The aggregation byte limit currently doesn't take into account that
reserved space, and as a result, aggregation could require space
past that which is available in the buffer.

Fix this by reducing the size used to compute the aggregation byte
limit by the NET_SKB_PAD offset reserved for each receive buffer.

Cc: <stable@vger.kernel.org>    # 5.18.x
Fixes: 84f9bd12d46db ("soc: qcom: ipa: IPA endpoints");
Signed-off-by: Alex Elder <elder@linaro.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
---
The original commit *does* cleanly cherry-pick onto v5.18.1.  -Alex

 drivers/net/ipa/ipa_endpoint.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ipa/ipa_endpoint.c b/drivers/net/ipa/ipa_endpoint.c
index cea7b2e2ce969..53764f3c0c7e4 100644
--- a/drivers/net/ipa/ipa_endpoint.c
+++ b/drivers/net/ipa/ipa_endpoint.c
@@ -130,9 +130,10 @@ static bool ipa_endpoint_data_valid_one(struct ipa *ipa, u32 count,
 		 */
 		if (data->endpoint.config.aggregation) {
 			limit += SZ_1K * aggr_byte_limit_max(ipa->version);
-			if (buffer_size > limit) {
+			if (buffer_size - NET_SKB_PAD > limit) {
 				dev_err(dev, "RX buffer size too large for aggregated RX endpoint %u (%u > %u)\n",
-					data->endpoint_id, buffer_size, limit);
+					data->endpoint_id,
+					buffer_size - NET_SKB_PAD, limit);
 
 				return false;
 			}
@@ -739,6 +740,7 @@ static void ipa_endpoint_init_aggr(struct ipa_endpoint *endpoint)
 	if (endpoint->data->aggregation) {
 		if (!endpoint->toward_ipa) {
 			const struct ipa_endpoint_rx_data *rx_data;
+			u32 buffer_size;
 			bool close_eof;
 			u32 limit;
 
@@ -746,7 +748,8 @@ static void ipa_endpoint_init_aggr(struct ipa_endpoint *endpoint)
 			val |= u32_encode_bits(IPA_ENABLE_AGGR, AGGR_EN_FMASK);
 			val |= u32_encode_bits(IPA_GENERIC, AGGR_TYPE_FMASK);
 
-			limit = ipa_aggr_size_kb(rx_data->buffer_size);
+			buffer_size = rx_data->buffer_size;
+			limit = ipa_aggr_size_kb(buffer_size - NET_SKB_PAD);
 			val |= aggr_byte_limit_encoded(version, limit);
 
 			limit = IPA_AGGR_TIME_LIMIT;
-- 
2.32.0

