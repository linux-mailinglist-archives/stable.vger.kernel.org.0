Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A6B106355BD
	for <lists+stable@lfdr.de>; Wed, 23 Nov 2022 10:24:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237571AbiKWJXZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 23 Nov 2022 04:23:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37196 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237614AbiKWJW5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 23 Nov 2022 04:22:57 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A3D5110CEAB
        for <stable@vger.kernel.org>; Wed, 23 Nov 2022 01:22:11 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 54DCCB81EF6
        for <stable@vger.kernel.org>; Wed, 23 Nov 2022 09:22:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 78734C433D6;
        Wed, 23 Nov 2022 09:22:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1669195329;
        bh=PeH0bQ5hq3OYDgHLt4GIjlCYjOdRkgAUNW2des0hxPA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=oGPOzNviLe1Dhm7kzmKK2VgxdQ03VQ1c0YIvhO5Zx/dxbcBtnigRNAWfqNNWJfioz
         kk8s/9ypfRdWUS8Ott4teo8sEbkmYXudRJAYv7MVTg0XuFA6uedTFq1yf14jIsi4By
         eryF/hla25fadx51uVCjI8+T/SjVIHuwOln0aqyA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Shang XiaoJing <shangxiaojing@huawei.com>,
        Lyude Paul <lyude@redhat.com>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 053/149] drm/drv: Fix potential memory leak in drm_dev_init()
Date:   Wed, 23 Nov 2022 09:50:36 +0100
Message-Id: <20221123084559.837742649@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221123084557.945845710@linuxfoundation.org>
References: <20221123084557.945845710@linuxfoundation.org>
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

From: Shang XiaoJing <shangxiaojing@huawei.com>

[ Upstream commit ff963634f7b2e0dc011349abb3fb81a0d074f443 ]

drm_dev_init() will add drm_dev_init_release() as a callback. When
drmm_add_action() failed, the release function won't be added. As the
result, the ref cnt added by device_get() in drm_dev_init() won't be put
by drm_dev_init_release(), which leads to the memleak. Use
drmm_add_action_or_reset() instead of drmm_add_action() to prevent
memleak.

unreferenced object 0xffff88810bc0c800 (size 2048):
  comm "modprobe", pid 8322, jiffies 4305809845 (age 15.292s)
  hex dump (first 32 bytes):
    e8 cc c0 0b 81 88 ff ff ff ff ff ff 00 00 00 00  ................
    20 24 3c 0c 81 88 ff ff 18 c8 c0 0b 81 88 ff ff   $<.............
  backtrace:
    [<000000007251f72d>] __kmalloc+0x4b/0x1c0
    [<0000000045f21f26>] platform_device_alloc+0x2d/0xe0
    [<000000004452a479>] platform_device_register_full+0x24/0x1c0
    [<0000000089f4ea61>] 0xffffffffa0736051
    [<00000000235b2441>] do_one_initcall+0x7a/0x380
    [<0000000001a4a177>] do_init_module+0x5c/0x230
    [<000000002bf8a8e2>] load_module+0x227d/0x2420
    [<00000000637d6d0a>] __do_sys_finit_module+0xd5/0x140
    [<00000000c99fc324>] do_syscall_64+0x3f/0x90
    [<000000004d85aa77>] entry_SYSCALL_64_after_hwframe+0x63/0xcd

Fixes: 2cbf7fc6718b ("drm: Use drmm_ for drm_dev_init cleanup")
Signed-off-by: Shang XiaoJing <shangxiaojing@huawei.com>
Reviewed-by: Lyude Paul <lyude@redhat.com>
Signed-off-by: Lyude Paul <lyude@redhat.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20221101070716.9189-2-shangxiaojing@huawei.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/drm_drv.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/drm_drv.c b/drivers/gpu/drm/drm_drv.c
index 006e3b896cae..4ca995ce19af 100644
--- a/drivers/gpu/drm/drm_drv.c
+++ b/drivers/gpu/drm/drm_drv.c
@@ -610,7 +610,7 @@ static int drm_dev_init(struct drm_device *dev,
 	mutex_init(&dev->clientlist_mutex);
 	mutex_init(&dev->master_mutex);
 
-	ret = drmm_add_action(dev, drm_dev_init_release, NULL);
+	ret = drmm_add_action_or_reset(dev, drm_dev_init_release, NULL);
 	if (ret)
 		return ret;
 
-- 
2.35.1



