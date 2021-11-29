Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9C0F1461E8F
	for <lists+stable@lfdr.de>; Mon, 29 Nov 2021 19:34:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1379089AbhK2ShT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Nov 2021 13:37:19 -0500
Received: from sin.source.kernel.org ([145.40.73.55]:52814 "EHLO
        sin.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1379224AbhK2SfT (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 29 Nov 2021 13:35:19 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 8AAF7CE13DB;
        Mon, 29 Nov 2021 18:31:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3869AC53FC7;
        Mon, 29 Nov 2021 18:31:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1638210717;
        bh=Do9khOqrfXRZ8qO85vsKXQkaVEEWbTqeYNdo6flBSww=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Riyrm8P6lRMq/0hISVWRDRFvPbJd/QCgjZnlLIWPtxgtlN5Jh5PQqT2VFrJsiIfho
         tTCVHqNCOVD763TESFYdcKBvAbJWs0fktJlM/dPw28MiB3QxW8B4W3hsXVuH75QK//
         acKTvJtzP6siy9FPR4FJlZ0IOoQabWr1c6foX++g=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Diana Wang <na.wang@corigine.com>,
        Simon Horman <simon.horman@corigine.com>,
        Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 065/121] nfp: checking parameter process for rx-usecs/tx-usecs is invalid
Date:   Mon, 29 Nov 2021 19:18:16 +0100
Message-Id: <20211129181713.833338634@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211129181711.642046348@linuxfoundation.org>
References: <20211129181711.642046348@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Diana Wang <na.wang@corigine.com>

[ Upstream commit 3bd6b2a838ba6a3b86d41b077f570b1b61174def ]

Use nn->tlv_caps.me_freq_mhz instead of nn->me_freq_mhz to check whether
rx-usecs/tx-usecs is valid.

This is because nn->tlv_caps.me_freq_mhz represents the clock_freq (MHz) of
the flow processing cores (FPC) on the NIC. While nn->me_freq_mhz is not
be set.

Fixes: ce991ab6662a ("nfp: read ME frequency from vNIC ctrl memory")
Signed-off-by: Diana Wang <na.wang@corigine.com>
Signed-off-by: Simon Horman <simon.horman@corigine.com>
Reviewed-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/netronome/nfp/nfp_net.h         | 3 ---
 drivers/net/ethernet/netronome/nfp/nfp_net_ethtool.c | 2 +-
 2 files changed, 1 insertion(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/netronome/nfp/nfp_net.h b/drivers/net/ethernet/netronome/nfp/nfp_net.h
index df5b748be068c..cc2ce452000a3 100644
--- a/drivers/net/ethernet/netronome/nfp/nfp_net.h
+++ b/drivers/net/ethernet/netronome/nfp/nfp_net.h
@@ -557,7 +557,6 @@ struct nfp_net_dp {
  * @exn_name:           Name for Exception interrupt
  * @shared_handler:     Handler for shared interrupts
  * @shared_name:        Name for shared interrupt
- * @me_freq_mhz:        ME clock_freq (MHz)
  * @reconfig_lock:	Protects @reconfig_posted, @reconfig_timer_active,
  *			@reconfig_sync_present and HW reconfiguration request
  *			regs/machinery from async requests (sync must take
@@ -640,8 +639,6 @@ struct nfp_net {
 	irq_handler_t shared_handler;
 	char shared_name[IFNAMSIZ + 8];
 
-	u32 me_freq_mhz;
-
 	bool link_up;
 	spinlock_t link_status_lock;
 
diff --git a/drivers/net/ethernet/netronome/nfp/nfp_net_ethtool.c b/drivers/net/ethernet/netronome/nfp/nfp_net_ethtool.c
index c036a1d0f8de6..cd0c9623f7dd2 100644
--- a/drivers/net/ethernet/netronome/nfp/nfp_net_ethtool.c
+++ b/drivers/net/ethernet/netronome/nfp/nfp_net_ethtool.c
@@ -1347,7 +1347,7 @@ static int nfp_net_set_coalesce(struct net_device *netdev,
 	 * ME timestamp ticks.  There are 16 ME clock cycles for each timestamp
 	 * count.
 	 */
-	factor = nn->me_freq_mhz / 16;
+	factor = nn->tlv_caps.me_freq_mhz / 16;
 
 	/* Each pair of (usecs, max_frames) fields specifies that interrupts
 	 * should be coalesced until
-- 
2.33.0



