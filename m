Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 896C950E4C8
	for <lists+stable@lfdr.de>; Mon, 25 Apr 2022 17:52:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233238AbiDYPzE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 25 Apr 2022 11:55:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51596 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230075AbiDYPzD (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 25 Apr 2022 11:55:03 -0400
Received: from mail-wm1-x330.google.com (mail-wm1-x330.google.com [IPv6:2a00:1450:4864:20::330])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 33C6D3A5CB
        for <stable@vger.kernel.org>; Mon, 25 Apr 2022 08:51:59 -0700 (PDT)
Received: by mail-wm1-x330.google.com with SMTP id c190-20020a1c35c7000000b0038e37907b5bso12817292wma.0
        for <stable@vger.kernel.org>; Mon, 25 Apr 2022 08:51:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=4ALRSFurtDuyX8i3wZ3ifrHF7kS/esrMLgLlLPdbzK8=;
        b=oXhyoXaflRP/YxjZ5+8v/UQ8Tv/QvGvKV9OC+uozk7kYEyCqE3IktHTdjTy/v6w8Qx
         8nCsrha13vQ+Tv/wf02VSn3VlPxUAi0J5fWl36/h0n4G/rD2XPKS+Lzwk0wtpiNqsS1s
         g+R8vldFv0UnyvpVOJd/bPYbse0dYwkPT/KrWvy8lG7Eiu2Cl3xhUxxJsSjacQT2JUs1
         b9ref6lUcUjhHYny45cJdvO85QrpGYHjpNw6T+7u64FrcutceVXUGwsYyw+DOfAMrBQM
         r66XrBhKG6cVHqDixlcpx92bc/OYYi8UbdyM6A/kDvCiRapPrdiBewHtj24p2fQo58m6
         QHmw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=4ALRSFurtDuyX8i3wZ3ifrHF7kS/esrMLgLlLPdbzK8=;
        b=h+EqWB4o9ubc0aboHfHIBemFVgYKdT/ajDBcjiTB0d468u71intvMC1goSxau8ZaZ9
         4PPKPabs6lcCy/XB6/3ZEDebiU0hU88NrdR+xKtW8iDNfV3vjajHwx6T5925VNAUpo30
         ry2l+slvMOgpyiD9zUEkc5THWgVMUXsJmpXLgZtTD6G9pRgxGZu0lADfgWHmfuJdDmHm
         F4auDZ+Kp0tm6nn/oLtoEc9DYjsd3PlnOwVlzROtpuBih3uwaq0f2+dzuZyeRqkvaEVz
         47+1eX5goX82o8DbkpdoEwgLwNo1+WTJIq/ENG/sKsooNNiHWH9t21JaUHeYvCGKXvQF
         Hg5Q==
X-Gm-Message-State: AOAM533HFLd9gh3HFRqgcJcA6YYXBnYVXMzqHH4z6PfYgApe5xb9pilZ
        4MckFM7DsX+mYWi7YWhl7Dp7VA==
X-Google-Smtp-Source: ABdhPJwzDh0zSAVNpzvhOT9n9jF1WSuPfX+RJ3ORJ1hIDW7e/YAbHBs2UEpQ39JCfYScVcf/Vb/y6Q==
X-Received: by 2002:a7b:c7c3:0:b0:389:cbf1:fadf with SMTP id z3-20020a7bc7c3000000b00389cbf1fadfmr27053152wmk.147.1650901917682;
        Mon, 25 Apr 2022 08:51:57 -0700 (PDT)
Received: from joneslee-l.cable.virginm.net (cpc155339-bagu17-2-0-cust87.1-3.cable.virginm.net. [86.27.177.88])
        by smtp.gmail.com with ESMTPSA id e17-20020adfa451000000b0020ada1a7c82sm3520299wra.11.2022.04.25.08.51.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 25 Apr 2022 08:51:57 -0700 (PDT)
From:   Lee Jones <lee.jones@linaro.org>
To:     lee.jones@linaro.org
Cc:     stable@vger.kernel.org, Dan Carpenter <dan.carpenter@oracle.com>
Subject: [PATCH 1/1] staging: ion: Prevent incorrect reference counting behavour
Date:   Mon, 25 Apr 2022 16:51:54 +0100
Message-Id: <20220425155154.2742426-1-lee.jones@linaro.org>
X-Mailer: git-send-email 2.36.0.rc2.479.g8af0fa9b8e-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Supply additional check in order to prevent unexpected results.

Fixes: b892bf75b2034 ("ion: Switch ion to use dma-buf")
Suggested-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
This is a forward-port from linux-4.4.y and linux-4.9.y.

It has never been upstream.

Please apply to v4.14 through v5.10.

 drivers/staging/android/ion/ion.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/staging/android/ion/ion.c b/drivers/staging/android/ion/ion.c
index e1fe03ceb7f13..e6d4a3ee6cda5 100644
--- a/drivers/staging/android/ion/ion.c
+++ b/drivers/staging/android/ion/ion.c
@@ -114,6 +114,9 @@ static void *ion_buffer_kmap_get(struct ion_buffer *buffer)
 	void *vaddr;
 
 	if (buffer->kmap_cnt) {
+		if (buffer->kmap_cnt == INT_MAX)
+			return ERR_PTR(-EOVERFLOW);
+
 		buffer->kmap_cnt++;
 		return buffer->vaddr;
 	}
-- 
2.36.0.rc2.479.g8af0fa9b8e-goog

