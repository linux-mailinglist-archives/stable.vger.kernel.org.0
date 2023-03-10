Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A388D6B4406
	for <lists+stable@lfdr.de>; Fri, 10 Mar 2023 15:20:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232125AbjCJOUw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 10 Mar 2023 09:20:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34382 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232132AbjCJOUf (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 10 Mar 2023 09:20:35 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9865D119FA7
        for <stable@vger.kernel.org>; Fri, 10 Mar 2023 06:19:05 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 4C945B822C0
        for <stable@vger.kernel.org>; Fri, 10 Mar 2023 14:19:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8F3BEC433D2;
        Fri, 10 Mar 2023 14:19:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678457943;
        bh=34p6pUekLLRF8oI1vy9aTu5Ltjgeq5q4dDzHUeu50vg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=npBpM6Q6LeHxT14eor2Bnj5s6adJZU5sgH+/4PX+vf/f1IW1avpuUyW9Dd9QdqAhH
         k2CE/xpxxxU4lthXo9nfMRfXAYwYJqpukJsBIgD2MSyDu/eOvWweraX3VSqhPB5KVw
         GiN4VX/FCaoJDeGGqZqh7Yw27wAAhhnlxuP6y7q8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Yuan Can <yuancan@huawei.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 110/252] media: i2c: ov772x: Fix memleak in ov772x_probe()
Date:   Fri, 10 Mar 2023 14:38:00 +0100
Message-Id: <20230310133722.130102751@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230310133718.803482157@linuxfoundation.org>
References: <20230310133718.803482157@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Yuan Can <yuancan@huawei.com>

[ Upstream commit 7485edb2b6ca5960205c0a49bedfd09bba30e521 ]

A memory leak was reported when testing ov772x with bpf mock device:

AssertionError: unreferenced object 0xffff888109afa7a8 (size 8):
  comm "python3", pid 279, jiffies 4294805921 (age 20.681s)
  hex dump (first 8 bytes):
    80 22 88 15 81 88 ff ff                          ."......
  backtrace:
    [<000000009990b438>] __kmalloc_node+0x44/0x1b0
    [<000000009e32f7d7>] kvmalloc_node+0x34/0x180
    [<00000000faf48134>] v4l2_ctrl_handler_init_class+0x11d/0x180 [videodev]
    [<00000000da376937>] ov772x_probe+0x1c3/0x68c [ov772x]
    [<000000003f0d225e>] i2c_device_probe+0x28d/0x680
    [<00000000e0b6db89>] really_probe+0x17c/0x3f0
    [<000000001b19fcee>] __driver_probe_device+0xe3/0x170
    [<0000000048370519>] driver_probe_device+0x49/0x120
    [<000000005ead07a0>] __device_attach_driver+0xf7/0x150
    [<0000000043f452b8>] bus_for_each_drv+0x114/0x180
    [<00000000358e5596>] __device_attach+0x1e5/0x2d0
    [<0000000043f83c5d>] bus_probe_device+0x126/0x140
    [<00000000ee0f3046>] device_add+0x810/0x1130
    [<00000000e0278184>] i2c_new_client_device+0x359/0x4f0
    [<0000000070baf34f>] of_i2c_register_device+0xf1/0x110
    [<00000000a9f2159d>] of_i2c_notify+0x100/0x160
unreferenced object 0xffff888119825c00 (size 256):
  comm "python3", pid 279, jiffies 4294805921 (age 20.681s)
  hex dump (first 32 bytes):
    00 b4 a5 17 81 88 ff ff 00 5e 82 19 81 88 ff ff  .........^......
    10 5c 82 19 81 88 ff ff 10 5c 82 19 81 88 ff ff  .\.......\......
  backtrace:
    [<000000009990b438>] __kmalloc_node+0x44/0x1b0
    [<000000009e32f7d7>] kvmalloc_node+0x34/0x180
    [<0000000073d88e0b>] v4l2_ctrl_new.cold+0x19b/0x86f [videodev]
    [<00000000b1f576fb>] v4l2_ctrl_new_std+0x16f/0x210 [videodev]
    [<00000000caf7ac99>] ov772x_probe+0x1fa/0x68c [ov772x]
    [<000000003f0d225e>] i2c_device_probe+0x28d/0x680
    [<00000000e0b6db89>] really_probe+0x17c/0x3f0
    [<000000001b19fcee>] __driver_probe_device+0xe3/0x170
    [<0000000048370519>] driver_probe_device+0x49/0x120
    [<000000005ead07a0>] __device_attach_driver+0xf7/0x150
    [<0000000043f452b8>] bus_for_each_drv+0x114/0x180
    [<00000000358e5596>] __device_attach+0x1e5/0x2d0
    [<0000000043f83c5d>] bus_probe_device+0x126/0x140
    [<00000000ee0f3046>] device_add+0x810/0x1130
    [<00000000e0278184>] i2c_new_client_device+0x359/0x4f0
    [<0000000070baf34f>] of_i2c_register_device+0xf1/0x110

The reason is that if priv->hdl.error is set, ov772x_probe() jumps to the
error_mutex_destroy without doing v4l2_ctrl_handler_free(), and all
resources allocated in v4l2_ctrl_handler_init() and v4l2_ctrl_new_std()
are leaked.

Fixes: 1112babde214 ("media: i2c: Copy ov772x soc_camera sensor driver")
Signed-off-by: Yuan Can <yuancan@huawei.com>
Reviewed-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
Signed-off-by: Mauro Carvalho Chehab <mchehab@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/i2c/ov772x.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/media/i2c/ov772x.c b/drivers/media/i2c/ov772x.c
index 4eae5f2f7d318..11deaec9afbfb 100644
--- a/drivers/media/i2c/ov772x.c
+++ b/drivers/media/i2c/ov772x.c
@@ -1424,7 +1424,7 @@ static int ov772x_probe(struct i2c_client *client,
 	priv->subdev.ctrl_handler = &priv->hdl;
 	if (priv->hdl.error) {
 		ret = priv->hdl.error;
-		goto error_mutex_destroy;
+		goto error_ctrl_free;
 	}
 
 	priv->clk = clk_get(&client->dev, NULL);
@@ -1473,7 +1473,6 @@ static int ov772x_probe(struct i2c_client *client,
 	clk_put(priv->clk);
 error_ctrl_free:
 	v4l2_ctrl_handler_free(&priv->hdl);
-error_mutex_destroy:
 	mutex_destroy(&priv->lock);
 
 	return ret;
-- 
2.39.2



