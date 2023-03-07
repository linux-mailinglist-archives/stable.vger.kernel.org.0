Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D32E46AEB2F
	for <lists+stable@lfdr.de>; Tue,  7 Mar 2023 18:41:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232025AbjCGRlE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Mar 2023 12:41:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53112 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231825AbjCGRkm (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Mar 2023 12:40:42 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 23BA295BF6
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 09:36:54 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B406761520
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 17:36:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A985DC433D2;
        Tue,  7 Mar 2023 17:36:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678210613;
        bh=8/rdtPe9n9y43FVsY++N0c1WC9ENPbCSQ7qnTrT30Ks=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=iNihrB1QcI6lfYfapVfwgwJgVONrM511LIBg3mGFjVsZ/LRRmXH1N0ocW17gUoryN
         sM+hhHtPhWTfx/Q8ahekDW8ExrycZleXsxmoqtYzsv+5c/SicqC4GX+k5p4edByR7u
         wfe+fRLmwk+Qct99VZ8wpeRU6VC3DTp+7awikyh0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Shang XiaoJing <shangxiaojing@huawei.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.2 0590/1001] media: ov2740: Fix memleak in ov2740_init_controls()
Date:   Tue,  7 Mar 2023 17:56:02 +0100
Message-Id: <20230307170047.105936299@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307170022.094103862@linuxfoundation.org>
References: <20230307170022.094103862@linuxfoundation.org>
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

[ Upstream commit 2d899592ed7829d0d5140853bac4d58742a6b8af ]

There is a kmemleak when testing the media/i2c/ov2740.c with bpf mock
device:

unreferenced object 0xffff8881090e19e0 (size 16):
  comm "51-i2c-ov2740", pid 278, jiffies 4294781584 (age 23.613s)
  hex dump (first 16 bytes):
    00 f3 7c 0b 81 88 ff ff 80 75 6a 09 81 88 ff ff  ..|......uj.....
  backtrace:
    [<000000004e9fad8f>] __kmalloc_node+0x44/0x1b0
    [<0000000039c802f4>] kvmalloc_node+0x34/0x180
    [<000000009b8b5c63>] v4l2_ctrl_handler_init_class+0x11d/0x180
[videodev]
    [<0000000038644056>] ov2740_probe+0x37d/0x84f [ov2740]
    [<0000000092489f59>] i2c_device_probe+0x28d/0x680
    [<000000001038babe>] really_probe+0x17c/0x3f0
    [<0000000098c7af1c>] __driver_probe_device+0xe3/0x170
    [<00000000e1b3dc24>] device_driver_attach+0x34/0x80
    [<000000005a04a34d>] bind_store+0x10b/0x1a0
    [<00000000ce25d4f2>] drv_attr_store+0x49/0x70
    [<000000007d9f4e9a>] sysfs_kf_write+0x8c/0xb0
    [<00000000be6cff0f>] kernfs_fop_write_iter+0x216/0x2e0
    [<0000000031ddb40a>] vfs_write+0x658/0x810
    [<0000000041beecdd>] ksys_write+0xd6/0x1b0
    [<0000000023755840>] do_syscall_64+0x38/0x90
    [<00000000b2cc2da2>] entry_SYSCALL_64_after_hwframe+0x63/0xcd

ov2740_init_controls() won't clean all the allocated resources in fail
path, which may causes the memleaks. Add v4l2_ctrl_handler_free() to
prevent memleak.

Fixes: 866edc895171 ("media: i2c: Add ov2740 image sensor driver")
Signed-off-by: Shang XiaoJing <shangxiaojing@huawei.com>
Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
Signed-off-by: Mauro Carvalho Chehab <mchehab@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/i2c/ov2740.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/media/i2c/ov2740.c b/drivers/media/i2c/ov2740.c
index f3731f932a946..89d126240c345 100644
--- a/drivers/media/i2c/ov2740.c
+++ b/drivers/media/i2c/ov2740.c
@@ -629,8 +629,10 @@ static int ov2740_init_controls(struct ov2740 *ov2740)
 				     V4L2_CID_TEST_PATTERN,
 				     ARRAY_SIZE(ov2740_test_pattern_menu) - 1,
 				     0, 0, ov2740_test_pattern_menu);
-	if (ctrl_hdlr->error)
+	if (ctrl_hdlr->error) {
+		v4l2_ctrl_handler_free(ctrl_hdlr);
 		return ctrl_hdlr->error;
+	}
 
 	ov2740->sd.ctrl_handler = ctrl_hdlr;
 
-- 
2.39.2



