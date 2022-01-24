Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DECE4499532
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 22:09:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1392413AbiAXUvK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 15:51:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41682 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1390172AbiAXUpD (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 15:45:03 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 159FEC0617BD;
        Mon, 24 Jan 2022 11:54:42 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id AAC876090A;
        Mon, 24 Jan 2022 19:54:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7F42BC340E5;
        Mon, 24 Jan 2022 19:54:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643054081;
        bh=Kdgl4eAeB8QZQJOvxda19BG6ULeDMmWdoInfnJAQYOg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=T5DSkxv14Dv/vA6fKbRnHS8g8fsNiYVQL05IAbrSSa+vdSK6wm/Jtr/2J07FO2zjo
         N2kJtpbtIBTKrB2AzKfwMz9Mss23SRXt6i7FmJG7haWma/lhRprF+4Xj6rYKQmQasr
         +Klvnf+fHpUZYbFraVqvlsCpSAE0ZSTGvf7VX+NU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Frank Rowand <frank.rowand@sony.com>,
        Rob Herring <robh@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 272/563] of: unittest: 64 bit dma address test requires arch support
Date:   Mon, 24 Jan 2022 19:40:37 +0100
Message-Id: <20220124184033.844760247@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124184024.407936072@linuxfoundation.org>
References: <20220124184024.407936072@linuxfoundation.org>
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
index a5c4c77b6f3e2..5407bbdb64395 100644
--- a/drivers/of/unittest.c
+++ b/drivers/of/unittest.c
@@ -941,8 +941,9 @@ static void __init of_unittest_parse_dma_ranges(void)
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



