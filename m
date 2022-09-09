Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 007D95B40A4
	for <lists+stable@lfdr.de>; Fri,  9 Sep 2022 22:28:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231866AbiIIU2a (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 9 Sep 2022 16:28:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54810 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231759AbiIIU2H (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 9 Sep 2022 16:28:07 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8FA32128C0E;
        Fri,  9 Sep 2022 13:26:52 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B6BD3B8261D;
        Fri,  9 Sep 2022 20:26:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6CCC1C433C1;
        Fri,  9 Sep 2022 20:26:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1662755209;
        bh=Q4su0ZuO4kXSL1ZZStcaaMZSAIC+ec0q2gIAB1m9DTs=;
        h=Date:To:From:Subject:From;
        b=mNrGCEDP/GaIOvnZCpDZmMqY4yMARhRC2zPKlChqTa25YUbL+HmiCZ2ZX7bu12tM3
         ozWdisCF4E+UL0W/67XGOx4cVfswLTXAQ3y5fsUjaz04O0nfM/xix4GuKlFZFGPusk
         dGiXjBd6ppNgSwdeKOFjIPRX06P9iOkNUGDhsnDY=
Date:   Fri, 09 Sep 2022 13:26:48 -0700
To:     mm-commits@vger.kernel.org, stable@vger.kernel.org,
        nathan@kernel.org, liushixin2@huawei.com, konrad.wilk@oracle.com,
        hch@lst.de, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + frontswap-dont-call-init-if-no-ops-are-registered.patch added to mm-hotfixes-unstable branch
Message-Id: <20220909202649.6CCC1C433C1@smtp.kernel.org>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch titled
     Subject: frontswap: don't call ->init if no ops are registered
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     frontswap-dont-call-init-if-no-ops-are-registered.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/frontswap-dont-call-init-if-no-ops-are-registered.patch

This patch will later appear in the mm-hotfixes-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: Christoph Hellwig <hch@lst.de>
Subject: frontswap: don't call ->init if no ops are registered
Date: Fri, 9 Sep 2022 15:08:29 +0200

If no frontswap module (i.e.  zswap) was registered, frontswap_ops will be
NULL.  In such situation, swapon crashes with the following stack trace:

  Unable to handle kernel access to user memory outside uaccess routines at virtual address 0000000000000000
  Mem abort info:
    ESR = 0x0000000096000004
    EC = 0x25: DABT (current EL), IL = 32 bits
    SET = 0, FnV = 0
    EA = 0, S1PTW = 0
    FSC = 0x04: level 0 translation fault
  Data abort info:
    ISV = 0, ISS = 0x00000004
    CM = 0, WnR = 0
  user pgtable: 4k pages, 48-bit VAs, pgdp=00000020a4fab000
  [0000000000000000] pgd=0000000000000000, p4d=0000000000000000
  Internal error: Oops: 96000004 [#1] SMP
  Modules linked in: zram fsl_dpaa2_eth pcs_lynx phylink ahci_qoriq crct10dif_ce ghash_ce sbsa_gwdt fsl_mc_dpio nvme lm90 nvme_core at803x xhci_plat_hcd rtc_fsl_ftm_alarm xgmac_mdio ahci_platform i2c_imx ip6_tables ip_tables fuse
  Unloaded tainted modules: cppc_cpufreq():1
  CPU: 10 PID: 761 Comm: swapon Not tainted 6.0.0-rc2-00454-g22100432cf14 #1
  Hardware name: SolidRun Ltd. SolidRun CEX7 Platform, BIOS EDK II Jun 21 2022
  pstate: 00400005 (nzcv daif +PAN -UAO -TCO -DIT -SSBS BTYPE=--)
  pc : frontswap_init+0x38/0x60
  lr : __do_sys_swapon+0x8a8/0x9f4
  sp : ffff80000969bcf0
  x29: ffff80000969bcf0 x28: ffff37bee0d8fc00 x27: ffff80000a7f5000
  x26: fffffcdefb971e80 x25: ffffaba797453b90 x24: 0000000000000064
  x23: ffff37c1f209d1a8 x22: ffff37bee880e000 x21: ffffaba797748560
  x20: ffff37bee0d8fce4 x19: ffffaba797748488 x18: 0000000000000014
  x17: 0000000030ec029a x16: ffffaba795a479b0 x15: 0000000000000000
  x14: 0000000000000000 x13: 0000000000000030 x12: 0000000000000001
  x11: ffff37c63c0aba18 x10: 0000000000000000 x9 : ffffaba7956b8c88
  x8 : ffff80000969bcd0 x7 : 0000000000000000 x6 : 0000000000000000
  x5 : 0000000000000001 x4 : 0000000000000000 x3 : ffffaba79730f000
  x2 : ffff37bee0d8fc00 x1 : 0000000000000000 x0 : 0000000000000000
  Call trace:
  frontswap_init+0x38/0x60
  __do_sys_swapon+0x8a8/0x9f4
  __arm64_sys_swapon+0x28/0x3c
  invoke_syscall+0x78/0x100
  el0_svc_common.constprop.0+0xd4/0xf4
  do_el0_svc+0x38/0x4c
  el0_svc+0x34/0x10c
  el0t_64_sync_handler+0x11c/0x150
  el0t_64_sync+0x190/0x194
  Code: d000e283 910003fd f9006c41 f946d461 (f9400021)
  ---[ end trace 0000000000000000 ]---

Link: https://lkml.kernel.org/r/20220909130829.3262926-1-hch@lst.de
Fixes: 1da0d94a3ec8 ("frontswap: remove support for multiple ops")
Reported-by: Nathan Chancellor <nathan@kernel.org>
Signed-off-by: Liu Shixin <liushixin2@huawei.com>
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/frontswap.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/mm/frontswap.c~frontswap-dont-call-init-if-no-ops-are-registered
+++ a/mm/frontswap.c
@@ -125,6 +125,9 @@ void frontswap_init(unsigned type, unsig
 	 * p->frontswap set to something valid to work properly.
 	 */
 	frontswap_map_set(sis, map);
+
+	if (!frontswap_enabled())
+		return;
 	frontswap_ops->init(type);
 }
 
_

Patches currently in -mm which might be from hch@lst.de are

frontswap-dont-call-init-if-no-ops-are-registered.patch
mm-remove-the-end_write_func-argument-to-__swap_writepage.patch

