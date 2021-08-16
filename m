Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 184403ED614
	for <lists+stable@lfdr.de>; Mon, 16 Aug 2021 15:17:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240068AbhHPNQq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Aug 2021 09:16:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:37396 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236644AbhHPNPM (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 16 Aug 2021 09:15:12 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1E5D760F46;
        Mon, 16 Aug 2021 13:12:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1629119554;
        bh=qiBDBaBjsVymJ+wxhbdGIuxoNdMRU1ON8G+24y8kUNs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=2ahK3i5U/MVvnhJEA4jdwd8o9ROvotB3/I4zndYV+W2QgWI+CA4mLx8PPJ8BZ2MDa
         +KFtzTcMBuwSCGD9RPclD9Kif9ARVeCX9e97JXg4Zq5GhTrgXAzkQJckvqmmc4pTqt
         1APNj8vLdMvfkMS2Xk1X+DrZvZPpg+tZf6FmcGak=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Anirudh Venkataramanan <anirudh.venkataramanan@intel.com>,
        Gurucharan G <gurucharanx.g@intel.com>,
        Konrad Jankowski <konrad0.jankowski@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.13 072/151] ice: Prevent probing virtual functions
Date:   Mon, 16 Aug 2021 15:01:42 +0200
Message-Id: <20210816125446.450848329@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210816125444.082226187@linuxfoundation.org>
References: <20210816125444.082226187@linuxfoundation.org>
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
index 0eb2307325d3..6a72a3b93037 100644
--- a/drivers/net/ethernet/intel/ice/ice_main.c
+++ b/drivers/net/ethernet/intel/ice/ice_main.c
@@ -4014,6 +4014,11 @@ ice_probe(struct pci_dev *pdev, const struct pci_device_id __always_unused *ent)
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



