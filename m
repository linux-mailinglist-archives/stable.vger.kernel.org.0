Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E2C02499B5B
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 23:00:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1575211AbiAXVvI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 16:51:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56214 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1458106AbiAXVmp (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 16:42:45 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D40E3C0612A9;
        Mon, 24 Jan 2022 12:30:27 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7207561531;
        Mon, 24 Jan 2022 20:30:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 52AE9C340E5;
        Mon, 24 Jan 2022 20:30:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643056226;
        bh=4kDAZJSYjqU7WDjd8+sdFj7h1cSKrs5tQjpUpiG2R98=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=eSPBnFK404nMnLQvpuCBKEdaOoIDEAgyMdYv+QD10lgWktZ2aSncNboU3EF4XMjBq
         bBWb/+Wq5vjv8CqQzmGLfwZXlz12zxBqw3bu0TYkbR6o1TAy5cav9J/i9WVeXEPw8V
         G337G1cm4yWe6wCFu7hCdEF7yKJ4QcCU/Hl+WADo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Frank Rowand <frank.rowand@sony.com>,
        Rob Herring <robh@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 414/846] of: unittest: 64 bit dma address test requires arch support
Date:   Mon, 24 Jan 2022 19:38:51 +0100
Message-Id: <20220124184115.252756385@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124184100.867127425@linuxfoundation.org>
References: <20220124184100.867127425@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Frank Rowand <frank.rowand@sony.com>

[ Upstream commit 9fd4cf5d3571b27d746b8ead494a3f051485b679 ]

If an architecture does not support 64 bit dma addresses then testing
for an expected dma address >= 0x100000000 will fail.

Fixes: e0d072782c73 ("dma-mapping: introduce DMA range map, supplanting dma_pfn_offset")
Signed-off-by: Frank Rowand <frank.rowand@sony.com>
Signed-off-by: Rob Herring <robh@kernel.org>
Link: https://lore.kernel.org/r/20211212221852.233295-1-frowand.list@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/of/unittest.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/of/unittest.c b/drivers/of/unittest.c
index 242381568f13c..2bee1d992408f 100644
--- a/drivers/of/unittest.c
+++ b/drivers/of/unittest.c
@@ -942,8 +942,9 @@ static void __init of_unittest_parse_dma_ranges(void)
 {
 	of_unittest_dma_ranges_one("/testcase-data/address-tests/device@70000000",
 		0x0, 0x20000000);
-	of_unittest_dma_ranges_one("/testcase-data/address-tests/bus@80000000/device@1000",
-		0x100000000, 0x20000000);
+	if (IS_ENABLED(CONFIG_ARCH_DMA_ADDR_T_64BIT))
+		of_unittest_dma_ranges_one("/testcase-data/address-tests/bus@80000000/device@1000",
+			0x100000000, 0x20000000);
 	of_unittest_dma_ranges_one("/testcase-data/address-tests/pci@90000000",
 		0x80000000, 0x20000000);
 }
-- 
2.34.1



