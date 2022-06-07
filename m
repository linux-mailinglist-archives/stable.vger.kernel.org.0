Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C654E54186A
	for <lists+stable@lfdr.de>; Tue,  7 Jun 2022 23:12:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1379746AbiFGVMT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 17:12:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35622 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1380193AbiFGVLk (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 17:11:40 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A0AC8218A89;
        Tue,  7 Jun 2022 11:53:29 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3E762612F2;
        Tue,  7 Jun 2022 18:53:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 162D4C3411C;
        Tue,  7 Jun 2022 18:53:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654628008;
        bh=gxsFb/v4AB0XAGjYM+rRf9p/fUvFDHFjqtE2n2EA7VY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JwEmA+gVAT75aFumcK5mpIS/emo2qNv6a7VjSI45Ln2QSre+BBhXci662v9sSDvDE
         /OQEN/AQNXGSOTX9actkI7KqeyJf6zcd7jHUY+FQfZoKIC4KDOGvFwlhrH9VuvTdB9
         dCVCUS9NSE9kNLER2aQ3ArvGqwgHsyiIVEW+rl30=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Yunfei Dong <yunfei.dong@mediatek.com>,
        "=?UTF-8?q?N=C3=ADcolas=20F . =20R . =20A . =20Prado?=" 
        <nfraprado@collabora.com>, Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.18 173/879] media: mediatek: vcodec: prevent kernel crash when rmmod mtk-vcodec-dec.ko
Date:   Tue,  7 Jun 2022 18:54:51 +0200
Message-Id: <20220607165007.735114915@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220607165002.659942637@linuxfoundation.org>
References: <20220607165002.659942637@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAD_ENC_HEADER,BAYES_00,
        DKIMWL_WL_HIGH,DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Yunfei Dong <yunfei.dong@mediatek.com>

[ Upstream commit c10c0086db688c95bb4e0e378e523818dff1551d ]

If the driver support subdev mode, the parameter "dev->pm.dev" will be
NULL in mtk_vcodec_dec_remove. Kernel will crash when try to rmmod
mtk-vcodec-dec.ko.

[ 4380.702726] pc : do_raw_spin_trylock+0x4/0x80
[ 4380.707075] lr : _raw_spin_lock_irq+0x90/0x14c
[ 4380.711509] sp : ffff80000819bc10
[ 4380.714811] x29: ffff80000819bc10 x28: ffff3600c03e4000 x27: 0000000000000000
[ 4380.721934] x26: 0000000000000000 x25: 0000000000000000 x24: 0000000000000000
[ 4380.729057] x23: ffff3600c0f34930 x22: ffffd5e923549000 x21: 0000000000000220
[ 4380.736179] x20: 0000000000000208 x19: ffffd5e9213e8ebc x18: 0000000000000020
[ 4380.743298] x17: 0000002000000000 x16: ffffd5e9213e8e90 x15: 696c346f65646976
[ 4380.750420] x14: 0000000000000000 x13: 0000000000000001 x12: 0000000000000040
[ 4380.757542] x11: 0000000000000000 x10: 0000000000000000 x9 : 0000000000000000
[ 4380.764664] x8 : 0000000000000000 x7 : ffff3600c7273ae8 x6 : ffffd5e9213e8ebc
[ 4380.771786] x5 : 0000000000000000 x4 : 0000000000000001 x3 : 0000000000000000
[ 4380.778908] x2 : 0000000000000000 x1 : ffff3600c03e4000 x0 : 0000000000000208
[ 4380.786031] Call trace:
[ 4380.788465]  do_raw_spin_trylock+0x4/0x80
[ 4380.792462]  __pm_runtime_disable+0x2c/0x1b0
[ 4380.796723]  mtk_vcodec_dec_remove+0x5c/0xa0 [mtk_vcodec_dec]
[ 4380.802466]  platform_remove+0x2c/0x60
[ 4380.806204]  __device_release_driver+0x194/0x250
[ 4380.810810]  driver_detach+0xc8/0x15c
[ 4380.814462]  bus_remove_driver+0x5c/0xb0
[ 4380.818375]  driver_unregister+0x34/0x64
[ 4380.822288]  platform_driver_unregister+0x18/0x24
[ 4380.826979]  mtk_vcodec_dec_driver_exit+0x1c/0x888 [mtk_vcodec_dec]
[ 4380.833240]  __arm64_sys_delete_module+0x190/0x224
[ 4380.838020]  invoke_syscall+0x48/0x114
[ 4380.841760]  el0_svc_common.constprop.0+0x60/0x11c
[ 4380.846540]  do_el0_svc+0x28/0x90
[ 4380.849844]  el0_svc+0x4c/0x100
[ 4380.852975]  el0t_64_sync_handler+0xec/0xf0
[ 4380.857148]  el0t_64_sync+0x190/0x194
[ 4380.860801] Code: 94431515 17ffffca d503201f d503245f (b9400004)

Signed-off-by: Yunfei Dong <yunfei.dong@mediatek.com>
Tested-by: Nícolas F. R. A. Prado <nfraprado@collabora.com>
Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Signed-off-by: Mauro Carvalho Chehab <mchehab@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/platform/mediatek/vcodec/mtk_vcodec_dec_drv.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/media/platform/mediatek/vcodec/mtk_vcodec_dec_drv.c b/drivers/media/platform/mediatek/vcodec/mtk_vcodec_dec_drv.c
index df7b25e9cbc8..128edcf541e1 100644
--- a/drivers/media/platform/mediatek/vcodec/mtk_vcodec_dec_drv.c
+++ b/drivers/media/platform/mediatek/vcodec/mtk_vcodec_dec_drv.c
@@ -487,7 +487,8 @@ static int mtk_vcodec_dec_remove(struct platform_device *pdev)
 		video_unregister_device(dev->vfd_dec);
 
 	v4l2_device_unregister(&dev->v4l2_dev);
-	pm_runtime_disable(dev->pm.dev);
+	if (!dev->vdec_pdata->is_subdev_supported)
+		pm_runtime_disable(dev->pm.dev);
 	mtk_vcodec_fw_release(dev->fw_handler);
 	return 0;
 }
-- 
2.35.1



