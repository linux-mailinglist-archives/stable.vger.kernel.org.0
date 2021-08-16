Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 375773ED49D
	for <lists+stable@lfdr.de>; Mon, 16 Aug 2021 15:04:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236652AbhHPNE1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Aug 2021 09:04:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:55340 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235536AbhHPNEX (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 16 Aug 2021 09:04:23 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2177C63292;
        Mon, 16 Aug 2021 13:03:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1629119031;
        bh=LPMaJ9ZVY7+KRz2c2ftd5MfC1UvkplOauhOCq0lMLAU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HytsVUT17K9G+RXco+dqb+Mt6dLKtztODN8j5/A6DKyK9jr/IJmSzb4QVRYykV142
         rYdqaV+1DeyncNVnpbJimgY8nOXhOJ1ePVCmbcvucK+lb8D25D2tUBB+KB1vVIPSul
         KUwGmgElmktaMYH4U3Thk4Gl7SLeuZRP91c7k1z8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Md Fahad Iqbal Polash <md.fahad.iqbal.polash@intel.com>,
        Konrad Jankowski <konrad0.jankowski@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 24/62] iavf: Set RSS LUT and key in reset handle path
Date:   Mon, 16 Aug 2021 15:01:56 +0200
Message-Id: <20210816125429.019844544@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210816125428.198692661@linuxfoundation.org>
References: <20210816125428.198692661@linuxfoundation.org>
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
index cda9b9a8392a..dc902e371c2c 100644
--- a/drivers/net/ethernet/intel/iavf/iavf_main.c
+++ b/drivers/net/ethernet/intel/iavf/iavf_main.c
@@ -1499,11 +1499,6 @@ static int iavf_reinit_interrupt_scheme(struct iavf_adapter *adapter)
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
@@ -2179,6 +2174,14 @@ continue_reset:
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



