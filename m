Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 401F46AF07A
	for <lists+stable@lfdr.de>; Tue,  7 Mar 2023 19:30:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230139AbjCGSa5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Mar 2023 13:30:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59288 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230165AbjCGSaT (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Mar 2023 13:30:19 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 08141A56B0
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 10:23:46 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 74A0B61530
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 18:23:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6BBAEC433EF;
        Tue,  7 Mar 2023 18:23:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678213425;
        bh=TCyPAF0V9tl7bAnqT4F7JiM4lT2HyLsF6nTnFs3uIDQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WwAgx42Y/vypV1k4Iwq+9k9XcsxGBHK+T7Zq14orKFvFB19iH5CTAvHdhSnzqash/
         gCsdfYHcSBTyfKMiqO63dbyzOn1q92IHlSkABv+fwYs0fbtjaX/bljLgRk7IzFGHQ/
         Enkbpkxk5B5RO6txQMkg1Z9ptLz8WbYTzHdUKqo8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Shang XiaoJing <shangxiaojing@huawei.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 501/885] media: max9286: Fix memleak in max9286_v4l2_register()
Date:   Tue,  7 Mar 2023 17:57:15 +0100
Message-Id: <20230307170024.232522732@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307170001.594919529@linuxfoundation.org>
References: <20230307170001.594919529@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Shang XiaoJing <shangxiaojing@huawei.com>

[ Upstream commit 8636c5fc7658c7c6299fb8b352d24ea4b9ba99e2 ]

There is a kmemleak when testing the media/i2c/max9286.c with bpf mock
device:

kmemleak: 5 new suspected memory leaks (see /sys/kernel/debug/kmemleak)

unreferenced object 0xffff88810defc400 (size 256):
  comm "python3", pid 278, jiffies 4294737563 (age 31.978s)
  hex dump (first 32 bytes):
    28 06 a7 0a 81 88 ff ff 00 fe 22 12 81 88 ff ff  (.........".....
    10 c4 ef 0d 81 88 ff ff 10 c4 ef 0d 81 88 ff ff  ................
  backtrace:
    [<00000000191de6a7>] __kmalloc_node+0x44/0x1b0
    [<000000002f4912b7>] kvmalloc_node+0x34/0x180
    [<0000000057dc4cae>] v4l2_ctrl_new+0x325/0x10f0 [videodev]
    [<0000000026030272>] v4l2_ctrl_new_std+0x16f/0x210 [videodev]
    [<00000000f0d9ea2f>] max9286_probe+0x76e/0xbff [max9286]
    [<00000000ea8f6455>] i2c_device_probe+0x28d/0x680
    [<0000000087529af3>] really_probe+0x17c/0x3f0
    [<00000000b08be526>] __driver_probe_device+0xe3/0x170
    [<000000004382edea>] driver_probe_device+0x49/0x120
    [<000000007bde528a>] __device_attach_driver+0xf7/0x150
    [<000000009f9c6ab4>] bus_for_each_drv+0x114/0x180
    [<00000000c8aaf588>] __device_attach+0x1e5/0x2d0
    [<0000000041cc06b9>] bus_probe_device+0x126/0x140
    [<000000002309860d>] device_add+0x810/0x1130
    [<000000002827bf98>] i2c_new_client_device+0x359/0x4f0
    [<00000000593bdc85>] of_i2c_register_device+0xf1/0x110

max9286_v4l2_register() calls v4l2_ctrl_new_std(), but won't free the
created v412_ctrl when fwnode_graph_get_endpoint_by_id() failed, which
causes the memleak. Call v4l2_ctrl_handler_free() to free the v412_ctrl.

Fixes: 66d8c9d2422d ("media: i2c: Add MAX9286 driver")
Signed-off-by: Shang XiaoJing <shangxiaojing@huawei.com>
Reviewed-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
Signed-off-by: Mauro Carvalho Chehab <mchehab@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/i2c/max9286.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/media/i2c/max9286.c b/drivers/media/i2c/max9286.c
index 9c083cf142319..d034a67042e35 100644
--- a/drivers/media/i2c/max9286.c
+++ b/drivers/media/i2c/max9286.c
@@ -932,6 +932,7 @@ static int max9286_v4l2_register(struct max9286_priv *priv)
 err_put_node:
 	fwnode_handle_put(ep);
 err_async:
+	v4l2_ctrl_handler_free(&priv->ctrls);
 	max9286_v4l2_notifier_unregister(priv);
 
 	return ret;
-- 
2.39.2



