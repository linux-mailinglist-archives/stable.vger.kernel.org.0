Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5F5B5592E7E
	for <lists+stable@lfdr.de>; Mon, 15 Aug 2022 13:50:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241327AbiHOLus (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 07:50:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35832 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241814AbiHOLup (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 07:50:45 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8E520CE09
        for <stable@vger.kernel.org>; Mon, 15 Aug 2022 04:50:42 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 06D67CE1061
        for <stable@vger.kernel.org>; Mon, 15 Aug 2022 11:50:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E21C0C433D6;
        Mon, 15 Aug 2022 11:50:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660564239;
        bh=BUojqpNM/FD4VqVR0uEOUvo8L5/65cpvEnAwYeRoVsY=;
        h=Subject:To:Cc:From:Date:From;
        b=c6puuT7UC85spG6xzxWFqETqtMSb3LE7H4R1YUskI4WZvFPyboQe6En5jIuam9xwj
         I3gNu671UYmEPWmMkRpKJglNy+zY4/6a3ZmB0VEuNTNQlJJWNquFkBDZv0LINqkuyv
         MXoNf8ydeJR2UIilC4i2VRyTfgh8xS2BeXXSw/Zc=
Subject: FAILED: patch "[PATCH] iommu/vt-d: avoid invalid memory access via" failed to apply to 4.9-stable tree
To:     alexandr.lobakin@intel.com, andriy.shevchenko@linux.intel.com,
        baolu.lu@linux.intel.com, oliver.sang@intel.com,
        yury.norov@gmail.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 15 Aug 2022 13:50:27 +0200
Message-ID: <16605642276219@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.9-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From b0b0b77ea611e3088e9523e60860f4f41b62b235 Mon Sep 17 00:00:00 2001
From: Alexander Lobakin <alexandr.lobakin@intel.com>
Date: Tue, 12 Jul 2022 17:38:36 +0200
Subject: [PATCH] iommu/vt-d: avoid invalid memory access via
 node_online(NUMA_NO_NODE)

KASAN reports:

[ 4.668325][ T0] BUG: KASAN: wild-memory-access in dmar_parse_one_rhsa (arch/x86/include/asm/bitops.h:214 arch/x86/include/asm/bitops.h:226 include/asm-generic/bitops/instrumented-non-atomic.h:142 include/linux/nodemask.h:415 drivers/iommu/intel/dmar.c:497)
[    4.676149][    T0] Read of size 8 at addr 1fffffff85115558 by task swapper/0/0
[    4.683454][    T0]
[    4.685638][    T0] CPU: 0 PID: 0 Comm: swapper/0 Not tainted 5.19.0-rc3-00004-g0e862838f290 #1
[    4.694331][    T0] Hardware name: Supermicro SYS-5018D-FN4T/X10SDV-8C-TLN4F, BIOS 1.1 03/02/2016
[    4.703196][    T0] Call Trace:
[    4.706334][    T0]  <TASK>
[ 4.709133][ T0] ? dmar_parse_one_rhsa (arch/x86/include/asm/bitops.h:214 arch/x86/include/asm/bitops.h:226 include/asm-generic/bitops/instrumented-non-atomic.h:142 include/linux/nodemask.h:415 drivers/iommu/intel/dmar.c:497)

after converting the type of the first argument (@nr, bit number)
of arch_test_bit() from `long` to `unsigned long`[0].

Under certain conditions (for example, when ACPI NUMA is disabled
via command line), pxm_to_node() can return %NUMA_NO_NODE (-1).
It is valid 'magic' number of NUMA node, but not valid bit number
to use in bitops.
node_online() eventually descends to test_bit() without checking
for the input, assuming it's on caller side (which might be good
for perf-critical tasks). There, -1 becomes %ULONG_MAX which leads
to an insane array index when calculating bit position in memory.

For now, add an explicit check for @node being not %NUMA_NO_NODE
before calling test_bit(). The actual logics didn't change here
at all.

[0] https://github.com/norov/linux/commit/0e862838f290147ea9c16db852d8d494b552d38d

Fixes: ee34b32d8c29 ("dmar: support for parsing Remapping Hardware Static Affinity structure")
Cc: stable@vger.kernel.org # 2.6.33+
Reported-by: kernel test robot <oliver.sang@intel.com>
Signed-off-by: Alexander Lobakin <alexandr.lobakin@intel.com>
Reviewed-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Reviewed-by: Lu Baolu <baolu.lu@linux.intel.com>
Signed-off-by: Yury Norov <yury.norov@gmail.com>

diff --git a/drivers/iommu/intel/dmar.c b/drivers/iommu/intel/dmar.c
index 592c1e1a5d4b..70d324c9894a 100644
--- a/drivers/iommu/intel/dmar.c
+++ b/drivers/iommu/intel/dmar.c
@@ -494,7 +494,7 @@ static int dmar_parse_one_rhsa(struct acpi_dmar_header *header, void *arg)
 		if (drhd->reg_base_addr == rhsa->base_address) {
 			int node = pxm_to_node(rhsa->proximity_domain);
 
-			if (!node_online(node))
+			if (node != NUMA_NO_NODE && !node_online(node))
 				node = NUMA_NO_NODE;
 			drhd->iommu->node = node;
 			return 0;

