Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B12416B40F1
	for <lists+stable@lfdr.de>; Fri, 10 Mar 2023 14:47:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230246AbjCJNrv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 10 Mar 2023 08:47:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46968 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230293AbjCJNru (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 10 Mar 2023 08:47:50 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7C93728E58
        for <stable@vger.kernel.org>; Fri, 10 Mar 2023 05:47:49 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 195BF617D5
        for <stable@vger.kernel.org>; Fri, 10 Mar 2023 13:47:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 246E3C433EF;
        Fri, 10 Mar 2023 13:47:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678456068;
        bh=3f2qvCaRwSZRnJnQINWmy8juXaOJ7GLzanXKZQXl3dE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=yw2uV9gLK77pbUN6P7aqexghdnbW44roGctvg3lEDE87nl0IvYuNjFmwKGnpm7MDO
         jGmStCUu0i8+x+KcTeVl1yQWkKv70S3PTQdRZMrAXlQp3yEZYYAGVBWKJdQZZvvFGk
         muo4YVvIr4Pn/gqmmJKCIDqg/5WzhHS9X0nP7MY8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Herbert Xu <herbert@gondor.apana.org.au>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 040/193] crypto: seqiv - Handle EBUSY correctly
Date:   Fri, 10 Mar 2023 14:37:02 +0100
Message-Id: <20230310133712.301614070@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230310133710.926811681@linuxfoundation.org>
References: <20230310133710.926811681@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Herbert Xu <herbert@gondor.apana.org.au>

[ Upstream commit 32e62025e5e52fbe4812ef044759de7010b15dbc ]

As it is seqiv only handles the special return value of EINPROGERSS,
which means that in all other cases it will free data related to the
request.

However, as the caller of seqiv may specify MAY_BACKLOG, we also need
to expect EBUSY and treat it in the same way.  Otherwise backlogged
requests will trigger a use-after-free.

Fixes: 0a270321dbf9 ("[CRYPTO] seqiv: Add Sequence Number IV Generator")
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 crypto/seqiv.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/crypto/seqiv.c b/crypto/seqiv.c
index 570b7d1aa0cac..ce9214097bc98 100644
--- a/crypto/seqiv.c
+++ b/crypto/seqiv.c
@@ -30,7 +30,7 @@ static void seqiv_aead_encrypt_complete2(struct aead_request *req, int err)
 	struct aead_request *subreq = aead_request_ctx(req);
 	struct crypto_aead *geniv;
 
-	if (err == -EINPROGRESS)
+	if (err == -EINPROGRESS || err == -EBUSY)
 		return;
 
 	if (err)
-- 
2.39.2



