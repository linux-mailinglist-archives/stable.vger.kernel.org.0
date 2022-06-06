Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0C31053EC2D
	for <lists+stable@lfdr.de>; Mon,  6 Jun 2022 19:10:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239511AbiFFOQy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 Jun 2022 10:16:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59488 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239702AbiFFOQ3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 6 Jun 2022 10:16:29 -0400
Received: from mail-qk1-x72e.google.com (mail-qk1-x72e.google.com [IPv6:2607:f8b0:4864:20::72e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D1D482CDE7
        for <stable@vger.kernel.org>; Mon,  6 Jun 2022 07:16:27 -0700 (PDT)
Received: by mail-qk1-x72e.google.com with SMTP id x65so10941968qke.2
        for <stable@vger.kernel.org>; Mon, 06 Jun 2022 07:16:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=jKMeNkqq2MneOF0nJ8e1K3cS4ErvDxl8zbrIsP+D7z4=;
        b=uNkzmmDBAiqFumletXVBSegaXmQ5PwIt/QZrOLYVVv5Sn3t9ukF1L6EsRdcY09AYue
         VaS5V0QJpHgCnGqOPFEMjSkIYT0nA7IbYYqtQyPgn5Ul7s1/HzJj5PRX6lAuZzoPvblo
         xcTzgjOg7RM91a+pInsGq/Rnlc1VUq7yczEyHW8zlOLUXG5n8d+h2MeFbeDiRFl02bAY
         YqfTC+9e/NfLwkK5N1gbV8tVELix9Y1v7XOb/dSouHStSS58G4IBRCo8cGvOhY39m0qI
         dn7I2BNiKB0MfOMOCqJNiDWa9r87vxCe/Jy10JUemG9//2amOsZxrirU7SQB+YxR9wfz
         ayGQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=jKMeNkqq2MneOF0nJ8e1K3cS4ErvDxl8zbrIsP+D7z4=;
        b=J+4k4G57DZzlO2Zp6E9JFd+xxQe4h+AUjv+b1Jj1W2AtxO1aVocpXcRgNoJw0Jlcuy
         1gT05uPW/J18NAwh0Fifzl0bn7pO497Mlkpa3sbu80txcE3tKqege1aRqtM+D9OtFRDw
         8mkGarNoE3Tkq4LLrh5dfjM1Oe3fDRtkTbhRS+uqltPA1jdxpP0zuaOKGdhRtkHm5O+2
         IAgFcG+6oKYUbDooU+EvsSP8QlDF5wPb4fmEDyO0WTsR/v7SpT2w4lY416WgZWsT5yra
         82vgxAZN+LQriuRCG86FFORLzKESalpymIYhmFj7RU4di2uH2gJIYaBaZ0iukgXpqzVg
         akpg==
X-Gm-Message-State: AOAM530B0LIAy10t8e7bB/Z88C0twVyC54+RDb5ea25CaoW6LIptHTAk
        nxibyoz9DfdQSSv5R1OmWAZTTz/8Ma5gaQ==
X-Google-Smtp-Source: ABdhPJyi/qRX6yt66aGBpMG8sm8DVxvQ86XzyL6Es1QiyYvWG019o4a7p2IlM+BPbx1oJEzia9Fcjw==
X-Received: by 2002:a05:620a:2601:b0:6a6:7ae4:3605 with SMTP id z1-20020a05620a260100b006a67ae43605mr14062336qko.88.1654524986638;
        Mon, 06 Jun 2022 07:16:26 -0700 (PDT)
Received: from presto.localdomain (c-73-185-129-58.hsd1.mn.comcast.net. [73.185.129.58])
        by smtp.gmail.com with ESMTPSA id z5-20020a05622a124500b00304efba3d84sm1264901qtx.25.2022.06.06.07.16.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 06 Jun 2022 07:16:26 -0700 (PDT)
From:   Alex Elder <elder@linaro.org>
To:     stable@vger.kernel.org
Cc:     kuba@kernel.org
Subject: [PATCH 2/2] net: ipa: fix page free in ipa_endpoint_replenish_one()
Date:   Mon,  6 Jun 2022 09:16:22 -0500
Message-Id: <20220606141622.725027-3-elder@linaro.org>
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

commit 70132763d5d2e94cd185e3aa92ac6a3ba89068fa upstream.

Currently the (possibly compound) pages used for receive buffers are
freed using __free_pages().  But according to this comment above the
definition of that function, that's wrong:
    If you want to use the page's reference count to decide
    when to free the allocation, you should allocate a compound
    page, and use put_page() instead of __free_pages().

Convert the call to __free_pages() in ipa_endpoint_replenish_one()
to use put_page() instead.

Fixes: 6a606b90153b8 ("net: ipa: allocate transaction in replenish loop")
Cc: <stable@vger.kernel.org>	# 5.10.x
Cc: <stable@vger.kernel.org>	# 5.15.x
Cc: <stable@vger.kernel.org>	# 5.17.x
Signed-off-by: Alex Elder <elder@linaro.org>
---
 drivers/net/ipa/ipa_endpoint.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ipa/ipa_endpoint.c b/drivers/net/ipa/ipa_endpoint.c
index 51ad51ddf758a..3378899def346 100644
--- a/drivers/net/ipa/ipa_endpoint.c
+++ b/drivers/net/ipa/ipa_endpoint.c
@@ -1060,7 +1060,7 @@ static int ipa_endpoint_replenish_one(struct ipa_endpoint *endpoint)
 err_trans_free:
 	gsi_trans_free(trans);
 err_free_pages:
-	__free_pages(page, get_order(IPA_RX_BUFFER_SIZE));
+	put_page(page);
 
 	return -ENOMEM;
 }
-- 
2.32.0

