Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0B56C47AE00
	for <lists+stable@lfdr.de>; Mon, 20 Dec 2021 15:59:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236725AbhLTO5W (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Dec 2021 09:57:22 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:33282 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239315AbhLTOzU (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Dec 2021 09:55:20 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D0830B80EDA;
        Mon, 20 Dec 2021 14:55:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 11F01C36AE7;
        Mon, 20 Dec 2021 14:55:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1640012117;
        bh=mFtx1yY1GC0GLadDMM2cOSSzicO64hCFCTdYcq7FnTI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SZqskFahzSU+AoqUjDC0q5N8OWzsdHVyNgs5TkV8/GXYzFZOqYlc+Htyk7Ds6bOKL
         Vsc73oTZgid1ZFk6Ks9csnldgNDg/g53TLRFL2xM6BBOEk6sPtnynohVTLxFLdDl+v
         bj2UsoEvJ5KKO0ScGMK3DUj2mZ9VfdJhAZLkzN0M=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Karol Kolacinski <karol.kolacinski@intel.com>,
        Gurucharan G <gurucharanx.g@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 086/177] ice: Use div64_u64 instead of div_u64 in adjfine
Date:   Mon, 20 Dec 2021 15:33:56 +0100
Message-Id: <20211220143042.999820465@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211220143040.058287525@linuxfoundation.org>
References: <20211220143040.058287525@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Karol Kolacinski <karol.kolacinski@intel.com>

[ Upstream commit 0013881c1145d36bf26165bb70fdd7560a5507a3 ]

Change the division in ice_ptp_adjfine from div_u64 to div64_u64.
div_u64 is used when the divisor is 32 bit but in this case incval is
64 bit and it caused incorrect calculations and incval adjustments.

Fixes: 06c16d89d2cb ("ice: register 1588 PTP clock device object for E810 devices")
Signed-off-by: Karol Kolacinski <karol.kolacinski@intel.com>
Tested-by: Gurucharan G <gurucharanx.g@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/intel/ice/ice_ptp.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_ptp.c b/drivers/net/ethernet/intel/ice/ice_ptp.c
index d1ef3d48a4b03..9df546984de25 100644
--- a/drivers/net/ethernet/intel/ice/ice_ptp.c
+++ b/drivers/net/ethernet/intel/ice/ice_ptp.c
@@ -459,7 +459,7 @@ static int ice_ptp_adjfine(struct ptp_clock_info *info, long scaled_ppm)
 		scaled_ppm = -scaled_ppm;
 	}
 
-	while ((u64)scaled_ppm > div_u64(U64_MAX, incval)) {
+	while ((u64)scaled_ppm > div64_u64(U64_MAX, incval)) {
 		/* handle overflow by scaling down the scaled_ppm and
 		 * the divisor, losing some precision
 		 */
-- 
2.33.0



