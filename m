Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 89F6C6648C8
	for <lists+stable@lfdr.de>; Tue, 10 Jan 2023 19:15:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231864AbjAJSPH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Jan 2023 13:15:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52968 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239041AbjAJSOn (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 10 Jan 2023 13:14:43 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4230B1900D
        for <stable@vger.kernel.org>; Tue, 10 Jan 2023 10:12:47 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E56CAB81909
        for <stable@vger.kernel.org>; Tue, 10 Jan 2023 18:12:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 41732C433EF;
        Tue, 10 Jan 2023 18:12:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1673374364;
        bh=Hcsc32datdJIw2r0yngOaym2xlbqVvOOHNwIVM7PqJc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=oTFrnoDFTquDR00bVI6ny0NgmqqqgtT2eNpiakNnNJQBlpw3ShZG6EfCHVWjXnzyw
         hJMZUQKnKSQMsSqVU5XgkoM/tQewFfCiGNsKu7CybQCbZ1L3qGbdIavKwEwsZHhCgX
         qo3ym6C+8fAd09cCa/PRWw9SEWcvoxx/6By+ovms=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Andreas Rammhold <andreas@rammhold.de>,
        Rob Herring <robh@kernel.org>
Subject: [PATCH 6.0 136/148] of/fdt: run soc memory setup when early_init_dt_scan_memory fails
Date:   Tue, 10 Jan 2023 19:04:00 +0100
Message-Id: <20230110180021.490252631@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230110180017.145591678@linuxfoundation.org>
References: <20230110180017.145591678@linuxfoundation.org>
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

From: Andreas Rammhold <andreas@rammhold.de>

commit 2a12187d5853d9fd5102278cecef7dac7c8ce7ea upstream.

If memory has been found early_init_dt_scan_memory now returns 1. If
it hasn't found any memory it will return 0, allowing other memory
setup mechanisms to carry on.

Previously early_init_dt_scan_memory always returned 0 without
distinguishing between any kind of memory setup being done or not. Any
code path after the early_init_dt_scan memory call in the ramips
plat_mem_setup code wouldn't be executed anymore. Making
early_init_dt_scan_memory the only way to initialize the memory.

Some boards, including my mt7621 based Cudy X6 board, depend on memory
initialization being done via the soc_info.mem_detect function
pointer. Those wouldn't be able to obtain memory and panic the kernel
during early bootup with the message "early_init_dt_alloc_memory_arch:
Failed to allocate 12416 bytes align=0x40".

Fixes: 1f012283e936 ("of/fdt: Rework early_init_dt_scan_memory() to call directly")
Cc: stable@vger.kernel.org
Signed-off-by: Andreas Rammhold <andreas@rammhold.de>
Link: https://lore.kernel.org/r/20221223112748.2935235-1-andreas@rammhold.de
Signed-off-by: Rob Herring <robh@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/mips/ralink/of.c |    2 +-
 drivers/of/fdt.c      |    6 ++++--
 2 files changed, 5 insertions(+), 3 deletions(-)

--- a/arch/mips/ralink/of.c
+++ b/arch/mips/ralink/of.c
@@ -64,7 +64,7 @@ void __init plat_mem_setup(void)
 	dtb = get_fdt();
 	__dt_setup_arch(dtb);
 
-	if (!early_init_dt_scan_memory())
+	if (early_init_dt_scan_memory())
 		return;
 
 	if (soc_info.mem_detect)
--- a/drivers/of/fdt.c
+++ b/drivers/of/fdt.c
@@ -1106,7 +1106,7 @@ u64 __init dt_mem_next_cell(int s, const
  */
 int __init early_init_dt_scan_memory(void)
 {
-	int node;
+	int node, found_memory = 0;
 	const void *fdt = initial_boot_params;
 
 	fdt_for_each_subnode(node, fdt, 0) {
@@ -1146,6 +1146,8 @@ int __init early_init_dt_scan_memory(voi
 
 			early_init_dt_add_memory_arch(base, size);
 
+			found_memory = 1;
+
 			if (!hotpluggable)
 				continue;
 
@@ -1154,7 +1156,7 @@ int __init early_init_dt_scan_memory(voi
 					base, base + size);
 		}
 	}
-	return 0;
+	return found_memory;
 }
 
 int __init early_init_dt_scan_chosen(char *cmdline)


