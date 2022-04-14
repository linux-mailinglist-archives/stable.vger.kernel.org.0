Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EE66850131C
	for <lists+stable@lfdr.de>; Thu, 14 Apr 2022 17:12:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239087AbiDNOHE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 14 Apr 2022 10:07:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47114 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347606AbiDNN7W (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 14 Apr 2022 09:59:22 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1E061240AA;
        Thu, 14 Apr 2022 06:50:29 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id CA32DB82985;
        Thu, 14 Apr 2022 13:50:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2D08FC385A5;
        Thu, 14 Apr 2022 13:50:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649944226;
        bh=IodMgCOPlbHTjYstVwL1rgNsPbzgP2ff+Y5c15pjrSw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=vbsi7uhO6/sL31yM6XAkPiQWZ5oiR81kPOo82TWpZqAf7mBN31+Mhov1/Z9VvijvQ
         9pQv2xgq7jkrBF+Ph/8E5Lpfu4EOfF8+6OM/fFSI9sNMhYCTs3sv/MBr+uLdYEb4Mh
         VWAc5KwlfsqqD3bGluRh1TYCEoKMiYnAWCt6xcSY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Colin Winegarden <colin.winegarden@broadcom.com>,
        Pavan Chebbi <pavan.chebbi@broadcom.com>,
        Michael Chan <michael.chan@broadcom.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 399/475] bnxt_en: Eliminate unintended link toggle during FW reset
Date:   Thu, 14 Apr 2022 15:13:04 +0200
Message-Id: <20220414110906.235158825@linuxfoundation.org>
X-Mailer: git-send-email 2.35.2
In-Reply-To: <20220414110855.141582785@linuxfoundation.org>
References: <20220414110855.141582785@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Michael Chan <michael.chan@broadcom.com>

[ Upstream commit 7c492a2530c1f05441da541307c2534230dfd59b ]

If the flow control settings have been changed, a subsequent FW reset
may cause the ethernet link to toggle unnecessarily.  This link toggle
will increase the down time by a few seconds.

The problem is caused by bnxt_update_phy_setting() detecting a false
mismatch in the flow control settings between the stored software
settings and the current FW settings after the FW reset.  This mismatch
is caused by the AUTONEG bit added to link_info->req_flow_ctrl in an
inconsistent way in bnxt_set_pauseparam() in autoneg mode.  The AUTONEG
bit should not be added to link_info->req_flow_ctrl.

Reviewed-by: Colin Winegarden <colin.winegarden@broadcom.com>
Reviewed-by: Pavan Chebbi <pavan.chebbi@broadcom.com>
Signed-off-by: Michael Chan <michael.chan@broadcom.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c b/drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c
index 97aff84fd1d1..d74c6a34b936 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c
@@ -1673,9 +1673,7 @@ static int bnxt_set_pauseparam(struct net_device *dev,
 		}
 
 		link_info->autoneg |= BNXT_AUTONEG_FLOW_CTRL;
-		if (bp->hwrm_spec_code >= 0x10201)
-			link_info->req_flow_ctrl =
-				PORT_PHY_CFG_REQ_AUTO_PAUSE_AUTONEG_PAUSE;
+		link_info->req_flow_ctrl = 0;
 	} else {
 		/* when transition from auto pause to force pause,
 		 * force a link change
-- 
2.35.1



