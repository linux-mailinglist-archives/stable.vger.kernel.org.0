Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 677305EA26F
	for <lists+stable@lfdr.de>; Mon, 26 Sep 2022 13:07:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237057AbiIZLHr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Sep 2022 07:07:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49942 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237084AbiIZLGm (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 26 Sep 2022 07:06:42 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C7CB53DF3D;
        Mon, 26 Sep 2022 03:34:12 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E81CB60C8E;
        Mon, 26 Sep 2022 10:32:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C45D4C433D6;
        Mon, 26 Sep 2022 10:32:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1664188361;
        bh=GJr2FcRWAMmIT+2OsSwsvU31ZvlaFNQNJB2v1KZj1EU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=R6mWPYg1Yzcq66i53r4lluogX2TDrtaJdabaijG4+Ccdb2T34HNEghE+tCHg0NZ+o
         ILXz06asnQXMp3b8HRiTZYUoEp98+8ZlbFkMhZfrTONkP1PB37EljEXRyAXTFoTl/9
         OIRgnLgX0tv1VwnPaZVefMBV0DnmAP7XvE6um2Mc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Alex Elder <elder@linaro.org>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 093/141] net: ipa: fix assumptions about DMA address size
Date:   Mon, 26 Sep 2022 12:11:59 +0200
Message-Id: <20220926100757.799468089@linuxfoundation.org>
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

[ Upstream commit d2fd2311de909a7f4e99b4bd11a19e6b671d6a6b ]

Some build time checks in ipa_table_validate_build() assume that a
DMA address is 64 bits wide.  That is more restrictive than it has
to be.  A route or filter table is 64 bits wide no matter what the
size of a DMA address is on the AP.  The code actually uses a
pointer to __le64 to access table entries, and a fixed constant
IPA_TABLE_ENTRY_SIZE to describe the size of those entries.

Loosen up two checks so they still verify some requirements, but
such that they do not assume the size of a DMA address is 64 bits.

Signed-off-by: Alex Elder <elder@linaro.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
Stable-dep-of: cf412ec33325 ("net: ipa: properly limit modem routing table use")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ipa/ipa_table.c | 14 ++++++++------
 1 file changed, 8 insertions(+), 6 deletions(-)

diff --git a/drivers/net/ipa/ipa_table.c b/drivers/net/ipa/ipa_table.c
index 0747866d60ab..f26cb9d706da 100644
--- a/drivers/net/ipa/ipa_table.c
+++ b/drivers/net/ipa/ipa_table.c
@@ -126,13 +126,15 @@ static void ipa_table_validate_build(void)
 	 */
 	BUILD_BUG_ON(ARCH_DMA_MINALIGN % IPA_TABLE_ALIGN);
 
-	/* Filter and route tables contain DMA addresses that refer to
-	 * filter or route rules.  We use a fixed constant to represent
-	 * the size of either type of table entry.  Code in ipa_table_init()
-	 * uses a pointer to __le64 to initialize table entriews.
+	/* Filter and route tables contain DMA addresses that refer
+	 * to filter or route rules.  But the size of a table entry
+	 * is 64 bits regardless of what the size of an AP DMA address
+	 * is.  A fixed constant defines the size of an entry, and
+	 * code in ipa_table_init() uses a pointer to __le64 to
+	 * initialize tables.
 	 */
-	BUILD_BUG_ON(IPA_TABLE_ENTRY_SIZE != sizeof(dma_addr_t));
-	BUILD_BUG_ON(sizeof(dma_addr_t) != sizeof(__le64));
+	BUILD_BUG_ON(sizeof(dma_addr_t) > IPA_TABLE_ENTRY_SIZE);
+	BUILD_BUG_ON(sizeof(__le64) != IPA_TABLE_ENTRY_SIZE);
 
 	/* A "zero rule" is used to represent no filtering or no routing.
 	 * It is a 64-bit block of zeroed memory.  Code in ipa_table_init()
-- 
2.35.1



