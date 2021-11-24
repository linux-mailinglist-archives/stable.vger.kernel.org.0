Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 38DF545C1FC
	for <lists+stable@lfdr.de>; Wed, 24 Nov 2021 14:21:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348130AbhKXNYn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Nov 2021 08:24:43 -0500
Received: from mail.kernel.org ([198.145.29.99]:48366 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1347730AbhKXNWy (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 24 Nov 2021 08:22:54 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4F47661B27;
        Wed, 24 Nov 2021 12:47:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637758071;
        bh=gm0cpVCI22aiOYMS4Em0K9cCVtlp/8vv9YLJ18RclrI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=q/6b8tzb1X4oNuOYzR8zmTZxSTA0AulFE9SGtcRgvPZMAXyFF8fHwmNvJjV/6bDVC
         PuTMXmqUtn18GByzW9/c4GOQwPN9OTByCI7nRovboFEccjAodjqdUJeJpZZl2VIVSS
         aZ/9CLDqGq5Ti4e4bVkboHFE0TklOx8RS8ZpztBo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Mitch Williams <mitch.a.williams@intel.com>,
        Tony Brelinski <tony.brelinski@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 052/100] iavf: validate pointers
Date:   Wed, 24 Nov 2021 12:58:08 +0100
Message-Id: <20211124115656.567644031@linuxfoundation.org>
X-Mailer: git-send-email 2.34.0
In-Reply-To: <20211124115654.849735859@linuxfoundation.org>
References: <20211124115654.849735859@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mitch Williams <mitch.a.williams@intel.com>

[ Upstream commit 131b0edc4028bb88bb472456b1ddba526cfb7036 ]

In some cases, the ethtool get_rxfh handler may be called with a null
key or indir parameter. So check these pointers, or you will have a very
bad day.

Fixes: 43a3d9ba34c9 ("i40evf: Allow PF driver to configure RSS")
Signed-off-by: Mitch Williams <mitch.a.williams@intel.com>
Tested-by: Tony Brelinski <tony.brelinski@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/intel/iavf/iavf_ethtool.c | 13 ++++++-------
 1 file changed, 6 insertions(+), 7 deletions(-)

diff --git a/drivers/net/ethernet/intel/iavf/iavf_ethtool.c b/drivers/net/ethernet/intel/iavf/iavf_ethtool.c
index 758bef02a2a86..ad1e796e5544a 100644
--- a/drivers/net/ethernet/intel/iavf/iavf_ethtool.c
+++ b/drivers/net/ethernet/intel/iavf/iavf_ethtool.c
@@ -962,14 +962,13 @@ static int iavf_get_rxfh(struct net_device *netdev, u32 *indir, u8 *key,
 
 	if (hfunc)
 		*hfunc = ETH_RSS_HASH_TOP;
-	if (!indir)
-		return 0;
-
-	memcpy(key, adapter->rss_key, adapter->rss_key_size);
+	if (key)
+		memcpy(key, adapter->rss_key, adapter->rss_key_size);
 
-	/* Each 32 bits pointed by 'indir' is stored with a lut entry */
-	for (i = 0; i < adapter->rss_lut_size; i++)
-		indir[i] = (u32)adapter->rss_lut[i];
+	if (indir)
+		/* Each 32 bits pointed by 'indir' is stored with a lut entry */
+		for (i = 0; i < adapter->rss_lut_size; i++)
+			indir[i] = (u32)adapter->rss_lut[i];
 
 	return 0;
 }
-- 
2.33.0



