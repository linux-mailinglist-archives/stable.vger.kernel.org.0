Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 881214624F5
	for <lists+stable@lfdr.de>; Mon, 29 Nov 2021 23:31:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233122AbhK2Wdd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Nov 2021 17:33:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60570 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231384AbhK2WdL (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 29 Nov 2021 17:33:11 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E9574C0800E5;
        Mon, 29 Nov 2021 10:39:05 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 41CD0CE1626;
        Mon, 29 Nov 2021 18:39:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1BFD7C53FCF;
        Mon, 29 Nov 2021 18:39:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1638211142;
        bh=BWD8/3OgvVLrMoJLJgqM78bwu35l1hX1zNuJsrKl7rY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0Q8AY2tDljhYjzzo4V6U9s/GIwxEOPRy8P+g5QzFCKruIdaGLfKr50Qdsa4/FxzTV
         8EcTB19WKqmnAYFl2MgpBMKZnCVgpo1icfn3BZFaTpebN0ZZHLY1L6i2co11AQ7GuD
         wYW0LJ8EpWr1uOuWBRCbujE5Tl1EqcufEVcqfPS0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Diana Wang <na.wang@corigine.com>,
        Simon Horman <simon.horman@corigine.com>,
        Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 109/179] nfp: checking parameter process for rx-usecs/tx-usecs is invalid
Date:   Mon, 29 Nov 2021 19:18:23 +0100
Message-Id: <20211129181722.528960001@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211129181718.913038547@linuxfoundation.org>
References: <20211129181718.913038547@linuxfoundation.org>
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
index df203738511bf..0b1865e9f0b59 100644
--- a/drivers/net/ethernet/netronome/nfp/nfp_net.h
+++ b/drivers/net/ethernet/netronome/nfp/nfp_net.h
@@ -565,7 +565,6 @@ struct nfp_net_dp {
  * @exn_name:           Name for Exception interrupt
  * @shared_handler:     Handler for shared interrupts
  * @shared_name:        Name for shared interrupt
- * @me_freq_mhz:        ME clock_freq (MHz)
  * @reconfig_lock:	Protects @reconfig_posted, @reconfig_timer_active,
  *			@reconfig_sync_present and HW reconfiguration request
  *			regs/machinery from async requests (sync must take
@@ -650,8 +649,6 @@ struct nfp_net {
 	irq_handler_t shared_handler;
 	char shared_name[IFNAMSIZ + 8];
 
-	u32 me_freq_mhz;
-
 	bool link_up;
 	spinlock_t link_status_lock;
 
diff --git a/drivers/net/ethernet/netronome/nfp/nfp_net_ethtool.c b/drivers/net/ethernet/netronome/nfp/nfp_net_ethtool.c
index 0685ece1f155d..be1a358baadb9 100644
--- a/drivers/net/ethernet/netronome/nfp/nfp_net_ethtool.c
+++ b/drivers/net/ethernet/netronome/nfp/nfp_net_ethtool.c
@@ -1343,7 +1343,7 @@ static int nfp_net_set_coalesce(struct net_device *netdev,
 	 * ME timestamp ticks.  There are 16 ME clock cycles for each timestamp
 	 * count.
 	 */
-	factor = nn->me_freq_mhz / 16;
+	factor = nn->tlv_caps.me_freq_mhz / 16;
 
 	/* Each pair of (usecs, max_frames) fields specifies that interrupts
 	 * should be coalesced until
-- 
2.33.0



