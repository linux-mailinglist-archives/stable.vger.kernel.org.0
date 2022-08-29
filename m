Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4E7B25A49AA
	for <lists+stable@lfdr.de>; Mon, 29 Aug 2022 13:27:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232241AbiH2L1o (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Aug 2022 07:27:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40138 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231965AbiH2L0Y (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 29 Aug 2022 07:26:24 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1F17B78234;
        Mon, 29 Aug 2022 04:16:16 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 803D9B80F1A;
        Mon, 29 Aug 2022 11:07:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E191BC433C1;
        Mon, 29 Aug 2022 11:07:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1661771229;
        bh=lb17TWvqJjOdV/AHBMCPYxlj+G08duqVBd0OPh0z1EY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=oXxs2y31P6/IYKieWqXg9tUrHyYGNIdg/QMvmbsUkrY4nbYPboWJbWUqtdj7r6X9t
         2ssvl8FP2CcuWEVngpp3nn+GpKOP0+jkj/nD7PjDJ66dJb5x/BVBGGlRkzuUo47FeH
         kfZvbEppCIu0JyE2MNWFtpFoepB8xib+Xvdr+nJg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Alex Elder <elder@linaro.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 26/86] net: ipa: dont assume SMEM is page-aligned
Date:   Mon, 29 Aug 2022 12:58:52 +0200
Message-Id: <20220829105757.611254614@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220829105756.500128871@linuxfoundation.org>
References: <20220829105756.500128871@linuxfoundation.org>
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

From: Alex Elder <elder@linaro.org>

[ Upstream commit b8d4380365c515d8e0351f2f46d371738dd19be1 ]

In ipa_smem_init(), a Qualcomm SMEM region is allocated (if needed)
and then its virtual address is fetched using qcom_smem_get().  The
physical address associated with that region is also fetched.

The physical address is adjusted so that it is page-aligned, and an
attempt is made to update the size of the region to compensate for
any non-zero adjustment.

But that adjustment isn't done properly.  The physical address is
aligned twice, and as a result the size is never actually adjusted.

Fix this by *not* aligning the "addr" local variable, and instead
making the "phys" local variable be the adjusted "addr" value.

Fixes: a0036bb413d5b ("net: ipa: define SMEM memory region for IPA")
Signed-off-by: Alex Elder <elder@linaro.org>
Link: https://lore.kernel.org/r/20220818134206.567618-1-elder@linaro.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ipa/ipa_mem.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ipa/ipa_mem.c b/drivers/net/ipa/ipa_mem.c
index a78d66051a17d..25a8d029f2075 100644
--- a/drivers/net/ipa/ipa_mem.c
+++ b/drivers/net/ipa/ipa_mem.c
@@ -414,7 +414,7 @@ static int ipa_smem_init(struct ipa *ipa, u32 item, size_t size)
 	}
 
 	/* Align the address down and the size up to a page boundary */
-	addr = qcom_smem_virt_to_phys(virt) & PAGE_MASK;
+	addr = qcom_smem_virt_to_phys(virt);
 	phys = addr & PAGE_MASK;
 	size = PAGE_ALIGN(size + addr - phys);
 	iova = phys;	/* We just want a direct mapping */
-- 
2.35.1



