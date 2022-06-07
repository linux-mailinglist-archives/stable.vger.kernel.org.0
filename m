Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8EE1D5407D5
	for <lists+stable@lfdr.de>; Tue,  7 Jun 2022 19:52:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347584AbiFGRwb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 13:52:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47472 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349411AbiFGRur (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 13:50:47 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5BA8517048;
        Tue,  7 Jun 2022 10:38:24 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 4F14CB822B5;
        Tue,  7 Jun 2022 17:37:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B3FF3C385A5;
        Tue,  7 Jun 2022 17:37:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654623464;
        bh=PP6xuZ+OYIWi/Lg7w2BAYMZ4Np2wleQMLd4YyDw0zp0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=zefBUM+UhjI3jzP8SF2JkbJzjaiKt7w5StznelQXkCO+fHWUEvdoKAQ0s3lEjalJ+
         saLp9aY3phFYyWUq/7HqRIKRxWtvYf3LCjHXGxFFv5tuQzFF3mEQY/Twtxi6k+Okjx
         jqpsd0b+NiopQgx6yTGCQogI670wQsoAtZuKdivk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Alex Elder <elder@linaro.org>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.10 428/452] net: ipa: fix page free in ipa_endpoint_trans_release()
Date:   Tue,  7 Jun 2022 19:04:45 +0200
Message-Id: <20220607164921.309516217@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220607164908.521895282@linuxfoundation.org>
References: <20220607164908.521895282@linuxfoundation.org>
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
Signed-off-by: Alex Elder <elder@linaro.org>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ipa/ipa_endpoint.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/net/ipa/ipa_endpoint.c
+++ b/drivers/net/ipa/ipa_endpoint.c
@@ -1179,7 +1179,7 @@ void ipa_endpoint_trans_release(struct i
 		struct page *page = trans->data;
 
 		if (page)
-			__free_pages(page, get_order(IPA_RX_BUFFER_SIZE));
+			put_page(page);
 	}
 }
 


