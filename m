Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1BC6A499447
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 21:42:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1388992AbiAXUkU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 15:40:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39178 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1385459AbiAXUd0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 15:33:26 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B9036C07E297;
        Mon, 24 Jan 2022 11:45:27 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 75097B8121A;
        Mon, 24 Jan 2022 19:45:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 839AAC340E5;
        Mon, 24 Jan 2022 19:45:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643053525;
        bh=qne+I7FLNYBtN/84TB3R3SwarzcOPorxaSIPNuVN8VA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RFBFuJKrTjct5kM2obhGF6dcGWsM782nIl9sjwBaVBFSJHVzdAJFpu4IzFGBOZvRv
         HRy5n8U3eFf2B9e6JLS8rUO4VZRGufnNChC1t2fDFoFrwvhmsbDec0XSLAaCI8LL2i
         DPnNx5GNkspOP642pJXITSLHBGY0ckDHWfixfDY4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hulk Robot <hulkci@huawei.com>,
        Wang Hai <wanghai38@huawei.com>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 093/563] media: dmxdev: fix UAF when dvb_register_device() fails
Date:   Mon, 24 Jan 2022 19:37:38 +0100
Message-Id: <20220124184027.608351413@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124184024.407936072@linuxfoundation.org>
References: <20220124184024.407936072@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Wang Hai <wanghai38@huawei.com>

[ Upstream commit ab599eb11882f834951c436cc080c3455ba32b9b ]

I got a use-after-free report:

dvbdev: dvb_register_device: failed to create device dvb1.dvr0 (-12)
...
==================================================================
BUG: KASAN: use-after-free in dvb_dmxdev_release+0xce/0x2f0
...
Call Trace:
 dump_stack_lvl+0x6c/0x8b
 print_address_description.constprop.0+0x48/0x70
 kasan_report.cold+0x82/0xdb
 __asan_load4+0x6b/0x90
 dvb_dmxdev_release+0xce/0x2f0
...
Allocated by task 7666:
 kasan_save_stack+0x23/0x50
 __kasan_kmalloc+0x83/0xa0
 kmem_cache_alloc_trace+0x22e/0x470
 dvb_register_device+0x12f/0x980
 dvb_dmxdev_init+0x1f3/0x230
...
Freed by task 7666:
 kasan_save_stack+0x23/0x50
 kasan_set_track+0x20/0x30
 kasan_set_free_info+0x24/0x40
 __kasan_slab_free+0xf2/0x130
 kfree+0xd1/0x5c0
 dvb_register_device.cold+0x1ac/0x1fa
 dvb_dmxdev_init+0x1f3/0x230
...

When dvb_register_device() in dvb_dmxdev_init() fails, dvb_dmxdev_init()
does not return a failure, and the memory pointed to by dvbdev or
dvr_dvbdev is invalid at this point. If they are used subsequently, it
will result in UFA or null-ptr-deref.

If dvb_register_device() in dvb_dmxdev_init() fails, fix the bug by making
dvb_dmxdev_init() return an error as well.

Link: https://lore.kernel.org/linux-media/20211015085741.1203283-1-wanghai38@huawei.com

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: Wang Hai <wanghai38@huawei.com>
Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/dvb-core/dmxdev.c | 18 +++++++++++++++---
 1 file changed, 15 insertions(+), 3 deletions(-)

diff --git a/drivers/media/dvb-core/dmxdev.c b/drivers/media/dvb-core/dmxdev.c
index f14a872d12687..e58cb8434dafe 100644
--- a/drivers/media/dvb-core/dmxdev.c
+++ b/drivers/media/dvb-core/dmxdev.c
@@ -1413,7 +1413,7 @@ static const struct dvb_device dvbdev_dvr = {
 };
 int dvb_dmxdev_init(struct dmxdev *dmxdev, struct dvb_adapter *dvb_adapter)
 {
-	int i;
+	int i, ret;
 
 	if (dmxdev->demux->open(dmxdev->demux) < 0)
 		return -EUSERS;
@@ -1432,14 +1432,26 @@ int dvb_dmxdev_init(struct dmxdev *dmxdev, struct dvb_adapter *dvb_adapter)
 					    DMXDEV_STATE_FREE);
 	}
 
-	dvb_register_device(dvb_adapter, &dmxdev->dvbdev, &dvbdev_demux, dmxdev,
+	ret = dvb_register_device(dvb_adapter, &dmxdev->dvbdev, &dvbdev_demux, dmxdev,
 			    DVB_DEVICE_DEMUX, dmxdev->filternum);
-	dvb_register_device(dvb_adapter, &dmxdev->dvr_dvbdev, &dvbdev_dvr,
+	if (ret < 0)
+		goto err_register_dvbdev;
+
+	ret = dvb_register_device(dvb_adapter, &dmxdev->dvr_dvbdev, &dvbdev_dvr,
 			    dmxdev, DVB_DEVICE_DVR, dmxdev->filternum);
+	if (ret < 0)
+		goto err_register_dvr_dvbdev;
 
 	dvb_ringbuffer_init(&dmxdev->dvr_buffer, NULL, 8192);
 
 	return 0;
+
+err_register_dvr_dvbdev:
+	dvb_unregister_device(dmxdev->dvbdev);
+err_register_dvbdev:
+	vfree(dmxdev->filter);
+	dmxdev->filter = NULL;
+	return ret;
 }
 
 EXPORT_SYMBOL(dvb_dmxdev_init);
-- 
2.34.1



