Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8AC755EA314
	for <lists+stable@lfdr.de>; Mon, 26 Sep 2022 13:19:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235880AbiIZLTh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Sep 2022 07:19:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46316 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237720AbiIZLSS (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 26 Sep 2022 07:18:18 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 84F54659D6;
        Mon, 26 Sep 2022 03:38:09 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 8EE1ACE10F6;
        Mon, 26 Sep 2022 10:36:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3DBE9C433C1;
        Mon, 26 Sep 2022 10:36:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1664188583;
        bh=I8k8+CTSWRvEg1zNHgM0TRsB64lBSXwEJrXQxlaIcz8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=STQQfqoAkymzav5EJiOqNh7PBtsx8H4E/YbsfUG7nKCC1fv7mRnbnrSeDzEgTekbu
         CrBBDiUodY63U7oI10AcTJgjgv7HCbOKUMGa0yxH/u6J2oAQ4sE2no2uIHdFTQc2w+
         48dvHpEqC7YoAKfHWVRTheXxb5dXdbGWfzigU3Mc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Michael Ellerman <mpe@ellerman.id.au>,
        Jordan Niethe <jniethe5@gmail.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 014/148] powerpc/rtas: Fix RTAS MSR[HV] handling for Cell
Date:   Mon, 26 Sep 2022 12:10:48 +0200
Message-Id: <20220926100756.584970374@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20220926100756.074519146@linuxfoundation.org>
References: <20220926100756.074519146@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Michael Ellerman <mpe@ellerman.id.au>

[ Upstream commit 91926d8b7e71aaf5f84f0cf208fc5a8b7a761050 ]

The semi-recent changes to MSR handling when entering RTAS (firmware)
cause crashes on IBM Cell machines. An example trace:

  kernel tried to execute user page (2fff01a8) - exploit attempt? (uid: 0)
  BUG: Unable to handle kernel instruction fetch
  Faulting instruction address: 0x2fff01a8
  Oops: Kernel access of bad area, sig: 11 [#1]
  BE PAGE_SIZE=64K MMU=Hash SMP NR_CPUS=4 NUMA Cell
  Modules linked in:
  CPU: 0 PID: 0 Comm: swapper/0 Tainted: G        W          6.0.0-rc2-00433-gede0a8d3307a #207
  NIP:  000000002fff01a8 LR: 0000000000032608 CTR: 0000000000000000
  REGS: c0000000015236b0 TRAP: 0400   Tainted: G        W           (6.0.0-rc2-00433-gede0a8d3307a)
  MSR:  0000000008001002 <ME,RI>  CR: 00000000  XER: 20000000
  ...
  NIP 0x2fff01a8
  LR  0x32608
  Call Trace:
    0xc00000000143c5f8 (unreliable)
    .rtas_call+0x224/0x320
    .rtas_get_boot_time+0x70/0x150
    .read_persistent_clock64+0x114/0x140
    .read_persistent_wall_and_boot_offset+0x24/0x80
    .timekeeping_init+0x40/0x29c
    .start_kernel+0x674/0x8f0
    start_here_common+0x1c/0x50

Unlike PAPR platforms where RTAS is only used in guests, on the IBM Cell
machines Linux runs with MSR[HV] set but also uses RTAS, provided by
SLOF.

Fix it by copying the MSR[HV] bit from the MSR value we've just read
using mfmsr into the value used for RTAS.

It seems like we could also fix it using an #ifdef CELL to set MSR[HV],
but that doesn't work because it's possible to build a single kernel
image that runs on both Cell native and pseries.

Fixes: b6b1c3ce06ca ("powerpc/rtas: Keep MSR[RI] set when calling RTAS")
Cc: stable@vger.kernel.org # v5.19+
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Reviewed-by: Jordan Niethe <jniethe5@gmail.com>
Link: https://lore.kernel.org/r/20220823115952.1203106-2-mpe@ellerman.id.au
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/powerpc/kernel/rtas_entry.S | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/arch/powerpc/kernel/rtas_entry.S b/arch/powerpc/kernel/rtas_entry.S
index 9ae1ca3c6fca..69dd8dd36689 100644
--- a/arch/powerpc/kernel/rtas_entry.S
+++ b/arch/powerpc/kernel/rtas_entry.S
@@ -125,8 +125,12 @@ __enter_rtas:
 	 * its critical regions (as specified in PAPR+ section 7.2.1). MSR[S]
 	 * is not impacted by RFI_TO_KERNEL (only urfid can unset it). So if
 	 * MSR[S] is set, it will remain when entering RTAS.
+	 * If we're in HV mode, RTAS must also run in HV mode, so extract MSR_HV
+	 * from the saved MSR value and insert into the value RTAS will use.
 	 */
+	extrdi	r0, r6, 1, 63 - MSR_HV_LG
 	LOAD_REG_IMMEDIATE(r6, MSR_ME | MSR_RI)
+	insrdi	r6, r0, 1, 63 - MSR_HV_LG
 
 	li      r0,0
 	mtmsrd  r0,1                    /* disable RI before using SRR0/1 */
-- 
2.35.1



