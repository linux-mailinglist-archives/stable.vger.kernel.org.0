Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 995FA47AF52
	for <lists+stable@lfdr.de>; Mon, 20 Dec 2021 16:11:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240148AbhLTPLG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Dec 2021 10:11:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38762 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240298AbhLTPJz (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Dec 2021 10:09:55 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 302C5C08EB19;
        Mon, 20 Dec 2021 06:55:49 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C4075611CE;
        Mon, 20 Dec 2021 14:55:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A9EFFC36AE9;
        Mon, 20 Dec 2021 14:55:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1640012148;
        bh=UAQmMQ4wVVPxIQk5xAmAZxowK6MH4lwD+rRjYygzOb0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ErVWmxKehLyV3FOqEBPAIjLc+iwwLvZauuzfnwntWpTUGOa3cQE4S/rJJwRS+SKsf
         DRG5YVDV7nf4WMTUqj754DdcNzXpoj3BuK6YmeV75QlSTkpERwTdRfiDqohqTCObdp
         K7mkwTUvuOyvAIRINWHbNINo2D0MZHW9DX2mSDF0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dima Ruinskiy <dima.ruinskiy@intel.com>,
        Sasha Neftin <sasha.neftin@intel.com>,
        Nechama Kraus <nechamax.kraus@linux.intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 096/177] igc: Fix typo in i225 LTR functions
Date:   Mon, 20 Dec 2021 15:34:06 +0100
Message-Id: <20211220143043.330386969@linuxfoundation.org>
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

From: Sasha Neftin <sasha.neftin@intel.com>

[ Upstream commit 0182d1f3fa640888a2ed7e3f6df2fdb10adee7c8 ]

The LTR maximum value was incorrectly written using the scale from
the LTR minimum value. This would cause incorrect values to be sent,
in cases where the initial calculation lead to different min/max scales.

Fixes: 707abf069548 ("igc: Add initial LTR support")
Suggested-by: Dima Ruinskiy <dima.ruinskiy@intel.com>
Signed-off-by: Sasha Neftin <sasha.neftin@intel.com>
Tested-by: Nechama Kraus <nechamax.kraus@linux.intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/intel/igc/igc_i225.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/intel/igc/igc_i225.c b/drivers/net/ethernet/intel/igc/igc_i225.c
index b2ef9fde97b38..b6807e16eea93 100644
--- a/drivers/net/ethernet/intel/igc/igc_i225.c
+++ b/drivers/net/ethernet/intel/igc/igc_i225.c
@@ -636,7 +636,7 @@ s32 igc_set_ltr_i225(struct igc_hw *hw, bool link)
 		ltrv = rd32(IGC_LTRMAXV);
 		if (ltr_max != (ltrv & IGC_LTRMAXV_LTRV_MASK)) {
 			ltrv = IGC_LTRMAXV_LSNP_REQ | ltr_max |
-			       (scale_min << IGC_LTRMAXV_SCALE_SHIFT);
+			       (scale_max << IGC_LTRMAXV_SCALE_SHIFT);
 			wr32(IGC_LTRMAXV, ltrv);
 		}
 	}
-- 
2.33.0



