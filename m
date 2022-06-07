Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7298A54171C
	for <lists+stable@lfdr.de>; Tue,  7 Jun 2022 22:59:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354025AbiFGU7L (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 16:59:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34356 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1377620AbiFGU6p (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 16:58:45 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ADFA0209046;
        Tue,  7 Jun 2022 11:44:41 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id DD92C6156D;
        Tue,  7 Jun 2022 18:44:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E80A2C385A2;
        Tue,  7 Jun 2022 18:44:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654627480;
        bh=rSusfQPLFHbWiohMqhK6NenZ3Zdw8efehaHO/siqSgw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RwD3RKL6Pil8jlwYcSvC7llsBF8UBuREX1NFrkGBHk36WqDZO2ujO7Ng+rygF1xVF
         JwVu1lC+LW4KjlgrmIBDP80TgA7rSNnM1WK0XnBNGVOYKh2ImhVq6of9JOK+qquGPC
         Z2KqGE8lbTkyxXjoGfz7xHmY0YZ5t456KaidBiGU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Alex Elder <elder@linaro.org>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.17 755/772] net: ipa: fix page free in ipa_endpoint_replenish_one()
Date:   Tue,  7 Jun 2022 19:05:47 +0200
Message-Id: <20220607165011.273700678@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220607164948.980838585@linuxfoundation.org>
References: <20220607164948.980838585@linuxfoundation.org>
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

From: Alex Elder <elder@linaro.org>

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
Signed-off-by: Alex Elder <elder@linaro.org>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ipa/ipa_endpoint.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/net/ipa/ipa_endpoint.c
+++ b/drivers/net/ipa/ipa_endpoint.c
@@ -1062,7 +1062,7 @@ static int ipa_endpoint_replenish_one(st
 err_trans_free:
 	gsi_trans_free(trans);
 err_free_pages:
-	__free_pages(page, get_order(IPA_RX_BUFFER_SIZE));
+	put_page(page);
 
 	return -ENOMEM;
 }


