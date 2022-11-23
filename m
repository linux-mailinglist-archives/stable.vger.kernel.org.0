Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 74CB76357E3
	for <lists+stable@lfdr.de>; Wed, 23 Nov 2022 10:48:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238199AbiKWJrO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 23 Nov 2022 04:47:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39040 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238316AbiKWJq4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 23 Nov 2022 04:46:56 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EE2D11173E0
        for <stable@vger.kernel.org>; Wed, 23 Nov 2022 01:44:05 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5FFB161B6D
        for <stable@vger.kernel.org>; Wed, 23 Nov 2022 09:44:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 56BC9C433C1;
        Wed, 23 Nov 2022 09:44:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1669196644;
        bh=BF5gCBuwH1W1K/AC5czjDoMzPEtYB1ue6ySDL3syHx8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qRzDCj6OR4atqtZTtbZ3ULXBw1unR7MYt1QKEXWXgKob6oJDu62ySldbVta0W/EfA
         Bc0h2vvXBsHFPrz+gE8pSWZqzwcJoAyY3ofA6Vkgek2d0rpnfRcKJwOQ5WxCQcM7Kt
         P2LdybuphdoThetXZnIw7FDOtVe8NzPvVD3HPyVQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Chen Zhongjin <chenzhongjin@huawei.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 088/314] ASoC: core: Fix use-after-free in snd_soc_exit()
Date:   Wed, 23 Nov 2022 09:48:53 +0100
Message-Id: <20221123084629.465385978@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221123084625.457073469@linuxfoundation.org>
References: <20221123084625.457073469@linuxfoundation.org>
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

From: Chen Zhongjin <chenzhongjin@huawei.com>

[ Upstream commit 6ec27c53886c8963729885bcf2dd996eba2767a7 ]

KASAN reports a use-after-free:

BUG: KASAN: use-after-free in device_del+0xb5b/0xc60
Read of size 8 at addr ffff888008655050 by task rmmod/387
CPU: 2 PID: 387 Comm: rmmod
Hardware name: QEMU Standard PC (i440FX + PIIX, 1996)
Call Trace:
<TASK>
dump_stack_lvl+0x79/0x9a
print_report+0x17f/0x47b
kasan_report+0xbb/0xf0
device_del+0xb5b/0xc60
platform_device_del.part.0+0x24/0x200
platform_device_unregister+0x2e/0x40
snd_soc_exit+0xa/0x22 [snd_soc_core]
__do_sys_delete_module.constprop.0+0x34f/0x5b0
do_syscall_64+0x3a/0x90
entry_SYSCALL_64_after_hwframe+0x63/0xcd
...
</TASK>

It's bacause in snd_soc_init(), snd_soc_util_init() is possble to fail,
but its ret is ignored, which makes soc_dummy_dev unregistered twice.

snd_soc_init()
    snd_soc_util_init()
        platform_device_register_simple(soc_dummy_dev)
        platform_driver_register() # fail
    	platform_device_unregister(soc_dummy_dev)
    platform_driver_register() # success
...
snd_soc_exit()
    snd_soc_util_exit()
    # soc_dummy_dev will be unregistered for second time

To fix it, handle error and stop snd_soc_init() when util_init() fail.
Also clean debugfs when util_init() or driver_register() fail.

Fixes: fb257897bf20 ("ASoC: Work around allmodconfig failure")
Signed-off-by: Chen Zhongjin <chenzhongjin@huawei.com>
Link: https://lore.kernel.org/r/20221028031603.59416-1-chenzhongjin@huawei.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/soc-core.c | 17 +++++++++++++++--
 1 file changed, 15 insertions(+), 2 deletions(-)

diff --git a/sound/soc/soc-core.c b/sound/soc/soc-core.c
index e824ff1a9fc0..3d057784cbd5 100644
--- a/sound/soc/soc-core.c
+++ b/sound/soc/soc-core.c
@@ -3472,10 +3472,23 @@ EXPORT_SYMBOL_GPL(snd_soc_of_get_dai_link_cpus);
 
 static int __init snd_soc_init(void)
 {
+	int ret;
+
 	snd_soc_debugfs_init();
-	snd_soc_util_init();
+	ret = snd_soc_util_init();
+	if (ret)
+		goto err_util_init;
 
-	return platform_driver_register(&soc_driver);
+	ret = platform_driver_register(&soc_driver);
+	if (ret)
+		goto err_register;
+	return 0;
+
+err_register:
+	snd_soc_util_exit();
+err_util_init:
+	snd_soc_debugfs_exit();
+	return ret;
 }
 module_init(snd_soc_init);
 
-- 
2.35.1



