Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C79B14D8250
	for <lists+stable@lfdr.de>; Mon, 14 Mar 2022 13:01:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240210AbiCNMCk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Mar 2022 08:02:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41128 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240245AbiCNMCX (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 14 Mar 2022 08:02:23 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 67B5C488A3;
        Mon, 14 Mar 2022 04:59:47 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id EB42FB80D24;
        Mon, 14 Mar 2022 11:59:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 41AA6C340E9;
        Mon, 14 Mar 2022 11:59:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1647259184;
        bh=zWVrTmPSziRDlOkzvchLv5PD3fJkMV+hctHczVrVRVc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hcYgoEL3BSf2wuyTDvujNu0R/LXkkULlUPSU2GfXNnL7ebHmEmcUZAvLQtqrBmH9T
         WojknSdZt9M2qVnN0/0tFVXP7yuVjAXPY6J60Vzh5vh0UUYgrGZn/7mrsODlctAJA+
         EeseQ4knS3wzbq1YLA2jyHa8xt3sw84dizateMrQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Grzegorz Siwik <grzegorz.siwik@intel.com>,
        Jedrzej Jagielski <jedrzej.jagielski@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        Sasha Levin <sashal@kernel.org>,
        Gurucharan <gurucharanx.g@intel.com>
Subject: [PATCH 5.10 21/71] ice: Fix curr_link_speed advertised speed
Date:   Mon, 14 Mar 2022 12:53:14 +0100
Message-Id: <20220314112738.525866564@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220314112737.929694832@linuxfoundation.org>
References: <20220314112737.929694832@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jedrzej Jagielski <jedrzej.jagielski@intel.com>

[ Upstream commit ad35ffa252af67d4cc7c744b9377a2b577748e3f ]

Change curr_link_speed advertised speed, due to
link_info.link_speed is not equal phy.curr_user_speed_req.
Without this patch it is impossible to set advertised
speed to same as link_speed.

Testing Hints: Try to set advertised speed
to 25G only with 25G default link (use ethtool -s 0x80000000)

Fixes: 48cb27f2fd18 ("ice: Implement handlers for ethtool PHY/link operations")
Signed-off-by: Grzegorz Siwik <grzegorz.siwik@intel.com>
Signed-off-by: Jedrzej Jagielski <jedrzej.jagielski@intel.com>
Tested-by: Gurucharan <gurucharanx.g@intel.com> (A Contingent worker at Intel)
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/intel/ice/ice_ethtool.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_ethtool.c b/drivers/net/ethernet/intel/ice/ice_ethtool.c
index 0582fca5e07f..421fc707f80a 100644
--- a/drivers/net/ethernet/intel/ice/ice_ethtool.c
+++ b/drivers/net/ethernet/intel/ice/ice_ethtool.c
@@ -2299,7 +2299,7 @@ ice_set_link_ksettings(struct net_device *netdev,
 		goto done;
 	}
 
-	curr_link_speed = pi->phy.link_info.link_speed;
+	curr_link_speed = pi->phy.curr_user_speed_req;
 	adv_link_speed = ice_ksettings_find_adv_link_speed(ks);
 
 	/* If speed didn't get set, set it to what it currently is.
-- 
2.34.1



