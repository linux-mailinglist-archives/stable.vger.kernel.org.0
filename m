Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EEA262A38C9
	for <lists+stable@lfdr.de>; Tue,  3 Nov 2020 02:21:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727449AbgKCBVY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 2 Nov 2020 20:21:24 -0500
Received: from mail.kernel.org ([198.145.29.99]:36906 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727475AbgKCBVX (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 2 Nov 2020 20:21:23 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6897C2242E;
        Tue,  3 Nov 2020 01:21:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604366483;
        bh=GyEvx6frgt88vBR1k0fBG/S5MKjUpJDCfLHN1tv5K4E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=I+rUM4a51XbHdx4xCVL5G7BjN77N6FYmcX9sV4fu4+Zt7GBLaEqxMmyiUK6x344F1
         HyyTrLN11jGa97I4Hwd3GcUSzv8udz+OOSCbt2HEppZpvBt0Y9T0QZSl4O4SPvRGal
         9jxUPRHkHeWQbYYWg/sSRKyzY6N0wlG2OipqT0xc=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Vincent Whitchurch <vincent.whitchurch@axis.com>,
        Rob Herring <robh@kernel.org>, Sasha Levin <sashal@kernel.org>,
        devicetree@vger.kernel.org
Subject: [PATCH AUTOSEL 4.4 3/5] of: Fix reserved-memory overlap detection
Date:   Mon,  2 Nov 2020 20:21:16 -0500
Message-Id: <20201103012119.184049-3-sashal@kernel.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20201103012119.184049-1-sashal@kernel.org>
References: <20201103012119.184049-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Vincent Whitchurch <vincent.whitchurch@axis.com>

[ Upstream commit ca05f33316559a04867295dd49f85aeedbfd6bfd ]

The reserved-memory overlap detection code fails to detect overlaps if
either of the regions starts at address 0x0.  The code explicitly checks
for and ignores such regions, apparently in order to ignore dynamically
allocated regions which have an address of 0x0 at this point.  These
dynamically allocated regions also have a size of 0x0 at this point, so
fix this by removing the check and sorting the dynamically allocated
regions ahead of any static regions at address 0x0.

For example, there are two overlaps in this case but they are not
currently reported:

	foo@0 {
	        reg = <0x0 0x2000>;
	};

	bar@0 {
	        reg = <0x0 0x1000>;
	};

	baz@1000 {
	        reg = <0x1000 0x1000>;
	};

	quux {
	        size = <0x1000>;
	};

but they are after this patch:

 OF: reserved mem: OVERLAP DETECTED!
 bar@0 (0x00000000--0x00001000) overlaps with foo@0 (0x00000000--0x00002000)
 OF: reserved mem: OVERLAP DETECTED!
 foo@0 (0x00000000--0x00002000) overlaps with baz@1000 (0x00001000--0x00002000)

Signed-off-by: Vincent Whitchurch <vincent.whitchurch@axis.com>
Link: https://lore.kernel.org/r/ded6fd6b47b58741aabdcc6967f73eca6a3f311e.1603273666.git-series.vincent.whitchurch@axis.com
Signed-off-by: Rob Herring <robh@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/of/of_reserved_mem.c | 13 +++++++++++--
 1 file changed, 11 insertions(+), 2 deletions(-)

diff --git a/drivers/of/of_reserved_mem.c b/drivers/of/of_reserved_mem.c
index 07dd81586c52b..7ccf077c72a05 100644
--- a/drivers/of/of_reserved_mem.c
+++ b/drivers/of/of_reserved_mem.c
@@ -218,6 +218,16 @@ static int __init __rmem_cmp(const void *a, const void *b)
 	if (ra->base > rb->base)
 		return 1;
 
+	/*
+	 * Put the dynamic allocations (address == 0, size == 0) before static
+	 * allocations at address 0x0 so that overlap detection works
+	 * correctly.
+	 */
+	if (ra->size < rb->size)
+		return -1;
+	if (ra->size > rb->size)
+		return 1;
+
 	return 0;
 }
 
@@ -235,8 +245,7 @@ static void __init __rmem_check_for_overlap(void)
 
 		this = &reserved_mem[i];
 		next = &reserved_mem[i + 1];
-		if (!(this->base && next->base))
-			continue;
+
 		if (this->base + this->size > next->base) {
 			phys_addr_t this_end, next_end;
 
-- 
2.27.0

