Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 760363ED58C
	for <lists+stable@lfdr.de>; Mon, 16 Aug 2021 15:12:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239283AbhHPNMN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Aug 2021 09:12:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:58216 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237295AbhHPNI2 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 16 Aug 2021 09:08:28 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7D00663290;
        Mon, 16 Aug 2021 13:07:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1629119230;
        bh=BYRSpgfnOu8/JiJhaUavVAeXs0htb0UfefHG91Sgyf8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=z6CVDZX2cNub/f6ILlH0DYbIdypAdCEW8N1806lLTzuDnaeLvOHizS47GUO/A1OAA
         btqIp7b27Kp7zLX7vNyGlL98FYoOFpBT6hktPE+jqGZrMyxj1YEQpmXLWJU8PRzFs1
         MUgrni9IwCtOVVTVvPk+vGCNFTnbkW4MMZjE+BhI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Anirudh Venkataramanan <anirudh.venkataramanan@intel.com>,
        Gurucharan G <gurucharanx.g@intel.com>,
        Konrad Jankowski <konrad0.jankowski@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 43/96] ice: Prevent probing virtual functions
Date:   Mon, 16 Aug 2021 15:01:53 +0200
Message-Id: <20210816125436.391477631@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210816125434.948010115@linuxfoundation.org>
References: <20210816125434.948010115@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Anirudh Venkataramanan <anirudh.venkataramanan@intel.com>

[ Upstream commit 50ac7479846053ca8054be833c1594e64de496bb ]

The userspace utility "driverctl" can be used to change/override the
system's default driver choices. This is useful in some situations
(buggy driver, old driver missing a device ID, trying a workaround,
etc.) where the user needs to load a different driver.

However, this is also prone to user error, where a driver is mapped
to a device it's not designed to drive. For example, if the ice driver
is mapped to driver iavf devices, the ice driver crashes.

Add a check to return an error if the ice driver is being used to
probe a virtual function.

Fixes: 837f08fdecbe ("ice: Add basic driver framework for Intel(R) E800 Series")
Signed-off-by: Anirudh Venkataramanan <anirudh.venkataramanan@intel.com>
Tested-by: Gurucharan G <gurucharanx.g@intel.com>
Tested-by: Konrad Jankowski <konrad0.jankowski@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/intel/ice/ice_main.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/net/ethernet/intel/ice/ice_main.c b/drivers/net/ethernet/intel/ice/ice_main.c
index 1567ddd4c5b8..6421e9fd69a2 100644
--- a/drivers/net/ethernet/intel/ice/ice_main.c
+++ b/drivers/net/ethernet/intel/ice/ice_main.c
@@ -3991,6 +3991,11 @@ ice_probe(struct pci_dev *pdev, const struct pci_device_id __always_unused *ent)
 	struct ice_hw *hw;
 	int i, err;
 
+	if (pdev->is_virtfn) {
+		dev_err(dev, "can't probe a virtual function\n");
+		return -EINVAL;
+	}
+
 	/* this driver uses devres, see
 	 * Documentation/driver-api/driver-model/devres.rst
 	 */
-- 
2.30.2



