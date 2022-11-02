Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5578161586D
	for <lists+stable@lfdr.de>; Wed,  2 Nov 2022 03:52:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230493AbiKBCwB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Nov 2022 22:52:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41196 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230505AbiKBCv4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 1 Nov 2022 22:51:56 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8B7B5220ED
        for <stable@vger.kernel.org>; Tue,  1 Nov 2022 19:51:54 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1912B617BB
        for <stable@vger.kernel.org>; Wed,  2 Nov 2022 02:51:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B223CC433D6;
        Wed,  2 Nov 2022 02:51:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1667357513;
        bh=kVEihka80BhLCyqRKS47FEqbkUxQ745sWa2/ZskqEmg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=u7xQZf6t7M2DkCudpx9VvMPpikV9WsQFbtlE8uoOboTgr2upw42zzQsD4IzBqdmJW
         8KYQUrbWCZ/cPYTdi17wr2w6CQC8D3WIEr0Hz8ZRmtNLFxQPQQGeMrkfkl13KH+pYL
         f856QTEWmoXikdXefSwUZR57Hm0Ms+2mqOJl0IQs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Kai Vehmanen <kai.vehmanen@linux.intel.com>,
        Bard Liao <yung-chuan.liao@linux.intel.com>,
        Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
        Gopal Vamshi Krishna <vamshi.krishna.gopal@intel.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 155/240] ASoC: SOF: Intel: pci-tgl: use RPL specific firmware definitions
Date:   Wed,  2 Nov 2022 03:32:10 +0100
Message-Id: <20221102022114.886340884@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221102022111.398283374@linuxfoundation.org>
References: <20221102022111.398283374@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Kai Vehmanen <kai.vehmanen@linux.intel.com>

[ Upstream commit 63d375b9f2a99bb111e3fb5f3e2442a391988949 ]

Split out firmware definitions for Intel Raptor Lake platforms.

Signed-off-by: Kai Vehmanen <kai.vehmanen@linux.intel.com>
Reviewed-by: Bard Liao <yung-chuan.liao@linux.intel.com>
Reviewed-by: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
Suggested-by: Gopal Vamshi Krishna <vamshi.krishna.gopal@intel.com>
Link: https://lore.kernel.org/r/20220816130510.190427-2-kai.vehmanen@linux.intel.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Stable-dep-of: 05de5cf6fb7d ("ASoC: SOF: Intel: pci-tgl: fix ADL-N descriptor")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/sof/intel/pci-tgl.c | 62 +++++++++++++++++++++++++++++++++--
 1 file changed, 59 insertions(+), 3 deletions(-)

diff --git a/sound/soc/sof/intel/pci-tgl.c b/sound/soc/sof/intel/pci-tgl.c
index ccc44ba3ad94..aac47cd007e8 100644
--- a/sound/soc/sof/intel/pci-tgl.c
+++ b/sound/soc/sof/intel/pci-tgl.c
@@ -159,6 +159,62 @@ static const struct sof_dev_desc adl_desc = {
 	.ops_init = sof_tgl_ops_init,
 };
 
+static const struct sof_dev_desc rpls_desc = {
+	.machines               = snd_soc_acpi_intel_rpl_machines,
+	.alt_machines           = snd_soc_acpi_intel_rpl_sdw_machines,
+	.use_acpi_target_states	= true,
+	.resindex_lpe_base      = 0,
+	.resindex_pcicfg_base   = -1,
+	.resindex_imr_base      = -1,
+	.irqindex_host_ipc      = -1,
+	.chip_info = &adls_chip_info,
+	.ipc_supported_mask	= BIT(SOF_IPC) | BIT(SOF_INTEL_IPC4),
+	.ipc_default		= SOF_IPC,
+	.default_fw_path = {
+		[SOF_IPC] = "intel/sof",
+		[SOF_INTEL_IPC4] = "intel/avs/rpl-s",
+	},
+	.default_tplg_path = {
+		[SOF_IPC] = "intel/sof-tplg",
+		[SOF_INTEL_IPC4] = "intel/avs-tplg",
+	},
+	.default_fw_filename = {
+		[SOF_IPC] = "sof-rpl-s.ri",
+		[SOF_INTEL_IPC4] = "dsp_basefw.bin",
+	},
+	.nocodec_tplg_filename = "sof-rpl-nocodec.tplg",
+	.ops = &sof_tgl_ops,
+	.ops_init = sof_tgl_ops_init,
+};
+
+static const struct sof_dev_desc rpl_desc = {
+	.machines               = snd_soc_acpi_intel_rpl_machines,
+	.alt_machines           = snd_soc_acpi_intel_rpl_sdw_machines,
+	.use_acpi_target_states = true,
+	.resindex_lpe_base      = 0,
+	.resindex_pcicfg_base   = -1,
+	.resindex_imr_base      = -1,
+	.irqindex_host_ipc      = -1,
+	.chip_info = &tgl_chip_info,
+	.ipc_supported_mask	= BIT(SOF_IPC) | BIT(SOF_INTEL_IPC4),
+	.ipc_default		= SOF_IPC,
+	.default_fw_path = {
+		[SOF_IPC] = "intel/sof",
+		[SOF_INTEL_IPC4] = "intel/avs/rpl",
+	},
+	.default_tplg_path = {
+		[SOF_IPC] = "intel/sof-tplg",
+		[SOF_INTEL_IPC4] = "intel/avs-tplg",
+	},
+	.default_fw_filename = {
+		[SOF_IPC] = "sof-rpl.ri",
+		[SOF_INTEL_IPC4] = "dsp_basefw.bin",
+	},
+	.nocodec_tplg_filename = "sof-rpl-nocodec.tplg",
+	.ops = &sof_tgl_ops,
+	.ops_init = sof_tgl_ops_init,
+};
+
 /* PCI IDs */
 static const struct pci_device_id sof_pci_ids[] = {
 	{ PCI_DEVICE(0x8086, 0xa0c8), /* TGL-LP */
@@ -172,7 +228,7 @@ static const struct pci_device_id sof_pci_ids[] = {
 	{ PCI_DEVICE(0x8086, 0x7ad0), /* ADL-S */
 		.driver_data = (unsigned long)&adls_desc},
 	{ PCI_DEVICE(0x8086, 0x7a50), /* RPL-S */
-		.driver_data = (unsigned long)&adls_desc},
+		.driver_data = (unsigned long)&rpls_desc},
 	{ PCI_DEVICE(0x8086, 0x51c8), /* ADL-P */
 		.driver_data = (unsigned long)&adl_desc},
 	{ PCI_DEVICE(0x8086, 0x51cd), /* ADL-P */
@@ -180,9 +236,9 @@ static const struct pci_device_id sof_pci_ids[] = {
 	{ PCI_DEVICE(0x8086, 0x51c9), /* ADL-PS */
 		.driver_data = (unsigned long)&adl_desc},
 	{ PCI_DEVICE(0x8086, 0x51ca), /* RPL-P */
-		.driver_data = (unsigned long)&adl_desc},
+		.driver_data = (unsigned long)&rpl_desc},
 	{ PCI_DEVICE(0x8086, 0x51cb), /* RPL-P */
-		.driver_data = (unsigned long)&adl_desc},
+		.driver_data = (unsigned long)&rpl_desc},
 	{ PCI_DEVICE(0x8086, 0x51cc), /* ADL-M */
 		.driver_data = (unsigned long)&adl_desc},
 	{ PCI_DEVICE(0x8086, 0x54c8), /* ADL-N */
-- 
2.35.1



