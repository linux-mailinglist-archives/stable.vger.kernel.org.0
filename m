Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A126C59A1D5
	for <lists+stable@lfdr.de>; Fri, 19 Aug 2022 18:36:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352051AbiHSQTC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Aug 2022 12:19:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47372 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352430AbiHSQQg (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 19 Aug 2022 12:16:36 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AB48B108F1C;
        Fri, 19 Aug 2022 08:59:52 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B150A6178A;
        Fri, 19 Aug 2022 15:59:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BAEA9C433C1;
        Fri, 19 Aug 2022 15:59:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660924791;
        bh=qVykEADmkqDd7dMui6E8TD0P8QHRoDILfpFsL3tT9i4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qzV+zuP5sM6tL2OtGmb5RxjNV0ozar9ozYVl5miImlTPGuA1pcFW8uUvTeBksEg/r
         AOmAYFduCgOsrLpJi3pELN6Df0obxenSpLhPdP2j+8YJdRv/bjU+fA/DIPOfGg7A9N
         uUXxG5ADMRYBgnF+BsdHkBCYoZD+pT6BpVPNVf5A=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Zhengchao Shao <shaozhengchao@huawei.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 254/545] crypto: hisilicon/hpre - dont use GFP_KERNEL to alloc mem during softirq
Date:   Fri, 19 Aug 2022 17:40:24 +0200
Message-Id: <20220819153840.721711207@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220819153829.135562864@linuxfoundation.org>
References: <20220819153829.135562864@linuxfoundation.org>
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
index a87f9904087a..90c13ebe7e83 100644
--- a/drivers/crypto/hisilicon/hpre/hpre_crypto.c
+++ b/drivers/crypto/hisilicon/hpre/hpre_crypto.c
@@ -210,7 +210,7 @@ static int hpre_prepare_dma_buf(struct hpre_asym_request *hpre_req,
 	if (unlikely(shift < 0))
 		return -EINVAL;
 
-	ptr = dma_alloc_coherent(dev, ctx->key_sz, tmp, GFP_KERNEL);
+	ptr = dma_alloc_coherent(dev, ctx->key_sz, tmp, GFP_ATOMIC);
 	if (unlikely(!ptr))
 		return -ENOMEM;
 
-- 
2.35.1



