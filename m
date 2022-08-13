Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8412E591AD7
	for <lists+stable@lfdr.de>; Sat, 13 Aug 2022 16:12:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237698AbiHMOMl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 13 Aug 2022 10:12:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40090 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237374AbiHMOMl (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 13 Aug 2022 10:12:41 -0400
Received: from mail-oa1-x2a.google.com (mail-oa1-x2a.google.com [IPv6:2001:4860:4864:20::2a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5DEF017AB5
        for <stable@vger.kernel.org>; Sat, 13 Aug 2022 07:12:39 -0700 (PDT)
Received: by mail-oa1-x2a.google.com with SMTP id 586e51a60fabf-10ea30a098bso3775264fac.8
        for <stable@vger.kernel.org>; Sat, 13 Aug 2022 07:12:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc;
        bh=9rZXrrjnAGvU9UDASoLGmuogxthsWQg3OunMXRacvuc=;
        b=w8u3qGW6JRFASKxDf1sJzw8Oas+dzxXWDKEaLAHwov5EBQ6x0NHhFKuUHnAy63PJK8
         9bwe/MV2u7PyXM1rBmvtW1/N48CyDtQvNqn8xpb9ZKkbEEKwnI0M29+QKzZSfB/SDsFK
         IKN16ULVMLS6ryrzcQlMdtsBWosMYZwN8jJmcbZNE4IUmp33XiPP9zSTJu+luF2eYQq9
         P/qGhZzH673c1+UVrN/b2XOIqdqiCA2ODPvU7/byvgA4Ltu0cr8ladMZG3hg6cOJ2Gt3
         9TNVkhfzWsXCMjX8DzdUN8DAIQXK2Oy/c08/ipNaiFHZtXtMwPmAqM1X/xKegS7Tld49
         y5UQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc;
        bh=9rZXrrjnAGvU9UDASoLGmuogxthsWQg3OunMXRacvuc=;
        b=lk/SVDv0w3yuWBP+E7dRM7D90qj5+ugsH/IRG1UJY8W/kJBjwHq6dW6g6a5KYLyZi5
         YFfXwTA3XEpIg2Us7S6xUadGs9/sWH9ocDav4bdHcP6mUY6HolLz7x4zemlvNR305vAR
         p4e5HVoePMcktJcZSuff3eVJRdjAUwX7VfxsSqVQ03GIB8RlkE+Mm9dZCEvR5U0RHWcO
         hFtItJ41+BQ7w9pw9WE86cz2Slx9T0VtaFxY5ESnlKCoD60KFYTgK+pIf46nLMURkhbC
         5rgt7DyzHbwW5HAo7hE4+7uXCYJ5y6RY9J1FrvfASbav/R6XxOp8ZQFiCpLA3ysqV5nY
         nIag==
X-Gm-Message-State: ACgBeo1Z3L5EioYK9ifeku2ZqXC0IA0iKHgcElweQFrWRhrG+3WyJAax
        kZtKFtohvUzsXxKLNnIxsE2gUmKasqBz8fSsoD5I/Q==
X-Google-Smtp-Source: AA6agR643V7288fZd037oA1VIDWYkCAjjSTVCTnoPRh3DCqf2r6DcryLiNWbSGqnlt9qtc968Rp1niSD+81riGLDLrg=
X-Received: by 2002:a05:6870:c185:b0:115:1923:d506 with SMTP id
 h5-20020a056870c18500b001151923d506mr3971144oad.108.1660399957678; Sat, 13
 Aug 2022 07:12:37 -0700 (PDT)
MIME-Version: 1.0
References: <20220706095644.5852-1-srinivas.kandagatla@linaro.org> <YsW8Lnhu19Wn2fZJ@matsya>
In-Reply-To: <YsW8Lnhu19Wn2fZJ@matsya>
From:   Amit Pundir <amit.pundir@linaro.org>
Date:   Sat, 13 Aug 2022 19:42:00 +0530
Message-ID: <CAMi1Hd2RgG7MZ90hkDPijRkN7pFP-RdnVdv_j7bj2OxXxXS+1w@mail.gmail.com>
Subject: Re: [PATCH] soundwire: qcom: Check device status before reading devid
To:     Vinod Koul <vkoul@kernel.org>
Cc:     Srinivas Kandagatla <srinivas.kandagatla@linaro.org>,
        yung-chuan.liao@linux.intel.com,
        pierre-louis.bossart@linux.intel.com, alsa-devel@alsa-project.org,
        linux-arm-msm@vger.kernel.org, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, 6 Jul 2022 at 22:15, Vinod Koul <vkoul@kernel.org> wrote:
>
> On 06-07-22, 10:56, Srinivas Kandagatla wrote:
> > As per hardware datasheet its recommended that we check the device
> > status before reading devid assigned by auto-enumeration.
> >
> > Without this patch we see SoundWire devices with invalid enumeration
> > addresses on the bus.
>
> Applied, thanks

Hi,

This broke DB845c running AOSP. I see:

[   10.753773][  T234]  regmap_slimbus slimbus regmap_sdw
soundwire_bus r820t qt1010 qrtr_tun qrtr_smd qrtr_mhi qrtr qnoc_sm8250
qnoc_sdm845 qm1d1c0042 qm1d1b0004 qcom_usb_vbus_regulator qcom_tsens
qcom_spmi_regulator qcom_rpm qcom_q6v5_wcss qcom_q6v5_pas
qcom_q6v5_mss qcom_q6v5_adsp qcom_q6v5 qcom_sysmon qcom_pil_info
qcom_hwspinlock qcom_glink_rpm qcom_aoss qcom_wdt qcom_spmi_temp_alarm
qcom_spmi_pmic regmap_spmi qcom_spmi_adc5 qcom_spmi_adc_tm5
qcom_vadc_common qcom_rpmh_regulator qcom_pon reboot_mode
qcom_pmic_typec qcom_pdc qcom_ipcc qcom_cpufreq_hw
qcom_apcs_ipc_mailbox q6prm_clocks q6prm q6asm_dai q6routing q6asm
q6apm_lpass_dais q6apm_dai snd_q6apm q6afe_dai q6afe_clocks q6adm
snd_q6dsp_common q6afe q6core pm8941_pwrkey pm8916_wdt
pinctrl_spmi_mpp pinctrl_spmi_gpio pinctrl_sm8250
pinctrl_sm8250_lpass_lpi pinctrl_sdm845 pinctrl_msm pinctrl_lpass_lpi
phy_qcom_usb_hs ulpi phy_qcom_snps_femto_v2 phy_qcom_qusb2
phy_qcom_qmp_usb phy_qcom_qmp_ufs phy_qcom_qmp_pcie
[   10.768358][  T234]  phy_qcom_qmp_pcie_msm8996 phy_qcom_qmp_combo
or51211 or51132 ohci_platform ohci_pci ohci_hcd nxt6000 nxt200x
nvmem_qfprom mxl692 mxl5xx mxl5007t mxl5005s mxl301rf mt352 mt312
mt2266 mt2131 mt20xx mt2063 mt2060 msm_serial msm msi001 mn88473
mn88472 mn88443x michael_mic mdt_loader mcp251xfd mc44s803 mb86a20s
mb86a16 max2165 m88rs6000t m88rs2000 m88ds3103 lpass_gfm_sm8250
lontium_lt9611uxc lontium_lt9611 lnbp22 lnbp21 lnbh29 lnbh25 lmh
llcc_qcom lgs8gxx lgs8gl5 lgdt330x lgdt3306a lgdt3305 lg2160 l64781
ix2505v itd1000 it913x isl6423 isl6421 isl6405 icc_rpmh icc_osm_l3
icc_bcm_voter i2c_rk3x i2c_qup i2c_qcom_geni i2c_mux_pca954x i2c_dev
i2c_designware_platform i2c_designware_core horus3a helene
gpucc_sm8250 gpucc_sdm845 gpu_sched gpio_wcd934x gpio_regulator
gcc_sm8250 gcc_sdm845 fc2580 fc0013 fc0012 fc0011 fastrpc
extcon_usb_gpio ec100 e4000 dvb_pll ds3000 drxk drxd drx39xyj
drm_dp_aux_bus drm_display_helper display_connector drm_kms_helper
dispcc_sm8250
[   10.854247][  T234]  dispcc_sdm845 dib9000 dib8000 dib7000p
dib7000m dib3000mc dibx000_common dib3000mb dib0090 dib0070 cxd2880
cxd2880_spi cxd2841er cxd2820r cxd2099 cx24123 cx24120 cx24117 cx24116
cx24113 cx24110 cx22702 cx22700 cqhci cpr clk_spmi_pmic_div clk_rpmh
qcom_rpmh cmd_db clk_qcom bcm3510 bam_dma virt_dma ax88179_178a
au8522_dig au8522_decoder au8522_common ath11k_pci mhi ath11k_ahb
ath11k ath10k_snoc qcom_common qcom_glink_smem qcom_glink qcom_smd
smem ath10k_pci ath10k_core ath atbm8830 ascot2e arm_smmu qcom_scm apr
pdr_interface qmi_helpers rpmsg_core af9033 af9013 i2c_mux a8293
[   10.993742][  T234] CPU: 0 PID: 234 Comm: irq/178-wcd934x Tainted:
G        W          5.19.0-mainline-14184-g69dac8e431af #1
[   11.005126][  T234] Hardware name: Thundercomm Dragonboard 845c (DT)
[   11.011531][  T234] pstate: 20400005 (nzCv daif +PAN -UAO -TCO -DIT
-SSBS BTYPE=--)
[   11.019245][  T234] pc : qcom_swrm_irq_handler+0x5d8/0x7a8 [soundwire_qcom]
[   11.026265][  T234] lr : qcom_swrm_irq_handler+0x448/0x7a8 [soundwire_qcom]
[   11.033281][  T234] sp : ffffffc009e73c40
[   11.037319][  T234] x29: ffffffc009e73c40 x28: 000000000000000b
x27: ffffff8088144bb8
[   11.045211][  T234] x26: ffffff8088144898 x25: ffffff8088144880
x24: ffffff8088147800
[   11.053101][  T234] x23: ffffff8088141800 x22: 0000000000000002
x21: 000000000000058c
[   11.060993][  T234] x20: 000000000000000b x19: 0000000000000001
x18: 0000000000000000
[   11.068886][  T234] x17: 000000000005000c x16: 0000000000000000
x15: 0000000000000001
[   11.076778][  T234] x14: 0000000000000001 x13: 0000000000000001
x12: 0000000000000000
[   11.084669][  T234] x11: 0000000000000000 x10: 0000000000000b00 x9
: ffffffc009e737d0
[   11.092560][  T234] x8 : ffffff8088cb58e0 x7 : ffffff80fd69b400 x6
: 0000000005c94c5d
[   11.100450][  T234] x5 : 0002000000200000 x4 : ffffff8088cb4d80 x3
: ffffff80881448b0
[   11.108340][  T234] x2 : 0000000000000000 x1 : 0000000000000000 x0
: 000000000000000b
[   11.116229][  T234] Call trace:
[   11.119402][  T234]  qcom_swrm_irq_handler+0x5d8/0x7a8 [soundwire_qcom]
[   11.126066][  T234]  handle_nested_irq+0xb8/0x138
[   11.130815][  T234]  regmap_irq_thread+0x244/0x698
[   11.135645][  T234]  irq_thread_fn+0x2c/0x98
[   11.139952][  T234]  irq_thread+0x17c/0x228
[   11.144172][  T234]  kthread+0x110/0x120
[   11.148129][  T234]  ret_from_fork+0x10/0x20
[   11.152441][  T234] Code: 34ffd400 aa1303e0 950cd906 17fffe9d (d4207d00)
[   11.159282][  T234] ---[ end trace 0000000000000000 ]---
[   11.164632][  T234] Kernel panic - not syncing: BRK handler: Fatal exception
[   11.171730][  T234] SMP: stopping secondary CPUs
[   11.376443][  T234] Kernel Offset: 0x2fef400000 from 0xffffffc008000000
[   11.383109][  T234] PHYS_OFFSET: 0x80000000
[   11.387322][  T234] CPU features: 0x0000,00041021,19801c86
[   11.392850][  T234] Memory Limit: none

Regards,
Amit Pundir


>
> --
> ~Vinod
