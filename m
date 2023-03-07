Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7B2426AF4AD
	for <lists+stable@lfdr.de>; Tue,  7 Mar 2023 20:18:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233749AbjCGTS2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Mar 2023 14:18:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42138 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233826AbjCGTSK (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Mar 2023 14:18:10 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F1C19BCB89
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 11:02:05 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 64C89B8199A
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 19:02:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A3B4EC433D2;
        Tue,  7 Mar 2023 19:02:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678215723;
        bh=0va78jl4UDs+/hwjhcE0ukICzgxufnnQt0OzOOgLtxI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=o0vpzY3zbznom18UpMB3vJLBwE7G9W5jJArK1Yv98GZfXmgVB1Uv7TsHXSXEFYYTk
         dNRnljKYGApOw+5PpzyHOCFYADta13VAvy77PRGjiPkwboqW8di1WcEOOkPsuOEmKA
         C0eMvZQROyI7Miu7HXPIl6qKU3HmvpvrUAxLGVYY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Shang XiaoJing <shangxiaojing@huawei.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 353/567] media: ov5675: Fix memleak in ov5675_init_controls()
Date:   Tue,  7 Mar 2023 18:01:29 +0100
Message-Id: <20230307165921.173686343@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307165905.838066027@linuxfoundation.org>
References: <20230307165905.838066027@linuxfoundation.org>
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

[ Upstream commit dd74ed6c213003533e3abf4c204374ef01d86978 ]

There is a kmemleak when testing the media/i2c/ov5675.c with bpf mock
device:

AssertionError: unreferenced object 0xffff888107362160 (size 16):
  comm "python3", pid 277, jiffies 4294832798 (age 20.722s)
  hex dump (first 16 bytes):
    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
  backtrace:
    [<00000000abe7d67c>] __kmalloc_node+0x44/0x1b0
    [<000000008a725aac>] kvmalloc_node+0x34/0x180
    [<000000009a53cd11>] v4l2_ctrl_handler_init_class+0x11d/0x180
[videodev]
    [<0000000055b46db0>] ov5675_probe+0x38b/0x897 [ov5675]
    [<00000000153d886c>] i2c_device_probe+0x28d/0x680
    [<000000004afb7e8f>] really_probe+0x17c/0x3f0
    [<00000000ff2f18e4>] __driver_probe_device+0xe3/0x170
    [<000000000a001029>] driver_probe_device+0x49/0x120
    [<00000000e39743c7>] __device_attach_driver+0xf7/0x150
    [<00000000d32fd070>] bus_for_each_drv+0x114/0x180
    [<000000009083ac41>] __device_attach+0x1e5/0x2d0
    [<0000000015b4a830>] bus_probe_device+0x126/0x140
    [<000000007813deaf>] device_add+0x810/0x1130
    [<000000007becb867>] i2c_new_client_device+0x386/0x540
    [<000000007f9cf4b4>] of_i2c_register_device+0xf1/0x110
    [<00000000ebfdd032>] of_i2c_notify+0xfc/0x1f0

ov5675_init_controls() won't clean all the allocated resources in fail
path, which may causes the memleaks. Add v4l2_ctrl_handler_free() to
prevent memleak.

Fixes: bf27502b1f3b ("media: ov5675: Add support for OV5675 sensor")
Signed-off-by: Shang XiaoJing <shangxiaojing@huawei.com>
Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
Signed-off-by: Mauro Carvalho Chehab <mchehab@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/i2c/ov5675.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/media/i2c/ov5675.c b/drivers/media/i2c/ov5675.c
index da5850b7ad07f..2104589dd4343 100644
--- a/drivers/media/i2c/ov5675.c
+++ b/drivers/media/i2c/ov5675.c
@@ -791,8 +791,10 @@ static int ov5675_init_controls(struct ov5675 *ov5675)
 	v4l2_ctrl_new_std(ctrl_hdlr, &ov5675_ctrl_ops,
 			  V4L2_CID_VFLIP, 0, 1, 1, 0);
 
-	if (ctrl_hdlr->error)
+	if (ctrl_hdlr->error) {
+		v4l2_ctrl_handler_free(ctrl_hdlr);
 		return ctrl_hdlr->error;
+	}
 
 	ov5675->sd.ctrl_handler = ctrl_hdlr;
 
-- 
2.39.2



