Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7D25E6B4924
	for <lists+stable@lfdr.de>; Fri, 10 Mar 2023 16:10:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233777AbjCJPKJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 10 Mar 2023 10:10:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43844 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233815AbjCJPJi (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 10 Mar 2023 10:09:38 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A14BF138446
        for <stable@vger.kernel.org>; Fri, 10 Mar 2023 07:02:00 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id DED3561962
        for <stable@vger.kernel.org>; Fri, 10 Mar 2023 15:01:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F01DCC433D2;
        Fri, 10 Mar 2023 15:01:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678460467;
        bh=+dAeZUBo1tgHtmKQMXYrXFTTr9mpxj48/QZb/IK5kJM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Os0hXTvksJRvtuBhl/S8+z1At7ZnDCYt0Umx6t4O5r3Ufxm9qoSpHD8zur+OFCr61
         KRhbCWLLmU37cO6cd+FV5mJPMfrISz/VsiSmMND8/LzHTVgFlOYqA8WeBXj0FPgXmX
         GfGM6Etg0YhGJTli+LhwxYsFp63+ArEznuRe7ljA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Liwei Song <liwei.song@windriver.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 313/529] drm/radeon: free iio for atombios when driver shutdown
Date:   Fri, 10 Mar 2023 14:37:36 +0100
Message-Id: <20230310133819.504559424@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230310133804.978589368@linuxfoundation.org>
References: <20230310133804.978589368@linuxfoundation.org>
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

From: Liwei Song <liwei.song@windriver.com>

[ Upstream commit 4773fadedca918faec443daaca5e4ea1c0ced144 ]

Fix below kmemleak when unload radeon driver:

unreferenced object 0xffff9f8608ede200 (size 512):
  comm "systemd-udevd", pid 326, jiffies 4294682822 (age 716.338s)
  hex dump (first 32 bytes):
    00 00 00 00 c4 aa ec aa 14 ab 00 00 00 00 00 00  ................
    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
  backtrace:
    [<0000000062fadebe>] kmem_cache_alloc_trace+0x2f1/0x500
    [<00000000b6883cea>] atom_parse+0x117/0x230 [radeon]
    [<00000000158c23fd>] radeon_atombios_init+0xab/0x170 [radeon]
    [<00000000683f672e>] si_init+0x57/0x750 [radeon]
    [<00000000566cc31f>] radeon_device_init+0x559/0x9c0 [radeon]
    [<0000000046efabb3>] radeon_driver_load_kms+0xc1/0x1a0 [radeon]
    [<00000000b5155064>] drm_dev_register+0xdd/0x1d0
    [<0000000045fec835>] radeon_pci_probe+0xbd/0x100 [radeon]
    [<00000000e69ecca3>] pci_device_probe+0xe1/0x160
    [<0000000019484b76>] really_probe.part.0+0xc1/0x2c0
    [<000000003f2649da>] __driver_probe_device+0x96/0x130
    [<00000000231c5bb1>] driver_probe_device+0x24/0xf0
    [<0000000000a42377>] __driver_attach+0x77/0x190
    [<00000000d7574da6>] bus_for_each_dev+0x7f/0xd0
    [<00000000633166d2>] driver_attach+0x1e/0x30
    [<00000000313b05b8>] bus_add_driver+0x12c/0x1e0

iio was allocated in atom_index_iio() called by atom_parse(),
but it doesn't got released when the dirver is shutdown.
Fix this kmemleak by free it in radeon_atombios_fini().

Signed-off-by: Liwei Song <liwei.song@windriver.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/radeon/radeon_device.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/gpu/drm/radeon/radeon_device.c b/drivers/gpu/drm/radeon/radeon_device.c
index 8287410f471fb..131f425c363a5 100644
--- a/drivers/gpu/drm/radeon/radeon_device.c
+++ b/drivers/gpu/drm/radeon/radeon_device.c
@@ -1022,6 +1022,7 @@ void radeon_atombios_fini(struct radeon_device *rdev)
 {
 	if (rdev->mode_info.atom_context) {
 		kfree(rdev->mode_info.atom_context->scratch);
+		kfree(rdev->mode_info.atom_context->iio);
 	}
 	kfree(rdev->mode_info.atom_context);
 	rdev->mode_info.atom_context = NULL;
-- 
2.39.2



