Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D352745C549
	for <lists+stable@lfdr.de>; Wed, 24 Nov 2021 14:53:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352352AbhKXN4H (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Nov 2021 08:56:07 -0500
Received: from mail.kernel.org ([198.145.29.99]:42980 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1354672AbhKXNwr (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 24 Nov 2021 08:52:47 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id F37E261212;
        Wed, 24 Nov 2021 13:04:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637759094;
        bh=TDwMex5wZFK+gxD0fGodl1GiCvpfRAx0KSzSOeds54U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Yo0zXxOsdAF/kGFTLNUXjJPgQz1GmdNQZDc8DU+0xQogN4R/Tfuo35T/A4TDDL8c8
         eMmFGQ9ij1N7rUEiX9c4SE93kVvfhLKniHBRmRBMl6kzr4E/DfWQR7u5L9kWkpTylO
         XsqzQDIMkr7IX4L6FlWjLWD7DktLJ+EsIpHoQgmc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Grzegorz Szczurek <grzegorzx.szczurek@intel.com>,
        Tony Brelinski <tony.brelinski@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 131/279] iavf: Fix for setting queues to 0
Date:   Wed, 24 Nov 2021 12:56:58 +0100
Message-Id: <20211124115723.327766871@linuxfoundation.org>
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

From: Grzegorz Szczurek <grzegorzx.szczurek@intel.com>

[ Upstream commit 9a6e9e483a9684a34573fd9f9e30ecfb047cb8cb ]

Now setting combine to 0 will be rejected with the
appropriate error code.
This has been implemented by adding a condition that checks
the value of combine equal to zero.
Without this patch, when the user requested it, no error was
returned and combine was set to the default value for VF.

Fixes: 5520deb15326 ("iavf: Enable support for up to 16 queues")
Signed-off-by: Grzegorz Szczurek <grzegorzx.szczurek@intel.com>
Tested-by: Tony Brelinski <tony.brelinski@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/intel/iavf/iavf_ethtool.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/intel/iavf/iavf_ethtool.c b/drivers/net/ethernet/intel/iavf/iavf_ethtool.c
index 25ee0606e625f..144a776793597 100644
--- a/drivers/net/ethernet/intel/iavf/iavf_ethtool.c
+++ b/drivers/net/ethernet/intel/iavf/iavf_ethtool.c
@@ -1787,7 +1787,7 @@ static int iavf_set_channels(struct net_device *netdev,
 	/* All of these should have already been checked by ethtool before this
 	 * even gets to us, but just to be sure.
 	 */
-	if (num_req > adapter->vsi_res->num_queue_pairs)
+	if (num_req == 0 || num_req > adapter->vsi_res->num_queue_pairs)
 		return -EINVAL;
 
 	if (num_req == adapter->num_active_queues)
-- 
2.33.0



