Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6C8F9635525
	for <lists+stable@lfdr.de>; Wed, 23 Nov 2022 10:16:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237283AbiKWJPB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 23 Nov 2022 04:15:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56824 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237286AbiKWJOu (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 23 Nov 2022 04:14:50 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 91EFA107E4C
        for <stable@vger.kernel.org>; Wed, 23 Nov 2022 01:14:48 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 419EFB81EF9
        for <stable@vger.kernel.org>; Wed, 23 Nov 2022 09:14:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5ABBDC433D6;
        Wed, 23 Nov 2022 09:14:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1669194885;
        bh=vvIEhiJa9pK2NM92hK7sLhClYHmJU5Y7fnE0VhGALmY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SYxjGt+eiFB9f6AlDhAbrql2jXz8OBCHTqdnlRdkeVuxUkRQkSUEt+dYrS3AuZLf8
         SViLBRhAz3ogDQXS7uag0FQ8YI9NokSmkyWPQNv6hy3C7yqsH0ehZdw3MuYPa4m6jm
         oLhAYfaSEit2TaLxezwTYgTnM9WffGPAqGbCqp4k=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Martin Kaiser <martin@kaiser.cx>,
        Shawn Guo <shawn.guo@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 087/156] serial: imx: Add missing .thaw_noirq hook
Date:   Wed, 23 Nov 2022 09:50:44 +0100
Message-Id: <20221123084601.140404508@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221123084557.816085212@linuxfoundation.org>
References: <20221123084557.816085212@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Shawn Guo <shawn.guo@linaro.org>

[ Upstream commit 4561d8008a467cb05ac632a215391d6b787f40aa ]

The following warning is seen with non-console UART instance when
system hibernates.

[   37.371969] ------------[ cut here ]------------
[   37.376599] uart3_root_clk already disabled
[   37.380810] WARNING: CPU: 0 PID: 296 at drivers/clk/clk.c:952 clk_core_disable+0xa4/0xb0
...
[   37.506986] Call trace:
[   37.509432]  clk_core_disable+0xa4/0xb0
[   37.513270]  clk_disable+0x34/0x50
[   37.516672]  imx_uart_thaw+0x38/0x5c
[   37.520250]  platform_pm_thaw+0x30/0x6c
[   37.524089]  dpm_run_callback.constprop.0+0x3c/0xd4
[   37.528972]  device_resume+0x7c/0x160
[   37.532633]  dpm_resume+0xe8/0x230
[   37.536036]  hibernation_snapshot+0x288/0x430
[   37.540397]  hibernate+0x10c/0x2e0
[   37.543798]  state_store+0xc4/0xd0
[   37.547203]  kobj_attr_store+0x1c/0x30
[   37.550953]  sysfs_kf_write+0x48/0x60
[   37.554619]  kernfs_fop_write_iter+0x118/0x1ac
[   37.559063]  new_sync_write+0xe8/0x184
[   37.562812]  vfs_write+0x230/0x290
[   37.566214]  ksys_write+0x68/0xf4
[   37.569529]  __arm64_sys_write+0x20/0x2c
[   37.573452]  invoke_syscall.constprop.0+0x50/0xf0
[   37.578156]  do_el0_svc+0x11c/0x150
[   37.581648]  el0_svc+0x30/0x140
[   37.584792]  el0t_64_sync_handler+0xe8/0xf0
[   37.588976]  el0t_64_sync+0x1a0/0x1a4
[   37.592639] ---[ end trace 56e22eec54676d75 ]---

On hibernating, pm core calls into related hooks in sequence like:

    .freeze
    .freeze_noirq
    .thaw_noirq
    .thaw

With .thaw_noirq hook being absent, the clock will be disabled in a
unbalanced call which results the warning above.

    imx_uart_freeze()
        clk_prepare_enable()
    imx_uart_suspend_noirq()
        clk_disable()
    imx_uart_thaw
        clk_disable_unprepare()

Adding the missing .thaw_noirq hook as imx_uart_resume_noirq() will have
the call sequence corrected as below and thus fix the warning.

    imx_uart_freeze()
        clk_prepare_enable()
    imx_uart_suspend_noirq()
        clk_disable()
    imx_uart_resume_noirq()
        clk_enable()
    imx_uart_thaw
        clk_disable_unprepare()

Fixes: 09df0b3464e5 ("serial: imx: fix endless loop during suspend")
Reviewed-by: Martin Kaiser <martin@kaiser.cx>
Signed-off-by: Shawn Guo <shawn.guo@linaro.org>
Link: https://lore.kernel.org/r/20221012121353.2346280-1-shawn.guo@linaro.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/tty/serial/imx.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/tty/serial/imx.c b/drivers/tty/serial/imx.c
index 8b41a783b37e..3f5878e367c7 100644
--- a/drivers/tty/serial/imx.c
+++ b/drivers/tty/serial/imx.c
@@ -2551,6 +2551,7 @@ static const struct dev_pm_ops imx_uart_pm_ops = {
 	.suspend_noirq = imx_uart_suspend_noirq,
 	.resume_noirq = imx_uart_resume_noirq,
 	.freeze_noirq = imx_uart_suspend_noirq,
+	.thaw_noirq = imx_uart_resume_noirq,
 	.restore_noirq = imx_uart_resume_noirq,
 	.suspend = imx_uart_suspend,
 	.resume = imx_uart_resume,
-- 
2.35.1



