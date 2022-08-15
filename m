Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 03D685937E8
	for <lists+stable@lfdr.de>; Mon, 15 Aug 2022 21:29:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229769AbiHOS6e (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 14:58:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48574 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245298AbiHOS5L (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 14:57:11 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 70BCE49B51;
        Mon, 15 Aug 2022 11:32:20 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 97E57B8107A;
        Mon, 15 Aug 2022 18:32:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E1FB6C433D6;
        Mon, 15 Aug 2022 18:32:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660588337;
        bh=70ihzHdaa0U9BhqBj0wzWZsZcC9BnrOnx85aHESZwOY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FB0E5kTLqmRaTHjsS1Br/DdTdAjruwVJjB9NLAYaMCt95WMQHI3cFWL9RnkpwgT7p
         aW/2qD3w8UET20fX+IkWUVxPXcvQyYHjUZKHNsJ1HOB96DgdqEhKEgJ1aXidMRcHo4
         yb429XjOHDdvz6nbMQmsT3FFJztP00olt7V4RfDo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Zhengchao Shao <shaozhengchao@huawei.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 371/779] crypto: hisilicon/hpre - dont use GFP_KERNEL to alloc mem during softirq
Date:   Mon, 15 Aug 2022 20:00:15 +0200
Message-Id: <20220815180353.125040549@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220815180337.130757997@linuxfoundation.org>
References: <20220815180337.130757997@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Zhengchao Shao <shaozhengchao@huawei.com>

[ Upstream commit 98dfa9343f37bdd4112966292751e3a93aaf2e56 ]

The hpre encryption driver may be used to encrypt and decrypt packets
during the rx softirq, it is not allowed to use GFP_KERNEL.

Fixes: c8b4b477079d ("crypto: hisilicon - add HiSilicon HPRE accelerator")
Signed-off-by: Zhengchao Shao <shaozhengchao@huawei.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/crypto/hisilicon/hpre/hpre_crypto.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/crypto/hisilicon/hpre/hpre_crypto.c b/drivers/crypto/hisilicon/hpre/hpre_crypto.c
index 7ba7641723a0..4062251fd1b6 100644
--- a/drivers/crypto/hisilicon/hpre/hpre_crypto.c
+++ b/drivers/crypto/hisilicon/hpre/hpre_crypto.c
@@ -252,7 +252,7 @@ static int hpre_prepare_dma_buf(struct hpre_asym_request *hpre_req,
 	if (unlikely(shift < 0))
 		return -EINVAL;
 
-	ptr = dma_alloc_coherent(dev, ctx->key_sz, tmp, GFP_KERNEL);
+	ptr = dma_alloc_coherent(dev, ctx->key_sz, tmp, GFP_ATOMIC);
 	if (unlikely(!ptr))
 		return -ENOMEM;
 
-- 
2.35.1



