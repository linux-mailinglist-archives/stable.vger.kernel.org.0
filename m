Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9F4E566CCDF
	for <lists+stable@lfdr.de>; Mon, 16 Jan 2023 18:30:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234861AbjAPRaH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Jan 2023 12:30:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51972 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234842AbjAPR3a (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 Jan 2023 12:29:30 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 62AB53A58C
        for <stable@vger.kernel.org>; Mon, 16 Jan 2023 09:07:04 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9DBD361058
        for <stable@vger.kernel.org>; Mon, 16 Jan 2023 17:07:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AD374C433D2;
        Mon, 16 Jan 2023 17:07:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1673888823;
        bh=XlZJNHhtXi5aAm3yDyXYaVpM8t3/hcKIPK5nJ+W4XnM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cfwCE2ysd6URL8Ja5J+eSe3elvLLNRa7vFGg98OneAZxdBve/0xwdkjYTqIGOMlfz
         ovLjBvBb/pdLOjdSRuMRuy7hCKs7EKPqYDgfEDTQUnsZJhyNzAQP0WLq5tHFsf8jmc
         pMTrcPEnNYm89Br9b4xkoqNSVwlrkQgw1HfeKmJI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Gaosheng Cui <cuigaosheng1@huawei.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 153/338] crypto: img-hash - Fix variable dereferenced before check hdev->req
Date:   Mon, 16 Jan 2023 16:50:26 +0100
Message-Id: <20230116154827.523464473@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230116154820.689115727@linuxfoundation.org>
References: <20230116154820.689115727@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Gaosheng Cui <cuigaosheng1@huawei.com>

[ Upstream commit 04ba54e5af8f8f0137b08cb51a0b3a2e1ea46c94 ]

Smatch report warning as follows:

drivers/crypto/img-hash.c:366 img_hash_dma_task() warn: variable
dereferenced before check 'hdev->req'

Variable dereferenced should be done after check 'hdev->req',
fix it.

Fixes: d358f1abbf71 ("crypto: img-hash - Add Imagination Technologies hw hash accelerator")
Fixes: 10badea259fa ("crypto: img-hash - Fix null pointer exception")
Signed-off-by: Gaosheng Cui <cuigaosheng1@huawei.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/crypto/img-hash.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/crypto/img-hash.c b/drivers/crypto/img-hash.c
index b87000a0a01c..f70923643a97 100644
--- a/drivers/crypto/img-hash.c
+++ b/drivers/crypto/img-hash.c
@@ -359,12 +359,16 @@ static int img_hash_dma_init(struct img_hash_dev *hdev)
 static void img_hash_dma_task(unsigned long d)
 {
 	struct img_hash_dev *hdev = (struct img_hash_dev *)d;
-	struct img_hash_request_ctx *ctx = ahash_request_ctx(hdev->req);
+	struct img_hash_request_ctx *ctx;
 	u8 *addr;
 	size_t nbytes, bleft, wsend, len, tbc;
 	struct scatterlist tsg;
 
-	if (!hdev->req || !ctx->sg)
+	if (!hdev->req)
+		return;
+
+	ctx = ahash_request_ctx(hdev->req);
+	if (!ctx->sg)
 		return;
 
 	addr = sg_virt(ctx->sg);
-- 
2.35.1



