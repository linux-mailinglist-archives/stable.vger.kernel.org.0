Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6976E3ED589
	for <lists+stable@lfdr.de>; Mon, 16 Aug 2021 15:12:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238373AbhHPNML (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Aug 2021 09:12:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:58330 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238049AbhHPNIe (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 16 Aug 2021 09:08:34 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B537560E78;
        Mon, 16 Aug 2021 13:07:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1629119235;
        bh=sD+kHG8bzB50R504rt+xhViQPS1oUjfSyADjVV6IfVI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=R5W4siETb+Sze6QHm6lJ9v8jC6lsyNP5iiOV12QpOQ9lnfh/ZOD2pGmNFuwDtv1fT
         Vz2HJE96gTQdI/XR3c02d3EXVUWd0mMU12gQc9jszNcAv7Ysmt3H1ES7K2VAf+s2xg
         aMShJSa2Xo/7UVt0f7BdOalftgcbl96g/vla+TEo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Md Fahad Iqbal Polash <md.fahad.iqbal.polash@intel.com>,
        Konrad Jankowski <konrad0.jankowski@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 45/96] iavf: Set RSS LUT and key in reset handle path
Date:   Mon, 16 Aug 2021 15:01:55 +0200
Message-Id: <20210816125436.464192722@linuxfoundation.org>
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
index f3caf5eab8d4..c4ec9a91c7c5 100644
--- a/drivers/net/ethernet/intel/iavf/iavf_main.c
+++ b/drivers/net/ethernet/intel/iavf/iavf_main.c
@@ -1489,11 +1489,6 @@ static int iavf_reinit_interrupt_scheme(struct iavf_adapter *adapter)
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
@@ -2167,6 +2162,14 @@ continue_reset:
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



