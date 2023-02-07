Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ABF8E68D5E0
	for <lists+stable@lfdr.de>; Tue,  7 Feb 2023 12:43:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231691AbjBGLnX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Feb 2023 06:43:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60156 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229847AbjBGLnM (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Feb 2023 06:43:12 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D81C835269
        for <stable@vger.kernel.org>; Tue,  7 Feb 2023 03:43:07 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 7FC34B81923
        for <stable@vger.kernel.org>; Tue,  7 Feb 2023 11:43:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D975FC433EF;
        Tue,  7 Feb 2023 11:43:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1675770185;
        bh=wBUba3ycHnzZ/2EiGhghruT/uMkowzTzLo5KvD+Ou/U=;
        h=Subject:To:Cc:From:Date:From;
        b=Bu9DJyCf4ADd75R1k9/Dvsi9P1LwNcRLdQCxQ/1uOzWwgBgBxW+t18c24fd9QxwwF
         DZRUpkIRoPNgGEflT1B/PfJy0PrPjcxZysZysl6MNk6JPde8hwmCLGR+ojHt+GX+y/
         qr8UTOscTa9Ky06WksRgZZgKPB5dnhcDb4Dk6jaU=
Subject: FAILED: patch "[PATCH] powerpc/kexec_file: Count hot-pluggable memory in FDT" failed to apply to 5.10-stable tree
To:     sourabhjain@linux.ibm.com, mpe@ellerman.id.au
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Tue, 07 Feb 2023 12:42:52 +0100
Message-ID: <1675770172135113@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
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

fc546faa5595 ("powerpc/kexec_file: Count hot-pluggable memory in FDT estimate")
7294194b47e9 ("powerpc/kexec_file: Fix division by zero in extra size estimation")
340a4a9f8773 ("powerpc: Take in account addition CPU node when building kexec FDT")
886db32398ab ("powerpc/kexec_file: Restore FDT size estimation for kdump kernel")
3c985d31ad66 ("powerpc: Use common of_kexec_alloc_and_setup_fdt()")
e6635bab530d ("powerpc: Use ELF fields defined in 'struct kimage'")
2377c92e37fe ("powerpc/kexec_file: fix FDT size estimation for kdump kernel")

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From fc546faa559538fb312c77e055243ece18ab3288 Mon Sep 17 00:00:00 2001
From: Sourabh Jain <sourabhjain@linux.ibm.com>
Date: Tue, 31 Jan 2023 08:36:15 +0530
Subject: [PATCH] powerpc/kexec_file: Count hot-pluggable memory in FDT
 estimate

On Systems where online memory is lesser compared to max memory, the
kexec_file_load system call may fail to load the kdump kernel with the
below errors:

    "Failed to update fdt with linux,drconf-usable-memory property"
    "Error setting up usable-memory property for kdump kernel"

This happens because the size estimation for usable memory properties
for the kdump kernel's FDT is based on the online memory whereas the
usable memory properties include max memory. In short, the hot-pluggable
memory is not accounted for while estimating the size of the usable
memory properties.

The issue is addressed by calculating usable memory property size using
max hotplug address instead of the last online memory address.

Fixes: 2377c92e37fe ("powerpc/kexec_file: fix FDT size estimation for kdump kernel")
Signed-off-by: Sourabh Jain <sourabhjain@linux.ibm.com>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://lore.kernel.org/r/20230131030615.729894-1-sourabhjain@linux.ibm.com

diff --git a/arch/powerpc/kexec/file_load_64.c b/arch/powerpc/kexec/file_load_64.c
index 19d084682bc2..52085751f5f4 100644
--- a/arch/powerpc/kexec/file_load_64.c
+++ b/arch/powerpc/kexec/file_load_64.c
@@ -990,7 +990,7 @@ unsigned int kexec_extra_fdt_size_ppc64(struct kimage *image)
 	 * number of usable memory entries and use for FDT size estimation.
 	 */
 	if (drmem_lmb_size()) {
-		usm_entries = ((memblock_end_of_DRAM() / drmem_lmb_size()) +
+		usm_entries = ((memory_hotplug_max() / drmem_lmb_size()) +
 			       (2 * (resource_size(&crashk_res) / drmem_lmb_size())));
 		extra_size = (unsigned int)(usm_entries * sizeof(u64));
 	} else {

