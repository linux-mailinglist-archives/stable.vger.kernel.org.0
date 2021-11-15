Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1E50B452677
	for <lists+stable@lfdr.de>; Tue, 16 Nov 2021 03:02:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351133AbhKPCFo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 21:05:44 -0500
Received: from mail.kernel.org ([198.145.29.99]:46092 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239583AbhKOSDU (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 13:03:20 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id B1C9B6334C;
        Mon, 15 Nov 2021 17:37:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1636997871;
        bh=aZ4kYDgbwLpwX1LShksEquspdKDSWFtvC9isdHfZAfI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=A3ntd4iAcI1J3ee9Ut+9OPvPPBY+asf0nektiYdb3WunjX+WG9a/NQ1uhHQBK5NTN
         ffg/ALj06HJDdwMP5SeDJdZiJKNXTyb0YbQilZG8AzU5xd8lcihesZ6dM/ADO6qn+B
         Mh5wHg7woDlYfpFhmxuOu/FvtsqzcHjCF1PQk7/4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Yazen Ghannam <yazen.ghannam@amd.com>,
        Borislav Petkov <bp@suse.de>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 305/575] EDAC/amd64: Handle three rank interleaving mode
Date:   Mon, 15 Nov 2021 18:00:30 +0100
Message-Id: <20211115165354.333125243@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211115165343.579890274@linuxfoundation.org>
References: <20211115165343.579890274@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Yazen Ghannam <yazen.ghannam@amd.com>

[ Upstream commit 9f4873fb6af7966de8fcbd95c36b61351c1c4b1f ]

AMD Rome systems and later support interleaving between three identical
ranks within a channel.

Check for this mode by counting the number of enabled chip selects and
comparing their masks. If there are exactly three enabled chip selects
and their masks are identical, then three rank interleaving is enabled.

The size of a rank is determined from its mask value. However, three
rank interleaving doesn't follow the method of swapping an interleave
bit with the most significant bit. Rather, the interleave bit is flipped
and the most significant bit remains the same. There is only a single
interleave bit in this case.

Account for this when determining the chip select size by keeping the
most significant bit at its original value and ignoring any zero bits.
This will return a full bitmask in [MSB:1].

Fixes: e53a3b267fb0 ("EDAC/amd64: Find Chip Select memory size using Address Mask")
Signed-off-by: Yazen Ghannam <yazen.ghannam@amd.com>
Signed-off-by: Borislav Petkov <bp@suse.de>
Link: https://lkml.kernel.org/r/20211005154419.2060504-1-yazen.ghannam@amd.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/edac/amd64_edac.c | 22 +++++++++++++++++++++-
 1 file changed, 21 insertions(+), 1 deletion(-)

diff --git a/drivers/edac/amd64_edac.c b/drivers/edac/amd64_edac.c
index b36d5879b91e0..f5635dfa9acf6 100644
--- a/drivers/edac/amd64_edac.c
+++ b/drivers/edac/amd64_edac.c
@@ -786,12 +786,14 @@ static void debug_dump_dramcfg_low(struct amd64_pvt *pvt, u32 dclr, int chan)
 #define CS_ODD_PRIMARY		BIT(1)
 #define CS_EVEN_SECONDARY	BIT(2)
 #define CS_ODD_SECONDARY	BIT(3)
+#define CS_3R_INTERLEAVE	BIT(4)
 
 #define CS_EVEN			(CS_EVEN_PRIMARY | CS_EVEN_SECONDARY)
 #define CS_ODD			(CS_ODD_PRIMARY | CS_ODD_SECONDARY)
 
 static int f17_get_cs_mode(int dimm, u8 ctrl, struct amd64_pvt *pvt)
 {
+	u8 base, count = 0;
 	int cs_mode = 0;
 
 	if (csrow_enabled(2 * dimm, ctrl, pvt))
@@ -804,6 +806,20 @@ static int f17_get_cs_mode(int dimm, u8 ctrl, struct amd64_pvt *pvt)
 	if (csrow_sec_enabled(2 * dimm + 1, ctrl, pvt))
 		cs_mode |= CS_ODD_SECONDARY;
 
+	/*
+	 * 3 Rank inteleaving support.
+	 * There should be only three bases enabled and their two masks should
+	 * be equal.
+	 */
+	for_each_chip_select(base, ctrl, pvt)
+		count += csrow_enabled(base, ctrl, pvt);
+
+	if (count == 3 &&
+	    pvt->csels[ctrl].csmasks[0] == pvt->csels[ctrl].csmasks[1]) {
+		edac_dbg(1, "3R interleaving in use.\n");
+		cs_mode |= CS_3R_INTERLEAVE;
+	}
+
 	return cs_mode;
 }
 
@@ -1612,10 +1628,14 @@ static int f17_addr_mask_to_cs_size(struct amd64_pvt *pvt, u8 umc,
 	 *
 	 * The MSB is the number of bits in the full mask because BIT[0] is
 	 * always 0.
+	 *
+	 * In the special 3 Rank interleaving case, a single bit is flipped
+	 * without swapping with the most significant bit. This can be handled
+	 * by keeping the MSB where it is and ignoring the single zero bit.
 	 */
 	msb = fls(addr_mask_orig) - 1;
 	weight = hweight_long(addr_mask_orig);
-	num_zero_bits = msb - weight;
+	num_zero_bits = msb - weight - !!(cs_mode & CS_3R_INTERLEAVE);
 
 	/* Take the number of zero bits off from the top of the mask. */
 	addr_mask_deinterleaved = GENMASK_ULL(msb - num_zero_bits, 1);
-- 
2.33.0



