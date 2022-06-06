Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C026453E734
	for <lists+stable@lfdr.de>; Mon,  6 Jun 2022 19:07:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239504AbiFFOQy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 Jun 2022 10:16:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56834 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239523AbiFFOPz (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 6 Jun 2022 10:15:55 -0400
Received: from mail-qv1-xf2b.google.com (mail-qv1-xf2b.google.com [IPv6:2607:f8b0:4864:20::f2b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B62382CDF5
        for <stable@vger.kernel.org>; Mon,  6 Jun 2022 07:15:54 -0700 (PDT)
Received: by mail-qv1-xf2b.google.com with SMTP id i19so10268883qvu.13
        for <stable@vger.kernel.org>; Mon, 06 Jun 2022 07:15:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=GLyJHlSkO1ZQpe16ul4O8RVZNZlAAdD7uVcxK3IEPdc=;
        b=rdmcVLqvapms0VuTwWl2/h706XaXU3XWWOWs6BWdhYa3w7eGh21kATzcl2LcibY5BQ
         Y2hr/jCqem9RY79QNMxLqnuXgfQ0WsvZXRgbHL/XnUNtIDm0MfWQsy61Y5fdgn7mq1pN
         PRJxrgtG8HtWMLSPkoa2eV1qG5TOKAKuI7CfMZ3GHpeFkDP0MmnMi7/BPYMYHZASMaRv
         VCYg8TGhdFZfScqXRO3/CL3f2Q8GPbpO+wxjejVzl4YX3v79YMkp+P/7lZtFMyLWIetd
         tj1GAAUgT2RDOO7/5r+Q6VYQeDeEPLcEOoQJohC5bZ/D4pXnpeYSaX8Qj/LTc2zQgdCK
         +4Og==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=GLyJHlSkO1ZQpe16ul4O8RVZNZlAAdD7uVcxK3IEPdc=;
        b=3HqBupbo1ZleUtBz2J14zGu1H5RXTf2VmNeG/X6xSkeC5cZHUJ3Qjf3A3wxWtwrGLo
         i2xX/GyKuANO/GRsKdZEpHX4arh6+e1xdNU5vERqX70XoWpCQSTlrxWZ92kPV5DkGjMl
         SZc9rCceCcfC2OZXF0z7Qr57Ipi0Wndfyuf7rDdmF2sw3lO/svLV0nJfSmFGsFsRzaUP
         8VU+0ecKbSZsTT63NIaQ4Ht5h6599Hb+8OD5wPWdM3IDSOfDzW4m3+D2rr3jKZkUHGJT
         KKb1ZuCUtJa7QDS1O5OxywAoQ7X/MDCOr/5y4K62lAztWiGzQqjfnouGfyEE2NeUZj69
         6pYw==
X-Gm-Message-State: AOAM533CO28ei1apPXCK08R/gyrBLML7dj8suFcWNGxPxWaw9oZZHgKY
        /cl0pCGkkdZQSCBLcxppITzAJsbeq4wJDA==
X-Google-Smtp-Source: ABdhPJwb1u6ZPHiLTYXsiBGe8n6Mjv5CbVJyoIREnBVa1HrCb9WFzQXzFYBsRQ+DFhb+FnwZRvtpPw==
X-Received: by 2002:a05:6214:29ca:b0:464:dc6e:c110 with SMTP id gh10-20020a05621429ca00b00464dc6ec110mr19697584qvb.53.1654524953618;
        Mon, 06 Jun 2022 07:15:53 -0700 (PDT)
Received: from presto.localdomain (c-73-185-129-58.hsd1.mn.comcast.net. [73.185.129.58])
        by smtp.gmail.com with ESMTPSA id x12-20020a05620a448c00b006a6d033782fsm447451qkp.63.2022.06.06.07.15.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 06 Jun 2022 07:15:53 -0700 (PDT)
From:   Alex Elder <elder@linaro.org>
To:     stable@vger.kernel.org
Cc:     kuba@kernel.org
Subject: [PATCH 2/2] net: ipa: fix page free in ipa_endpoint_replenish_one()
Date:   Mon,  6 Jun 2022 09:15:48 -0500
Message-Id: <20220606141548.724917-3-elder@linaro.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20220606141548.724917-1-elder@linaro.org>
References: <20220606141548.724917-1-elder@linaro.org>
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

Cc: <stable@vger.kernel.org>    # 5.18.x
Fixes: 6a606b90153b8 ("net: ipa: allocate transaction in replenish loop")
Signed-off-by: Alex Elder <elder@linaro.org>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
 drivers/net/ipa/ipa_endpoint.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ipa/ipa_endpoint.c b/drivers/net/ipa/ipa_endpoint.c
index 04a2aa0f120ac..5edb728e7100c 100644
--- a/drivers/net/ipa/ipa_endpoint.c
+++ b/drivers/net/ipa/ipa_endpoint.c
@@ -1060,7 +1060,7 @@ static int ipa_endpoint_replenish_one(struct ipa_endpoint *endpoint,
 
 	ret = gsi_trans_page_add(trans, page, len, offset);
 	if (ret)
-		__free_pages(page, get_order(buffer_size));
+		put_page(page);
 	else
 		trans->data = page;	/* transaction owns page now */
 
-- 
2.32.0

