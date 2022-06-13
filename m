Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1ACC85497FD
	for <lists+stable@lfdr.de>; Mon, 13 Jun 2022 18:36:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354695AbiFMMbB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Jun 2022 08:31:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36110 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1358343AbiFMM3k (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Jun 2022 08:29:40 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 22724286F0;
        Mon, 13 Jun 2022 04:06:41 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A6939B80EA7;
        Mon, 13 Jun 2022 11:06:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 182E7C34114;
        Mon, 13 Jun 2022 11:06:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1655118399;
        bh=vwXcdhnVOCrYk5dtqcAHOP3Nk/WMBvVWYBtNL46+VZE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=enhgt5VRzCZ2kZvXT0r8nyUubbuRWJm2CJqXnrErlUZL3klMnvQ/8sc4JmMyMlde2
         ztHiQ0eRGmcmmmkAp2kizfIuCHEP1UCsZYFfEHlwoHgT4Z7BNwN18QHWHecnYqyagA
         bCFiMnu2vB86OB80cOEWa3+D+U94Ec7cqWKxWYqU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Tianhao Zhao <tizhao@redhat.com>,
        Martin Habets <habetsm.xilinx@gmail.com>,
        =?UTF-8?q?=C3=8D=C3=B1igo=20Huguet?= <ihuguet@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 062/172] sfc: fix considering that all channels have TX queues
Date:   Mon, 13 Jun 2022 12:10:22 +0200
Message-Id: <20220613094905.310212719@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220613094850.166931805@linuxfoundation.org>
References: <20220613094850.166931805@linuxfoundation.org>
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

From: Martin Habets <habetsm.xilinx@gmail.com>

[ Upstream commit 2e102b53f8a778f872dc137f4c7ac548705817aa ]

Normally, all channels have RX and TX queues, but this is not true if
modparam efx_separate_tx_channels=1 is used. In that cases, some
channels only have RX queues and others only TX queues (or more
preciselly, they have them allocated, but not initialized).

Fix efx_channel_has_tx_queues to return the correct value for this case
too.

Messages shown at probe time before the fix:
 sfc 0000:03:00.0 ens6f0np0: MC command 0x82 inlen 544 failed rc=-22 (raw=0) arg=0
 ------------[ cut here ]------------
 netdevice: ens6f0np0: failed to initialise TXQ -1
 WARNING: CPU: 1 PID: 626 at drivers/net/ethernet/sfc/ef10.c:2393 efx_ef10_tx_init+0x201/0x300 [sfc]
 [...] stripped
 RIP: 0010:efx_ef10_tx_init+0x201/0x300 [sfc]
 [...] stripped
 Call Trace:
  efx_init_tx_queue+0xaa/0xf0 [sfc]
  efx_start_channels+0x49/0x120 [sfc]
  efx_start_all+0x1f8/0x430 [sfc]
  efx_net_open+0x5a/0xe0 [sfc]
  __dev_open+0xd0/0x190
  __dev_change_flags+0x1b3/0x220
  dev_change_flags+0x21/0x60
 [...] stripped

Messages shown at remove time before the fix:
 sfc 0000:03:00.0 ens6f0np0: failed to flush 10 queues
 sfc 0000:03:00.0 ens6f0np0: failed to flush queues

Fixes: 8700aff08984 ("sfc: fix channel allocation with brute force")
Reported-by: Tianhao Zhao <tizhao@redhat.com>
Signed-off-by: Martin Habets <habetsm.xilinx@gmail.com>
Tested-by: Íñigo Huguet <ihuguet@redhat.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/sfc/net_driver.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/sfc/net_driver.h b/drivers/net/ethernet/sfc/net_driver.h
index 9f7dfdf708cf..8aecb4bd2c0d 100644
--- a/drivers/net/ethernet/sfc/net_driver.h
+++ b/drivers/net/ethernet/sfc/net_driver.h
@@ -1522,7 +1522,7 @@ static inline bool efx_channel_is_xdp_tx(struct efx_channel *channel)
 
 static inline bool efx_channel_has_tx_queues(struct efx_channel *channel)
 {
-	return true;
+	return channel && channel->channel >= channel->efx->tx_channel_offset;
 }
 
 static inline unsigned int efx_channel_num_tx_queues(struct efx_channel *channel)
-- 
2.35.1



