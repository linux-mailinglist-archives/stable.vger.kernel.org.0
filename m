Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CC6366AEA42
	for <lists+stable@lfdr.de>; Tue,  7 Mar 2023 18:32:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231585AbjCGRcO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Mar 2023 12:32:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33280 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231584AbjCGRb6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Mar 2023 12:31:58 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 473919F059
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 09:27:16 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D8AD4614D0
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 17:27:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D241AC433EF;
        Tue,  7 Mar 2023 17:27:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678210035;
        bh=bCzAuCAgaC0sTsd1MhZmDi2ES+iEdRG6AWUPKt701qA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ellKwmwruptQkaRh4retA5a7CLSoOg0BWoKaOSDKgWCYYGenMXNrX58AjeONlj9No
         syanX1/TTe4nqQAYkSxIP991sUThXLsJ/HpQTc1YZ/fN97lA10qGp8a/vGKmj9IZ/u
         w9HLMCEbTUy5CqgOEYGAnjvnrg5agYc1vdPKKTTw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Arnd Bergmann <arnd@arndb.de>,
        Stanislaw Gruszka <stanislaw.gruszka@linux.intel.com>,
        Jeffrey Hugo <quic_jhugo@quicinc.com>,
        Oded Gabbay <ogabbay@kernel.org>,
        Jacek Lawrynowicz <jacek.lawrynowicz@linux.intel.com>,
        Thomas Zimmermann <tzimmermann@suse.de>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.2 0411/1001] accel: fix CONFIG_DRM dependencies
Date:   Tue,  7 Mar 2023 17:53:03 +0100
Message-Id: <20230307170039.169223149@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307170022.094103862@linuxfoundation.org>
References: <20230307170022.094103862@linuxfoundation.org>
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

From: Arnd Bergmann <arnd@arndb.de>

[ Upstream commit 9f20c9f4b1e17e83e9ccc247cfdc0b61041bff3d ]

At the moment, accel drivers can be built-in even with CONFIG_DRM=m,
but this causes a link failure:

x86_64-linux-ld: drivers/accel/ivpu/ivpu_drv.o: in function `ivpu_dev_init':
ivpu_drv.c:(.text+0x1535): undefined reference to `drmm_kmalloc'
x86_64-linux-ld: ivpu_drv.c:(.text+0x1562): undefined reference to `drmm_kmalloc'
x86_64-linux-ld: drivers/accel/ivpu/ivpu_drv.o: in function `ivpu_remove':
ivpu_drv.c:(.text+0x1faa): undefined reference to `drm_dev_unregister'
x86_64-linux-ld: drivers/accel/ivpu/ivpu_drv.o: in function `ivpu_probe':
ivpu_drv.c:(.text+0x1fef): undefined reference to `__devm_drm_dev_alloc'

The problem is that DRM_ACCEL is a 'bool' symbol, so driver that
only depend on DRM_ACCEL but not also on DRM do not see the restriction
to =m configs.

To ensure that each accel driver has an implied dependency on CONFIG_DRM,
enclose the entire Kconfig file in an if/endif check.

Fixes: 8bf4889762a8 ("drivers/accel: define kconfig and register a new major")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Reviewed-by: Stanislaw Gruszka <stanislaw.gruszka@linux.intel.com>
Reviewed-by: Jeffrey Hugo <quic_jhugo@quicinc.com>
Reviewed-by: Oded Gabbay <ogabbay@kernel.org>
Signed-off-by: Jacek Lawrynowicz <jacek.lawrynowicz@linux.intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20230127221504.2522909-1-arnd@kernel.org
(cherry picked from commit 3524c96a121952f214271622bb372661ced86101)
Signed-off-by: Thomas Zimmermann <tzimmermann@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/accel/Kconfig | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/accel/Kconfig b/drivers/accel/Kconfig
index c9ce849b2984a..c8177ae415b8b 100644
--- a/drivers/accel/Kconfig
+++ b/drivers/accel/Kconfig
@@ -6,9 +6,10 @@
 # as, but not limited to, Machine-Learning and Deep-Learning acceleration
 # devices
 #
+if DRM
+
 menuconfig DRM_ACCEL
 	bool "Compute Acceleration Framework"
-	depends on DRM
 	help
 	  Framework for device drivers of compute acceleration devices, such
 	  as, but not limited to, Machine-Learning and Deep-Learning
@@ -22,3 +23,5 @@ menuconfig DRM_ACCEL
 	  major number than GPUs, and will be exposed to user-space using
 	  different device files, called accel/accel* (in /dev, sysfs
 	  and debugfs).
+
+endif
-- 
2.39.2



