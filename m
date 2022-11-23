Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 13EDF6353D8
	for <lists+stable@lfdr.de>; Wed, 23 Nov 2022 10:00:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236819AbiKWI6i (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 23 Nov 2022 03:58:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33930 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236810AbiKWI6T (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 23 Nov 2022 03:58:19 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 773B487A5D
        for <stable@vger.kernel.org>; Wed, 23 Nov 2022 00:58:18 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 072B8CE20F6
        for <stable@vger.kernel.org>; Wed, 23 Nov 2022 08:58:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BF4EAC433D6;
        Wed, 23 Nov 2022 08:58:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1669193894;
        bh=I/DCJwncZwYj2qRF9/gB1NM8kyDOLWWZK9insvDA7Yk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YzBE1/y6GWWcZFuQyStlda/L49s297Zzrs3p36KDjtk66aT51FiU+5EMwo2i3x/HW
         MXkB73Bc4TbeSfgDECQu9SGgflSe8WDvRPqSjUJr5nc42NXhxKMZ5Ns3NJwQjwphyI
         MEoPSQRbBgVvI8aPfw4LrRPv+ZLWMff8gC1ajxaM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Zhengchao Shao <shaozhengchao@huawei.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 14/88] ethernet: s2io: disable napi when start nic failed in s2io_card_up()
Date:   Wed, 23 Nov 2022 09:50:11 +0100
Message-Id: <20221123084549.009994388@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221123084548.535439312@linuxfoundation.org>
References: <20221123084548.535439312@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Zhengchao Shao <shaozhengchao@huawei.com>

[ Upstream commit 0348c1ab980c1d43fb37b758d4b760990c066cb5 ]

When failed to start nic or add interrupt service routine in
s2io_card_up() for opening device, napi isn't disabled. When open
s2io device next time, it will trigger a BUG_ON()in napi_enable().
Compile tested only.

Fixes: 5f490c968056 ("S2io: Fixed synchronization between scheduling of napi with card reset and close")
Signed-off-by: Zhengchao Shao <shaozhengchao@huawei.com>
Link: https://lore.kernel.org/r/20221109023741.131552-1-shaozhengchao@huawei.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/neterion/s2io.c | 29 +++++++++++++++++++---------
 1 file changed, 20 insertions(+), 9 deletions(-)

diff --git a/drivers/net/ethernet/neterion/s2io.c b/drivers/net/ethernet/neterion/s2io.c
index 55538722f6f3..94aabf280768 100644
--- a/drivers/net/ethernet/neterion/s2io.c
+++ b/drivers/net/ethernet/neterion/s2io.c
@@ -7132,9 +7132,8 @@ static int s2io_card_up(struct s2io_nic *sp)
 		if (ret) {
 			DBG_PRINT(ERR_DBG, "%s: Out of memory in Open\n",
 				  dev->name);
-			s2io_reset(sp);
-			free_rx_buffers(sp);
-			return -ENOMEM;
+			ret = -ENOMEM;
+			goto err_fill_buff;
 		}
 		DBG_PRINT(INFO_DBG, "Buf in ring:%d is %d:\n", i,
 			  ring->rx_bufs_left);
@@ -7172,18 +7171,16 @@ static int s2io_card_up(struct s2io_nic *sp)
 	/* Enable Rx Traffic and interrupts on the NIC */
 	if (start_nic(sp)) {
 		DBG_PRINT(ERR_DBG, "%s: Starting NIC failed\n", dev->name);
-		s2io_reset(sp);
-		free_rx_buffers(sp);
-		return -ENODEV;
+		ret = -ENODEV;
+		goto err_out;
 	}
 
 	/* Add interrupt service routine */
 	if (s2io_add_isr(sp) != 0) {
 		if (sp->config.intr_type == MSI_X)
 			s2io_rem_isr(sp);
-		s2io_reset(sp);
-		free_rx_buffers(sp);
-		return -ENODEV;
+		ret = -ENODEV;
+		goto err_out;
 	}
 
 	S2IO_TIMER_CONF(sp->alarm_timer, s2io_alarm_handle, sp, (HZ/2));
@@ -7202,6 +7199,20 @@ static int s2io_card_up(struct s2io_nic *sp)
 	}
 
 	return 0;
+
+err_out:
+	if (config->napi) {
+		if (config->intr_type == MSI_X) {
+			for (i = 0; i < sp->config.rx_ring_num; i++)
+				napi_disable(&sp->mac_control.rings[i].napi);
+		} else {
+			napi_disable(&sp->napi);
+		}
+	}
+err_fill_buff:
+	s2io_reset(sp);
+	free_rx_buffers(sp);
+	return ret;
 }
 
 /**
-- 
2.35.1



