Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 095D4BA758
	for <lists+stable@lfdr.de>; Sun, 22 Sep 2019 21:48:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2438647AbfIVS5q (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 22 Sep 2019 14:57:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:60366 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2438640AbfIVS5p (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 22 Sep 2019 14:57:45 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 385362190F;
        Sun, 22 Sep 2019 18:57:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1569178665;
        bh=q7MH5xjL57lYshgLlsRFQ3lgZeENdcd5LR0JjZVkFok=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RT/OkQwqF7zBATM9QlTz76CS1/EuLGz2tKqzcdYYIkzCI+cpVR8UssCCKOHxZsJa5
         uyG+ATCUywmiNMz45LXOaDv9hNQJXpks2g/DnkZp/hbmiYXbnzdvLW+66vBJHGEWhC
         qEV9cXafEJROr5c0gW1DUdKiytUwf/45iXZDa6As=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Robert Richter <rrichter@marvell.com>,
        Borislav Petkov <bp@suse.de>,
        "linux-edac@vger.kernel.org" <linux-edac@vger.kernel.org>,
        James Morse <james.morse@arm.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Tony Luck <tony.luck@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 4.14 17/89] EDAC/mc: Fix grain_bits calculation
Date:   Sun, 22 Sep 2019 14:56:05 -0400
Message-Id: <20190922185717.3412-17-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190922185717.3412-1-sashal@kernel.org>
References: <20190922185717.3412-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Robert Richter <rrichter@marvell.com>

[ Upstream commit 3724ace582d9f675134985727fd5e9811f23c059 ]

The grain in EDAC is defined as "minimum granularity for an error
report, in bytes". The following calculation of the grain_bits in
edac_mc is wrong:

	grain_bits = fls_long(e->grain) + 1;

Where grain_bits is defined as:

	grain = 1 << grain_bits

Example:

	grain = 8	# 64 bit (8 bytes)
	grain_bits = fls_long(8) + 1
	grain_bits = 4 + 1 = 5

	grain = 1 << grain_bits
	grain = 1 << 5 = 32

Replace it with the correct calculation:

	grain_bits = fls_long(e->grain - 1);

The example gives now:

	grain_bits = fls_long(8 - 1)
	grain_bits = fls_long(7)
	grain_bits = 3

	grain = 1 << 3 = 8

Also, check if the hardware reports a reasonable grain != 0 and fallback
with a warning to 1 byte granularity otherwise.

 [ bp: massage a bit. ]

Signed-off-by: Robert Richter <rrichter@marvell.com>
Signed-off-by: Borislav Petkov <bp@suse.de>
Cc: "linux-edac@vger.kernel.org" <linux-edac@vger.kernel.org>
Cc: James Morse <james.morse@arm.com>
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>
Cc: Tony Luck <tony.luck@intel.com>
Link: https://lkml.kernel.org/r/20190624150758.6695-2-rrichter@marvell.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/edac/edac_mc.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/edac/edac_mc.c b/drivers/edac/edac_mc.c
index 80801c616395e..f7fa05fee45a1 100644
--- a/drivers/edac/edac_mc.c
+++ b/drivers/edac/edac_mc.c
@@ -1240,9 +1240,13 @@ void edac_mc_handle_error(const enum hw_event_mc_err_type type,
 	if (p > e->location)
 		*(p - 1) = '\0';
 
-	/* Report the error via the trace interface */
-	grain_bits = fls_long(e->grain) + 1;
+	/* Sanity-check driver-supplied grain value. */
+	if (WARN_ON_ONCE(!e->grain))
+		e->grain = 1;
+
+	grain_bits = fls_long(e->grain - 1);
 
+	/* Report the error via the trace interface */
 	if (IS_ENABLED(CONFIG_RAS))
 		trace_mc_event(type, e->msg, e->label, e->error_count,
 			       mci->mc_idx, e->top_layer, e->mid_layer,
-- 
2.20.1

