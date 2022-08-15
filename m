Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 70C9B594A54
	for <lists+stable@lfdr.de>; Tue, 16 Aug 2022 02:18:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354100AbiHOX7U (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 19:59:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35516 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354798AbiHOX5T (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 19:57:19 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F0A6145059;
        Mon, 15 Aug 2022 13:20:16 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 30E1460F71;
        Mon, 15 Aug 2022 20:20:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2C339C433C1;
        Mon, 15 Aug 2022 20:20:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660594815;
        bh=0k9//eBqNhDq78+Kg1GxWRhLI/u1l1Xl9phB5I/ycWs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SPlaY8KqSM5TyE6OLIuX5xSsnYqkV/mPh7sGvBIWK8djuhXsVKhL5C5t9J2SmsBHR
         /bEv2LMHQsmJWGTQ241JOTNzCEXYd7ie2BYkBr6dHXNDhbZsxXxTCxWv9MIK7i9Z9E
         pCldi5P+DFuoYFq6zXXZfoQP7KdYMcuzVWTSWF/Y=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jian Shen <shenjian15@huawei.com>,
        Guangbin Huang <huangguangbin2@huawei.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.19 0567/1157] net: ice: fix error NETIF_F_HW_VLAN_CTAG_FILTER check in ice_vsi_sync_fltr()
Date:   Mon, 15 Aug 2022 19:58:43 +0200
Message-Id: <20220815180502.295591842@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220815180439.416659447@linuxfoundation.org>
References: <20220815180439.416659447@linuxfoundation.org>
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

From: Jian Shen <shenjian15@huawei.com>

[ Upstream commit 7dc839fe47611e6995f370cae37b9797cf7d2672 ]

vsi->current_netdev_flags is used store the current net device
flags, not the active netdevice features. So it should use
vsi->netdev->featurs, rather than vsi->current_netdev_flags
to check NETIF_F_HW_VLAN_CTAG_FILTER.

Fixes: 1babaf77f49d ("ice: Advertise 802.1ad VLAN filtering and offloads for PF netdev")
Signed-off-by: Jian Shen <shenjian15@huawei.com>
Signed-off-by: Guangbin Huang <huangguangbin2@huawei.com>
Acked-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/intel/ice/ice_main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_main.c b/drivers/net/ethernet/intel/ice/ice_main.c
index 9f02b60459f1..bc68dc5c6927 100644
--- a/drivers/net/ethernet/intel/ice/ice_main.c
+++ b/drivers/net/ethernet/intel/ice/ice_main.c
@@ -433,7 +433,7 @@ static int ice_vsi_sync_fltr(struct ice_vsi *vsi)
 						IFF_PROMISC;
 					goto out_promisc;
 				}
-				if (vsi->current_netdev_flags &
+				if (vsi->netdev->features &
 				    NETIF_F_HW_VLAN_CTAG_FILTER)
 					vlan_ops->ena_rx_filtering(vsi);
 			}
-- 
2.35.1



