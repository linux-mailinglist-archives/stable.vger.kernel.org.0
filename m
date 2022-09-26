Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1DF6E5EB118
	for <lists+stable@lfdr.de>; Mon, 26 Sep 2022 21:15:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230057AbiIZTPz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Sep 2022 15:15:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56806 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229551AbiIZTPl (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 26 Sep 2022 15:15:41 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 08B726B8D6;
        Mon, 26 Sep 2022 12:15:39 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 39479CE1331;
        Mon, 26 Sep 2022 19:15:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9B8B4C433C1;
        Mon, 26 Sep 2022 19:15:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1664219736;
        bh=WZfLSznjUSFot4ZZ5kD6MZpBi7UUGaYHctcFTvHP2FQ=;
        h=Date:To:From:Subject:From;
        b=1X9PzYBobEtM26VPqJDJFBxNORGyTCbEUgJ/ZjXH5zJI3nnbeuSWfn/X9QLfNDWLs
         JM7UcR7RkT7c4xQZK4G6yHKp52+Qsr1ycjoB9knsML90PerL40eiOhwSEUs8hEBGKo
         jckLGtVIdXJ6+3yMSJKz4e5/mWrkYbOJ+eWfeYwQ=
Date:   Mon, 26 Sep 2022 12:15:35 -0700
To:     mm-commits@vger.kernel.org, stable@vger.kernel.org,
        nathan@kernel.org, liushixin2@huawei.com, konrad.wilk@oracle.com,
        hch@lst.de, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] frontswap-dont-call-init-if-no-ops-are-registered.patch removed from -mm tree
Message-Id: <20220926191536.9B8B4C433C1@smtp.kernel.org>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The quilt patch titled
     Subject: frontswap: don't call ->init if no ops are registered
has been removed from the -mm tree.  Its filename was
     frontswap-dont-call-init-if-no-ops-are-registered.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
Signed-off-by: Christoph Hellwig <hch@lst.de>
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

mm-add-psi-accounting-around-read_folio-and-readahead-calls.patch
sched-psi-export-psi_memstall_enterleave.patch
btrfs-add-manual-psi-accounting-for-compressed-reads.patch
erofs-add-manual-psi-accounting-for-the-compressed-address-space.patch
block-remove-psi-accounting-from-the-bio-layer.patch

