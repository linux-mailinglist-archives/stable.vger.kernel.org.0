Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 091712F5F0
	for <lists+stable@lfdr.de>; Thu, 30 May 2019 06:51:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727494AbfE3Evk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 30 May 2019 00:51:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:49066 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728283AbfE3DKz (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 29 May 2019 23:10:55 -0400
Received: from localhost (ip67-88-213-2.z213-88-67.customer.algx.net [67.88.213.2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B6B6D24481;
        Thu, 30 May 2019 03:10:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1559185854;
        bh=11eoCVyjHUvZ4VuOsBnLJjZ55ivTqJg/YMhx7s9WbFA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=2OisHip0DI7xotH/AWgrKMHKBhSCgMp1Hm9/bjOquiq2WHSAS7wpt34Y3OoTZlmP2
         X73Qsk26I6RrY7+a1yZyiCKxaKoM295aLtDSABYZ7b2PWWiTcG+FBCCoFTAd0voWOg
         V2uCr6UN6Atd5ULCPYay/CRUH95i/HgOi/38G/Ek=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Russell King <rmk+kernel@armlinux.org.uk>,
        Lucas Stach <l.stach@pengutronix.de>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.1 181/405] drm: etnaviv: avoid DMA API warning when importing buffers
Date:   Wed, 29 May 2019 20:02:59 -0700
Message-Id: <20190530030550.240685566@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190530030540.291644921@linuxfoundation.org>
References: <20190530030540.291644921@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit 1262cc8893ecb0eb2c21e042d0d268cc180edb61 ]

During boot, I get this kernel warning:

WARNING: CPU: 0 PID: 19001 at kernel/dma/debug.c:1301 debug_dma_map_sg+0x284/0x3dc
etnaviv etnaviv: DMA-API: mapping sg segment longer than device claims to support [len=3145728] [max=65536]
Modules linked in: ip6t_REJECT nf_reject_ipv6 ip6t_rpfilter xt_tcpudp ipt_REJECT nf_reject_ipv4 xt_conntrack ip_set nfnetlink ebtable_broute ebtable_nat ip6table_raw ip6table_nat nf_nat_ipv6 ip6table_mangle iptable_raw iptable_nat nf_nat_ipv4 nf_nat nf_conntrack nf_defrag_ipv4 nf_defrag_ipv6 libcrc32c iptable_mangle ebtable_filter ebtables ip6table_filter ip6_tables iptable_filter caam_jr error snd_soc_imx_spdif imx_thermal snd_soc_imx_audmux nvmem_imx_ocotp snd_soc_sgtl5000
caam imx_sdma virt_dma coda rc_cec v4l2_mem2mem snd_soc_fsl_ssi snd_soc_fsl_spdif imx_vdoa imx_pcm_dma videobuf2_dma_contig etnaviv dw_hdmi_cec gpu_sched dw_hdmi_ahb_audio imx6q_cpufreq nfsd sch_fq_codel ip_tables x_tables
CPU: 0 PID: 19001 Comm: Xorg Not tainted 4.20.0+ #307
Hardware name: Freescale i.MX6 Quad/DualLite (Device Tree)
[<c0019658>] (unwind_backtrace) from [<c001489c>] (show_stack+0x10/0x14)
[<c001489c>] (show_stack) from [<c07fb420>] (dump_stack+0x9c/0xd4)
[<c07fb420>] (dump_stack) from [<c00312dc>] (__warn+0xf8/0x124)
[<c00312dc>] (__warn) from [<c00313d0>] (warn_slowpath_fmt+0x38/0x48)
[<c00313d0>] (warn_slowpath_fmt) from [<c00b14e8>] (debug_dma_map_sg+0x284/0x3dc)
[<c00b14e8>] (debug_dma_map_sg) from [<c046eb40>] (drm_gem_map_dma_buf+0xc4/0x13c)
[<c046eb40>] (drm_gem_map_dma_buf) from [<c04c3314>] (dma_buf_map_attachment+0x38/0x5c)
[<c04c3314>] (dma_buf_map_attachment) from [<c046e728>] (drm_gem_prime_import_dev+0x74/0x104)
[<c046e728>] (drm_gem_prime_import_dev) from [<c046e5bc>] (drm_gem_prime_fd_to_handle+0x84/0x17c)
[<c046e5bc>] (drm_gem_prime_fd_to_handle) from [<c046edd0>] (drm_prime_fd_to_handle_ioctl+0x38/0x4c)
[<c046edd0>] (drm_prime_fd_to_handle_ioctl) from [<c0460efc>] (drm_ioctl_kernel+0x90/0xc8)
[<c0460efc>] (drm_ioctl_kernel) from [<c0461114>] (drm_ioctl+0x1e0/0x3b0)
[<c0461114>] (drm_ioctl) from [<c01cae20>] (do_vfs_ioctl+0x90/0xa48)
[<c01cae20>] (do_vfs_ioctl) from [<c01cb80c>] (ksys_ioctl+0x34/0x60)
[<c01cb80c>] (ksys_ioctl) from [<c0009000>] (ret_fast_syscall+0x0/0x28)
Exception stack(0xd81a9fa8 to 0xd81a9ff0)
9fa0:                   b6c69c88 bec613f8 00000009 c00c642e bec613f8 b86c4600
9fc0: b6c69c88 bec613f8 c00c642e 00000036 012762e0 01276348 00000300 012d91f8
9fe0: b6989f18 bec613dc b697185c b667be5c
irq event stamp: 47905
hardirqs last  enabled at (47913): [<c0098824>] console_unlock+0x46c/0x680
hardirqs last disabled at (47922): [<c0098470>] console_unlock+0xb8/0x680
softirqs last  enabled at (47754): [<c000a484>] __do_softirq+0x344/0x540
softirqs last disabled at (47701): [<c0038700>] irq_exit+0x124/0x144
---[ end trace af477747acbcc642 ]---

The reason is the contiguous buffer exceeds the default maximum segment
size of 64K as specified by dma_get_max_seg_size() in
linux/dma-mapping.h.  Fix this by providing our own segment size, which
is set to 2GiB to cover the window found in MMUv1 GPUs.

Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>
Signed-off-by: Lucas Stach <l.stach@pengutronix.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/etnaviv/etnaviv_drv.c | 5 +++++
 drivers/gpu/drm/etnaviv/etnaviv_drv.h | 1 +
 2 files changed, 6 insertions(+)

diff --git a/drivers/gpu/drm/etnaviv/etnaviv_drv.c b/drivers/gpu/drm/etnaviv/etnaviv_drv.c
index 18c27f795cf61..3156450723bad 100644
--- a/drivers/gpu/drm/etnaviv/etnaviv_drv.c
+++ b/drivers/gpu/drm/etnaviv/etnaviv_drv.c
@@ -515,6 +515,9 @@ static int etnaviv_bind(struct device *dev)
 	}
 	drm->dev_private = priv;
 
+	dev->dma_parms = &priv->dma_parms;
+	dma_set_max_seg_size(dev, SZ_2G);
+
 	mutex_init(&priv->gem_lock);
 	INIT_LIST_HEAD(&priv->gem_list);
 	priv->num_gpus = 0;
@@ -552,6 +555,8 @@ static void etnaviv_unbind(struct device *dev)
 
 	component_unbind_all(dev, drm);
 
+	dev->dma_parms = NULL;
+
 	drm->dev_private = NULL;
 	kfree(priv);
 
diff --git a/drivers/gpu/drm/etnaviv/etnaviv_drv.h b/drivers/gpu/drm/etnaviv/etnaviv_drv.h
index a6a7ded37ef1d..6a4ea127c4f1a 100644
--- a/drivers/gpu/drm/etnaviv/etnaviv_drv.h
+++ b/drivers/gpu/drm/etnaviv/etnaviv_drv.h
@@ -42,6 +42,7 @@ struct etnaviv_file_private {
 
 struct etnaviv_drm_private {
 	int num_gpus;
+	struct device_dma_parameters dma_parms;
 	struct etnaviv_gpu *gpu[ETNA_MAX_PIPES];
 
 	/* list of GEM objects: */
-- 
2.20.1



