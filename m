Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 55BC21AC89F
	for <lists+stable@lfdr.de>; Thu, 16 Apr 2020 17:12:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2394986AbgDPPLj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Apr 2020 11:11:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:35834 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2441659AbgDPNuL (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Apr 2020 09:50:11 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C43A32224E;
        Thu, 16 Apr 2020 13:49:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1587044997;
        bh=iGAvezQIXpomV+U2h6LGXS5TodfnQCAsqZ5z6i5QdVU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QM/P5UnC7Jo7LcTeoTLYe7mb6Wv+XwFwt7AjkJAJ7oxYWrSUFe/YSUvv6QvmYL1ua
         MYE5aUFGBfjuQ2QmtFINzgWXkdTsZIUGnYUeMWF/lb1auGP6YQK5rlUzINGaLkcVN8
         whpo0OOyoUmDxfYpagq0Ix4o/VeDYYZqRIL8ClF8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Libor Pechacek <lpechacek@suse.cz>,
        Michal Suchanek <msuchanek@suse.de>,
        Michael Ellerman <mpe@ellerman.id.au>
Subject: [PATCH 5.4 188/232] powerpc/pseries: Avoid NULL pointer dereference when drmem is unavailable
Date:   Thu, 16 Apr 2020 15:24:42 +0200
Message-Id: <20200416131338.652737635@linuxfoundation.org>
X-Mailer: git-send-email 2.26.1
In-Reply-To: <20200416131316.640996080@linuxfoundation.org>
References: <20200416131316.640996080@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Libor Pechacek <lpechacek@suse.cz>

commit a83836dbc53e96f13fec248ecc201d18e1e3111d upstream.

In guests without hotplugagble memory drmem structure is only zero
initialized. Trying to manipulate DLPAR parameters results in a crash.

  $ echo "memory add count 1" > /sys/kernel/dlpar
  Oops: Kernel access of bad area, sig: 11 [#1]
  LE PAGE_SIZE=64K MMU=Hash SMP NR_CPUS=2048 NUMA pSeries
  ...
  NIP:  c0000000000ff294 LR: c0000000000ff248 CTR: 0000000000000000
  REGS: c0000000fb9d3880 TRAP: 0300   Tainted: G            E      (5.5.0-rc6-2-default)
  MSR:  8000000000009033 <SF,EE,ME,IR,DR,RI,LE>  CR: 28242428  XER: 20000000
  CFAR: c0000000009a6c10 DAR: 0000000000000010 DSISR: 40000000 IRQMASK: 0
  ...
  NIP dlpar_memory+0x6e4/0xd00
  LR  dlpar_memory+0x698/0xd00
  Call Trace:
    dlpar_memory+0x698/0xd00 (unreliable)
    handle_dlpar_errorlog+0xc0/0x190
    dlpar_store+0x198/0x4a0
    kobj_attr_store+0x30/0x50
    sysfs_kf_write+0x64/0x90
    kernfs_fop_write+0x1b0/0x290
    __vfs_write+0x3c/0x70
    vfs_write+0xd0/0x260
    ksys_write+0xdc/0x130
    system_call+0x5c/0x68

Taking closer look at the code, I can see that for_each_drmem_lmb is a
macro expanding into `for (lmb = &drmem_info->lmbs[0]; lmb <=
&drmem_info->lmbs[drmem_info->n_lmbs - 1]; lmb++)`. When drmem_info->lmbs
is NULL, the loop would iterate through the whole address range if it
weren't stopped by the NULL pointer dereference on the next line.

This patch aligns for_each_drmem_lmb and for_each_drmem_lmb_in_range
macro behavior with the common C semantics, where the end marker does
not belong to the scanned range, and alters get_lmb_range() semantics.
As a side effect, the wraparound observed in the crash is prevented.

Fixes: 6c6ea53725b3 ("powerpc/mm: Separate ibm, dynamic-memory data from DT format")
Cc: stable@vger.kernel.org # v4.16+
Signed-off-by: Libor Pechacek <lpechacek@suse.cz>
Signed-off-by: Michal Suchanek <msuchanek@suse.de>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://lore.kernel.org/r/20200131132829.10281-1-msuchanek@suse.de
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/powerpc/include/asm/drmem.h                |    4 ++--
 arch/powerpc/platforms/pseries/hotplug-memory.c |    8 ++++----
 2 files changed, 6 insertions(+), 6 deletions(-)

--- a/arch/powerpc/include/asm/drmem.h
+++ b/arch/powerpc/include/asm/drmem.h
@@ -27,12 +27,12 @@ struct drmem_lmb_info {
 extern struct drmem_lmb_info *drmem_info;
 
 #define for_each_drmem_lmb_in_range(lmb, start, end)		\
-	for ((lmb) = (start); (lmb) <= (end); (lmb)++)
+	for ((lmb) = (start); (lmb) < (end); (lmb)++)
 
 #define for_each_drmem_lmb(lmb)					\
 	for_each_drmem_lmb_in_range((lmb),			\
 		&drmem_info->lmbs[0],				\
-		&drmem_info->lmbs[drmem_info->n_lmbs - 1])
+		&drmem_info->lmbs[drmem_info->n_lmbs])
 
 /*
  * The of_drconf_cell_v1 struct defines the layout of the LMB data
--- a/arch/powerpc/platforms/pseries/hotplug-memory.c
+++ b/arch/powerpc/platforms/pseries/hotplug-memory.c
@@ -223,7 +223,7 @@ static int get_lmb_range(u32 drc_index,
 			 struct drmem_lmb **end_lmb)
 {
 	struct drmem_lmb *lmb, *start, *end;
-	struct drmem_lmb *last_lmb;
+	struct drmem_lmb *limit;
 
 	start = NULL;
 	for_each_drmem_lmb(lmb) {
@@ -236,10 +236,10 @@ static int get_lmb_range(u32 drc_index,
 	if (!start)
 		return -EINVAL;
 
-	end = &start[n_lmbs - 1];
+	end = &start[n_lmbs];
 
-	last_lmb = &drmem_info->lmbs[drmem_info->n_lmbs - 1];
-	if (end > last_lmb)
+	limit = &drmem_info->lmbs[drmem_info->n_lmbs];
+	if (end > limit)
 		return -EINVAL;
 
 	*start_lmb = start;


