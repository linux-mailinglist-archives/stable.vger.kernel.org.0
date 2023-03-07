Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8D0BD6AF4AA
	for <lists+stable@lfdr.de>; Tue,  7 Mar 2023 20:18:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233600AbjCGTSZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Mar 2023 14:18:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44912 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233946AbjCGTSE (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Mar 2023 14:18:04 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 02CB4D6EAF
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 11:02:03 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id F2E90CE1C5D
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 19:02:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9B090C4339B;
        Tue,  7 Mar 2023 19:01:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678215720;
        bh=CgR1hQXIsEJsb0oCdsq5LOKU55QOgBWNAc9wOvTmEBQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ucRpur3YCBOMBkbooqB5WWMWAJX3Hu09wtM03NbiXhGC8Rg7mzEodm4pLcUWlxuo0
         P6Ss5PGJZCHtY1OZ6vC4kS9Hl7JTxs5xPcLxwbbyMTkjbq8mUuVwW3q1q6kIYueGty
         z7xunnWO6VrQHZU48SDbqIyBNiJBPh+qs2gi3KDA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Shang XiaoJing <shangxiaojing@huawei.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 352/567] media: ov2740: Fix memleak in ov2740_init_controls()
Date:   Tue,  7 Mar 2023 18:01:28 +0100
Message-Id: <20230307165921.126657848@linuxfoundation.org>
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
index 934c9d65cb097..4b1ab3e07910e 100644
--- a/drivers/media/i2c/ov2740.c
+++ b/drivers/media/i2c/ov2740.c
@@ -603,8 +603,10 @@ static int ov2740_init_controls(struct ov2740 *ov2740)
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



