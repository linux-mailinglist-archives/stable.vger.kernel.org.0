Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8D1246A30F6
	for <lists+stable@lfdr.de>; Sun, 26 Feb 2023 15:56:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231208AbjBZO4B (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 26 Feb 2023 09:56:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55258 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231283AbjBZOzP (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 26 Feb 2023 09:55:15 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AAC9F15887;
        Sun, 26 Feb 2023 06:50:59 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 367F060C49;
        Sun, 26 Feb 2023 14:50:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7FF3AC433A0;
        Sun, 26 Feb 2023 14:50:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1677423054;
        bh=r+KOjwwc9UaFDXuIkKlXzP5eA2B5FpFDXbCIlVGldCA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NMBBT7dJB0u71CDVuhN/RZeY9JoL0POhnPfdcbCv9nLMQfU3331nas74s8ItyuKfF
         OUE3VkB6hTbDdY/1ZqWbk/Wuz2W52KO9kAivW8NRwcgqQUz4IqKChQyhC5S6w9ZWk+
         1O334O9AMX0X+mSOI02Td09LqOM47L0mDbMei5+PtLLKRwjsuxRln4ay7AeB4QHtEl
         vqcaep66AYGv5I8nnDaAjtQKB29uSRtGY0qvoJdcv+2oVqNlpuoqu6Ij55abbEIVa7
         G1duByZG7l8JAKwzOAnxKmkhBglq5dsgfiyJCxezrW6TrcsoiSsDgR7QHsh+qgXOKT
         lCirVqk0k5aaw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Kees Cook <keescook@chromium.org>,
        Nathan Chancellor <nathan@kernel.org>,
        Weili Qian <qianweili@huawei.com>,
        Zhou Wang <wangzhou1@hisilicon.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        linux-crypto@vger.kernel.org, Sasha Levin <sashal@kernel.org>,
        ndesaulniers@google.com, llvm@lists.linux.dev
Subject: [PATCH AUTOSEL 5.10 16/27] crypto: hisilicon: Wipe entire pool on error
Date:   Sun, 26 Feb 2023 09:50:03 -0500
Message-Id: <20230226145014.828855-16-sashal@kernel.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230226145014.828855-1-sashal@kernel.org>
References: <20230226145014.828855-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Kees Cook <keescook@chromium.org>

[ Upstream commit aa85923a954e7704bc9d3847dabeb8540aa98d13 ]

To work around a Clang __builtin_object_size bug that shows up under
CONFIG_FORTIFY_SOURCE and UBSAN_BOUNDS, move the per-loop-iteration
mem_block wipe into a single wipe of the entire pool structure after
the loop.

Reported-by: Nathan Chancellor <nathan@kernel.org>
Link: https://github.com/ClangBuiltLinux/linux/issues/1780
Cc: Weili Qian <qianweili@huawei.com>
Cc: Zhou Wang <wangzhou1@hisilicon.com>
Cc: Herbert Xu <herbert@gondor.apana.org.au>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: linux-crypto@vger.kernel.org
Signed-off-by: Kees Cook <keescook@chromium.org>
Tested-by: Nathan Chancellor <nathan@kernel.org> # build
Link: https://lore.kernel.org/r/20230106041945.never.831-kees@kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/crypto/hisilicon/sgl.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/crypto/hisilicon/sgl.c b/drivers/crypto/hisilicon/sgl.c
index 725a739800b0a..ce77826c7fb05 100644
--- a/drivers/crypto/hisilicon/sgl.c
+++ b/drivers/crypto/hisilicon/sgl.c
@@ -113,9 +113,8 @@ struct hisi_acc_sgl_pool *hisi_acc_create_sgl_pool(struct device *dev,
 	for (j = 0; j < i; j++) {
 		dma_free_coherent(dev, block_size, block[j].sgl,
 				  block[j].sgl_dma);
-		memset(block + j, 0, sizeof(*block));
 	}
-	kfree(pool);
+	kfree_sensitive(pool);
 	return ERR_PTR(-ENOMEM);
 }
 EXPORT_SYMBOL_GPL(hisi_acc_create_sgl_pool);
-- 
2.39.0

