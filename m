Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C3D9A60FE55
	for <lists+stable@lfdr.de>; Thu, 27 Oct 2022 19:04:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236913AbiJ0REb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 27 Oct 2022 13:04:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58868 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236910AbiJ0RE2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 27 Oct 2022 13:04:28 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8479E1D7
        for <stable@vger.kernel.org>; Thu, 27 Oct 2022 10:04:25 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 23AEC623D8
        for <stable@vger.kernel.org>; Thu, 27 Oct 2022 17:04:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 38A11C433D7;
        Thu, 27 Oct 2022 17:04:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666890264;
        bh=027BP/7fywPWtdlNB7x17qJFKRv4BfoIleyg2digxe8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=o2KE+WVy/EMEb1Wl98cN8sIWlQNiyjv/f/DprtaQu8kEYmHwAK+5NImVQLL9cX0X+
         KsSvDH1apmg56kWvMf/aifmMXT377kJYSggWlh7h2PYZGpMqOm/hKtZiduCZVawtTA
         expkdeWSvfvvVyMAUQoxwrENl/4Vkd13dPlgpW9g=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Yang Yingliang <yangyingliang@huawei.com>,
        Leon Romanovsky <leonro@nvidia.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 62/79] net: hns: fix possible memory leak in hnae_ae_register()
Date:   Thu, 27 Oct 2022 18:56:00 +0200
Message-Id: <20221027165056.983680795@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221027165054.917467648@linuxfoundation.org>
References: <20221027165054.917467648@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Yang Yingliang <yangyingliang@huawei.com>

[ Upstream commit ff2f5ec5d009844ec28f171123f9e58750cef4bf ]

Inject fault while probing module, if device_register() fails,
but the refcount of kobject is not decreased to 0, the name
allocated in dev_set_name() is leaked. Fix this by calling
put_device(), so that name can be freed in callback function
kobject_cleanup().

unreferenced object 0xffff00c01aba2100 (size 128):
  comm "systemd-udevd", pid 1259, jiffies 4294903284 (age 294.152s)
  hex dump (first 32 bytes):
    68 6e 61 65 30 00 00 00 18 21 ba 1a c0 00 ff ff  hnae0....!......
    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
  backtrace:
    [<0000000034783f26>] slab_post_alloc_hook+0xa0/0x3e0
    [<00000000748188f2>] __kmem_cache_alloc_node+0x164/0x2b0
    [<00000000ab0743e8>] __kmalloc_node_track_caller+0x6c/0x390
    [<000000006c0ffb13>] kvasprintf+0x8c/0x118
    [<00000000fa27bfe1>] kvasprintf_const+0x60/0xc8
    [<0000000083e10ed7>] kobject_set_name_vargs+0x3c/0xc0
    [<000000000b87affc>] dev_set_name+0x7c/0xa0
    [<000000003fd8fe26>] hnae_ae_register+0xcc/0x190 [hnae]
    [<00000000fe97edc9>] hns_dsaf_ae_init+0x9c/0x108 [hns_dsaf]
    [<00000000c36ff1eb>] hns_dsaf_probe+0x548/0x748 [hns_dsaf]

Fixes: 6fe6611ff275 ("net: add Hisilicon Network Subsystem hnae framework support")
Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
Reviewed-by: Leon Romanovsky <leonro@nvidia.com>
Link: https://lore.kernel.org/r/20221018122451.1749171-1-yangyingliang@huawei.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/hisilicon/hns/hnae.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/hisilicon/hns/hnae.c b/drivers/net/ethernet/hisilicon/hns/hnae.c
index 00fafc0f8512..430eccea8e5e 100644
--- a/drivers/net/ethernet/hisilicon/hns/hnae.c
+++ b/drivers/net/ethernet/hisilicon/hns/hnae.c
@@ -419,8 +419,10 @@ int hnae_ae_register(struct hnae_ae_dev *hdev, struct module *owner)
 	hdev->cls_dev.release = hnae_release;
 	(void)dev_set_name(&hdev->cls_dev, "hnae%d", hdev->id);
 	ret = device_register(&hdev->cls_dev);
-	if (ret)
+	if (ret) {
+		put_device(&hdev->cls_dev);
 		return ret;
+	}
 
 	__module_get(THIS_MODULE);
 
-- 
2.35.1



