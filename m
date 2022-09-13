Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A3B0C5B7269
	for <lists+stable@lfdr.de>; Tue, 13 Sep 2022 16:55:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234483AbiIMOz0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 13 Sep 2022 10:55:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34340 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234632AbiIMOxa (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 13 Sep 2022 10:53:30 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 675CE72B67;
        Tue, 13 Sep 2022 07:26:50 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 63DB1B80F9B;
        Tue, 13 Sep 2022 14:24:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C6708C433C1;
        Tue, 13 Sep 2022 14:24:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1663079051;
        bh=KaSwSIgk7nDDYsYLWWwE5uYh50byIm2BzbB5QmW7AQ0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=blC/FieGI/43U538PcmeScjC+K8P5Zl8CVpBPhFSkPUDox+fJCIHS0lg05QVFcgtj
         HoFRUUAWnEUUjMzaDWRAEvorP7TTK30s3U/rxtjwdblOHiMQFUDb0SHbt1fLnthyWF
         3QdCiGfKitI97Ezkfg07aq/Sgw/npQ1ezPGX61T8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Mark Bloch <mbloch@nvidia.com>,
        Chris Mi <cmi@nvidia.com>, Leon Romanovsky <leon@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 64/79] RDMA/mlx5: Set local port to one when accessing counters
Date:   Tue, 13 Sep 2022 16:05:09 +0200
Message-Id: <20220913140353.293777543@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20220913140350.291927556@linuxfoundation.org>
References: <20220913140350.291927556@linuxfoundation.org>
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

From: Chris Mi <cmi@nvidia.com>

[ Upstream commit 74b30b3ad5cec95d2647e796d10137438a098bc1 ]

When accessing Ports Performance Counters Register (PPCNT),
local port must be one if it is Function-Per-Port HCA that
HCA_CAP.num_ports is 1.

The offending patch can change the local port to other values
when accessing PPCNT after enabling switchdev mode. The following
syndrome will be printed:

 # cat /sys/class/infiniband/rdmap4s0f0/ports/2/counters/*
 # dmesg
 mlx5_core 0000:04:00.0: mlx5_cmd_check:756:(pid 12450): ACCESS_REG(0x805) op_mod(0x1) failed, status bad parameter(0x3), syndrome (0x1e5585)

Fix it by setting local port to one for Function-Per-Port HCA.

Fixes: 210b1f78076f ("IB/mlx5: When not in dual port RoCE mode, use provided port as native")
Reviewed-by: Mark Bloch <mbloch@nvidia.com>
Signed-off-by: Chris Mi <cmi@nvidia.com>
Link: https://lore.kernel.org/r/6c5086c295c76211169e58dbd610fb0402360bab.1661763459.git.leonro@nvidia.com
Signed-off-by: Leon Romanovsky <leon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/mlx5/mad.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/infiniband/hw/mlx5/mad.c b/drivers/infiniband/hw/mlx5/mad.c
index 9bb9bb058932f..cca7a4a6bd82d 100644
--- a/drivers/infiniband/hw/mlx5/mad.c
+++ b/drivers/infiniband/hw/mlx5/mad.c
@@ -166,6 +166,12 @@ static int process_pma_cmd(struct mlx5_ib_dev *dev, u8 port_num,
 		mdev = dev->mdev;
 		mdev_port_num = 1;
 	}
+	if (MLX5_CAP_GEN(dev->mdev, num_ports) == 1) {
+		/* set local port to one for Function-Per-Port HCA. */
+		mdev = dev->mdev;
+		mdev_port_num = 1;
+	}
+
 	/* Declaring support of extended counters */
 	if (in_mad->mad_hdr.attr_id == IB_PMA_CLASS_PORT_INFO) {
 		struct ib_class_port_info cpi = {};
-- 
2.35.1



