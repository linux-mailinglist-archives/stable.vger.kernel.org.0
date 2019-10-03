Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D68C4CAB0C
	for <lists+stable@lfdr.de>; Thu,  3 Oct 2019 19:27:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730592AbfJCR0K (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 3 Oct 2019 13:26:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:41352 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388969AbfJCQQZ (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 3 Oct 2019 12:16:25 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E423D20700;
        Thu,  3 Oct 2019 16:16:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1570119384;
        bh=REPlmJ3AG9u8ggMbAE/uWkhiDbswCFmGAr0G8TJ0BKE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Tgkw+Mjl2Z/PxXOCD1b2BUHiP//FQf+0EaS1C0SUQPXg+GvOtP4c2CwVMv5T4iusU
         DkRi00GC/P8gMNSX+sQsQe+S4R83YuG6SiIiS9Ormkq2FMhf7M0n+dpLi1ksG6IC1j
         S0hWnZKHZ00+i5AKbqG5PsPzpkwJWUO5ceKxzgMM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Robert Richter <rrichter@marvell.com>,
        Borislav Petkov <bp@suse.de>,
        "linux-edac@vger.kernel.org" <linux-edac@vger.kernel.org>,
        James Morse <james.morse@arm.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Tony Luck <tony.luck@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 046/211] EDAC/mc: Fix grain_bits calculation
Date:   Thu,  3 Oct 2019 17:51:52 +0200
Message-Id: <20191003154458.628881944@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191003154447.010950442@linuxfoundation.org>
References: <20191003154447.010950442@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
index 7d3edd7139328..f59511bd99261 100644
--- a/drivers/edac/edac_mc.c
+++ b/drivers/edac/edac_mc.c
@@ -1246,9 +1246,13 @@ void edac_mc_handle_error(const enum hw_event_mc_err_type type,
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



