Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9BC726C174E
	for <lists+stable@lfdr.de>; Mon, 20 Mar 2023 16:12:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232333AbjCTPMm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Mar 2023 11:12:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36674 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232097AbjCTPMI (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Mar 2023 11:12:08 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7863631E1A
        for <stable@vger.kernel.org>; Mon, 20 Mar 2023 08:07:08 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 11E02B80EC3
        for <stable@vger.kernel.org>; Mon, 20 Mar 2023 15:07:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6DCA3C4339C;
        Mon, 20 Mar 2023 15:07:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1679324826;
        bh=n4GtEvqKkRv2yfdFJkXa8qv4syimoEUT00jPaqUSvJE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Y8g/b/j91BSNlJc2olEW1CahtD9l4l0OUilCUJTonVXA7vIS7FgR3YJragoQhQvXA
         eVocfZu/KVXPS7frTpE+HnihO3Vxw+Ylp5NVYjL394PT1oysjcmYd3aIeAIVZ+t+Cv
         lbans3IF0ryO+RWJXyGFchmMbH/kKyfQamb34u5k=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Ranjani Sridharan <ranjani.sridharan@linux.intel.com>,
        Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
        Bard Liao <yung-chuan.liao@linux.intel.com>,
        Peter Ujfalusi <peter.ujfalusi@linux.intel.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 010/198] ASoC: SOF: Intel: HDA: Fix device description
Date:   Mon, 20 Mar 2023 15:52:28 +0100
Message-Id: <20230320145507.912136853@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230320145507.420176832@linuxfoundation.org>
References: <20230320145507.420176832@linuxfoundation.org>
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

From: Ranjani Sridharan <ranjani.sridharan@linux.intel.com>

[ Upstream commit 9eb2b4cac223095d2079a6d52b8bbddc6e064288 ]

Add the missing ops_free callback for APL/CNL/CML/JSL/TGL/EHL platforms.

Fixes: 1da51943725f ("ASoC: SOF: Intel: hda: init NHLT for IPC4")

Signed-off-by: Ranjani Sridharan <ranjani.sridharan@linux.intel.com>
Reviewed-by: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
Reviewed-by: Bard Liao <yung-chuan.liao@linux.intel.com>
Signed-off-by: Peter Ujfalusi <peter.ujfalusi@linux.intel.com>
Link: https://lore.kernel.org/r/20230307093914.25409-3-peter.ujfalusi@linux.intel.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/sof/intel/pci-apl.c | 1 +
 sound/soc/sof/intel/pci-cnl.c | 2 ++
 sound/soc/sof/intel/pci-icl.c | 1 +
 sound/soc/sof/intel/pci-tgl.c | 5 +++++
 4 files changed, 9 insertions(+)

diff --git a/sound/soc/sof/intel/pci-apl.c b/sound/soc/sof/intel/pci-apl.c
index 998e219011f01..ad8431b13125d 100644
--- a/sound/soc/sof/intel/pci-apl.c
+++ b/sound/soc/sof/intel/pci-apl.c
@@ -72,6 +72,7 @@ static const struct sof_dev_desc glk_desc = {
 	.nocodec_tplg_filename = "sof-glk-nocodec.tplg",
 	.ops = &sof_apl_ops,
 	.ops_init = sof_apl_ops_init,
+	.ops_free = hda_ops_free,
 };
 
 /* PCI IDs */
diff --git a/sound/soc/sof/intel/pci-cnl.c b/sound/soc/sof/intel/pci-cnl.c
index c797356f7028b..33677ce8de41d 100644
--- a/sound/soc/sof/intel/pci-cnl.c
+++ b/sound/soc/sof/intel/pci-cnl.c
@@ -45,6 +45,7 @@ static const struct sof_dev_desc cnl_desc = {
 	.nocodec_tplg_filename = "sof-cnl-nocodec.tplg",
 	.ops = &sof_cnl_ops,
 	.ops_init = sof_cnl_ops_init,
+	.ops_free = hda_ops_free,
 };
 
 static const struct sof_dev_desc cfl_desc = {
@@ -102,6 +103,7 @@ static const struct sof_dev_desc cml_desc = {
 	.nocodec_tplg_filename = "sof-cnl-nocodec.tplg",
 	.ops = &sof_cnl_ops,
 	.ops_init = sof_cnl_ops_init,
+	.ops_free = hda_ops_free,
 };
 
 /* PCI IDs */
diff --git a/sound/soc/sof/intel/pci-icl.c b/sound/soc/sof/intel/pci-icl.c
index 48f24f8ace261..9a42a4ea1a5ea 100644
--- a/sound/soc/sof/intel/pci-icl.c
+++ b/sound/soc/sof/intel/pci-icl.c
@@ -73,6 +73,7 @@ static const struct sof_dev_desc jsl_desc = {
 	.nocodec_tplg_filename = "sof-jsl-nocodec.tplg",
 	.ops = &sof_cnl_ops,
 	.ops_init = sof_cnl_ops_init,
+	.ops_free = hda_ops_free,
 };
 
 /* PCI IDs */
diff --git a/sound/soc/sof/intel/pci-tgl.c b/sound/soc/sof/intel/pci-tgl.c
index 4cfe4f242fc5e..19e2d68dcb20a 100644
--- a/sound/soc/sof/intel/pci-tgl.c
+++ b/sound/soc/sof/intel/pci-tgl.c
@@ -45,6 +45,7 @@ static const struct sof_dev_desc tgl_desc = {
 	.nocodec_tplg_filename = "sof-tgl-nocodec.tplg",
 	.ops = &sof_tgl_ops,
 	.ops_init = sof_tgl_ops_init,
+	.ops_free = hda_ops_free,
 };
 
 static const struct sof_dev_desc tglh_desc = {
@@ -101,6 +102,7 @@ static const struct sof_dev_desc ehl_desc = {
 	.nocodec_tplg_filename = "sof-ehl-nocodec.tplg",
 	.ops = &sof_tgl_ops,
 	.ops_init = sof_tgl_ops_init,
+	.ops_free = hda_ops_free,
 };
 
 static const struct sof_dev_desc adls_desc = {
@@ -129,6 +131,7 @@ static const struct sof_dev_desc adls_desc = {
 	.nocodec_tplg_filename = "sof-adl-nocodec.tplg",
 	.ops = &sof_tgl_ops,
 	.ops_init = sof_tgl_ops_init,
+	.ops_free = hda_ops_free,
 };
 
 static const struct sof_dev_desc adl_desc = {
@@ -157,6 +160,7 @@ static const struct sof_dev_desc adl_desc = {
 	.nocodec_tplg_filename = "sof-adl-nocodec.tplg",
 	.ops = &sof_tgl_ops,
 	.ops_init = sof_tgl_ops_init,
+	.ops_free = hda_ops_free,
 };
 
 static const struct sof_dev_desc adl_n_desc = {
@@ -185,6 +189,7 @@ static const struct sof_dev_desc adl_n_desc = {
 	.nocodec_tplg_filename = "sof-adl-nocodec.tplg",
 	.ops = &sof_tgl_ops,
 	.ops_init = sof_tgl_ops_init,
+	.ops_free = hda_ops_free,
 };
 
 static const struct sof_dev_desc rpls_desc = {
-- 
2.39.2



