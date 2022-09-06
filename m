Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6CF545AEB8A
	for <lists+stable@lfdr.de>; Tue,  6 Sep 2022 16:26:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240986AbiIFOIY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 6 Sep 2022 10:08:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58892 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240902AbiIFOHa (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 6 Sep 2022 10:07:30 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E827585F86;
        Tue,  6 Sep 2022 06:45:40 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 474C2CE1779;
        Tue,  6 Sep 2022 13:44:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C5917C433D6;
        Tue,  6 Sep 2022 13:44:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1662471876;
        bh=PkANjPyEN6TSj19BYKsh3KOyw4fzz4r1byqtdqWJq2I=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZHdkqg3Ld1w+TboZ3Y0+xXGNLlFCd/ofXo8NwlEczL4gmrk3LwQNElr8h0Ifx96X5
         2xzXQDNccqp43YJwWaLCbEXIqgXfXLjJEhWXqUmz+hSY4Yb0zJp4VB+qaTp0ndj+l/
         TZuSJbBHv6vDnw0SN/GRNcowp6X/w5ghIu0PpdJo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?=C5=81ukasz=20Bartosik?= <lb@semihalf.com>,
        Radhakrishna Sripada <radhakrishna.sripada@intel.com>,
        Jani Nikula <jani.nikula@intel.com>,
        Rodrigo Vivi <rodrigo.vivi@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.19 038/155] drm/i915: fix null pointer dereference
Date:   Tue,  6 Sep 2022 15:29:46 +0200
Message-Id: <20220906132831.034858111@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20220906132829.417117002@linuxfoundation.org>
References: <20220906132829.417117002@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Łukasz Bartosik <lb@semihalf.com>

[ Upstream commit 458ec0c8f35963626ccd51c3d50b752de5f1b9d4 ]

Asus chromebook CX550 crashes during boot on v5.17-rc1 kernel.
The root cause is null pointer defeference of bi_next
in tgl_get_bw_info() in drivers/gpu/drm/i915/display/intel_bw.c.

BUG: kernel NULL pointer dereference, address: 000000000000002e
PGD 0 P4D 0
Oops: 0002 [#1] PREEMPT SMP NOPTI
CPU: 0 PID: 1 Comm: swapper/0 Tainted: G     U            5.17.0-rc1
Hardware name: Google Delbin/Delbin, BIOS Google_Delbin.13672.156.3 05/14/2021
RIP: 0010:tgl_get_bw_info+0x2de/0x510
...
[    2.554467] Call Trace:
[    2.554467]  <TASK>
[    2.554467]  intel_bw_init_hw+0x14a/0x434
[    2.554467]  ? _printk+0x59/0x73
[    2.554467]  ? _dev_err+0x77/0x91
[    2.554467]  i915_driver_hw_probe+0x329/0x33e
[    2.554467]  i915_driver_probe+0x4c8/0x638
[    2.554467]  i915_pci_probe+0xf8/0x14e
[    2.554467]  ? _raw_spin_unlock_irqrestore+0x12/0x2c
[    2.554467]  pci_device_probe+0xaa/0x142
[    2.554467]  really_probe+0x13f/0x2f4
[    2.554467]  __driver_probe_device+0x9e/0xd3
[    2.554467]  driver_probe_device+0x24/0x7c
[    2.554467]  __driver_attach+0xba/0xcf
[    2.554467]  ? driver_attach+0x1f/0x1f
[    2.554467]  bus_for_each_dev+0x8c/0xc0
[    2.554467]  bus_add_driver+0x11b/0x1f7
[    2.554467]  driver_register+0x60/0xea
[    2.554467]  ? mipi_dsi_bus_init+0x16/0x16
[    2.554467]  i915_init+0x2c/0xb9
[    2.554467]  ? mipi_dsi_bus_init+0x16/0x16
[    2.554467]  do_one_initcall+0x12e/0x2b3
[    2.554467]  do_initcall_level+0xd6/0xf3
[    2.554467]  do_initcalls+0x4e/0x79
[    2.554467]  kernel_init_freeable+0xed/0x14d
[    2.554467]  ? rest_init+0xc1/0xc1
[    2.554467]  kernel_init+0x1a/0x120
[    2.554467]  ret_from_fork+0x1f/0x30
[    2.554467]  </TASK>
...
Kernel panic - not syncing: Fatal exception

Fixes: c64a9a7c05be ("drm/i915: Update memory bandwidth formulae")
Signed-off-by: Łukasz Bartosik <lb@semihalf.com>
Reviewed-by: Radhakrishna Sripada <radhakrishna.sripada@intel.com>
Signed-off-by: Jani Nikula <jani.nikula@intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20220201153354.11971-1-lukasz.bartosik@semihalf.com
(cherry picked from commit c247cd03898c4c43c3bce6d4014730403bc13032)
Signed-off-by: Rodrigo Vivi <rodrigo.vivi@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/i915/display/intel_bw.c | 16 +++++++++-------
 1 file changed, 9 insertions(+), 7 deletions(-)

diff --git a/drivers/gpu/drm/i915/display/intel_bw.c b/drivers/gpu/drm/i915/display/intel_bw.c
index 37bd7b17f3d0b..f2fad199e2e0b 100644
--- a/drivers/gpu/drm/i915/display/intel_bw.c
+++ b/drivers/gpu/drm/i915/display/intel_bw.c
@@ -404,15 +404,17 @@ static int tgl_get_bw_info(struct drm_i915_private *dev_priv, const struct intel
 		int clpchgroup;
 		int j;
 
-		if (i < num_groups - 1)
-			bi_next = &dev_priv->max_bw[i + 1];
-
 		clpchgroup = (sa->deburst * qi.deinterleave / num_channels) << i;
 
-		if (i < num_groups - 1 && clpchgroup < clperchgroup)
-			bi_next->num_planes = (ipqdepth - clpchgroup) / clpchgroup + 1;
-		else
-			bi_next->num_planes = 0;
+		if (i < num_groups - 1) {
+			bi_next = &dev_priv->max_bw[i + 1];
+
+			if (clpchgroup < clperchgroup)
+				bi_next->num_planes = (ipqdepth - clpchgroup) /
+						       clpchgroup + 1;
+			else
+				bi_next->num_planes = 0;
+		}
 
 		bi->num_qgv_points = qi.num_points;
 		bi->num_psf_gv_points = qi.num_psf_points;
-- 
2.35.1



