Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 42B5A4AFD5C
	for <lists+stable@lfdr.de>; Wed,  9 Feb 2022 20:27:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235234AbiBIT10 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 9 Feb 2022 14:27:26 -0500
Received: from gmail-smtp-in.l.google.com ([23.128.96.19]:46724 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234283AbiBIT0r (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 9 Feb 2022 14:26:47 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 75A1FE00E268;
        Wed,  9 Feb 2022 11:19:16 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7458661981;
        Wed,  9 Feb 2022 19:15:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5A2C8C340E7;
        Wed,  9 Feb 2022 19:15:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1644434149;
        bh=NNc+7Y0huyvzPtYU7fhizoIjK1Exh4LxPSeoyJjDrRY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=B41GUDSDg7IUnEg/ob37dwh7rMBV32XE0SMP2RA3PfKYBeYicpFQUmOHiZB6cz2T6
         xspszoAINY8Ht2UTycYwy3h9AvxmR1ufG/taiSuangxdjGPj9mq/SJzYLXjvnHRjw+
         H+hvVNKy7bXCqvQJQMZd+R1bvrucT7R33u8x66zU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jan Beulich <jbeulich@suse.com>,
        Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 5.15 5/5] crypto: api - Move cryptomgr soft dependency into algapi
Date:   Wed,  9 Feb 2022 20:14:30 +0100
Message-Id: <20220209191250.163703971@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220209191249.980911721@linuxfoundation.org>
References: <20220209191249.980911721@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Herbert Xu <herbert@gondor.apana.org.au>

commit c6ce9c5831cae515d375a01b97ae1778689acf19 upstream.

The soft dependency on cryptomgr is only needed in algapi because
if algapi isn't present then no algorithms can be loaded.  This
also fixes the case where api is built-in but algapi is built as
a module as the soft dependency would otherwise get lost.

Fixes: 8ab23d547f65 ("crypto: api - Add softdep on cryptomgr")
Reported-by: Jan Beulich <jbeulich@suse.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Tested-by: Jan Beulich <jbeulich@suse.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 crypto/algapi.c |    1 +
 crypto/api.c    |    1 -
 2 files changed, 1 insertion(+), 1 deletion(-)

--- a/crypto/algapi.c
+++ b/crypto/algapi.c
@@ -1277,3 +1277,4 @@ module_exit(crypto_algapi_exit);
 
 MODULE_LICENSE("GPL");
 MODULE_DESCRIPTION("Cryptographic algorithms API");
+MODULE_SOFTDEP("pre: cryptomgr");
--- a/crypto/api.c
+++ b/crypto/api.c
@@ -603,4 +603,3 @@ EXPORT_SYMBOL_GPL(crypto_req_done);
 
 MODULE_DESCRIPTION("Cryptographic core API");
 MODULE_LICENSE("GPL");
-MODULE_SOFTDEP("pre: cryptomgr");


