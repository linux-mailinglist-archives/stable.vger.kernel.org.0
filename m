Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2FEDE6C17EC
	for <lists+stable@lfdr.de>; Mon, 20 Mar 2023 16:18:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232554AbjCTPST (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Mar 2023 11:18:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50922 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232445AbjCTPSA (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Mar 2023 11:18:00 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 807FE31BFD
        for <stable@vger.kernel.org>; Mon, 20 Mar 2023 08:12:40 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id CA1F3615AC
        for <stable@vger.kernel.org>; Mon, 20 Mar 2023 15:12:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D8AE3C433A1;
        Mon, 20 Mar 2023 15:12:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1679325158;
        bh=u+UkYaVqcTZmdfg4R1UvRpaBvDMgQ8BB9FpaB0r6CsM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CkWfDvh3Wjcq1TTbDsJPoC+ym3HyAPEHfVxCTqyuZqQpEB+TASuXRl19ptg0HQbEs
         fMBvkFUDVjJOpd1+ofsna/4AwZ45za7wEyhI8rhcXYtP3qnV8yIfXKtpRpso1hjBnT
         K4pizp1hsWk71hHKK50L0XeqTOuZrf7vxuwKkNq4=
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
Subject: [PATCH 6.2 011/211] ASoC: SOF: Intel: HDA: Fix device description
Date:   Mon, 20 Mar 2023 15:52:26 +0100
Message-Id: <20230320145513.772639200@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230320145513.305686421@linuxfoundation.org>
References: <20230320145513.305686421@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
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
index 69279dcc92dc1..aff6cb573c270 100644
--- a/sound/soc/sof/intel/pci-apl.c
+++ b/sound/soc/sof/intel/pci-apl.c
@@ -78,6 +78,7 @@ static const struct sof_dev_desc glk_desc = {
 	.nocodec_tplg_filename = "sof-glk-nocodec.tplg",
 	.ops = &sof_apl_ops,
 	.ops_init = sof_apl_ops_init,
+	.ops_free = hda_ops_free,
 };
 
 /* PCI IDs */
diff --git a/sound/soc/sof/intel/pci-cnl.c b/sound/soc/sof/intel/pci-cnl.c
index 8db3f8d15b55e..4c0c1c369dcd8 100644
--- a/sound/soc/sof/intel/pci-cnl.c
+++ b/sound/soc/sof/intel/pci-cnl.c
@@ -48,6 +48,7 @@ static const struct sof_dev_desc cnl_desc = {
 	.nocodec_tplg_filename = "sof-cnl-nocodec.tplg",
 	.ops = &sof_cnl_ops,
 	.ops_init = sof_cnl_ops_init,
+	.ops_free = hda_ops_free,
 };
 
 static const struct sof_dev_desc cfl_desc = {
@@ -111,6 +112,7 @@ static const struct sof_dev_desc cml_desc = {
 	.nocodec_tplg_filename = "sof-cnl-nocodec.tplg",
 	.ops = &sof_cnl_ops,
 	.ops_init = sof_cnl_ops_init,
+	.ops_free = hda_ops_free,
 };
 
 /* PCI IDs */
diff --git a/sound/soc/sof/intel/pci-icl.c b/sound/soc/sof/intel/pci-icl.c
index d6cf75e357dbf..6785669113b3c 100644
--- a/sound/soc/sof/intel/pci-icl.c
+++ b/sound/soc/sof/intel/pci-icl.c
@@ -79,6 +79,7 @@ static const struct sof_dev_desc jsl_desc = {
 	.nocodec_tplg_filename = "sof-jsl-nocodec.tplg",
 	.ops = &sof_cnl_ops,
 	.ops_init = sof_cnl_ops_init,
+	.ops_free = hda_ops_free,
 };
 
 /* PCI IDs */
diff --git a/sound/soc/sof/intel/pci-tgl.c b/sound/soc/sof/intel/pci-tgl.c
index e80c4dfef85a5..adc7314a1b578 100644
--- a/sound/soc/sof/intel/pci-tgl.c
+++ b/sound/soc/sof/intel/pci-tgl.c
@@ -48,6 +48,7 @@ static const struct sof_dev_desc tgl_desc = {
 	.nocodec_tplg_filename = "sof-tgl-nocodec.tplg",
 	.ops = &sof_tgl_ops,
 	.ops_init = sof_tgl_ops_init,
+	.ops_free = hda_ops_free,
 };
 
 static const struct sof_dev_desc tglh_desc = {
@@ -110,6 +111,7 @@ static const struct sof_dev_desc ehl_desc = {
 	.nocodec_tplg_filename = "sof-ehl-nocodec.tplg",
 	.ops = &sof_tgl_ops,
 	.ops_init = sof_tgl_ops_init,
+	.ops_free = hda_ops_free,
 };
 
 static const struct sof_dev_desc adls_desc = {
@@ -141,6 +143,7 @@ static const struct sof_dev_desc adls_desc = {
 	.nocodec_tplg_filename = "sof-adl-nocodec.tplg",
 	.ops = &sof_tgl_ops,
 	.ops_init = sof_tgl_ops_init,
+	.ops_free = hda_ops_free,
 };
 
 static const struct sof_dev_desc adl_desc = {
@@ -172,6 +175,7 @@ static const struct sof_dev_desc adl_desc = {
 	.nocodec_tplg_filename = "sof-adl-nocodec.tplg",
 	.ops = &sof_tgl_ops,
 	.ops_init = sof_tgl_ops_init,
+	.ops_free = hda_ops_free,
 };
 
 static const struct sof_dev_desc adl_n_desc = {
@@ -203,6 +207,7 @@ static const struct sof_dev_desc adl_n_desc = {
 	.nocodec_tplg_filename = "sof-adl-nocodec.tplg",
 	.ops = &sof_tgl_ops,
 	.ops_init = sof_tgl_ops_init,
+	.ops_free = hda_ops_free,
 };
 
 static const struct sof_dev_desc rpls_desc = {
-- 
2.39.2



