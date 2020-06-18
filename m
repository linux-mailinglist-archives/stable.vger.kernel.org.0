Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EC1711FE690
	for <lists+stable@lfdr.de>; Thu, 18 Jun 2020 04:34:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728746AbgFRBO1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 17 Jun 2020 21:14:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:44080 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728233AbgFRBOZ (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 17 Jun 2020 21:14:25 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 501B9221EE;
        Thu, 18 Jun 2020 01:14:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592442864;
        bh=rbuICGyWG8fCTI3u8+UUBOuYEADzK0pn45InuIr1ir0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=C7j2BEup8WL3U981bpi3+nzNQBm1AKC1z0+8N/T1qr0mH9DZJsAAJwQVxhaFjrqJs
         A2WnoH4/HZ4ATXfsSbK0lx6X9AdznwCpVhS3LKwHP0MGSvWWu08WUaLlb+oQj/6of7
         WGXsLiqAMebUXyrqWecZVEax0PcbRYP87DfQTlbw=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     John Hubbard <jhubbard@nvidia.com>,
        Derek Kiernan <derek.kiernan@xilinx.com>,
        Dragan Cvetic <dragan.cvetic@xilinx.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Michal Simek <michal.simek@xilinx.com>,
        linux-arm-kernel@lists.infradead.org,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 5.7 292/388] misc: xilinx-sdfec: improve get_user_pages_fast() error handling
Date:   Wed, 17 Jun 2020 21:06:29 -0400
Message-Id: <20200618010805.600873-292-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200618010805.600873-1-sashal@kernel.org>
References: <20200618010805.600873-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: John Hubbard <jhubbard@nvidia.com>

[ Upstream commit 57343d51613227373759f5b0f2eede257fd4b82e ]

This fixes the case of get_user_pages_fast() returning a -errno.
The result needs to be stored in a signed integer. And for safe
signed/unsigned comparisons, it's best to keep everything signed.
And get_user_pages_fast() also expects a signed value for number
of pages to pin.

Therefore, change most relevant variables, from u32 to int. Leave
"n" unsigned, for convenience in checking for overflow. And provide
a WARN_ON_ONCE() and early return, if overflow occurs.

Also, as long as we're tidying up: rename the page array from page,
to pages, in order to match the conventions used in most other call
sites.

Fixes: 20ec628e8007e ("misc: xilinx_sdfec: Add ability to configure LDPC")
Cc: Derek Kiernan <derek.kiernan@xilinx.com>
Cc: Dragan Cvetic <dragan.cvetic@xilinx.com>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Michal Simek <michal.simek@xilinx.com>
Cc: linux-arm-kernel@lists.infradead.org
Signed-off-by: John Hubbard <jhubbard@nvidia.com>
Link: https://lore.kernel.org/r/20200527012628.1100649-2-jhubbard@nvidia.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/misc/xilinx_sdfec.c | 27 +++++++++++++++++----------
 1 file changed, 17 insertions(+), 10 deletions(-)

diff --git a/drivers/misc/xilinx_sdfec.c b/drivers/misc/xilinx_sdfec.c
index 71bbaa56bdb5..e2766aad9e14 100644
--- a/drivers/misc/xilinx_sdfec.c
+++ b/drivers/misc/xilinx_sdfec.c
@@ -602,10 +602,10 @@ static int xsdfec_table_write(struct xsdfec_dev *xsdfec, u32 offset,
 			      const u32 depth)
 {
 	u32 reg = 0;
-	u32 res;
-	u32 n, i;
+	int res, i, nr_pages;
+	u32 n;
 	u32 *addr = NULL;
-	struct page *page[MAX_NUM_PAGES];
+	struct page *pages[MAX_NUM_PAGES];
 
 	/*
 	 * Writes that go beyond the length of
@@ -622,15 +622,22 @@ static int xsdfec_table_write(struct xsdfec_dev *xsdfec, u32 offset,
 	if ((len * XSDFEC_REG_WIDTH_JUMP) % PAGE_SIZE)
 		n += 1;
 
-	res = get_user_pages_fast((unsigned long)src_ptr, n, 0, page);
-	if (res < n) {
-		for (i = 0; i < res; i++)
-			put_page(page[i]);
+	if (WARN_ON_ONCE(n > INT_MAX))
+		return -EINVAL;
+
+	nr_pages = n;
+
+	res = get_user_pages_fast((unsigned long)src_ptr, nr_pages, 0, pages);
+	if (res < nr_pages) {
+		if (res > 0) {
+			for (i = 0; i < res; i++)
+				put_page(pages[i]);
+		}
 		return -EINVAL;
 	}
 
-	for (i = 0; i < n; i++) {
-		addr = kmap(page[i]);
+	for (i = 0; i < nr_pages; i++) {
+		addr = kmap(pages[i]);
 		do {
 			xsdfec_regwrite(xsdfec,
 					base_addr + ((offset + reg) *
@@ -639,7 +646,7 @@ static int xsdfec_table_write(struct xsdfec_dev *xsdfec, u32 offset,
 			reg++;
 		} while ((reg < len) &&
 			 ((reg * XSDFEC_REG_WIDTH_JUMP) % PAGE_SIZE));
-		put_page(page[i]);
+		put_page(pages[i]);
 	}
 	return reg;
 }
-- 
2.25.1

