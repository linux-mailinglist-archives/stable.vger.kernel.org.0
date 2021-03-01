Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DFC71328E28
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 20:26:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239015AbhCATYw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 14:24:52 -0500
Received: from mail.kernel.org ([198.145.29.99]:43886 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240315AbhCATSz (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 14:18:55 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id EF8F965061;
        Mon,  1 Mar 2021 17:23:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614619413;
        bh=AJ3uhTSzwnOtW4U7Q+pKwF4bb1pWRrBavSkm4MuTQRE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZnS5nvr65AKG9u7dx8H5CXSDtmi73Fvagcwphk/0M+zG8dcVrvl1SCF1Tl3f+6ueK
         KVuL0KP5zsLMFOQ2ZuOniLUTYInm6xH6tkSCmBT+uIuLKpzh1ly/1Z5cREia9aYBCz
         HQjFCeeygx/n5EPU20WQqUciQT+EAo/I8KnfFcz8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dave Ertman <david.m.ertman@intel.com>,
        Tony Brelinski <tonyx.brelinski@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 445/663] ice: report correct max number of TCs
Date:   Mon,  1 Mar 2021 17:11:33 +0100
Message-Id: <20210301161203.917958397@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210301161141.760350206@linuxfoundation.org>
References: <20210301161141.760350206@linuxfoundation.org>
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



