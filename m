Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 91B3D4FD1DA
	for <lists+stable@lfdr.de>; Tue, 12 Apr 2022 09:08:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243030AbiDLHBt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 Apr 2022 03:01:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58618 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351128AbiDLHAF (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 12 Apr 2022 03:00:05 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A1BFA42EF3;
        Mon, 11 Apr 2022 23:46:41 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9A06D61093;
        Tue, 12 Apr 2022 06:46:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ADDA1C385A8;
        Tue, 12 Apr 2022 06:46:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649746000;
        bh=UXOL9ozP+2qJrD/MwC8apLa02lpVVWnL6ePTyLoqf4g=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VRFWvCiw8/e5ymjqp3bs2ZObnZmeiCSUtZzILFgSoY7JrtKtVN0blH7lFn4vjnPYz
         ulqXR5qqRLMoqnK3Kh4zSYTjmWFyqBtgBtUsCBz9n76UVirqDT32pI8jqwTXkFKNv/
         iAcHPhlDRNaIgbYYXVQkgfcxAS64XEUUf3AgvoIg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ohad Sharabi <osharabi@habana.ai>,
        Oded Gabbay <ogabbay@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 123/277] habanalabs: fix possible memory leak in MMU DR fini
Date:   Tue, 12 Apr 2022 08:28:46 +0200
Message-Id: <20220412062945.601076144@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220412062942.022903016@linuxfoundation.org>
References: <20220412062942.022903016@linuxfoundation.org>
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

From: Ohad Sharabi <osharabi@habana.ai>

[ Upstream commit eb85eec858c1a5c11d3a0bff403f6440b05b40dc ]

This patch fixes what seems to be copy paste error.

We will have a memory leak if the host-resident shadow is NULL (which
will likely happen as the DR and HR are not dependent).

Signed-off-by: Ohad Sharabi <osharabi@habana.ai>
Reviewed-by: Oded Gabbay <ogabbay@kernel.org>
Signed-off-by: Oded Gabbay <ogabbay@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/misc/habanalabs/common/mmu/mmu_v1.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/misc/habanalabs/common/mmu/mmu_v1.c b/drivers/misc/habanalabs/common/mmu/mmu_v1.c
index 0f536f79dd9c..e68e9f71c546 100644
--- a/drivers/misc/habanalabs/common/mmu/mmu_v1.c
+++ b/drivers/misc/habanalabs/common/mmu/mmu_v1.c
@@ -467,7 +467,7 @@ static void hl_mmu_v1_fini(struct hl_device *hdev)
 {
 	/* MMU H/W fini was already done in device hw_fini() */
 
-	if (!ZERO_OR_NULL_PTR(hdev->mmu_priv.hr.mmu_shadow_hop0)) {
+	if (!ZERO_OR_NULL_PTR(hdev->mmu_priv.dr.mmu_shadow_hop0)) {
 		kvfree(hdev->mmu_priv.dr.mmu_shadow_hop0);
 		gen_pool_destroy(hdev->mmu_priv.dr.mmu_pgt_pool);
 
-- 
2.35.1



