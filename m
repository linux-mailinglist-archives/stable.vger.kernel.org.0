Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CD4683ED61B
	for <lists+stable@lfdr.de>; Mon, 16 Aug 2021 15:17:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237818AbhHPNQt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Aug 2021 09:16:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:39410 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239084AbhHPNPM (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 16 Aug 2021 09:15:12 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1B15A6329B;
        Mon, 16 Aug 2021 13:12:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1629119562;
        bh=kSGablp0Ki+RwPm51yskvvIVI9cBpKaFPZZIfDmnovQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=d1LYvwM2EIFOcC1RRmQHA7Q/Qhdy4lVQloXdnhQLLKmzvPMBZ4Xis8lC7Lju5HRHg
         Qw4cF/2PIWp/973vVeMgt5RyLLRhRLciMlv24cZ3h8SO+vtf8JMMcVmcrZFo5yq+5x
         RII+HCPXV+n+vAxL5WuszxTQ97XxpWdjCY09yb0g=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Md Fahad Iqbal Polash <md.fahad.iqbal.polash@intel.com>,
        Konrad Jankowski <konrad0.jankowski@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.13 075/151] iavf: Set RSS LUT and key in reset handle path
Date:   Mon, 16 Aug 2021 15:01:45 +0200
Message-Id: <20210816125446.544481126@linuxfoundation.org>
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

From: Md Fahad Iqbal Polash <md.fahad.iqbal.polash@intel.com>

[ Upstream commit a7550f8b1c9712894f9e98d6caf5f49451ebd058 ]

iavf driver should set RSS LUT and key unconditionally in reset
path. Currently, the driver does not do that. This patch fixes
this issue.

Fixes: 2c86ac3c7079 ("i40evf: create a generic config RSS function")
Signed-off-by: Md Fahad Iqbal Polash <md.fahad.iqbal.polash@intel.com>
Tested-by: Konrad Jankowski <konrad0.jankowski@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/intel/iavf/iavf_main.c | 13 ++++++++-----
 1 file changed, 8 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/intel/iavf/iavf_main.c b/drivers/net/ethernet/intel/iavf/iavf_main.c
index 44bafedd09f2..244ec74ceca7 100644
--- a/drivers/net/ethernet/intel/iavf/iavf_main.c
+++ b/drivers/net/ethernet/intel/iavf/iavf_main.c
@@ -1506,11 +1506,6 @@ static int iavf_reinit_interrupt_scheme(struct iavf_adapter *adapter)
 	set_bit(__IAVF_VSI_DOWN, adapter->vsi.state);
 
 	iavf_map_rings_to_vectors(adapter);
-
-	if (RSS_AQ(adapter))
-		adapter->aq_required |= IAVF_FLAG_AQ_CONFIGURE_RSS;
-	else
-		err = iavf_init_rss(adapter);
 err:
 	return err;
 }
@@ -2200,6 +2195,14 @@ continue_reset:
 			goto reset_err;
 	}
 
+	if (RSS_AQ(adapter)) {
+		adapter->aq_required |= IAVF_FLAG_AQ_CONFIGURE_RSS;
+	} else {
+		err = iavf_init_rss(adapter);
+		if (err)
+			goto reset_err;
+	}
+
 	adapter->aq_required |= IAVF_FLAG_AQ_GET_CONFIG;
 	adapter->aq_required |= IAVF_FLAG_AQ_MAP_VECTORS;
 
-- 
2.30.2



