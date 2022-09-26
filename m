Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B97D75EA275
	for <lists+stable@lfdr.de>; Mon, 26 Sep 2022 13:08:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234400AbiIZLIQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Sep 2022 07:08:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35570 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234370AbiIZLHP (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 26 Sep 2022 07:07:15 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 987CF23BE1;
        Mon, 26 Sep 2022 03:34:17 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 21493609FE;
        Mon, 26 Sep 2022 10:32:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 156FBC433D6;
        Mon, 26 Sep 2022 10:32:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1664188364;
        bh=t/CdJeowKoIkUUXV3GUs+L273If4I8CeICo71n3PeEg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=B0NapMWC1A1ZM5c3JGqJKQojYC95ak/bsBnZoLbEpsrPFFLeqk+MWNHhsB1izWzM2
         Rf3wvTBjzHR3BkgMXi5C4qXWLE2mQuI5z44kjfHNGZRda3BaVTFb8TEozwRhqwtFlm
         bPRV9dWAnmBYzDGe/mi/HFDHHYpT5lBdHfxSPAaQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Alex Elder <elder@linaro.org>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 094/141] net: ipa: fix table alignment requirement
Date:   Mon, 26 Sep 2022 12:12:00 +0200
Message-Id: <20220926100757.837361076@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20220926100754.639112000@linuxfoundation.org>
References: <20220926100754.639112000@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Alex Elder <elder@linaro.org>

[ Upstream commit e5d4e96b44cf20330c970c3e30ea0a8c3a23feca ]

We currently have a build-time check to ensure that the minimum DMA
allocation alignment satisfies the constraint that IPA filter and
route tables must point to rules that are 128-byte aligned.

But what's really important is that the actual allocated DMA memory
has that alignment, even if the minimum is smaller than that.

Remove the BUILD_BUG_ON() call checking against minimim DMA alignment
and instead verify at rutime that the allocated memory is properly
aligned.

Signed-off-by: Alex Elder <elder@linaro.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
Stable-dep-of: cf412ec33325 ("net: ipa: properly limit modem routing table use")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ipa/ipa_table.c | 20 ++++++++++++--------
 1 file changed, 12 insertions(+), 8 deletions(-)

diff --git a/drivers/net/ipa/ipa_table.c b/drivers/net/ipa/ipa_table.c
index f26cb9d706da..45e1d68b4694 100644
--- a/drivers/net/ipa/ipa_table.c
+++ b/drivers/net/ipa/ipa_table.c
@@ -118,14 +118,6 @@
 /* Check things that can be validated at build time. */
 static void ipa_table_validate_build(void)
 {
-	/* IPA hardware accesses memory 128 bytes at a time.  Addresses
-	 * referred to by entries in filter and route tables must be
-	 * aligned on 128-byte byte boundaries.  The only rule address
-	 * ever use is the "zero rule", and it's aligned at the base
-	 * of a coherent DMA allocation.
-	 */
-	BUILD_BUG_ON(ARCH_DMA_MINALIGN % IPA_TABLE_ALIGN);
-
 	/* Filter and route tables contain DMA addresses that refer
 	 * to filter or route rules.  But the size of a table entry
 	 * is 64 bits regardless of what the size of an AP DMA address
@@ -669,6 +661,18 @@ int ipa_table_init(struct ipa *ipa)
 	if (!virt)
 		return -ENOMEM;
 
+	/* We put the "zero rule" at the base of our table area.  The IPA
+	 * hardware requires rules to be aligned on a 128-byte boundary.
+	 * Make sure the allocation satisfies this constraint.
+	 */
+	if (addr % IPA_TABLE_ALIGN) {
+		dev_err(dev, "table address %pad not %u-byte aligned\n",
+			&addr, IPA_TABLE_ALIGN);
+		dma_free_coherent(dev, size, virt, addr);
+
+		return -ERANGE;
+	}
+
 	ipa->table_virt = virt;
 	ipa->table_addr = addr;
 
-- 
2.35.1



