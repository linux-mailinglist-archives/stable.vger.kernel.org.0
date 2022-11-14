Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 25101627E81
	for <lists+stable@lfdr.de>; Mon, 14 Nov 2022 13:48:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237305AbiKNMsd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Nov 2022 07:48:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40676 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237324AbiKNMs3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 14 Nov 2022 07:48:29 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D85923AB
        for <stable@vger.kernel.org>; Mon, 14 Nov 2022 04:48:27 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 81043B80EB9
        for <stable@vger.kernel.org>; Mon, 14 Nov 2022 12:48:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A4CEDC4347C;
        Mon, 14 Nov 2022 12:48:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1668430105;
        bh=ZoBt3qvMhdsIn/BFlJ18Ovy3hVUYO2Au2vRDwhYNrzg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=OJmwZVjxYEPQauIiK+cGZ6ZyJxDWUZlMvKqE/GrB5CWpMgSkcBDJbugoBx+AfjZzi
         pmBlCkoBSd79j9Jt9EB2nsaQx+Md4X1UTmD7Ab3nrvbFsBGBnECM1MrJezCoqJR73s
         Ib1C0o54HSCpnO8fGmtezfkGtozYfkn7zFCwuBy8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Zhengchao Shao <shaozhengchao@huawei.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 29/95] can: af_can: fix NULL pointer dereference in can_rx_register()
Date:   Mon, 14 Nov 2022 13:45:23 +0100
Message-Id: <20221114124443.742516245@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221114124442.530286937@linuxfoundation.org>
References: <20221114124442.530286937@linuxfoundation.org>
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

[ Upstream commit 8aa59e355949442c408408c2d836e561794c40a1 ]

It causes NULL pointer dereference when testing as following:
(a) use syscall(__NR_socket, 0x10ul, 3ul, 0) to create netlink socket.
(b) use syscall(__NR_sendmsg, ...) to create bond link device and vxcan
    link device, and bind vxcan device to bond device (can also use
    ifenslave command to bind vxcan device to bond device).
(c) use syscall(__NR_socket, 0x1dul, 3ul, 1) to create CAN socket.
(d) use syscall(__NR_bind, ...) to bind the bond device to CAN socket.

The bond device invokes the can-raw protocol registration interface to
receive CAN packets. However, ml_priv is not allocated to the dev,
dev_rcv_lists is assigned to NULL in can_rx_register(). In this case,
it will occur the NULL pointer dereference issue.

The following is the stack information:
BUG: kernel NULL pointer dereference, address: 0000000000000008
PGD 122a4067 P4D 122a4067 PUD 1223c067 PMD 0
Oops: 0000 [#1] PREEMPT SMP
RIP: 0010:can_rx_register+0x12d/0x1e0
Call Trace:
<TASK>
raw_enable_filters+0x8d/0x120
raw_enable_allfilters+0x3b/0x130
raw_bind+0x118/0x4f0
__sys_bind+0x163/0x1a0
__x64_sys_bind+0x1e/0x30
do_syscall_64+0x35/0x80
entry_SYSCALL_64_after_hwframe+0x63/0xcd
</TASK>

Fixes: 4e096a18867a ("net: introduce CAN specific pointer in the struct net_device")
Signed-off-by: Zhengchao Shao <shaozhengchao@huawei.com>
Reviewed-by: Marc Kleine-Budde <mkl@pengutronix.de>
Link: https://lore.kernel.org/all/20221028085650.170470-1-shaozhengchao@huawei.com
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/can/af_can.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/can/af_can.c b/net/can/af_can.c
index 1c95ede2c9a6..cf554e855521 100644
--- a/net/can/af_can.c
+++ b/net/can/af_can.c
@@ -451,7 +451,7 @@ int can_rx_register(struct net *net, struct net_device *dev, canid_t can_id,
 
 	/* insert new receiver  (dev,canid,mask) -> (func,data) */
 
-	if (dev && dev->type != ARPHRD_CAN)
+	if (dev && (dev->type != ARPHRD_CAN || !can_get_ml_priv(dev)))
 		return -ENODEV;
 
 	if (dev && !net_eq(net, dev_net(dev)))
-- 
2.35.1



