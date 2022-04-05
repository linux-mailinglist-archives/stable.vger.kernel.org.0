Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 688154F28BF
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 10:21:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239879AbiDEIVo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 04:21:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59700 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233859AbiDEIKU (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 04:10:20 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7B24F6D3AE;
        Tue,  5 Apr 2022 01:02:45 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id EE5DF61668;
        Tue,  5 Apr 2022 08:02:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 073CDC385A1;
        Tue,  5 Apr 2022 08:02:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649145764;
        bh=SZ4EvZnAPRDnjkGVnHLjI/vKNE1LPOyioXCA44z+XjE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GXuW3XjwXyDAmXkzgGnNUbEoAqpDt6ljfO/9/t0qlBeuldE1FHOGtUFIEehN8iWhX
         /i43VSCF4royP4dHf1ySHw4YJlmvepcEQ/F/u3mry20E9nKwdmKJIvdJ2d7GT1Nm4x
         DohJzyPk2BZm6Y++eCC022WFfKA8B8L29ZQd7RaQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Lennert Buytenhek <buytenh@arista.com>,
        Corinna Vinschen <vinschen@redhat.com>,
        Vinicius Costa Gomes <vinicius.gomes@intel.com>,
        Dvora Fuxbrumer <dvorax.fuxbrumer@linux.intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.17 0522/1126] igc: avoid kernel warning when changing RX ring parameters
Date:   Tue,  5 Apr 2022 09:21:09 +0200
Message-Id: <20220405070422.951243160@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220405070407.513532867@linuxfoundation.org>
References: <20220405070407.513532867@linuxfoundation.org>
User-Agent: quilt/0.66
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

From: Corinna Vinschen <vinschen@redhat.com>

[ Upstream commit 453307b569a0d41bddd07f26bf41b784cd82a4c9 ]

Calling ethtool changing the RX ring parameters like this:

  $ ethtool -G eth0 rx 1024

on igc triggers kernel warnings like this:

[  225.198467] ------------[ cut here ]------------
[  225.198473] Missing unregister, handled but fix driver
[  225.198485] WARNING: CPU: 7 PID: 959 at net/core/xdp.c:168
xdp_rxq_info_reg+0x79/0xd0
[...]
[  225.198601] Call Trace:
[  225.198604]  <TASK>
[  225.198609]  igc_setup_rx_resources+0x3f/0xe0 [igc]
[  225.198617]  igc_ethtool_set_ringparam+0x30e/0x450 [igc]
[  225.198626]  ethnl_set_rings+0x18a/0x250
[  225.198631]  genl_family_rcv_msg_doit+0xca/0x110
[  225.198637]  genl_rcv_msg+0xce/0x1c0
[  225.198640]  ? rings_prepare_data+0x60/0x60
[  225.198644]  ? genl_get_cmd+0xd0/0xd0
[  225.198647]  netlink_rcv_skb+0x4e/0xf0
[  225.198652]  genl_rcv+0x24/0x40
[  225.198655]  netlink_unicast+0x20e/0x330
[  225.198659]  netlink_sendmsg+0x23f/0x480
[  225.198663]  sock_sendmsg+0x5b/0x60
[  225.198667]  __sys_sendto+0xf0/0x160
[  225.198671]  ? handle_mm_fault+0xb2/0x280
[  225.198676]  ? do_user_addr_fault+0x1eb/0x690
[  225.198680]  __x64_sys_sendto+0x20/0x30
[  225.198683]  do_syscall_64+0x38/0x90
[  225.198687]  entry_SYSCALL_64_after_hwframe+0x44/0xae
[  225.198693] RIP: 0033:0x7f7ae38ac3aa

igc_ethtool_set_ringparam() copies the igc_ring structure but neglects to
reset the xdp_rxq_info member before calling igc_setup_rx_resources().
This in turn calls xdp_rxq_info_reg() with an already registered xdp_rxq_info.

Make sure to unregister the xdp_rxq_info structure first in
igc_setup_rx_resources.

Fixes: 73f1071c1d29 ("igc: Add support for XDP_TX action")
Reported-by: Lennert Buytenhek <buytenh@arista.com>
Signed-off-by: Corinna Vinschen <vinschen@redhat.com>
Acked-by: Vinicius Costa Gomes <vinicius.gomes@intel.com>
Tested-by: Dvora Fuxbrumer <dvorax.fuxbrumer@linux.intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/intel/igc/igc_main.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/net/ethernet/intel/igc/igc_main.c b/drivers/net/ethernet/intel/igc/igc_main.c
index 629e4a644a9d..2a9ae53238f7 100644
--- a/drivers/net/ethernet/intel/igc/igc_main.c
+++ b/drivers/net/ethernet/intel/igc/igc_main.c
@@ -505,6 +505,9 @@ int igc_setup_rx_resources(struct igc_ring *rx_ring)
 	u8 index = rx_ring->queue_index;
 	int size, desc_len, res;
 
+	/* XDP RX-queue info */
+	if (xdp_rxq_info_is_reg(&rx_ring->xdp_rxq))
+		xdp_rxq_info_unreg(&rx_ring->xdp_rxq);
 	res = xdp_rxq_info_reg(&rx_ring->xdp_rxq, ndev, index,
 			       rx_ring->q_vector->napi.napi_id);
 	if (res < 0) {
-- 
2.34.1



