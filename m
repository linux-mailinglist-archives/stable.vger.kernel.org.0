Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A13076AF3AB
	for <lists+stable@lfdr.de>; Tue,  7 Mar 2023 20:07:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233514AbjCGTHj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Mar 2023 14:07:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51668 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231474AbjCGTHT (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Mar 2023 14:07:19 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 26A9BA76A7
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 10:52:35 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C3ACEB819C5
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 18:52:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0747CC433D2;
        Tue,  7 Mar 2023 18:52:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678215152;
        bh=jDUBds/hVNSD6VJmJm1WR9oK9h9S+kyz2l/Dt+rfwvA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jExtt8HbcWv5soQErvD3c8g4HUswy650uNP4YfhRp1Ki6BuJExxssXNHWm3F0GA7r
         dD3S25LIVB+CTdlWXemdljWIkTIuC0xOyFRi+JTmxPYSlv/euyhnZY6U1eiQq4FGPo
         AD/VkmzlKuUPbjr8k9twPrOUAEp6SSZnf1KQMTb4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Yuan Can <yuancan@huawei.com>,
        Melissa Wen <mwen@igalia.com>,
        Melissa Wen <melissa.srw@gmail.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 169/567] drm/vkms: Fix memory leak in vkms_init()
Date:   Tue,  7 Mar 2023 17:58:25 +0100
Message-Id: <20230307165913.264967921@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307165905.838066027@linuxfoundation.org>
References: <20230307165905.838066027@linuxfoundation.org>
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

[ Upstream commit 0d0b368b9d104b437e1f4850ae94bdb9a3601e89 ]

A memory leak was reported after the vkms module install failed.

unreferenced object 0xffff88810bc28520 (size 16):
  comm "modprobe", pid 9662, jiffies 4298009455 (age 42.590s)
  hex dump (first 16 bytes):
    01 01 00 64 81 88 ff ff 00 00 dc 0a 81 88 ff ff  ...d............
  backtrace:
    [<00000000e7561ff8>] kmalloc_trace+0x27/0x60
    [<000000000b1954a0>] 0xffffffffc45200a9
    [<00000000abbf1da0>] do_one_initcall+0xd0/0x4f0
    [<000000001505ee87>] do_init_module+0x1a4/0x680
    [<00000000958079ad>] load_module+0x6249/0x7110
    [<00000000117e4696>] __do_sys_finit_module+0x140/0x200
    [<00000000f74b12d2>] do_syscall_64+0x35/0x80
    [<000000008fc6fcde>] entry_SYSCALL_64_after_hwframe+0x46/0xb0

The reason is that the vkms_init() returns without checking the return
value of vkms_create(), and if the vkms_create() failed, the config
allocated at the beginning of vkms_init() is leaked.

 vkms_init()
   config = kmalloc(...) # config allocated
   ...
   return vkms_create() # vkms_create failed and config is leaked

Fix this problem by checking return value of vkms_create() and free the
config if error happened.

Fixes: 2df7af93fdad ("drm/vkms: Add vkms_config type")
Signed-off-by: Yuan Can <yuancan@huawei.com>
Reviewed-by: Melissa Wen <mwen@igalia.com>
Signed-off-by: Melissa Wen <melissa.srw@gmail.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20221101065156.41584-2-yuancan@huawei.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/vkms/vkms_drv.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/vkms/vkms_drv.c b/drivers/gpu/drm/vkms/vkms_drv.c
index 0ffe5f0e33f75..dfe983eaa07ff 100644
--- a/drivers/gpu/drm/vkms/vkms_drv.c
+++ b/drivers/gpu/drm/vkms/vkms_drv.c
@@ -218,6 +218,7 @@ static int vkms_create(struct vkms_config *config)
 
 static int __init vkms_init(void)
 {
+	int ret;
 	struct vkms_config *config;
 
 	config = kmalloc(sizeof(*config), GFP_KERNEL);
@@ -230,7 +231,11 @@ static int __init vkms_init(void)
 	config->writeback = enable_writeback;
 	config->overlay = enable_overlay;
 
-	return vkms_create(config);
+	ret = vkms_create(config);
+	if (ret)
+		kfree(config);
+
+	return ret;
 }
 
 static void vkms_destroy(struct vkms_config *config)
-- 
2.39.2



