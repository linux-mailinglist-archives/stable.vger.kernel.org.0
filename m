Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8F4F153F2CA
	for <lists+stable@lfdr.de>; Tue,  7 Jun 2022 01:52:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235355AbiFFXwC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 Jun 2022 19:52:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37284 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235357AbiFFXwA (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 6 Jun 2022 19:52:00 -0400
Received: from mail-pj1-x1036.google.com (mail-pj1-x1036.google.com [IPv6:2607:f8b0:4864:20::1036])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E5F8E612A8
        for <stable@vger.kernel.org>; Mon,  6 Jun 2022 16:51:58 -0700 (PDT)
Received: by mail-pj1-x1036.google.com with SMTP id e24so14176656pjt.0
        for <stable@vger.kernel.org>; Mon, 06 Jun 2022 16:51:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Az5/ufszy2Yss6KvjflMBeMhd7vexU/BhYHjmjob1nw=;
        b=DZk/aNTDUn2wlr3VcMKqDhOyp223j0Ve3wolf5dZwMobALUiZ57h250ySN7jn3h/7h
         yh3+j9ovaKUaCNJMVExLfTm+bL5rauAYC9kO/1LW0M/UGRKSG9f4/fvttOUgyXTv/F6i
         69b69bcx++HNNFKiLXJiDCH066wQWSMIRCQkc=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Az5/ufszy2Yss6KvjflMBeMhd7vexU/BhYHjmjob1nw=;
        b=WTCojkwvKAPAdzCewNAYvAmwA9cAO/vds5v3/Aeo437W0tvcg5UJMHDatIXpUtU3eP
         O7C/pwSr4nI0bZP8xZZJDVfPIMTDn6Lld/BLGM3JavV2Tcrablw3iHgG4gqKyE9bC+4l
         6zdxOwmCIsV7nGUx1RVFc4lWgo4gE8bfZuLWMfY5aeOioZiIpy5CEQ0C61QCnl4S1XvM
         Ce0oeSfRDGZZ+tAeMtt2Kr7DIWPItnEB5a7/5IIJaQTWg3zSdE6PI82mddto4kwx09zw
         uVnJP3zHthGqxrGwUIh52NnnDC7zD3UBGkD9AV/yEli5Wk5krLiEmZR8gWmvly4bVrl5
         UWow==
X-Gm-Message-State: AOAM533gRjdtUO0fKkPkCwgqgnRoFnp1TL9Z/9A69T02dljH4GLd5T35
        +i0vJMvQXsk8rQ3vlRLWLKE1MS017S6ipQ==
X-Google-Smtp-Source: ABdhPJxZdc6u07+92qH6LGkrcFx1B1ZDFvLeHJE2BM1oOz40OsCzV/M1u8yA9+CtYzNKXTbD7zbmkg==
X-Received: by 2002:a17:90b:1e44:b0:1e2:e772:5f08 with SMTP id pi4-20020a17090b1e4400b001e2e7725f08mr49079351pjb.129.1654559518249;
        Mon, 06 Jun 2022 16:51:58 -0700 (PDT)
Received: from smtp.gmail.com ([2620:15c:202:201:7100:486c:d20:242a])
        by smtp.gmail.com with ESMTPSA id 66-20020a621445000000b0050dc762816dsm11005789pfu.71.2022.06.06.16.51.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 06 Jun 2022 16:51:57 -0700 (PDT)
From:   Stephen Boyd <swboyd@chromium.org>
To:     stable@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, patches@lists.linux.dev,
        Alex Elder <elder@linaro.org>,
        Georgi Djakov <djakov@kernel.org>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Taniya Das <quic_tdas@quicinc.com>,
        Mike Tipton <quic_mdtipton@quicinc.com>
Subject: [PATCH 5.15 1/2] interconnect: qcom: sc7180: Drop IP0 interconnects
Date:   Mon,  6 Jun 2022 16:51:54 -0700
Message-Id: <20220606235155.2437168-2-swboyd@chromium.org>
X-Mailer: git-send-email 2.36.1.255.ge46751e96f-goog
In-Reply-To: <20220606235155.2437168-1-swboyd@chromium.org>
References: <20220606235155.2437168-1-swboyd@chromium.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-3.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

commit 2f3724930eb4bba74f7d10bc3bef5bb22dd323df upstream.

The IPA BCM resource ("IP0") on sc7180 was moved to the clk-rpmh driver
in commit bcd63d222b60 ("clk: qcom: rpmh: Add IPA clock for SC7180") and
modeled as a clk, but this interconnect driver still had it modeled as
an interconnect. This was mostly OK because nobody used the interconnect
definition, until the interconnect framework started dropping bandwidth
requests on interconnects that aren't used via the sync_state callback
in commit 7d3b0b0d8184 ("interconnect: qcom: Use icc_sync_state"). Once
that patch was applied the IP0 resource was going to be controlled from
two places, the clk framework and the interconnect framework.

Even then, things were probably going to be OK, because commit
b95b668eaaa2 ("interconnect: qcom: icc-rpmh: Add BCMs to commit list in
pre_aggregate") was needed to actually drop bandwidth requests on unused
interconnects, of which the IPA was one of the interconnect that wasn't
getting dropped to zero. Combining the three commits together leads to
bad behavior where the interconnect framework is disabling the IP0
resource because it has no users while the clk framework thinks the IP0
resource is on because the only user, the IPA driver, has turned it on
via clk_prepare_enable(). Depending on when sync_state is called, we can
get into a situation like below:

  IPA driver probes
  IPA driver gets notified modem started
   runtime PM get()
    IPA clk enabled -> IP0 resource is ON
  sync_state runs
   interconnect zeroes out the IP0 resource -> IP0 resource is off
  IPA driver tries to access a register and blows up

The crash is an unclocked access that manifest as an SError.

 SError Interrupt on CPU0, code 0xbe000011 -- SError
 CPU: 0 PID: 3595 Comm: mmdata_mgr Not tainted 5.17.1+ #166
 Hardware name: Google Lazor (rev1 - 2) with LTE (DT)
 pstate: 60400009 (nZCv daif +PAN -UAO -TCO -DIT -SSBS BTYPE=--)
 pc : mutex_lock+0x4c/0x80
 lr : mutex_lock+0x30/0x80
 sp : ffffffc00da9b9c0
 x29: ffffffc00da9b9c0 x28: 0000000000000000 x27: 0000000000000000
 x26: ffffffc00da9bc90 x25: ffffff80c2024010 x24: ffffff80c2024000
 x23: ffffff8083100000 x22: ffffff80831000d0 x21: ffffff80831000a8
 x20: ffffff80831000a8 x19: ffffff8083100070 x18: 00000000ffff0a00
 x17: 000000002f7254f1 x16: 0000000000000100 x15: 0000000000000000
 x14: 0000000000000000 x13: 0000000000000000 x12: 0000000000000000
 x11: 000000000001f0b8 x10: ffffffc00931f0b8 x9 : 0000000000000000
 x8 : 0000000000000000 x7 : fefefefefeff2f60 x6 : 0000808080808080
 x5 : 0000000000000000 x4 : 8080808080800000 x3 : ffffff80d2d4ee28
 x2 : ffffff808c1d6e40 x1 : 0000000000000000 x0 : ffffff8083100070
 Kernel panic - not syncing: Asynchronous SError Interrupt
 CPU: 0 PID: 3595 Comm: mmdata_mgr Not tainted 5.17.1+ #166
 Hardware name: Google Lazor (rev1 - 2) with LTE (DT)
 Call trace:
  dump_backtrace+0xf4/0x114
  show_stack+0x24/0x30
  dump_stack_lvl+0x64/0x7c
  dump_stack+0x18/0x38
  panic+0x150/0x38c
  nmi_panic+0x88/0xa0
  arm64_serror_panic+0x74/0x80
  do_serror+0x0/0x80
  do_serror+0x58/0x80
  el1h_64_error_handler+0x34/0x4c
  el1h_64_error+0x78/0x7c
  mutex_lock+0x4c/0x80
  __gsi_channel_start+0x50/0x17c
  gsi_channel_start+0x54/0x90
  ipa_endpoint_enable_one+0x34/0xc0
  ipa_open+0x4c/0x120

Remove all IP0 resource management from the interconnect driver so that
clk-rpmh is the sole owner. This fixes the issue by preventing the
interconnect driver from overwriting the IP0 resource data that the
clk-rpmh driver wrote.

Cc: Alex Elder <elder@linaro.org>
Cc: Bjorn Andersson <bjorn.andersson@linaro.org>
Cc: Taniya Das <quic_tdas@quicinc.com>
Cc: Mike Tipton <quic_mdtipton@quicinc.com>
Fixes: b95b668eaaa2 ("interconnect: qcom: icc-rpmh: Add BCMs to commit list in pre_aggregate")
Fixes: bcd63d222b60 ("clk: qcom: rpmh: Add IPA clock for SC7180")
Fixes: 7d3b0b0d8184 ("interconnect: qcom: Use icc_sync_state")
Signed-off-by: Stephen Boyd <swboyd@chromium.org>
Tested-by: Alex Elder <elder@linaro.org>
Reviewed-by: Alex Elder <elder@linaro.org>
Reviewed-by: Bjorn Andersson <bjorn.andersson@linaro.org>
Link: https://lore.kernel.org/r/20220412220033.1273607-2-swboyd@chromium.org
Signed-off-by: Georgi Djakov <djakov@kernel.org>
Signed-off-by: Stephen Boyd <swboyd@chromium.org>
---
 drivers/interconnect/qcom/sc7180.c | 21 ---------------------
 1 file changed, 21 deletions(-)

diff --git a/drivers/interconnect/qcom/sc7180.c b/drivers/interconnect/qcom/sc7180.c
index 12d59c36df53..5f7c0f85fa8e 100644
--- a/drivers/interconnect/qcom/sc7180.c
+++ b/drivers/interconnect/qcom/sc7180.c
@@ -47,7 +47,6 @@ DEFINE_QNODE(qnm_mnoc_sf, SC7180_MASTER_MNOC_SF_MEM_NOC, 1, 32, SC7180_SLAVE_GEM
 DEFINE_QNODE(qnm_snoc_gc, SC7180_MASTER_SNOC_GC_MEM_NOC, 1, 8, SC7180_SLAVE_LLCC);
 DEFINE_QNODE(qnm_snoc_sf, SC7180_MASTER_SNOC_SF_MEM_NOC, 1, 16, SC7180_SLAVE_LLCC);
 DEFINE_QNODE(qxm_gpu, SC7180_MASTER_GFX3D, 2, 32, SC7180_SLAVE_GEM_NOC_SNOC, SC7180_SLAVE_LLCC);
-DEFINE_QNODE(ipa_core_master, SC7180_MASTER_IPA_CORE, 1, 8, SC7180_SLAVE_IPA_CORE);
 DEFINE_QNODE(llcc_mc, SC7180_MASTER_LLCC, 2, 4, SC7180_SLAVE_EBI1);
 DEFINE_QNODE(qhm_mnoc_cfg, SC7180_MASTER_CNOC_MNOC_CFG, 1, 4, SC7180_SLAVE_SERVICE_MNOC);
 DEFINE_QNODE(qxm_camnoc_hf0, SC7180_MASTER_CAMNOC_HF0, 2, 32, SC7180_SLAVE_MNOC_HF_MEM_NOC);
@@ -129,7 +128,6 @@ DEFINE_QNODE(qhs_mdsp_ms_mpu_cfg, SC7180_SLAVE_MSS_PROC_MS_MPU_CFG, 1, 4);
 DEFINE_QNODE(qns_gem_noc_snoc, SC7180_SLAVE_GEM_NOC_SNOC, 1, 8, SC7180_MASTER_GEM_NOC_SNOC);
 DEFINE_QNODE(qns_llcc, SC7180_SLAVE_LLCC, 1, 16, SC7180_MASTER_LLCC);
 DEFINE_QNODE(srvc_gemnoc, SC7180_SLAVE_SERVICE_GEM_NOC, 1, 4);
-DEFINE_QNODE(ipa_core_slave, SC7180_SLAVE_IPA_CORE, 1, 8);
 DEFINE_QNODE(ebi, SC7180_SLAVE_EBI1, 2, 4);
 DEFINE_QNODE(qns_mem_noc_hf, SC7180_SLAVE_MNOC_HF_MEM_NOC, 1, 32, SC7180_MASTER_MNOC_HF_MEM_NOC);
 DEFINE_QNODE(qns_mem_noc_sf, SC7180_SLAVE_MNOC_SF_MEM_NOC, 1, 32, SC7180_MASTER_MNOC_SF_MEM_NOC);
@@ -160,7 +158,6 @@ DEFINE_QBCM(bcm_mc0, "MC0", true, &ebi);
 DEFINE_QBCM(bcm_sh0, "SH0", true, &qns_llcc);
 DEFINE_QBCM(bcm_mm0, "MM0", false, &qns_mem_noc_hf);
 DEFINE_QBCM(bcm_ce0, "CE0", false, &qxm_crypto);
-DEFINE_QBCM(bcm_ip0, "IP0", false, &ipa_core_slave);
 DEFINE_QBCM(bcm_cn0, "CN0", true, &qnm_snoc, &xm_qdss_dap, &qhs_a1_noc_cfg, &qhs_a2_noc_cfg, &qhs_ahb2phy0, &qhs_aop, &qhs_aoss, &qhs_boot_rom, &qhs_camera_cfg, &qhs_camera_nrt_throttle_cfg, &qhs_camera_rt_throttle_cfg, &qhs_clk_ctl, &qhs_cpr_cx, &qhs_cpr_mx, &qhs_crypto0_cfg, &qhs_dcc_cfg, &qhs_ddrss_cfg, &qhs_display_cfg, &qhs_display_rt_throttle_cfg, &qhs_display_throttle_cfg, &qhs_glm, &qhs_gpuss_cfg, &qhs_imem_cfg, &qhs_ipa, &qhs_mnoc_cfg, &qhs_mss_cfg, &qhs_npu_cfg, &qhs_npu_dma_throttle_cfg, &qhs_npu_dsp_throttle_cfg, &qhs_pimem_cfg, &qhs_prng, &qhs_qdss_cfg, &qhs_qm_cfg, &qhs_qm_mpu_cfg, &qhs_qup0, &qhs_qup1, &qhs_security, &qhs_snoc_cfg, &qhs_tcsr, &qhs_tlmm_1, &qhs_tlmm_2, &qhs_tlmm_3, &qhs_ufs_mem_cfg, &qhs_usb3, &qhs_venus_cfg, &qhs_venus_throttle_cfg, &qhs_vsense_ctrl_cfg, &srvc_cnoc);
 DEFINE_QBCM(bcm_mm1, "MM1", false, &qxm_camnoc_hf0_uncomp, &qxm_camnoc_hf1_uncomp, &qxm_camnoc_sf_uncomp, &qhm_mnoc_cfg, &qxm_mdp0, &qxm_rot, &qxm_venus0, &qxm_venus_arm9);
 DEFINE_QBCM(bcm_sh2, "SH2", false, &acm_sys_tcu);
@@ -372,22 +369,6 @@ static struct qcom_icc_desc sc7180_gem_noc = {
 	.num_bcms = ARRAY_SIZE(gem_noc_bcms),
 };
 
-static struct qcom_icc_bcm *ipa_virt_bcms[] = {
-	&bcm_ip0,
-};
-
-static struct qcom_icc_node *ipa_virt_nodes[] = {
-	[MASTER_IPA_CORE] = &ipa_core_master,
-	[SLAVE_IPA_CORE] = &ipa_core_slave,
-};
-
-static struct qcom_icc_desc sc7180_ipa_virt = {
-	.nodes = ipa_virt_nodes,
-	.num_nodes = ARRAY_SIZE(ipa_virt_nodes),
-	.bcms = ipa_virt_bcms,
-	.num_bcms = ARRAY_SIZE(ipa_virt_bcms),
-};
-
 static struct qcom_icc_bcm *mc_virt_bcms[] = {
 	&bcm_acv,
 	&bcm_mc0,
@@ -519,8 +500,6 @@ static const struct of_device_id qnoc_of_match[] = {
 	  .data = &sc7180_dc_noc},
 	{ .compatible = "qcom,sc7180-gem-noc",
 	  .data = &sc7180_gem_noc},
-	{ .compatible = "qcom,sc7180-ipa-virt",
-	  .data = &sc7180_ipa_virt},
 	{ .compatible = "qcom,sc7180-mc-virt",
 	  .data = &sc7180_mc_virt},
 	{ .compatible = "qcom,sc7180-mmss-noc",
-- 
https://chromeos.dev

