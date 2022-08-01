Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7B6275869D5
	for <lists+stable@lfdr.de>; Mon,  1 Aug 2022 14:08:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233656AbiHAMID (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Aug 2022 08:08:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43168 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233700AbiHAMH3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 1 Aug 2022 08:07:29 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7A7055F99C;
        Mon,  1 Aug 2022 04:55:26 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2F39F612D0;
        Mon,  1 Aug 2022 11:55:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3B04AC433C1;
        Mon,  1 Aug 2022 11:55:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1659354924;
        bh=R4r38YJ5Dy31el24nkUxBsEoOBTpXjcjl5kVMXZYn0Q=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=oR8d9sBzlm911P52+XYucIPtBfcrqjwTyRHnq4tJ6lA0rxXvD8IdcWH+A4Gma9ihI
         icQZRhUcdGWRieSF9vdEO256wKU2SDRuFhRRle3pjFluxb9vBUJVRkjeNRXmJU8wad
         70O9eL4HExtZdcH7XuufHMQzOPBaoCyRZ7e0U5+o=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Dimitri John Ledkov <dimitri.ledkov@canonical.com>,
        Thadeu Lima de Souza Cascardo <cascardo@canonical.com>,
        Borislav Petkov <bp@suse.de>
Subject: [PATCH 5.15 69/69] x86/bugs: Do not enable IBPB at firmware entry when IBPB is not available
Date:   Mon,  1 Aug 2022 13:47:33 +0200
Message-Id: <20220801114137.252692437@linuxfoundation.org>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20220801114134.468284027@linuxfoundation.org>
References: <20220801114134.468284027@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Thadeu Lima de Souza Cascardo <cascardo@canonical.com>

commit 571c30b1a88465a1c85a6f7762609939b9085a15 upstream.

Some cloud hypervisors do not provide IBPB on very recent CPU processors,
including AMD processors affected by Retbleed.

Using IBPB before firmware calls on such systems would cause a GPF at boot
like the one below. Do not enable such calls when IBPB support is not
present.

  EFI Variables Facility v0.08 2004-May-17
  general protection fault, maybe for address 0x1: 0000 [#1] PREEMPT SMP NOPTI
  CPU: 0 PID: 24 Comm: kworker/u2:1 Not tainted 5.19.0-rc8+ #7
  Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 0.0.0 02/06/2015
  Workqueue: efi_rts_wq efi_call_rts
  RIP: 0010:efi_call_rts
  Code: e8 37 33 58 ff 41 bf 48 00 00 00 49 89 c0 44 89 f9 48 83 c8 01 4c 89 c2 48 c1 ea 20 66 90 b9 49 00 00 00 b8 01 00 00 00 31 d2 <0f> 30 e8 7b 9f 5d ff e8 f6 f8 ff ff 4c 89 f1 4c 89 ea 4c 89 e6 48
  RSP: 0018:ffffb373800d7e38 EFLAGS: 00010246
  RAX: 0000000000000001 RBX: 0000000000000006 RCX: 0000000000000049
  RDX: 0000000000000000 RSI: ffff94fbc19d8fe0 RDI: ffff94fbc1b2b300
  RBP: ffffb373800d7e70 R08: 0000000000000000 R09: 0000000000000000
  R10: 000000000000000b R11: 000000000000000b R12: ffffb3738001fd78
  R13: ffff94fbc2fcfc00 R14: ffffb3738001fd80 R15: 0000000000000048
  FS:  0000000000000000(0000) GS:ffff94fc3da00000(0000) knlGS:0000000000000000
  CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
  CR2: ffff94fc30201000 CR3: 000000006f610000 CR4: 00000000000406f0
  Call Trace:
   <TASK>
   ? __wake_up
   process_one_work
   worker_thread
   ? rescuer_thread
   kthread
   ? kthread_complete_and_exit
   ret_from_fork
   </TASK>
  Modules linked in:

Fixes: 28a99e95f55c ("x86/amd: Use IBPB for firmware calls")
Reported-by: Dimitri John Ledkov <dimitri.ledkov@canonical.com>
Signed-off-by: Thadeu Lima de Souza Cascardo <cascardo@canonical.com>
Signed-off-by: Borislav Petkov <bp@suse.de>
Cc: <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20220728122602.2500509-1-cascardo@canonical.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kernel/cpu/bugs.c |    1 +
 1 file changed, 1 insertion(+)

--- a/arch/x86/kernel/cpu/bugs.c
+++ b/arch/x86/kernel/cpu/bugs.c
@@ -1513,6 +1513,7 @@ static void __init spectre_v2_select_mit
 	 * enable IBRS around firmware calls.
 	 */
 	if (boot_cpu_has_bug(X86_BUG_RETBLEED) &&
+	    boot_cpu_has(X86_FEATURE_IBPB) &&
 	    (boot_cpu_data.x86_vendor == X86_VENDOR_AMD ||
 	     boot_cpu_data.x86_vendor == X86_VENDOR_HYGON)) {
 


