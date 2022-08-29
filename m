Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B91285A494E
	for <lists+stable@lfdr.de>; Mon, 29 Aug 2022 13:23:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231665AbiH2LXG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Aug 2022 07:23:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58352 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231806AbiH2LWX (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 29 Aug 2022 07:22:23 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CE5FA10CC;
        Mon, 29 Aug 2022 04:14:16 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 4DD4BB80EB8;
        Mon, 29 Aug 2022 11:14:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 98329C433C1;
        Mon, 29 Aug 2022 11:13:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1661771640;
        bh=tsEm34MD0Tn8vSDRsytIQ74EGAeQxHopaubzDZhDV+k=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RU/7g5kZwIadwRx2wD9TA99laJzAv7oZ/YOMw/d7gPS22DDt/IPJwm+kE+A52NNCN
         5qr8LSzSuFazasA1TZpyAWlpvRyLT5qgJ+A3udt9cvxMdbFWucrjrP5fu0xjhimk92
         VfUYMktiQxmogfnzOo7QsW1xLp/5+nduzzOhEf48=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Vikas Gupta <vikas.gupta@broadcom.com>,
        Michael Chan <michael.chan@broadcom.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.19 054/158] bnxt_en: fix LRO/GRO_HW features in ndo_fix_features callback
Date:   Mon, 29 Aug 2022 12:58:24 +0200
Message-Id: <20220829105810.994163211@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220829105808.828227973@linuxfoundation.org>
References: <20220829105808.828227973@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Vikas Gupta <vikas.gupta@broadcom.com>

[ Upstream commit 366c304741729e64d778c80555d9eb422cf5cc89 ]

LRO/GRO_HW should be disabled if there is an attached XDP program.
BNXT_FLAG_TPA is the current setting of the LRO/GRO_HW.  Using
BNXT_FLAG_TPA to disable LRO/GRO_HW will cause these features to be
permanently disabled once they are disabled.

Fixes: 1dc4c557bfed ("bnxt: adding bnxt_xdp_build_skb to build skb from multibuffer xdp_buff")
Signed-off-by: Vikas Gupta <vikas.gupta@broadcom.com>
Signed-off-by: Michael Chan <michael.chan@broadcom.com>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/broadcom/bnxt/bnxt.c | 5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.c b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
index cf9b00576ed36..964354536f9ce 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
@@ -11183,10 +11183,7 @@ static netdev_features_t bnxt_fix_features(struct net_device *dev,
 	if ((features & NETIF_F_NTUPLE) && !bnxt_rfs_capable(bp))
 		features &= ~NETIF_F_NTUPLE;
 
-	if (bp->flags & BNXT_FLAG_NO_AGG_RINGS)
-		features &= ~(NETIF_F_LRO | NETIF_F_GRO_HW);
-
-	if (!(bp->flags & BNXT_FLAG_TPA))
+	if ((bp->flags & BNXT_FLAG_NO_AGG_RINGS) || bp->xdp_prog)
 		features &= ~(NETIF_F_LRO | NETIF_F_GRO_HW);
 
 	if (!(features & NETIF_F_GRO))
-- 
2.35.1



