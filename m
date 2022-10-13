Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D7DCB5FCF32
	for <lists+stable@lfdr.de>; Thu, 13 Oct 2022 02:16:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229746AbiJMAQD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 Oct 2022 20:16:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37172 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229616AbiJMAQD (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 12 Oct 2022 20:16:03 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 24B52D38E3;
        Wed, 12 Oct 2022 17:16:02 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id AD1E161684;
        Thu, 13 Oct 2022 00:16:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ED257C433C1;
        Thu, 13 Oct 2022 00:15:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1665620161;
        bh=JANyCe8JQE5s7goiFOxXvXCylmib8YtSbUs1+M+zqNI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cpCr/mxtfaofkA+AMrMaLpTiy/e9gZjZvoz325/GNgzUEGCaEBHR+SYlsLVU1+H2S
         Qo4ZcEzJVzUjj6VrmBhwgYSndtcxieGDvb5byJkMK93p70fJSATB1OeFAFrfjQ4vpr
         kjvocfAuH26qkD7nsqUQBhruKE01ZWiHyrsXf1Zi39b8lySbznE5gDKo2RD8V9VWYg
         OgCqmhdJg5WlTH+aUTDc2uw3R8uqub/FIcBxKbilcnipS5+xcrwI82xMJ+xho+wefn
         Mm+pjYzYoesP3RrcZ+Gi/MV8YcNDWaBvht7PzbrZYX81cHwjWETpblS9pFvtKMRyE8
         bYLWFZzocyW/w==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Ian Nam <young.kwan.nam@xilinx.com>,
        Shubhrajyoti Datta <shubhrajyoti.datta@xilinx.com>,
        Michal Simek <michal.simek@amd.com>,
        Stephen Boyd <sboyd@kernel.org>,
        Sasha Levin <sashal@kernel.org>, mturquette@baylibre.com,
        michal.simek@xilinx.com, linux-clk@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH AUTOSEL 6.0 02/67] clk: zynqmp: Fix stack-out-of-bounds in strncpy`
Date:   Wed, 12 Oct 2022 20:14:43 -0400
Message-Id: <20221013001554.1892206-2-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221013001554.1892206-1-sashal@kernel.org>
References: <20221013001554.1892206-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_FILL_THIS_FORM_SHORT autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ian Nam <young.kwan.nam@xilinx.com>

[ Upstream commit dd80fb2dbf1cd8751efbe4e53e54056f56a9b115 ]

"BUG: KASAN: stack-out-of-bounds in strncpy+0x30/0x68"

Linux-ATF interface is using 16 bytes of SMC payload. In case clock name is
longer than 15 bytes, string terminated NULL character will not be received
by Linux. Add explicit NULL character at last byte to fix issues when clock
name is longer.

This fixes below bug reported by KASAN:

 ==================================================================
 BUG: KASAN: stack-out-of-bounds in strncpy+0x30/0x68
 Read of size 1 at addr ffff0008c89a7410 by task swapper/0/1

 CPU: 1 PID: 1 Comm: swapper/0 Not tainted 5.4.0-00396-g81ef9e7-dirty #3
 Hardware name: Xilinx Versal vck190 Eval board revA (QSPI) (DT)
 Call trace:
  dump_backtrace+0x0/0x1e8
  show_stack+0x14/0x20
  dump_stack+0xd4/0x108
  print_address_description.isra.0+0xbc/0x37c
  __kasan_report+0x144/0x198
  kasan_report+0xc/0x18
  __asan_load1+0x5c/0x68
  strncpy+0x30/0x68
  zynqmp_clock_probe+0x238/0x7b8
  platform_drv_probe+0x6c/0xc8
  really_probe+0x14c/0x418
  driver_probe_device+0x74/0x130
  __device_attach_driver+0xc4/0xe8
  bus_for_each_drv+0xec/0x150
  __device_attach+0x160/0x1d8
  device_initial_probe+0x10/0x18
  bus_probe_device+0xe0/0xf0
  device_add+0x528/0x950
  of_device_add+0x5c/0x80
  of_platform_device_create_pdata+0x120/0x168
  of_platform_bus_create+0x244/0x4e0
  of_platform_populate+0x50/0xe8
  zynqmp_firmware_probe+0x370/0x3a8
  platform_drv_probe+0x6c/0xc8
  really_probe+0x14c/0x418
  driver_probe_device+0x74/0x130
  device_driver_attach+0x94/0xa0
  __driver_attach+0x70/0x108
  bus_for_each_dev+0xe4/0x158
  driver_attach+0x30/0x40
  bus_add_driver+0x21c/0x2b8
  driver_register+0xbc/0x1d0
  __platform_driver_register+0x7c/0x88
  zynqmp_firmware_driver_init+0x1c/0x24
  do_one_initcall+0xa4/0x234
  kernel_init_freeable+0x1b0/0x24c
  kernel_init+0x10/0x110
  ret_from_fork+0x10/0x18

 The buggy address belongs to the page:
 page:ffff0008f9be1c88 refcount:0 mapcount:0 mapping:0000000000000000 index:0x0
 raw: 0008d00000000000 ffff0008f9be1c90 ffff0008f9be1c90 0000000000000000
 raw: 0000000000000000 0000000000000000 00000000ffffffff
 page dumped because: kasan: bad access detected

 addr ffff0008c89a7410 is located in stack of task swapper/0/1 at offset 112 in frame:
  zynqmp_clock_probe+0x0/0x7b8

 this frame has 3 objects:
  [32, 44) 'response'
  [64, 80) 'ret_payload'
  [96, 112) 'name'

 Memory state around the buggy address:
  ffff0008c89a7300: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
  ffff0008c89a7380: 00 00 00 00 f1 f1 f1 f1 00 04 f2 f2 00 00 f2 f2
 >ffff0008c89a7400: 00 00 f3 f3 00 00 00 00 00 00 00 00 00 00 00 00
                          ^
  ffff0008c89a7480: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
  ffff0008c89a7500: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
 ==================================================================

Signed-off-by: Ian Nam <young.kwan.nam@xilinx.com>
Signed-off-by: Shubhrajyoti Datta <shubhrajyoti.datta@xilinx.com>
Link: https://lore.kernel.org/r/20220510070154.29528-3-shubhrajyoti.datta@xilinx.com
Acked-by: Michal Simek <michal.simek@amd.com>
Signed-off-by: Stephen Boyd <sboyd@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/zynqmp/clkc.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/clk/zynqmp/clkc.c b/drivers/clk/zynqmp/clkc.c
index eb25303eefed..2c9da6623b84 100644
--- a/drivers/clk/zynqmp/clkc.c
+++ b/drivers/clk/zynqmp/clkc.c
@@ -710,6 +710,13 @@ static void zynqmp_get_clock_info(void)
 				  FIELD_PREP(CLK_ATTR_NODE_INDEX, i);
 
 		zynqmp_pm_clock_get_name(clock[i].clk_id, &name);
+
+		/*
+		 * Terminate with NULL character in case name provided by firmware
+		 * is longer and truncated due to size limit.
+		 */
+		name.name[sizeof(name.name) - 1] = '\0';
+
 		if (!strcmp(name.name, RESERVED_CLK_NAME))
 			continue;
 		strncpy(clock[i].clk_name, name.name, MAX_NAME_LEN);
-- 
2.35.1

