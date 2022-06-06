Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0498353E6B4
	for <lists+stable@lfdr.de>; Mon,  6 Jun 2022 19:07:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239514AbiFFOQz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 Jun 2022 10:16:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59454 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239692AbiFFOQ2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 6 Jun 2022 10:16:28 -0400
Received: from mail-qt1-x832.google.com (mail-qt1-x832.google.com [IPv6:2607:f8b0:4864:20::832])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F06BC2CDED
        for <stable@vger.kernel.org>; Mon,  6 Jun 2022 07:16:26 -0700 (PDT)
Received: by mail-qt1-x832.google.com with SMTP id p8so10403003qtx.9
        for <stable@vger.kernel.org>; Mon, 06 Jun 2022 07:16:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=GBPWs4VfHXh94P3ao4plTTdmZHpbZcBFI6OH7K0/CGA=;
        b=igVG3+9L4Aa7dMNSgIf5oEgMMGo2JIH6SGghoedwk+sHBRYrEcm345OoNJB+CvO8NG
         a0VFh51q4IXmiZMkxb5rU5mcyiwAo91zx7P9XWLSEmIBJgkgLdiT53FVnaD77lKv4woI
         VTzyv1l2jEJpgixQFg5ZY5pn/wTwewW8dmaD56byseB8wiFKvvXgR3wdrbIw9AoDY5H8
         58tnenlZ77DCNre+31p1nsGkrXt9ynFkkkkp/FpilaawSSZ0sGrvS8nxOncd2UuElFHL
         MGXLdmMXH3WmJM8th5YgX+5MIpHh8O9SFb4OAvj8+/N63tAF6dJMfJZh/292xa2eO8IX
         9YHg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=GBPWs4VfHXh94P3ao4plTTdmZHpbZcBFI6OH7K0/CGA=;
        b=0MFZRcvYSF9ivZF1CxZuQCkom+T7ndfMJpuf3rhVWwxhQmu0+1HayRHKKX99lTJODs
         V6IJKi7sIkygY923gOuV7ChM4o38yrcsPq0h3HQhG92Itc9Gci5XdzH6djrFRtPQlrEE
         taFjSFF3m+S+DZGt5Wg+fYOQVhXHbo+xWi5YVvgmzh1QQIaou/uu9tBoceeYjzC4IKsV
         ObHkSRv2DR6cp7J+oFobS8J7N7baS00N5oP6UYJaQ8kc8dXiu5xky8XCUvwZvQBd/p+N
         DcOeSjt8bp2rZzTLk0YoRBUOtUmtS1POe+PGg8DUZ5Vwetq7IK/qDz0+FP/5yt49mQOG
         +6Vg==
X-Gm-Message-State: AOAM530AY7KohmTC7znXp11nSSltTTTQfzliI2/G9Z6j4iHdXL/RO5Mg
        /xjmKnWDdS4ixPfDBvWrLqTBU6hintw4AA==
X-Google-Smtp-Source: ABdhPJxzfCMpW8r2j1JlljbUr2L26uxP8NaMpDrFdU/vcypbBoNw4CKNqoBFW63al7cfEVe9SNIqMg==
X-Received: by 2002:ac8:5fca:0:b0:304:d07c:6321 with SMTP id k10-20020ac85fca000000b00304d07c6321mr17143723qta.623.1654524985821;
        Mon, 06 Jun 2022 07:16:25 -0700 (PDT)
Received: from presto.localdomain (c-73-185-129-58.hsd1.mn.comcast.net. [73.185.129.58])
        by smtp.gmail.com with ESMTPSA id z5-20020a05622a124500b00304efba3d84sm1264901qtx.25.2022.06.06.07.16.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 06 Jun 2022 07:16:25 -0700 (PDT)
From:   Alex Elder <elder@linaro.org>
To:     stable@vger.kernel.org
Cc:     kuba@kernel.org
Subject: [PATCH 1/2] net: ipa: fix page free in ipa_endpoint_trans_release()
Date:   Mon,  6 Jun 2022 09:16:21 -0500
Message-Id: <20220606141622.725027-2-elder@linaro.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20220606141622.725027-1-elder@linaro.org>
References: <20220606141622.725027-1-elder@linaro.org>
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

commit 155c0c90bca918de6e4327275dfc1d97fd604115 upstream.

Currently the (possibly compound) page used for receive buffers are
freed using __free_pages().  But according to this comment above the
definition of that function, that's wrong:
    If you want to use the page's reference count to decide when
    to free the allocation, you should allocate a compound page,
    and use put_page() instead of __free_pages().

Convert the call to __free_pages() in ipa_endpoint_trans_release()
to use put_page() instead.

Fixes: ed23f02680caa ("net: ipa: define per-endpoint receive buffer size")
Cc: <stable@vger.kernel.org>	# 5.10.x
Cc: <stable@vger.kernel.org>	# 5.15.x
Cc: <stable@vger.kernel.org>	# 5.17.x
Signed-off-by: Alex Elder <elder@linaro.org>
---
 drivers/net/ipa/ipa_endpoint.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ipa/ipa_endpoint.c b/drivers/net/ipa/ipa_endpoint.c
index dde55ccae9d73..51ad51ddf758a 100644
--- a/drivers/net/ipa/ipa_endpoint.c
+++ b/drivers/net/ipa/ipa_endpoint.c
@@ -1400,7 +1400,7 @@ void ipa_endpoint_trans_release(struct ipa_endpoint *endpoint,
 		struct page *page = trans->data;
 
 		if (page)
-			__free_pages(page, get_order(IPA_RX_BUFFER_SIZE));
+			put_page(page);
 	}
 }
 
-- 
2.32.0

