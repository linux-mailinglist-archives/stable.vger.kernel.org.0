Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D69A21ACA0C
	for <lists+stable@lfdr.de>; Thu, 16 Apr 2020 17:31:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392253AbgDPNnL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Apr 2020 09:43:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:56360 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2392245AbgDPNnH (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Apr 2020 09:43:07 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9539A2223D;
        Thu, 16 Apr 2020 13:43:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1587044587;
        bh=Zg0lXdbFYkI82DZL3HsOsGw1RamNs7bH/YilUYo10QM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=BnXxxumv58rjNOOnFrpooJfS60IKjeABARrAwfAYv/79KhKdjwZd/L6uvthqQwWSD
         lsZh/v5ZJ8XbMCPzZQpHID3a6g7mvE+JB1mHdcoahMbVmMNQ4xBx7ay2U/t5rLuFJG
         u4aypbQmR/h2Ss+65EOuuKVPgckctmf9M6TFASgA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ilan Peer <ilan.peer@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>,
        Johannes Berg <johannes.berg@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 020/232] cfg80211: Do not warn on same channel at the end of CSA
Date:   Thu, 16 Apr 2020 15:21:54 +0200
Message-Id: <20200416131318.869848120@linuxfoundation.org>
X-Mailer: git-send-email 2.26.1
In-Reply-To: <20200416131316.640996080@linuxfoundation.org>
References: <20200416131316.640996080@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ilan Peer <ilan.peer@intel.com>

[ Upstream commit 05dcb8bb258575a8dd3499d0d78bd2db633c2b23 ]

When cfg80211_update_assoc_bss_entry() is called, there is a
verification that the BSS channel actually changed. As some APs use
CSA also for bandwidth changes, this would result with a kernel
warning.

Fix this by removing the WARN_ON().

Signed-off-by: Ilan Peer <ilan.peer@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
Link: https://lore.kernel.org/r/iwlwifi.20200326150855.96316ada0e8d.I6710376b1b4257e5f4712fc7ab16e2b638d512aa@changeid
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/wireless/scan.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/net/wireless/scan.c b/net/wireless/scan.c
index aef240fdf8df6..328402ab64a3f 100644
--- a/net/wireless/scan.c
+++ b/net/wireless/scan.c
@@ -2022,7 +2022,11 @@ void cfg80211_update_assoc_bss_entry(struct wireless_dev *wdev,
 
 	spin_lock_bh(&rdev->bss_lock);
 
-	if (WARN_ON(cbss->pub.channel == chan))
+	/*
+	 * Some APs use CSA also for bandwidth changes, i.e., without actually
+	 * changing the control channel, so no need to update in such a case.
+	 */
+	if (cbss->pub.channel == chan)
 		goto done;
 
 	/* use transmitting bss */
-- 
2.20.1



