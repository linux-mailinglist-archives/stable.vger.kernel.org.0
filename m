Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DC27953CA0E
	for <lists+stable@lfdr.de>; Fri,  3 Jun 2022 14:30:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244373AbiFCMaa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 3 Jun 2022 08:30:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58670 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229476AbiFCMa3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 3 Jun 2022 08:30:29 -0400
Received: from mail-il1-x133.google.com (mail-il1-x133.google.com [IPv6:2607:f8b0:4864:20::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C87353A5DF
        for <stable@vger.kernel.org>; Fri,  3 Jun 2022 05:30:28 -0700 (PDT)
Received: by mail-il1-x133.google.com with SMTP id f12so6311969ilj.1
        for <stable@vger.kernel.org>; Fri, 03 Jun 2022 05:30:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Nve8uJJzmUwywjAVhXgPxChpSGlt/rXVtDPfdgI05bs=;
        b=jMPDQIE5H1brPNcXOidHKpzo2jNfxU1cW4Pfo8HKpNmCI9tnh8AvVSae9lRjT+lMXx
         ikipPp/Oq0miLQi5VWSRNFbySl/Xs738rWWUSQZsI9ZM0rbNc4jVqQmzE9i29ZvYTpPK
         n4ZTJH5CMaDkVOkMptLdVNNfSYazNIL/+CUg791hdh04TJa4LW2Dvv4XP44JTiOa1VEm
         o+KPPjichngjbztqqcKRwTrHLwxf3fynSbJPAZRWERuGNsffWSTXyqOvoZd/yahjFo5s
         C7sw2aTi5xPBUkHYZV56sNtZteoBxW/ncIMeuGO0qIyq9yIougpibIojmvxgeFy1HigA
         FK3Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Nve8uJJzmUwywjAVhXgPxChpSGlt/rXVtDPfdgI05bs=;
        b=bL/OS6S2CkyFSRn/pBXy4Y3Nnfv+wVW448SsNor2KHsmHfiM0vWaMLG8GrOpp95wcB
         jgkH07T/2PQiSalYjxq2LdwC0Tw7UzDunBIcCyznYQadfQ30HEToFTVfwOLshiqptNGS
         VCz7VwULJ1ykNqBfb0SNv9fRpiyjRXShlTRDvR/3KoD/u6+S/nmLtT11T7VXJSMGtjA4
         VN6z9xtJTvq6nind2mISir2mwOy1qE2brpIR8mF/msxJX7aTv7i8GR6uKjNpGF1G03YT
         UTAXsRYPBD3fLcqp6D/W9Gsi+HRvHxQaXVubDBA5kqsyPGhJXUOpjqH047zjYvdvnKbY
         6dww==
X-Gm-Message-State: AOAM530V+LnPWR2scDYNyhnhoNsaLSx6WBEZ6ksHs1VXD/9oR3ZPvitt
        X0nEmiG4K/EeGUifQnkjFXAxJ1ODx2vWWQ==
X-Google-Smtp-Source: ABdhPJx2htSsSK0vhjSwn/w51NTgJbXFq+aTPZlGvulEtY/CL6zzNmr0A5DDjTqInavTSjIur6ZSSg==
X-Received: by 2002:a05:6638:1902:b0:32e:bf8c:55cb with SMTP id p2-20020a056638190200b0032ebf8c55cbmr6039304jal.181.1654259427959;
        Fri, 03 Jun 2022 05:30:27 -0700 (PDT)
Received: from presto.localdomain (c-73-185-129-58.hsd1.mn.comcast.net. [73.185.129.58])
        by smtp.gmail.com with ESMTPSA id r15-20020a92ce8f000000b002d1a16ef24dsm2721068ilo.82.2022.06.03.05.30.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 03 Jun 2022 05:30:27 -0700 (PDT)
From:   Alex Elder <elder@linaro.org>
To:     stable@vger.kernel.org
Cc:     "David S . Miller" <davem@davemloft.net>
Subject: [PATCH] net: ipa: compute proper aggregation limit
Date:   Fri,  3 Jun 2022 07:30:22 -0500
Message-Id: <20220603123024.27609-1-elder@linaro.org>
X-Mailer: git-send-email 2.32.0
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

Cc: <stable@vger.kernel.org>    # 5.10.x
Fixes: 84f9bd12d46db ("soc: qcom: ipa: IPA endpoints");
Signed-off-by: Alex Elder <elder@linaro.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
---
The original commit doesn't cherry-pick cleanly to v5.10.119.  -Alex

 drivers/net/ipa/ipa_endpoint.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ipa/ipa_endpoint.c b/drivers/net/ipa/ipa_endpoint.c
index 621648ce750b7..eb25a13042ea9 100644
--- a/drivers/net/ipa/ipa_endpoint.c
+++ b/drivers/net/ipa/ipa_endpoint.c
@@ -610,12 +610,14 @@ static void ipa_endpoint_init_aggr(struct ipa_endpoint *endpoint)
 
 	if (endpoint->data->aggregation) {
 		if (!endpoint->toward_ipa) {
+			u32 buffer_size;
 			u32 limit;
 
 			val |= u32_encode_bits(IPA_ENABLE_AGGR, AGGR_EN_FMASK);
 			val |= u32_encode_bits(IPA_GENERIC, AGGR_TYPE_FMASK);
 
-			limit = ipa_aggr_size_kb(IPA_RX_BUFFER_SIZE);
+			buffer_size = IPA_RX_BUFFER_SIZE - NET_SKB_PAD;
+			limit = ipa_aggr_size_kb(buffer_size);
 			val |= u32_encode_bits(limit, AGGR_BYTE_LIMIT_FMASK);
 
 			limit = IPA_AGGR_TIME_LIMIT_DEFAULT;
-- 
2.32.0

