Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7B75B3FD9BB
	for <lists+stable@lfdr.de>; Wed,  1 Sep 2021 14:28:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244289AbhIAM2s (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 1 Sep 2021 08:28:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:58226 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S244305AbhIAM2g (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 1 Sep 2021 08:28:36 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C173760BD3;
        Wed,  1 Sep 2021 12:27:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1630499259;
        bh=e5xMRHoqMDnQd6QeMakavPzBZ/MUyJnEMCGXlbEXznk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LQUHGei8rReMPHTwqTwyv9cFSotd484OjCb8JJCWrQc6VRa20CFFvBQx6Bl6lE+IC
         3SmgvBnwy0rYNMGasin4KKmEPOI+asyVhuUvfhbTbSwCGfPzoDY9FWPn3EbPjXUO4E
         Za7MVCnv2s0D+Iyn8lQGorvnw2smUDpOEcS9tLIM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Yee Li <seven.yi.lee@gmail.com>,
        Sasha Neftin <sasha.neftin@intel.com>,
        Dvora Fuxbrumer <dvorax.fuxbrumer@linux.intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 07/16] e1000e: Fix the max snoop/no-snoop latency for 10M
Date:   Wed,  1 Sep 2021 14:26:33 +0200
Message-Id: <20210901122249.145763633@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210901122248.920548099@linuxfoundation.org>
References: <20210901122248.920548099@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sasha Neftin <sasha.neftin@intel.com>

[ Upstream commit 44a13a5d99c71bf9e1676d9e51679daf4d7b3d73 ]

We should decode the latency and the max_latency before directly compare.
The latency should be presented as lat_enc = scale x value:
lat_enc_d = (lat_enc & 0x0x3ff) x (1U << (5*((max_ltr_enc & 0x1c00)
>> 10)))

Fixes: cf8fb73c23aa ("e1000e: add support for LTR on I217/I218")
Suggested-by: Yee Li <seven.yi.lee@gmail.com>
Signed-off-by: Sasha Neftin <sasha.neftin@intel.com>
Tested-by: Dvora Fuxbrumer <dvorax.fuxbrumer@linux.intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/intel/e1000e/ich8lan.c | 14 +++++++++++++-
 drivers/net/ethernet/intel/e1000e/ich8lan.h |  3 +++
 2 files changed, 16 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/intel/e1000e/ich8lan.c b/drivers/net/ethernet/intel/e1000e/ich8lan.c
index 625008e8cb0d..500016209ae0 100644
--- a/drivers/net/ethernet/intel/e1000e/ich8lan.c
+++ b/drivers/net/ethernet/intel/e1000e/ich8lan.c
@@ -1010,6 +1010,8 @@ static s32 e1000_platform_pm_pch_lpt(struct e1000_hw *hw, bool link)
 {
 	u32 reg = link << (E1000_LTRV_REQ_SHIFT + E1000_LTRV_NOSNOOP_SHIFT) |
 	    link << E1000_LTRV_REQ_SHIFT | E1000_LTRV_SEND;
+	u16 max_ltr_enc_d = 0;	/* maximum LTR decoded by platform */
+	u16 lat_enc_d = 0;	/* latency decoded */
 	u16 lat_enc = 0;	/* latency encoded */
 
 	if (link) {
@@ -1063,7 +1065,17 @@ static s32 e1000_platform_pm_pch_lpt(struct e1000_hw *hw, bool link)
 				     E1000_PCI_LTR_CAP_LPT + 2, &max_nosnoop);
 		max_ltr_enc = max_t(u16, max_snoop, max_nosnoop);
 
-		if (lat_enc > max_ltr_enc)
+		lat_enc_d = (lat_enc & E1000_LTRV_VALUE_MASK) *
+			     (1U << (E1000_LTRV_SCALE_FACTOR *
+			     ((lat_enc & E1000_LTRV_SCALE_MASK)
+			     >> E1000_LTRV_SCALE_SHIFT)));
+
+		max_ltr_enc_d = (max_ltr_enc & E1000_LTRV_VALUE_MASK) *
+				 (1U << (E1000_LTRV_SCALE_FACTOR *
+				 ((max_ltr_enc & E1000_LTRV_SCALE_MASK)
+				 >> E1000_LTRV_SCALE_SHIFT)));
+
+		if (lat_enc_d > max_ltr_enc_d)
 			lat_enc = max_ltr_enc;
 	}
 
diff --git a/drivers/net/ethernet/intel/e1000e/ich8lan.h b/drivers/net/ethernet/intel/e1000e/ich8lan.h
index 6374c8fc76a8..9957a4ffdc6d 100644
--- a/drivers/net/ethernet/intel/e1000e/ich8lan.h
+++ b/drivers/net/ethernet/intel/e1000e/ich8lan.h
@@ -291,8 +291,11 @@
 
 /* Latency Tolerance Reporting */
 #define E1000_LTRV			0x000F8
+#define E1000_LTRV_VALUE_MASK		0x000003FF
 #define E1000_LTRV_SCALE_MAX		5
 #define E1000_LTRV_SCALE_FACTOR		5
+#define E1000_LTRV_SCALE_SHIFT		10
+#define E1000_LTRV_SCALE_MASK		0x00001C00
 #define E1000_LTRV_REQ_SHIFT		15
 #define E1000_LTRV_NOSNOOP_SHIFT	16
 #define E1000_LTRV_SEND			(1 << 30)
-- 
2.30.2



