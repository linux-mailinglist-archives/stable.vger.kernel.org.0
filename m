Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 56A95498A41
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 20:02:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343964AbiAXTCT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 14:02:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44046 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343948AbiAXS6m (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 13:58:42 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1AC20C0617BD;
        Mon, 24 Jan 2022 10:55:36 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D7805B8121F;
        Mon, 24 Jan 2022 18:55:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F0AAFC340E5;
        Mon, 24 Jan 2022 18:55:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643050533;
        bh=Z4nxAGJ3zNBXE1ZFPZ/Q4sjK2iny9EAwaDNANlUTFik=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=EM6a3ANhzO9vWEnLRTaqyiMYqiHBNHlbLhCZycGIfWtLqC9Yeisd0wDBHO3HsPep4
         dBCi8MnI7bgbfjJvFXWoS13NZrNLApgAGNpbLzsmt5cwhm4icTIcegulssPQJlGFm0
         MBeoCjL9FAzNOdDDBd+VCcQL/wgv4FjAlPMlBRqU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hulk Robot <hulkci@huawei.com>,
        Wang Hai <wanghai38@huawei.com>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 032/157] media: dmxdev: fix UAF when dvb_register_device() fails
Date:   Mon, 24 Jan 2022 19:42:02 +0100
Message-Id: <20220124183933.821294735@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124183932.787526760@linuxfoundation.org>
References: <20220124183932.787526760@linuxfoundation.org>
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
index 0418b5a0fb645..32a2e6ffdb097 100644
--- a/drivers/media/dvb-core/dmxdev.c
+++ b/drivers/media/dvb-core/dmxdev.c
@@ -1225,7 +1225,7 @@ static const struct dvb_device dvbdev_dvr = {
 };
 int dvb_dmxdev_init(struct dmxdev *dmxdev, struct dvb_adapter *dvb_adapter)
 {
-	int i;
+	int i, ret;
 
 	if (dmxdev->demux->open(dmxdev->demux) < 0)
 		return -EUSERS;
@@ -1243,14 +1243,26 @@ int dvb_dmxdev_init(struct dmxdev *dmxdev, struct dvb_adapter *dvb_adapter)
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



