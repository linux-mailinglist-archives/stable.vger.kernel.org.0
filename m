Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1856B6B458B
	for <lists+stable@lfdr.de>; Fri, 10 Mar 2023 15:34:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232307AbjCJOej (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 10 Mar 2023 09:34:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38982 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232524AbjCJOec (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 10 Mar 2023 09:34:32 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 57D989E53F
        for <stable@vger.kernel.org>; Fri, 10 Mar 2023 06:34:30 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 0ADFFB822BF
        for <stable@vger.kernel.org>; Fri, 10 Mar 2023 14:34:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 334BBC4339B;
        Fri, 10 Mar 2023 14:34:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678458867;
        bh=bcUvaelcIR/fHDTJauh8j+glCKCOa9JiE5GgEkicGA4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GTvgne+Kjr/eXGXQ7fleqVHR2YDGIOZVJnqwb9QwifBjghCbyyFixSuVh3oLKev6R
         uzF1MPntl7pZP8Tp8v9II9+zDodC3OcepWWLSKXcZiwNq0aL9R7RoV2jPirv2W5Giw
         Utia3rf/1B6rK+DGEndcm96t2MdOCDLtPJjuPNNc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Shang XiaoJing <shangxiaojing@huawei.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 170/357] media: ov5675: Fix memleak in ov5675_init_controls()
Date:   Fri, 10 Mar 2023 14:37:39 +0100
Message-Id: <20230310133742.227316923@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230310133733.973883071@linuxfoundation.org>
References: <20230310133733.973883071@linuxfoundation.org>
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
index 1ae252378799e..477f61b8559c2 100644
--- a/drivers/media/i2c/ov5675.c
+++ b/drivers/media/i2c/ov5675.c
@@ -722,8 +722,10 @@ static int ov5675_init_controls(struct ov5675 *ov5675)
 				     V4L2_CID_TEST_PATTERN,
 				     ARRAY_SIZE(ov5675_test_pattern_menu) - 1,
 				     0, 0, ov5675_test_pattern_menu);
-	if (ctrl_hdlr->error)
+	if (ctrl_hdlr->error) {
+		v4l2_ctrl_handler_free(ctrl_hdlr);
 		return ctrl_hdlr->error;
+	}
 
 	ov5675->sd.ctrl_handler = ctrl_hdlr;
 
-- 
2.39.2



