Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4587E329107
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 21:22:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243161AbhCAUSg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 15:18:36 -0500
Received: from mail.kernel.org ([198.145.29.99]:37634 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239919AbhCAUHY (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 15:07:24 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 44DC9653AA;
        Mon,  1 Mar 2021 17:59:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614621567;
        bh=AJ3uhTSzwnOtW4U7Q+pKwF4bb1pWRrBavSkm4MuTQRE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=EWSshaNTAQZvOR+bvIgFSoa73DzY+CT7QSYdoU8P+ElMmh/+A3AtKoCdN5UR2rRnq
         syd5VShM4KfJqqdsN1hlB/95PtMhXuVAhBDzxew4l3YDOkAU+oPpsOL5t/RElsfaJ8
         LqduBRNPW8UilxWcr+n4kDrDpcm8DrXqqciYfPzE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dave Ertman <david.m.ertman@intel.com>,
        Tony Brelinski <tonyx.brelinski@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.11 534/775] ice: report correct max number of TCs
Date:   Mon,  1 Mar 2021 17:11:42 +0100
Message-Id: <20210301161227.880391504@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210301161201.679371205@linuxfoundation.org>
References: <20210301161201.679371205@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dave Ertman <david.m.ertman@intel.com>

[ Upstream commit 7dcf7aa01c7b9f18727cbe0f9cb4136f1c6cdcc2 ]

In the driver currently, we are reporting max number of TCs
to the DCBNL callback as a kernel define set to 8.  This is
preventing userspace applications performing DCBx to correctly
down map the TCs from requested to actual values.

Report the actual max TC value to userspace from the capability
struct.

Fixes: b94b013eb626 ("ice: Implement DCBNL support")
Signed-off-by: Dave Ertman <david.m.ertman@intel.com>
Tested-by: Tony Brelinski <tonyx.brelinski@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/intel/ice/ice_dcb_nl.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_dcb_nl.c b/drivers/net/ethernet/intel/ice/ice_dcb_nl.c
index 87f91b750d59a..842d44b63480f 100644
--- a/drivers/net/ethernet/intel/ice/ice_dcb_nl.c
+++ b/drivers/net/ethernet/intel/ice/ice_dcb_nl.c
@@ -136,7 +136,7 @@ ice_dcbnl_getnumtcs(struct net_device *dev, int __always_unused tcid, u8 *num)
 	if (!test_bit(ICE_FLAG_DCB_CAPABLE, pf->flags))
 		return -EINVAL;
 
-	*num = IEEE_8021QAZ_MAX_TCS;
+	*num = pf->hw.func_caps.common_cap.maxtc;
 	return 0;
 }
 
-- 
2.27.0



