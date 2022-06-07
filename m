Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C53B8541065
	for <lists+stable@lfdr.de>; Tue,  7 Jun 2022 21:24:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354522AbiFGTYO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 15:24:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34240 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1355125AbiFGTWL (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 15:22:11 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0B0FF67D24;
        Tue,  7 Jun 2022 11:09:02 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 00F686193C;
        Tue,  7 Jun 2022 18:09:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 141EDC3411C;
        Tue,  7 Jun 2022 18:09:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654625341;
        bh=ODRQG+sRCqh6RBUSnN70/uOk5euMC1g+MOEckd+VAeA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=vpWizjkEnnnK8sBouKrYvdB+viAiM7IKLW3aUxWr5KNDjRIOObJexDGiAIzoSTFNx
         wTjHPKv0QnKBJhnnf/xwnB53R8FU4nA2DdqYslYqfW9DEcv8pXK/SJlGNg/FyMyiau
         iTj8y7ixdXrlekCfWh+jMRbvgGeAxTxxVApCh460=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Alex Elder <elder@linaro.org>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.15 650/667] net: ipa: fix page free in ipa_endpoint_replenish_one()
Date:   Tue,  7 Jun 2022 19:05:15 +0200
Message-Id: <20220607164954.147888942@linuxfoundation.org>
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
@@ -1049,7 +1049,7 @@ static int ipa_endpoint_replenish_one(st
 err_trans_free:
 	gsi_trans_free(trans);
 err_free_pages:
-	__free_pages(page, get_order(IPA_RX_BUFFER_SIZE));
+	put_page(page);
 
 	return -ENOMEM;
 }


