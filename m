Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C91CC47AE61
	for <lists+stable@lfdr.de>; Mon, 20 Dec 2021 16:01:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239239AbhLTPA7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Dec 2021 10:00:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35408 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239287AbhLTO6c (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Dec 2021 09:58:32 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 85259C06139E;
        Mon, 20 Dec 2021 06:50:19 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 4FAD6B80EE5;
        Mon, 20 Dec 2021 14:50:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 963B0C36AE9;
        Mon, 20 Dec 2021 14:50:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1640011817;
        bh=KFT5JbsXW++rLHnX/dyQkshSoS748ONSTZZuJsD4OGo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YqAjHZdJ6XCgFAHjWD+25rJ86Br1jcBL5rGOMKFLPN2190p+TKbZgkfei7VlD+hXS
         rzo/Y6hXM4pasIqXKXBohQ7IFND3tgRykhYVz2GJotwR3s79mDKBqTR1knsBrkpuWG
         IN8KR0GNppFqlmzQujZmJSPG1swJ/7F4VO2ndfE8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dima Ruinskiy <dima.ruinskiy@intel.com>,
        Sasha Neftin <sasha.neftin@intel.com>,
        Nechama Kraus <nechamax.kraus@linux.intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 52/99] igc: Fix typo in i225 LTR functions
Date:   Mon, 20 Dec 2021 15:34:25 +0100
Message-Id: <20211220143031.136223009@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211220143029.352940568@linuxfoundation.org>
References: <20211220143029.352940568@linuxfoundation.org>
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
index 7ec04e48860c6..553d6bc78e6bd 100644
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



