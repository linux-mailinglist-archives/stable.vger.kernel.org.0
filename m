Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2C46F45C55D
	for <lists+stable@lfdr.de>; Wed, 24 Nov 2021 14:53:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352767AbhKXN5A (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Nov 2021 08:57:00 -0500
Received: from mail.kernel.org ([198.145.29.99]:44668 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1352479AbhKXNy6 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 24 Nov 2021 08:54:58 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 05B5D61A62;
        Wed, 24 Nov 2021 13:06:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637759181;
        bh=vFzyewjNr6FccMBf9WCAz3GHrxtCstL+Vni8xfYwaZI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nxblS6teuls1wH9a5qSd9+6/5a19Zs9Yc5AwZu2Dn8ThqtiBjQ2+g2PVoYSa2xJEr
         39G85F+fhuayjRH8BRn3chMhtvVeScM4y3ejy+fKI1NkoRmXtsOF3BPghY65+3Pem/
         RCpxIzjtU2Au8Y7HygbydAXLVNtB2p0UH6xYaMaE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Nicholas Nunley <nicholas.d.nunley@intel.com>,
        Tony Brelinski <tony.brelinski@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 126/279] iavf: dont clear a lock we dont hold
Date:   Wed, 24 Nov 2021 12:56:53 +0100
Message-Id: <20211124115723.158247067@linuxfoundation.org>
X-Mailer: git-send-email 2.34.0
In-Reply-To: <20211124115718.776172708@linuxfoundation.org>
References: <20211124115718.776172708@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Nicholas Nunley <nicholas.d.nunley@intel.com>

[ Upstream commit 2135a8d5c8186bc92901dc00f179ffd50e54c2ac ]

In iavf_configure_clsflower() the function will bail out if it is unable
to obtain the crit_section lock in a reasonable time. However, it will
clear the lock when exiting, so fix this.

Fixes: 640a8af5841f ("i40evf: Reorder configure_clsflower to avoid deadlock on error")
Signed-off-by: Nicholas Nunley <nicholas.d.nunley@intel.com>
Tested-by: Tony Brelinski <tony.brelinski@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/intel/iavf/iavf_main.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/intel/iavf/iavf_main.c b/drivers/net/ethernet/intel/iavf/iavf_main.c
index 5664a1905e8bb..f64ccf6286ec1 100644
--- a/drivers/net/ethernet/intel/iavf/iavf_main.c
+++ b/drivers/net/ethernet/intel/iavf/iavf_main.c
@@ -3041,8 +3041,10 @@ static int iavf_configure_clsflower(struct iavf_adapter *adapter,
 		return -ENOMEM;
 
 	while (!mutex_trylock(&adapter->crit_lock)) {
-		if (--count == 0)
-			goto err;
+		if (--count == 0) {
+			kfree(filter);
+			return err;
+		}
 		udelay(1);
 	}
 
-- 
2.33.0



