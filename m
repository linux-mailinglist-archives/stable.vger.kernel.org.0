Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ADCD853CA07
	for <lists+stable@lfdr.de>; Fri,  3 Jun 2022 14:30:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229476AbiFCMab (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 3 Jun 2022 08:30:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58680 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229785AbiFCMaa (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 3 Jun 2022 08:30:30 -0400
Received: from mail-il1-x131.google.com (mail-il1-x131.google.com [IPv6:2607:f8b0:4864:20::131])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B91E93A5DD
        for <stable@vger.kernel.org>; Fri,  3 Jun 2022 05:30:29 -0700 (PDT)
Received: by mail-il1-x131.google.com with SMTP id s1so6325703ilj.0
        for <stable@vger.kernel.org>; Fri, 03 Jun 2022 05:30:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=1TEvk9dAEtVjxl4WHJMV/dXitHqFfQ/El1Z6E7uuTSA=;
        b=vWKkBBkS/jIk1EvjRLZJgR8KXT11QD75Jr/qmqnQyNPtnJIExO1io3vM8YEjffLy9D
         GmC062CpKCvG8n0ttWyGQhup98r6LeRSUg7CHV2OVUMQLArwPhBkLv/w4dpp4daqAbAY
         r95TGsBrB77FWjPYPzM9ru4/acHzvzbzxeXS5XYLqxHPi47+Td2csNdfdTZBgAPaSqhO
         g3+DNk7hyW9FROgVq4gOD/F3kvdP9oyQ+Sh4uKA4r7xY8j1n61hk102GwY7wJi6g648/
         Er7ANtH0vEHNFrpirDkTu8SWDAcSR7/HZW6ulcW+zJTBE/9cK+MQ6hMiVhh/4Yyvmsa/
         SRjw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=1TEvk9dAEtVjxl4WHJMV/dXitHqFfQ/El1Z6E7uuTSA=;
        b=vE3E78fipWNrpoVWcYJEU/CemqIKNdjGTr5Cz0PbjLy4Edf0n0nCsb1VgsXTbh9rak
         fv4wHWzTdpO/02qTLCSVYjMWMP8KDNOsY/aJlSjteJ8GGXgMglv1ml1iJQmiU715ZBe0
         Dy56czYbqu+hI3w8Y/edzv1zE7Eg9KTtFZnQFR6/aY8Yi8yhLDvsZIPVdZLC79Uf1VTY
         rDiXu8QeM6bVYFlYe1uhkj6Ac5sTpmKx3JTB/gbGkd+3mCPrV8dqwH3+DMyLP7NJ9JIF
         XmoOpAXZAmdzGWii1pCJCJsee3ART3NQxcbmKd6L1jYE9XgrEnjoYRgWVikCX8RFYhVk
         Yo0g==
X-Gm-Message-State: AOAM530yPS6dx+Apb7ZL61BmXX1YziYNZ+stR5xkHzQbJrtSs72tsOIj
        oWQ1eXDbeuIyNWOaJ72kHLLT05RDFefj/Q==
X-Google-Smtp-Source: ABdhPJzVZmLMvIUF1OSaOeWguUf/d9pLfC6qi6bgq+vukFv6jzS0HiDgQKM0mQ5fbEcFw2kq3n6vfg==
X-Received: by 2002:a05:6638:3d8f:b0:331:3f88:baab with SMTP id ci15-20020a0566383d8f00b003313f88baabmr5711854jab.173.1654259428636;
        Fri, 03 Jun 2022 05:30:28 -0700 (PDT)
Received: from presto.localdomain (c-73-185-129-58.hsd1.mn.comcast.net. [73.185.129.58])
        by smtp.gmail.com with ESMTPSA id r15-20020a92ce8f000000b002d1a16ef24dsm2721068ilo.82.2022.06.03.05.30.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 03 Jun 2022 05:30:28 -0700 (PDT)
From:   Alex Elder <elder@linaro.org>
To:     stable@vger.kernel.org
Cc:     "David S . Miller" <davem@davemloft.net>
Subject: [PATCH] net: ipa: compute proper aggregation limit
Date:   Fri,  3 Jun 2022 07:30:23 -0500
Message-Id: <20220603123024.27609-2-elder@linaro.org>
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

Cc: <stable@vger.kernel.org>    # 5.15.x
Cc: <stable@vger.kernel.org>    # 5.17.x
Fixes: 84f9bd12d46db ("soc: qcom: ipa: IPA endpoints");
Signed-off-by: Alex Elder <elder@linaro.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
---
The original commit doesn't cherry-pick cleanly to v5.15.44 or v5.17.12  -Alex

 drivers/net/ipa/ipa_endpoint.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ipa/ipa_endpoint.c b/drivers/net/ipa/ipa_endpoint.c
index 87e42db1b61e6..477eb4051bed7 100644
--- a/drivers/net/ipa/ipa_endpoint.c
+++ b/drivers/net/ipa/ipa_endpoint.c
@@ -722,13 +722,15 @@ static void ipa_endpoint_init_aggr(struct ipa_endpoint *endpoint)
 
 	if (endpoint->data->aggregation) {
 		if (!endpoint->toward_ipa) {
+			u32 buffer_size;
 			bool close_eof;
 			u32 limit;
 
 			val |= u32_encode_bits(IPA_ENABLE_AGGR, AGGR_EN_FMASK);
 			val |= u32_encode_bits(IPA_GENERIC, AGGR_TYPE_FMASK);
 
-			limit = ipa_aggr_size_kb(IPA_RX_BUFFER_SIZE);
+			buffer_size = IPA_RX_BUFFER_SIZE - NET_SKB_PAD;
+			limit = ipa_aggr_size_kb(buffer_size);
 			val |= aggr_byte_limit_encoded(version, limit);
 
 			limit = IPA_AGGR_TIME_LIMIT;
-- 
2.32.0

