Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0896D59BFD5
	for <lists+stable@lfdr.de>; Mon, 22 Aug 2022 14:55:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229704AbiHVMy6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 22 Aug 2022 08:54:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33528 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229565AbiHVMy5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 22 Aug 2022 08:54:57 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 43ACAB7DC
        for <stable@vger.kernel.org>; Mon, 22 Aug 2022 05:54:56 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id EA039B81134
        for <stable@vger.kernel.org>; Mon, 22 Aug 2022 12:54:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3F6EEC433D6;
        Mon, 22 Aug 2022 12:54:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1661172893;
        bh=sOfsdjga+r+5+MQSBVLLjSoZ7rcYbeeCTGmMfVsm41A=;
        h=Subject:To:Cc:From:Date:From;
        b=u7NpgKLG0OurR4eLg+VCqNdQOXWXz88j66RffKFlU1OH4YKZwO2+f7MCr5eajZfFB
         UcjFRgV7PUmlMgGuGcLxvNdO7Ti+HZLi+ILEp/mSKJJScQ/R8AaE/R/vwTu1+WXOZg
         c7yaSypGXA3NFRKSV956MAkE2UX7yJYwdqdQ5IHY=
Subject: FAILED: patch "[PATCH] mlxsw: spectrum: Clear PTP configuration after unregistering" failed to apply to 5.10-stable tree
To:     amcohen@nvidia.com, davem@davemloft.net, idosch@nvidia.com,
        petrm@nvidia.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 22 Aug 2022 14:54:50 +0200
Message-ID: <166117289025560@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
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


The patch below does not apply to the 5.10-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From a159e986ad26d3f35c0157ac92760ba5e44e6785 Mon Sep 17 00:00:00 2001
From: Amit Cohen <amcohen@nvidia.com>
Date: Fri, 12 Aug 2022 17:32:01 +0200
Subject: [PATCH] mlxsw: spectrum: Clear PTP configuration after unregistering
 the netdevice

Currently as part of removing port, PTP API is called to clear the
existing configuration and set the 'rx_filter' and 'tx_type' to zero.
The clearing is done before unregistering the netdevice, which means that
there is a window of time in which the user can reconfigure PTP in the
port, and this configuration will not be cleared.

Reorder the operations, clear PTP configuration after unregistering the
netdevice.

Fixes: 8748642751ede ("mlxsw: spectrum: PTP: Support SIOCGHWTSTAMP, SIOCSHWTSTAMP ioctls")
Signed-off-by: Amit Cohen <amcohen@nvidia.com>
Signed-off-by: Ido Schimmel <idosch@nvidia.com>
Signed-off-by: Petr Machata <petrm@nvidia.com>
Signed-off-by: David S. Miller <davem@davemloft.net>

diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
index 1e240cdd9cbd..30c7b0e15721 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
@@ -1897,9 +1897,9 @@ static void mlxsw_sp_port_remove(struct mlxsw_sp *mlxsw_sp, u16 local_port)
 
 	cancel_delayed_work_sync(&mlxsw_sp_port->periodic_hw_stats.update_dw);
 	cancel_delayed_work_sync(&mlxsw_sp_port->ptp.shaper_dw);
-	mlxsw_sp_port_ptp_clear(mlxsw_sp_port);
 	mlxsw_core_port_clear(mlxsw_sp->core, local_port, mlxsw_sp);
 	unregister_netdev(mlxsw_sp_port->dev); /* This calls ndo_stop */
+	mlxsw_sp_port_ptp_clear(mlxsw_sp_port);
 	mlxsw_sp_port_vlan_classification_set(mlxsw_sp_port, true, true);
 	mlxsw_sp->ports[local_port] = NULL;
 	mlxsw_sp_port_vlan_flush(mlxsw_sp_port, true);

