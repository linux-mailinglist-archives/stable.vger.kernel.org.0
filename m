Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AC0E76BB381
	for <lists+stable@lfdr.de>; Wed, 15 Mar 2023 13:45:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233103AbjCOMp0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 Mar 2023 08:45:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37118 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233226AbjCOMpB (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 15 Mar 2023 08:45:01 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4B26AA0F33
        for <stable@vger.kernel.org>; Wed, 15 Mar 2023 05:43:42 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E528E61D7E
        for <stable@vger.kernel.org>; Wed, 15 Mar 2023 12:43:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 079AEC433EF;
        Wed, 15 Mar 2023 12:43:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678884186;
        bh=u9rdFuJd7vfSdtKdi3pxRs6DKibakRTSZSEQfENK7gM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZltwtUwj267JOGAwQchjhle/6rMefqmhW7o0YwqTZYqT8BJE2TxWLNtcyrj0PKuVT
         uzmHT5rfHZ2aPDXRUyfvRF1uh45pPyxKchdNL2peY1HhZ/Bl7kj0bh0VYsI0YqRs0w
         of6qlfdN4gs6H1EsPQeC6vQ+WdSn6gSZGW9w2azQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Chris Hofstaedtler <zeha@debian.org>,
        Conor Dooley <conor.dooley@microchip.com>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Palmer Dabbelt <palmer@rivosinc.com>
Subject: [PATCH 6.2 140/141] RISC-V: fix taking the text_mutex twice during sifive errata patching
Date:   Wed, 15 Mar 2023 13:14:03 +0100
Message-Id: <20230315115744.259356929@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230315115739.932786806@linuxfoundation.org>
References: <20230315115739.932786806@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Conor Dooley <conor@kernel.org>

commit bf89b7ee52af5a5944fa3539e86089f72475055b upstream.

Chris pointed out that some bonehead, *cough* me *cough*, added two
mutex_locks() to the SiFive errata patching. The second was meant to
have been a mutex_unlock().

This results in errors such as

Unable to handle kernel NULL pointer dereference at virtual address 0000000000000030
Oops [#1]
Modules linked in:
CPU: 0 PID: 0 Comm: swapper Not tainted
6.2.0-rc1-starlight-00079-g9493e6f3ce02 #229
Hardware name: BeagleV Starlight Beta (DT)
epc : __schedule+0x42/0x500
 ra : schedule+0x46/0xce
epc : ffffffff8065957c ra : ffffffff80659a80 sp : ffffffff81203c80
 gp : ffffffff812d50a0 tp : ffffffff8120db40 t0 : ffffffff81203d68
 t1 : 0000000000000001 t2 : 4c45203a76637369 s0 : ffffffff81203cf0
 s1 : ffffffff8120db40 a0 : 0000000000000000 a1 : ffffffff81213958
 a2 : ffffffff81213958 a3 : 0000000000000000 a4 : 0000000000000000
 a5 : ffffffff80a1bd00 a6 : 0000000000000000 a7 : 0000000052464e43
 s2 : ffffffff8120db41 s3 : ffffffff80a1ad00 s4 : 0000000000000000
 s5 : 0000000000000002 s6 : ffffffff81213938 s7 : 0000000000000000
 s8 : 0000000000000000 s9 : 0000000000000001 s10: ffffffff812d7204
 s11: ffffffff80d3c920 t3 : 0000000000000001 t4 : ffffffff812e6dd7
 t5 : ffffffff812e6dd8 t6 : ffffffff81203bb8
status: 0000000200000100 badaddr: 0000000000000030 cause: 000000000000000d
[<ffffffff80659a80>] schedule+0x46/0xce
[<ffffffff80659dce>] schedule_preempt_disabled+0x16/0x28
[<ffffffff8065ae0c>] __mutex_lock.constprop.0+0x3fe/0x652
[<ffffffff8065b138>] __mutex_lock_slowpath+0xe/0x16
[<ffffffff8065b182>] mutex_lock+0x42/0x4c
[<ffffffff8000ad94>] sifive_errata_patch_func+0xf6/0x18c
[<ffffffff80002b92>] _apply_alternatives+0x74/0x76
[<ffffffff80802ee8>] apply_boot_alternatives+0x3c/0xfa
[<ffffffff80803cb0>] setup_arch+0x60c/0x640
[<ffffffff80800926>] start_kernel+0x8e/0x99c
---[ end trace 0000000000000000 ]---

Reported-by: Chris Hofstaedtler <zeha@debian.org>
Fixes: 9493e6f3ce02 ("RISC-V: take text_mutex during alternative patching")
Signed-off-by: Conor Dooley <conor.dooley@microchip.com>
Tested-by: Geert Uytterhoeven <geert+renesas@glider.be>
Link: https://lore.kernel.org/r/20230302174154.970746-1-conor@kernel.org
[Palmer: pick up Geert's bug report from the thread]
Signed-off-by: Palmer Dabbelt <palmer@rivosinc.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/riscv/errata/sifive/errata.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/riscv/errata/sifive/errata.c
+++ b/arch/riscv/errata/sifive/errata.c
@@ -110,7 +110,7 @@ void __init_or_module sifive_errata_patc
 		if (cpu_req_errata & tmp) {
 			mutex_lock(&text_mutex);
 			patch_text_nosync(alt->old_ptr, alt->alt_ptr, alt->alt_len);
-			mutex_lock(&text_mutex);
+			mutex_unlock(&text_mutex);
 			cpu_apply_errata |= tmp;
 		}
 	}


