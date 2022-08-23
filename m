Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DB5A559D65D
	for <lists+stable@lfdr.de>; Tue, 23 Aug 2022 11:12:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240760AbiHWJBn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Aug 2022 05:01:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42196 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241104AbiHWJBH (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 23 Aug 2022 05:01:07 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E4F3E82876;
        Tue, 23 Aug 2022 01:27:50 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 0A5CBB81C48;
        Tue, 23 Aug 2022 08:27:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 422EFC433D6;
        Tue, 23 Aug 2022 08:27:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1661243223;
        bh=XqrLsuMQD7WWEuspC3uWOb0vRFo3OKEJ+OYxw17qHtc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=oEwUN44leMxMTSHFRzJSeWYjtTyG3798at4nFKsKFszNZxsKgyl5Fg0+KLwVAqUy0
         vgk0GHr/BIDGj+WgJbNzYPVs1tpK+5NCniOmVotYrMcm4CcIfqMv+fsckrW4SbiGBd
         GPPFZ+N51RHE0SiTaoC9jHntF954tfK0RxybIgfM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Amit Cohen <amcohen@nvidia.com>,
        Ido Schimmel <idosch@nvidia.com>,
        Petr Machata <petrm@nvidia.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.19 209/365] mlxsw: spectrum: Clear PTP configuration after unregistering the netdevice
Date:   Tue, 23 Aug 2022 10:01:50 +0200
Message-Id: <20220823080126.937910740@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220823080118.128342613@linuxfoundation.org>
References: <20220823080118.128342613@linuxfoundation.org>
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

From: Amit Cohen <amcohen@nvidia.com>

commit a159e986ad26d3f35c0157ac92760ba5e44e6785 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/mellanox/mlxsw/spectrum.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
@@ -1822,9 +1822,9 @@ static void mlxsw_sp_port_remove(struct
 
 	cancel_delayed_work_sync(&mlxsw_sp_port->periodic_hw_stats.update_dw);
 	cancel_delayed_work_sync(&mlxsw_sp_port->ptp.shaper_dw);
-	mlxsw_sp_port_ptp_clear(mlxsw_sp_port);
 	mlxsw_core_port_clear(mlxsw_sp->core, local_port, mlxsw_sp);
 	unregister_netdev(mlxsw_sp_port->dev); /* This calls ndo_stop */
+	mlxsw_sp_port_ptp_clear(mlxsw_sp_port);
 	mlxsw_sp_port_vlan_classification_set(mlxsw_sp_port, true, true);
 	mlxsw_sp->ports[local_port] = NULL;
 	mlxsw_sp_port_vlan_flush(mlxsw_sp_port, true);


