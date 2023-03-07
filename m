Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 111826AE5C7
	for <lists+stable@lfdr.de>; Tue,  7 Mar 2023 17:03:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231600AbjCGQDY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Mar 2023 11:03:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52060 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231602AbjCGQCy (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Mar 2023 11:02:54 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 08CB59226B
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 08:00:39 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B747261492
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 16:00:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A79D0C4339B;
        Tue,  7 Mar 2023 16:00:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678204834;
        bh=bMOxqG++01wltjER6yXkVZut7u7kk9k93glUTUCoxcg=;
        h=Subject:To:Cc:From:Date:From;
        b=mKl8/iTD2C+XE9iVw129hb9oPshWtq1AuViRlVciYp1ElMJKyG6Xkl85rZ40uADfm
         sbD0CDiI/Kh/1efvZHZQD+C6dQ+iqWFzyIKUIpnxkGkwpiELry5pM+3B59BOuHow/C
         9nuBzcpdDFLQ1vXaImQyCjgoPUBFm7CadXMY+kTk=
Subject: FAILED: patch "[PATCH] RISC-V: fix ordering of Zbb extension" failed to apply to 6.2-stable tree
To:     heiko.stuebner@vrull.eu, ajones@ventanamicro.com,
        conor.dooley@microchip.com, palmer@rivosinc.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Tue, 07 Mar 2023 17:00:25 +0100
Message-ID: <167820482516243@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
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


The patch below does not apply to the 6.2-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

To reproduce the conflict and resubmit, you may use the following commands:

git fetch https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git/ linux-6.2.y
git checkout FETCH_HEAD
git cherry-pick -x 1eac28201ac0725192f5ced34192d281a06692e5
# <resolve conflicts, build, test, etc.>
git commit -s
git send-email --to '<stable@vger.kernel.org>' --in-reply-to '167820482516243@kroah.com' --subject-prefix 'PATCH 6.2.y' HEAD^..

Possible dependencies:

1eac28201ac0 ("RISC-V: fix ordering of Zbb extension")
80c200b34ee8 ("RISC-V: resort all extensions in consistent orders")

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 1eac28201ac0725192f5ced34192d281a06692e5 Mon Sep 17 00:00:00 2001
From: Heiko Stuebner <heiko.stuebner@vrull.eu>
Date: Wed, 8 Feb 2023 23:53:27 +0100
Subject: [PATCH] RISC-V: fix ordering of Zbb extension

As Andrew reported,
    Zb* comes after Zi* according 27.11 "Subset Naming Convention"
so fix the ordering accordingly.

Reported-by: Andrew Jones <ajones@ventanamicro.com>
Signed-off-by: Heiko Stuebner <heiko.stuebner@vrull.eu>
Reviewed-by: Conor Dooley <conor.dooley@microchip.com>
Reviewed-by: Andrew Jones <ajones@ventanamicro.com>
Tested-by: Conor Dooley <conor.dooley@microchip.com>
Link: https://lore.kernel.org/r/20230208225328.1636017-2-heiko@sntech.de
Cc: stable@vger.kernel.org
Signed-off-by: Palmer Dabbelt <palmer@rivosinc.com>

diff --git a/arch/riscv/kernel/cpu.c b/arch/riscv/kernel/cpu.c
index 420228e219f7..8400f0cc9704 100644
--- a/arch/riscv/kernel/cpu.c
+++ b/arch/riscv/kernel/cpu.c
@@ -185,9 +185,9 @@ arch_initcall(riscv_cpuinfo_init);
  * New entries to this struct should follow the ordering rules described above.
  */
 static struct riscv_isa_ext_data isa_ext_arr[] = {
-	__RISCV_ISA_EXT_DATA(zbb, RISCV_ISA_EXT_ZBB),
 	__RISCV_ISA_EXT_DATA(zicbom, RISCV_ISA_EXT_ZICBOM),
 	__RISCV_ISA_EXT_DATA(zihintpause, RISCV_ISA_EXT_ZIHINTPAUSE),
+	__RISCV_ISA_EXT_DATA(zbb, RISCV_ISA_EXT_ZBB),
 	__RISCV_ISA_EXT_DATA(sscofpmf, RISCV_ISA_EXT_SSCOFPMF),
 	__RISCV_ISA_EXT_DATA(sstc, RISCV_ISA_EXT_SSTC),
 	__RISCV_ISA_EXT_DATA(svinval, RISCV_ISA_EXT_SVINVAL),

