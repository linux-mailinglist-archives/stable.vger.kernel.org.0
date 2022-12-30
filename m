Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8D91C657D63
	for <lists+stable@lfdr.de>; Wed, 28 Dec 2022 16:42:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233961AbiL1Pmq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Dec 2022 10:42:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57726 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233967AbiL1Pmi (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Dec 2022 10:42:38 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A07721705A
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 07:42:37 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3D9696156C
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 15:42:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4ECC7C433F0;
        Wed, 28 Dec 2022 15:42:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672242156;
        bh=0sw4uCSW7Htn5DR7826mBaweXPhwOsT9Xec91BfqeVI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CbpG18HoGPQsmBuDgOxP5R3EidY/czZyIQzKfsto6fzQzqGaQPcSYwfE87kuYjLEt
         QjbPPq/UktUvgIzCFm0qJCPXGSN7lJotArvpCkpNcFkEBpPakKLx4Q6/yMfXXOzRQw
         XaEyhBlGAwmJNyMtE9cNtenCZ1BoN3glWePg1dac=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Sibi Sankar <quic_sibis@quicinc.com>,
        Mukesh Ojha <quic_mojha@quicinc.com>,
        Luca Weiss <luca.weiss@fairphone.com>,
        Bjorn Andersson <andersson@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 569/731] remoteproc: qcom_q6v5_pas: detach power domains on remove
Date:   Wed, 28 Dec 2022 15:41:16 +0100
Message-Id: <20221228144313.050282840@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144256.536395940@linuxfoundation.org>
References: <20221228144256.536395940@linuxfoundation.org>
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

From: Luca Weiss <luca.weiss@fairphone.com>

[ Upstream commit 34d01df00b84127be04c914fc9f8e8be1fcdf851 ]

We need to detach from the power domains also on remove, not just on
probe fail so a subsequent probe works as expected.

Otherwise the following error appears on re-probe:

[   29.452005] sysfs: cannot create duplicate filename '/devices/genpd:0:3000000.remoteproc'
[   29.477121] CPU: 1 PID: 483 Comm: sh Tainted: G        W          6.1.0-rc4-00075-g71a113770bda #78
[   29.510319] Hardware name: Fairphone 4 (DT)
[   29.538335] Call trace:
[   29.564470]  dump_backtrace.part.0+0xe0/0xf0
[   29.592602]  show_stack+0x18/0x30
[   29.619616]  dump_stack_lvl+0x64/0x80
[   29.646834]  dump_stack+0x18/0x34
[   29.673541]  sysfs_warn_dup+0x60/0x7c
[   29.700592]  sysfs_create_dir_ns+0xec/0x110
[   29.728057]  kobject_add_internal+0xb8/0x374
[   29.755530]  kobject_add+0x9c/0x104
[   29.782072]  device_add+0xbc/0x8a0
[   29.808445]  device_register+0x20/0x30
[   29.835175]  genpd_dev_pm_attach_by_id+0xa4/0x190
[   29.862851]  genpd_dev_pm_attach_by_name+0x3c/0xb0
[   29.890472]  dev_pm_domain_attach_by_name+0x20/0x30
[   29.918212]  adsp_probe+0x278/0x580
[   29.944384]  platform_probe+0x68/0xc0
[   29.970603]  really_probe+0xbc/0x2dc
[   29.996662]  __driver_probe_device+0x78/0xe0
[   30.023491]  device_driver_attach+0x48/0xac
[   30.050215]  bind_store+0xb8/0x114
[   30.075957]  drv_attr_store+0x24/0x3c
[   30.101874]  sysfs_kf_write+0x44/0x54
[   30.127751]  kernfs_fop_write_iter+0x120/0x1f0
[   30.154448]  vfs_write+0x1ac/0x380
[   30.179937]  ksys_write+0x70/0x104
[   30.205274]  __arm64_sys_write+0x1c/0x2c
[   30.231060]  invoke_syscall+0x48/0x114
[   30.256594]  el0_svc_common.constprop.0+0x44/0xec
[   30.283183]  do_el0_svc+0x2c/0xd0
[   30.308320]  el0_svc+0x2c/0x84
[   30.333059]  el0t_64_sync_handler+0xf4/0x120
[   30.359001]  el0t_64_sync+0x18c/0x190
[   30.384385] kobject_add_internal failed for genpd:0:3000000.remoteproc with -EEXIST, don't try to register things with the same name in the same directory.
[   30.406029] remoteproc remoteproc0: releasing 3000000.remoteproc
[   30.416064] qcom_q6v5_pas: probe of 3000000.remoteproc failed with error -17

Fixes: 17ee2fb4e856 ("remoteproc: qcom: pas: Vote for active/proxy power domains")
Reviewed-by: Sibi Sankar <quic_sibis@quicinc.com>
Reviewed-by: Mukesh Ojha <quic_mojha@quicinc.com>
Signed-off-by: Luca Weiss <luca.weiss@fairphone.com>
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Link: https://lore.kernel.org/r/20221118090816.100012-2-luca.weiss@fairphone.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/remoteproc/qcom_q6v5_pas.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/remoteproc/qcom_q6v5_pas.c b/drivers/remoteproc/qcom_q6v5_pas.c
index 533b48522326..8b82fd598dfa 100644
--- a/drivers/remoteproc/qcom_q6v5_pas.c
+++ b/drivers/remoteproc/qcom_q6v5_pas.c
@@ -514,6 +514,7 @@ static int adsp_remove(struct platform_device *pdev)
 	qcom_remove_sysmon_subdev(adsp->sysmon);
 	qcom_remove_smd_subdev(adsp->rproc, &adsp->smd_subdev);
 	qcom_remove_ssr_subdev(adsp->rproc, &adsp->ssr_subdev);
+	adsp_pds_detach(adsp, adsp->proxy_pds, adsp->proxy_pd_count);
 	device_init_wakeup(adsp->dev, false);
 	rproc_free(adsp->rproc);
 
-- 
2.35.1



