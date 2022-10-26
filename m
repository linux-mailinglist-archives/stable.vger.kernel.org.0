Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C0BFB60E573
	for <lists+stable@lfdr.de>; Wed, 26 Oct 2022 18:30:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231681AbiJZQaJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 26 Oct 2022 12:30:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45482 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232733AbiJZQaI (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 26 Oct 2022 12:30:08 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 233925789D
        for <stable@vger.kernel.org>; Wed, 26 Oct 2022 09:30:07 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B4B2261FB0
        for <stable@vger.kernel.org>; Wed, 26 Oct 2022 16:30:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C2964C433C1;
        Wed, 26 Oct 2022 16:30:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666801806;
        bh=0Oip6CbDFcSm7UD79s1HeXRHzhn31ab6GD0kt2nCBNg=;
        h=Subject:To:Cc:From:Date:From;
        b=Tfr/7jag3w4S3xDvfFOMwL1FnT5QQky4BNBoXm/H7FCIqcavumXUC0nHzK60MlnL3
         SKVN2ihUApeNPCXjZzKxijWAYenW5FXOUuVXZVBsazAjE1Dq2ayUuxqtFPAEMvDm8Z
         jitV5SXl5ih8neaOPILOn2M3Vwglo8hBIbD9sI9g=
Subject: FAILED: patch "[PATCH] x86/topology: Fix duplicated core ID within a package" failed to apply to 5.10-stable tree
To:     rui.zhang@intel.com, dave.hansen@linux.intel.com,
        len.brown@intel.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Wed, 26 Oct 2022 18:30:03 +0200
Message-ID: <166680180314873@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.10-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

Possible dependencies:

71eac7063698 ("x86/topology: Fix duplicated core ID within a package")

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 71eac7063698b7d7b8fafb1683ac24a034541141 Mon Sep 17 00:00:00 2001
From: Zhang Rui <rui.zhang@intel.com>
Date: Fri, 14 Oct 2022 17:01:47 +0800
Subject: [PATCH] x86/topology: Fix duplicated core ID within a package

Today, core ID is assumed to be unique within each package.

But an AlderLake-N platform adds a Module level between core and package,
Linux excludes the unknown modules bits from the core ID, resulting in
duplicate core ID's.

To keep core ID unique within a package, Linux must include all APIC-ID
bits for known or unknown levels above the core and below the package
in the core ID.

It is important to understand that core ID's have always come directly
from the APIC-ID encoding, which comes from the BIOS. Thus there is no
guarantee that they start at 0, or that they are contiguous.
As such, naively using them for array indexes can be problematic.

[ dhansen: un-known -> unknown ]

Fixes: 7745f03eb395 ("x86/topology: Add CPUID.1F multi-die/package support")
Suggested-by: Len Brown <len.brown@intel.com>
Signed-off-by: Zhang Rui <rui.zhang@intel.com>
Signed-off-by: Dave Hansen <dave.hansen@linux.intel.com>
Reviewed-by: Len Brown <len.brown@intel.com>
Cc: stable@vger.kernel.org
Link: https://lkml.kernel.org/r/20221014090147.1836-5-rui.zhang@intel.com

diff --git a/arch/x86/kernel/cpu/topology.c b/arch/x86/kernel/cpu/topology.c
index f7592814e5d5..5e868b62a7c4 100644
--- a/arch/x86/kernel/cpu/topology.c
+++ b/arch/x86/kernel/cpu/topology.c
@@ -141,7 +141,7 @@ int detect_extended_topology(struct cpuinfo_x86 *c)
 		sub_index++;
 	}
 
-	core_select_mask = (~(-1 << core_plus_mask_width)) >> ht_mask_width;
+	core_select_mask = (~(-1 << pkg_mask_width)) >> ht_mask_width;
 	die_select_mask = (~(-1 << die_plus_mask_width)) >>
 				core_plus_mask_width;
 

