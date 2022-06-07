Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E239E54051E
	for <lists+stable@lfdr.de>; Tue,  7 Jun 2022 19:23:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346085AbiFGRVw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 13:21:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45198 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345979AbiFGRVW (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 13:21:22 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DC97E10657E;
        Tue,  7 Jun 2022 10:20:59 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 618E160920;
        Tue,  7 Jun 2022 17:20:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 71888C385A5;
        Tue,  7 Jun 2022 17:20:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654622458;
        bh=UAo6LCwq6BdnSWAM2NkTDxIo7p5zcc9lLplkkTTl0vo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gZK3jRijd955tHmkYCNmSZVt3rnCpQhz2ZoDm3lOsSIveU1aUcgwQzYDpzVkVZNTl
         JQRgm6be00uGNW23Ym216lUC73a/f2lPljGjx6+PIw4v4mNToUkO0DNBUqqYBFamwe
         bcIlQqUqBiyo5nDnpl3sbPI0BFFcCLTiCR62+szY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Maksym Yaremchuk <maksymy@nvidia.com>,
        Petr Machata <petrm@nvidia.com>,
        Ido Schimmel <idosch@nvidia.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 064/452] mlxsw: Treat LLDP packets as control
Date:   Tue,  7 Jun 2022 18:58:41 +0200
Message-Id: <20220607164910.457691262@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220607164908.521895282@linuxfoundation.org>
References: <20220607164908.521895282@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Petr Machata <petrm@nvidia.com>

[ Upstream commit 0106668cd2f91bf913fb78972840dedfba80a3c3 ]

When trapping packets for on-CPU processing, Spectrum machines
differentiate between control and non-control traps. Traffic trapped
through non-control traps is treated as data and kept in shared buffer in
pools 0-4. Traffic trapped through control traps is kept in the dedicated
control buffer 9. The advantage of marking traps as control is that
pressure in the data plane does not prevent the control traffic to be
processed.

When the LLDP trap was introduced, it was marked as a control trap. But
then in commit aed4b5721143 ("mlxsw: spectrum: PTP: Hook into packet
receive path"), PTP traps were introduced. Because Ethernet-encapsulated
PTP packets look to the Spectrum-1 ASIC as LLDP traffic and are trapped
under the LLDP trap, this trap was reconfigured as non-control, in sync
with the PTP traps.

There is however no requirement that PTP traffic be handled as data.
Besides, the usual encapsulation for PTP traffic is UDP, not bare Ethernet,
and that is in deployments that even need PTP, which is far less common
than LLDP. This is reflected by the default policer, which was not bumped
up to the 19Kpps / 24Kpps that is the expected load of a PTP-enabled
Spectrum-1 switch.

Marking of LLDP trap as non-control was therefore probably misguided. In
this patch, change it back to control.

Reported-by: Maksym Yaremchuk <maksymy@nvidia.com>
Signed-off-by: Petr Machata <petrm@nvidia.com>
Signed-off-by: Ido Schimmel <idosch@nvidia.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/mellanox/mlxsw/spectrum_trap.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_trap.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_trap.c
index 433f14ade464..02ba6aa01105 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_trap.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_trap.c
@@ -709,7 +709,7 @@ static const struct mlxsw_sp_trap_item mlxsw_sp_trap_items_arr[] = {
 		.trap = MLXSW_SP_TRAP_CONTROL(LLDP, LLDP, TRAP),
 		.listeners_arr = {
 			MLXSW_RXL(mlxsw_sp_rx_ptp_listener, LLDP, TRAP_TO_CPU,
-				  false, SP_LLDP, DISCARD),
+				  true, SP_LLDP, DISCARD),
 		},
 	},
 	{
-- 
2.35.1



