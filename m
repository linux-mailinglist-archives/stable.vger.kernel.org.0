Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 726CF5921DB
	for <lists+stable@lfdr.de>; Sun, 14 Aug 2022 17:42:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241096AbiHNPmZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 14 Aug 2022 11:42:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40012 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241587AbiHNPl6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 14 Aug 2022 11:41:58 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 856BB2317A;
        Sun, 14 Aug 2022 08:33:26 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 357F560D24;
        Sun, 14 Aug 2022 15:33:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8CC98C433D6;
        Sun, 14 Aug 2022 15:33:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1660491203;
        bh=/0+jimdYwUCJN42zHCwjCqChS2Ubs8v0UBsiMm24SKs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CWTTQvtEPE0Jhgq+jo2IIFUEzcxNWfDgkWY47hQSm5OL75PcLDJ0bE/AODMYlHTIA
         kB8K54GSuJd9K/UBNMFCymGIwV3vhm2NoeCBfVyS4cFVYa+gfbvZ3I6cwH273FACN3
         u4m/YU4KESm6GBkRwyIh0oCBetQ1jxVHk0VPeUPZsmYsWPwKCDrgqMyLKQfriOZmTU
         GIKePcZ12CNk0BKp2N88WYR2FP4aDlCi04I0CRLJLK/wsV7S8M+OkX+40e/LrnSR73
         kYFrtkmeWR9wLWSE7MPpMDXj1i6xI8E3en+pnX/ESjq2BdK4QtsOeCMuNwFivAeyLm
         ukXk/7v2A1sKw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Robert Marko <robimarko@gmail.com>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Sasha Levin <sashal@kernel.org>, agross@kernel.org,
        mturquette@baylibre.com, sboyd@kernel.org,
        linux-arm-msm@vger.kernel.org, linux-clk@vger.kernel.org
Subject: [PATCH AUTOSEL 5.15 17/46] clk: qcom: ipq8074: dont disable gcc_sleep_clk_src
Date:   Sun, 14 Aug 2022 11:32:18 -0400
Message-Id: <20220814153247.2378312-17-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220814153247.2378312-1-sashal@kernel.org>
References: <20220814153247.2378312-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Robert Marko <robimarko@gmail.com>

[ Upstream commit 1bf7305e79aab095196131bdc87a97796e0e3fac ]

Once the usb sleep clocks are disabled, clock framework is trying to
disable the sleep clock source also.

However, it seems that it cannot be disabled and trying to do so produces:
[  245.436390] ------------[ cut here ]------------
[  245.441233] gcc_sleep_clk_src status stuck at 'on'
[  245.441254] WARNING: CPU: 2 PID: 223 at clk_branch_wait+0x130/0x140
[  245.450435] Modules linked in: xhci_plat_hcd xhci_hcd dwc3 dwc3_qcom leds_gpio
[  245.456601] CPU: 2 PID: 223 Comm: sh Not tainted 5.18.0-rc4 #215
[  245.463889] Hardware name: Xiaomi AX9000 (DT)
[  245.470050] pstate: 204000c5 (nzCv daIF +PAN -UAO -TCO -DIT -SSBS BTYPE=--)
[  245.474307] pc : clk_branch_wait+0x130/0x140
[  245.481073] lr : clk_branch_wait+0x130/0x140
[  245.485588] sp : ffffffc009f2bad0
[  245.489838] x29: ffffffc009f2bad0 x28: ffffff8003e6c800 x27: 0000000000000000
[  245.493057] x26: 0000000000000000 x25: 0000000000000000 x24: ffffff800226ef20
[  245.500175] x23: ffffffc0089ff550 x22: 0000000000000000 x21: ffffffc008476ad0
[  245.507294] x20: 0000000000000000 x19: ffffffc00965ac70 x18: fffffffffffc51a7
[  245.514413] x17: 68702e3030303837 x16: 3a6d726f6674616c x15: ffffffc089f2b777
[  245.521531] x14: ffffffc0095c9d18 x13: 0000000000000129 x12: 0000000000000129
[  245.528649] x11: 00000000ffffffea x10: ffffffc009621d18 x9 : 0000000000000001
[  245.535767] x8 : 0000000000000001 x7 : 0000000000017fe8 x6 : 0000000000000001
[  245.542885] x5 : ffffff803fdca6d8 x4 : 0000000000000000 x3 : 0000000000000027
[  245.550002] x2 : 0000000000000027 x1 : 0000000000000023 x0 : 0000000000000026
[  245.557122] Call trace:
[  245.564229]  clk_branch_wait+0x130/0x140
[  245.566490]  clk_branch2_disable+0x2c/0x40
[  245.570656]  clk_core_disable+0x60/0xb0
[  245.574561]  clk_core_disable+0x68/0xb0
[  245.578293]  clk_disable+0x30/0x50
[  245.582113]  dwc3_qcom_remove+0x60/0xc0 [dwc3_qcom]
[  245.585588]  platform_remove+0x28/0x60
[  245.590361]  device_remove+0x4c/0x80
[  245.594179]  device_release_driver_internal+0x1dc/0x230
[  245.597914]  device_driver_detach+0x18/0x30
[  245.602861]  unbind_store+0xec/0x110
[  245.607027]  drv_attr_store+0x24/0x40
[  245.610847]  sysfs_kf_write+0x44/0x60
[  245.614405]  kernfs_fop_write_iter+0x128/0x1c0
[  245.618052]  new_sync_write+0xc0/0x130
[  245.622391]  vfs_write+0x1d4/0x2a0
[  245.626123]  ksys_write+0x58/0xe0
[  245.629508]  __arm64_sys_write+0x1c/0x30
[  245.632895]  invoke_syscall.constprop.0+0x5c/0x110
[  245.636890]  do_el0_svc+0xa0/0x150
[  245.641488]  el0_svc+0x18/0x60
[  245.644872]  el0t_64_sync_handler+0xa4/0x130
[  245.647914]  el0t_64_sync+0x174/0x178
[  245.652340] ---[ end trace 0000000000000000 ]---

So, add CLK_IS_CRITICAL flag to the clock so that the kernel won't try
to disable the sleep clock.

Signed-off-by: Robert Marko <robimarko@gmail.com>
Signed-off-by: Bjorn Andersson <bjorn.andersson@linaro.org>
Link: https://lore.kernel.org/r/20220515210048.483898-10-robimarko@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/qcom/gcc-ipq8074.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/clk/qcom/gcc-ipq8074.c b/drivers/clk/qcom/gcc-ipq8074.c
index 541016db3c4b..6bdf65a6e33d 100644
--- a/drivers/clk/qcom/gcc-ipq8074.c
+++ b/drivers/clk/qcom/gcc-ipq8074.c
@@ -662,6 +662,7 @@ static struct clk_branch gcc_sleep_clk_src = {
 			},
 			.num_parents = 1,
 			.ops = &clk_branch2_ops,
+			.flags = CLK_IS_CRITICAL,
 		},
 	},
 };
-- 
2.35.1

