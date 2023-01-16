Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0E25066CCEE
	for <lists+stable@lfdr.de>; Mon, 16 Jan 2023 18:31:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234747AbjAPRbG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Jan 2023 12:31:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53298 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234807AbjAPRai (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 Jan 2023 12:30:38 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1ED463D080
        for <stable@vger.kernel.org>; Mon, 16 Jan 2023 09:07:43 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B052A61058
        for <stable@vger.kernel.org>; Mon, 16 Jan 2023 17:07:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C41B9C433D2;
        Mon, 16 Jan 2023 17:07:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1673888862;
        bh=gl4tJKknsbemXsvsJFKPhl4r00gmBAcGpnTDMPFDXDc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KIsiTSGP76y2EMgxFmSQ+Qu7oAsqkJ1sGhas/evU4k38F3wD46iVez5V35yBiBaHa
         xcdy+Fk9hO4yZGAZdiwo09Oj/0+PL/EJrPhWp1ncYIG1ArkJ7khEVL6ChEW5SWbAA1
         RjXuqnm71NPQY+VzZHSjsysxuexDxgxXW4I96a2M=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Zhengchao Shao <shaozhengchao@huawei.com>,
        Luis Chamberlain <mcgrof@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 167/338] test_firmware: fix memory leak in test_firmware_init()
Date:   Mon, 16 Jan 2023 16:50:40 +0100
Message-Id: <20230116154828.172534279@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230116154820.689115727@linuxfoundation.org>
References: <20230116154820.689115727@linuxfoundation.org>
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

[ Upstream commit 7610615e8cdb3f6f5bbd9d8e7a5d8a63e3cabf2e ]

When misc_register() failed in test_firmware_init(), the memory pointed
by test_fw_config->name is not released. The memory leak information is
as follows:
unreferenced object 0xffff88810a34cb00 (size 32):
  comm "insmod", pid 7952, jiffies 4294948236 (age 49.060s)
  hex dump (first 32 bytes):
    74 65 73 74 2d 66 69 72 6d 77 61 72 65 2e 62 69  test-firmware.bi
    6e 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  n...............
  backtrace:
    [<ffffffff81b21fcb>] __kmalloc_node_track_caller+0x4b/0xc0
    [<ffffffff81affb96>] kstrndup+0x46/0xc0
    [<ffffffffa0403a49>] __test_firmware_config_init+0x29/0x380 [test_firmware]
    [<ffffffffa040f068>] 0xffffffffa040f068
    [<ffffffff81002c41>] do_one_initcall+0x141/0x780
    [<ffffffff816a72c3>] do_init_module+0x1c3/0x630
    [<ffffffff816adb9e>] load_module+0x623e/0x76a0
    [<ffffffff816af471>] __do_sys_finit_module+0x181/0x240
    [<ffffffff89978f99>] do_syscall_64+0x39/0xb0
    [<ffffffff89a0008b>] entry_SYSCALL_64_after_hwframe+0x63/0xcd

Fixes: c92316bf8e94 ("test_firmware: add batched firmware tests")
Signed-off-by: Zhengchao Shao <shaozhengchao@huawei.com>
Acked-by: Luis Chamberlain <mcgrof@kernel.org>
Link: https://lore.kernel.org/r/20221119035721.18268-1-shaozhengchao@huawei.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 lib/test_firmware.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/lib/test_firmware.c b/lib/test_firmware.c
index 2e5e18bbfd28..1c5e5246bf10 100644
--- a/lib/test_firmware.c
+++ b/lib/test_firmware.c
@@ -903,6 +903,7 @@ static int __init test_firmware_init(void)
 
 	rc = misc_register(&test_fw_misc_device);
 	if (rc) {
+		__test_firmware_config_free();
 		kfree(test_fw_config);
 		pr_err("could not register misc device: %d\n", rc);
 		return rc;
-- 
2.35.1



