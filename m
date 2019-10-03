Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A8ECBCAC2C
	for <lists+stable@lfdr.de>; Thu,  3 Oct 2019 19:46:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731942AbfJCQGc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 3 Oct 2019 12:06:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:53860 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730492AbfJCQGb (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 3 Oct 2019 12:06:31 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8375E207FF;
        Thu,  3 Oct 2019 16:06:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1570118791;
        bh=z5ldPJTP+L3NCpdYEwBJfONcAFoO4Nxd2HBNJFZkk6A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qJBaIzNfy7XQ0nIRK2GerUJR36pDgFGRyfEqnW/pZtggHnw5lQcVubotTewt5sg22
         RichRMVKzOJZoR/BMLywcEc4Z21K5Ww9tU9Wg4rkOLdydeLahhUg4MRuzEknQpky7N
         CKWPROF7PLZhK3771bEQMhIho53DXZCuIOtMPlO8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Subject: [PATCH 4.14 011/185] iwlwifi: mvm: send BCAST management frames to the right station
Date:   Thu,  3 Oct 2019 17:51:29 +0200
Message-Id: <20191003154439.769397054@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191003154437.541662648@linuxfoundation.org>
References: <20191003154437.541662648@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

commit 65c3b582ecab7a403efdf08babbf87fdbe27369c upstream.

Probe responses were sent to the multicast station while
they should be routed to the broadcast station.
This has no negative effect since the frame was still
routed to the right queue, but it looked very fishy
to send a frame to a (queue, station) tuple where
'queue' is not mapped to 'station'.

Fixes: 7c305de2b954 ("iwlwifi: mvm: Direct multicast frames to the correct station")
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/net/wireless/intel/iwlwifi/mvm/tx.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/net/wireless/intel/iwlwifi/mvm/tx.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/tx.c
@@ -651,7 +651,7 @@ int iwl_mvm_tx_skb_non_sta(struct iwl_mv
 		if (info.control.vif->type == NL80211_IFTYPE_P2P_DEVICE ||
 		    info.control.vif->type == NL80211_IFTYPE_AP ||
 		    info.control.vif->type == NL80211_IFTYPE_ADHOC) {
-			if (info.control.vif->type == NL80211_IFTYPE_P2P_DEVICE)
+			if (!ieee80211_is_data(hdr->frame_control))
 				sta_id = mvmvif->bcast_sta.sta_id;
 			else
 				sta_id = mvmvif->mcast_sta.sta_id;


