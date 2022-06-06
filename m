Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 50BCE53EBE5
	for <lists+stable@lfdr.de>; Mon,  6 Jun 2022 19:09:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239408AbiFFOQw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 Jun 2022 10:16:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56748 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239522AbiFFOPy (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 6 Jun 2022 10:15:54 -0400
Received: from mail-qk1-x736.google.com (mail-qk1-x736.google.com [IPv6:2607:f8b0:4864:20::736])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 043932CE0A
        for <stable@vger.kernel.org>; Mon,  6 Jun 2022 07:15:54 -0700 (PDT)
Received: by mail-qk1-x736.google.com with SMTP id o73so5977643qke.7
        for <stable@vger.kernel.org>; Mon, 06 Jun 2022 07:15:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=fE8cWs8Dfq+m21rsqH9g0r0Eknqx15Xgfwm3GmNPdEU=;
        b=rM3Lqwdv+NNHOO8FXVYHEp3AkPHj7gFbU3Iz7X7KYrFybq25Qoa82ZA/6J/iIdm/jg
         sqdRarHZ1lq6+Mz7h2QHHq55S5QpqGvX2Cg9iyktSACU6E9RL71qKqUXNdngZkEI8EUZ
         2CQhKkHaIW6PLFZrdfFjGsj3VhHMLJVlWksRteHoEcLbIHWb7ki4fg3psdLBSaqwvLpY
         ILQ8oTiptNDGN1k/QisD4xnrzx3wi28EatZm/M7+gKq0sZeRad2GG8C6+B7IJFWXLGfR
         CSfLyzbM7JILf/uGl+kP9uisD1Ud4nL9LTe08Yhz+orJnaNj5jdpuku5t07+1SFgz2Js
         Bqxw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=fE8cWs8Dfq+m21rsqH9g0r0Eknqx15Xgfwm3GmNPdEU=;
        b=j1RiOQUmrGcg0uMDvNWhBcyjy2FrAXbLQn9f555UQtcgRclDOwt9YQmoDOg43ymYDS
         X3jQFBbdIn8QEmvFKUKwq4uUnDdhvHbotizVcEfkiIZRmmgppzG5SGwPyJ+75WnXe/tI
         X5hwTZJzf1YVCGQHCWd4Ws3LBzLOAqZYDwIlXwFovrLWFoc6KMGLv3/X4j8p6DgZ6iyP
         yu6yxMZDu0fgnSV+Ws6NmtV7gKwIdEtTYSdXDe0lIx6SbP6i4iPdXpzmDSqtHoqGzC3b
         oLmTZwf8rf9PYGLQ8K/l6hgd2jMQe14dupZzoZjlQio1Q/09A6m53of4AfXkVPeM3F12
         QJQQ==
X-Gm-Message-State: AOAM533zY03bK1+u2MtvXsdWmQU5y2UtAjrzu9+Q53KCgirS7+Mt4+jM
        lpD1EVcGn2V2RR/l9KpQvJK8yXPNZM3MLg==
X-Google-Smtp-Source: ABdhPJzh92VX2cXkLI+je1dhqRO3xWqz3tneMZoGx1/kF4dW4mGqoBXjqx7eqOIhqkw6P5lb89kUew==
X-Received: by 2002:a05:620a:4096:b0:6a5:cdb:f6df with SMTP id f22-20020a05620a409600b006a50cdbf6dfmr16292363qko.698.1654524952758;
        Mon, 06 Jun 2022 07:15:52 -0700 (PDT)
Received: from presto.localdomain (c-73-185-129-58.hsd1.mn.comcast.net. [73.185.129.58])
        by smtp.gmail.com with ESMTPSA id x12-20020a05620a448c00b006a6d033782fsm447451qkp.63.2022.06.06.07.15.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 06 Jun 2022 07:15:52 -0700 (PDT)
From:   Alex Elder <elder@linaro.org>
To:     stable@vger.kernel.org
Cc:     kuba@kernel.org
Subject: [PATCH 1/2] net: ipa: fix page free in ipa_endpoint_trans_release()
Date:   Mon,  6 Jun 2022 09:15:47 -0500
Message-Id: <20220606141548.724917-2-elder@linaro.org>
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

commit 155c0c90bca918de6e4327275dfc1d97fd604115 upstream.

Currently the (possibly compound) page used for receive buffers are
freed using __free_pages().  But according to this comment above the
definition of that function, that's wrong:
    If you want to use the page's reference count to decide when
    to free the allocation, you should allocate a compound page,
    and use put_page() instead of __free_pages().

Convert the call to __free_pages() in ipa_endpoint_trans_release()
to use put_page() instead.

Cc: <stable@vger.kernel.org>    # 5.18.x
Fixes: ed23f02680caa ("net: ipa: define per-endpoint receive buffer size")
Signed-off-by: Alex Elder <elder@linaro.org>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
 drivers/net/ipa/ipa_endpoint.c | 7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ipa/ipa_endpoint.c b/drivers/net/ipa/ipa_endpoint.c
index 53764f3c0c7e4..04a2aa0f120ac 100644
--- a/drivers/net/ipa/ipa_endpoint.c
+++ b/drivers/net/ipa/ipa_endpoint.c
@@ -1383,11 +1383,8 @@ void ipa_endpoint_trans_release(struct ipa_endpoint *endpoint,
 	} else {
 		struct page *page = trans->data;
 
-		if (page) {
-			u32 buffer_size = endpoint->data->rx.buffer_size;
-
-			__free_pages(page, get_order(buffer_size));
-		}
+		if (page)
+			put_page(page);
 	}
 }
 
-- 
2.32.0

