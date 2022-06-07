Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D176154105E
	for <lists+stable@lfdr.de>; Tue,  7 Jun 2022 21:23:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352535AbiFGTXo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 15:23:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34218 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1355059AbiFGTWG (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 15:22:06 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B838D49F81;
        Tue,  7 Jun 2022 11:08:58 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 492AFB82340;
        Tue,  7 Jun 2022 18:08:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ACD6BC385A5;
        Tue,  7 Jun 2022 18:08:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654625336;
        bh=t3hrAwWBwsBzAgzMagjHfQFc8tnCTd0Z2UGGpiYnyUE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dEbmHm0SFW1t5FHXevpK6wmsqPX6R2NYUVyz6wQLL+lff6cZRQKAyW3cXV4naFjo/
         4e3J5oqlt6UXRNgmQjI8Y42hrnNtbF7qwURL5ZZ3u7bVZyDwQAw/I6mbx4ggd9lBjj
         spJrj1GunVizn+GaRDuMo+w1268PL8ZmbIbPSOAU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Alex Elder <elder@linaro.org>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.15 649/667] net: ipa: fix page free in ipa_endpoint_trans_release()
Date:   Tue,  7 Jun 2022 19:05:14 +0200
Message-Id: <20220607164954.118180898@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220607164934.766888869@linuxfoundation.org>
References: <20220607164934.766888869@linuxfoundation.org>
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
@@ -1389,7 +1389,7 @@ void ipa_endpoint_trans_release(struct i
 		struct page *page = trans->data;
 
 		if (page)
-			__free_pages(page, get_order(IPA_RX_BUFFER_SIZE));
+			put_page(page);
 	}
 }
 


