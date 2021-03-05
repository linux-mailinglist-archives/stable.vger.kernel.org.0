Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0177D32EAD0
	for <lists+stable@lfdr.de>; Fri,  5 Mar 2021 13:41:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233330AbhCEMkZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 5 Mar 2021 07:40:25 -0500
Received: from mail.kernel.org ([198.145.29.99]:55102 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233364AbhCEMkG (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 5 Mar 2021 07:40:06 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5C3E264F44;
        Fri,  5 Mar 2021 12:40:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614948005;
        bh=pPhuODF5YQXrCVSoGD7/MI0sdXCCdPa2t2QXebb4Pdg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=V2ECix1lokf/eDwmtx3AVNC6wIq4yPw4DyDi1K1hXZPqgtPU8L3/pflugASSPu5za
         UtX5GpKcW1H+MKUHwOILelAlLbN5bQ8UonDF1pnNFvoIxCHpsYsBFPeyvoiYk3Lyx8
         tSS8Z99hmLw79IrxdAo+1mPGOPyiu6I79w4OZ2x4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jan Beulich <jbeulich@suse.com>,
        Juergen Gross <jgross@suse.com>
Subject: [PATCH 4.14 35/39] Xen/gnttab: handle p2m update errors on a per-slot basis
Date:   Fri,  5 Mar 2021 13:22:34 +0100
Message-Id: <20210305120853.545955106@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210305120851.751937389@linuxfoundation.org>
References: <20210305120851.751937389@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jan Beulich <jbeulich@suse.com>

commit 8310b77b48c5558c140e7a57a702e7819e62f04e upstream.

Bailing immediately from set_foreign_p2m_mapping() upon a p2m updating
error leaves the full batch in an ambiguous state as far as the caller
is concerned. Instead flags respective slots as bad, unmapping what
was mapped there right away.

HYPERVISOR_grant_table_op()'s return value and the individual unmap
slots' status fields get used only for a one-time - there's not much we
can do in case of a failure.

Note that there's no GNTST_enomem or alike, so GNTST_general_error gets
used.

The map ops' handle fields get overwritten just to be on the safe side.

This is part of XSA-367.

Cc: <stable@vger.kernel.org>
Signed-off-by: Jan Beulich <jbeulich@suse.com>
Reviewed-by: Juergen Gross <jgross@suse.com>
Link: https://lore.kernel.org/r/96cccf5d-e756-5f53-b91a-ea269bfb9be0@suse.com
Signed-off-by: Juergen Gross <jgross@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm/xen/p2m.c |   35 +++++++++++++++++++++++++++++++----
 arch/x86/xen/p2m.c |   44 +++++++++++++++++++++++++++++++++++++++++---
 2 files changed, 72 insertions(+), 7 deletions(-)

--- a/arch/arm/xen/p2m.c
+++ b/arch/arm/xen/p2m.c
@@ -91,12 +91,39 @@ int set_foreign_p2m_mapping(struct gntta
 	int i;
 
 	for (i = 0; i < count; i++) {
+		struct gnttab_unmap_grant_ref unmap;
+		int rc;
+
 		if (map_ops[i].status)
 			continue;
-		if (unlikely(!set_phys_to_machine(map_ops[i].host_addr >> XEN_PAGE_SHIFT,
-				    map_ops[i].dev_bus_addr >> XEN_PAGE_SHIFT))) {
-			return -ENOMEM;
-		}
+		if (likely(set_phys_to_machine(map_ops[i].host_addr >> XEN_PAGE_SHIFT,
+				    map_ops[i].dev_bus_addr >> XEN_PAGE_SHIFT)))
+			continue;
+
+		/*
+		 * Signal an error for this slot. This in turn requires
+		 * immediate unmapping.
+		 */
+		map_ops[i].status = GNTST_general_error;
+		unmap.host_addr = map_ops[i].host_addr,
+		unmap.handle = map_ops[i].handle;
+		map_ops[i].handle = ~0;
+		if (map_ops[i].flags & GNTMAP_device_map)
+			unmap.dev_bus_addr = map_ops[i].dev_bus_addr;
+		else
+			unmap.dev_bus_addr = 0;
+
+		/*
+		 * Pre-populate the status field, to be recognizable in
+		 * the log message below.
+		 */
+		unmap.status = 1;
+
+		rc = HYPERVISOR_grant_table_op(GNTTABOP_unmap_grant_ref,
+					       &unmap, 1);
+		if (rc || unmap.status != GNTST_okay)
+			pr_err_once("gnttab unmap failed: rc=%d st=%d\n",
+				    rc, unmap.status);
 	}
 
 	return 0;
--- a/arch/x86/xen/p2m.c
+++ b/arch/x86/xen/p2m.c
@@ -706,6 +706,8 @@ int set_foreign_p2m_mapping(struct gntta
 
 	for (i = 0; i < count; i++) {
 		unsigned long mfn, pfn;
+		struct gnttab_unmap_grant_ref unmap[2];
+		int rc;
 
 		/* Do not add to override if the map failed. */
 		if (map_ops[i].status != GNTST_okay ||
@@ -723,10 +725,46 @@ int set_foreign_p2m_mapping(struct gntta
 
 		WARN(pfn_to_mfn(pfn) != INVALID_P2M_ENTRY, "page must be ballooned");
 
-		if (unlikely(!set_phys_to_machine(pfn, FOREIGN_FRAME(mfn)))) {
-			ret = -ENOMEM;
-			goto out;
+		if (likely(set_phys_to_machine(pfn, FOREIGN_FRAME(mfn))))
+			continue;
+
+		/*
+		 * Signal an error for this slot. This in turn requires
+		 * immediate unmapping.
+		 */
+		map_ops[i].status = GNTST_general_error;
+		unmap[0].host_addr = map_ops[i].host_addr,
+		unmap[0].handle = map_ops[i].handle;
+		map_ops[i].handle = ~0;
+		if (map_ops[i].flags & GNTMAP_device_map)
+			unmap[0].dev_bus_addr = map_ops[i].dev_bus_addr;
+		else
+			unmap[0].dev_bus_addr = 0;
+
+		if (kmap_ops) {
+			kmap_ops[i].status = GNTST_general_error;
+			unmap[1].host_addr = kmap_ops[i].host_addr,
+			unmap[1].handle = kmap_ops[i].handle;
+			kmap_ops[i].handle = ~0;
+			if (kmap_ops[i].flags & GNTMAP_device_map)
+				unmap[1].dev_bus_addr = kmap_ops[i].dev_bus_addr;
+			else
+				unmap[1].dev_bus_addr = 0;
 		}
+
+		/*
+		 * Pre-populate both status fields, to be recognizable in
+		 * the log message below.
+		 */
+		unmap[0].status = 1;
+		unmap[1].status = 1;
+
+		rc = HYPERVISOR_grant_table_op(GNTTABOP_unmap_grant_ref,
+					       unmap, 1 + !!kmap_ops);
+		if (rc || unmap[0].status != GNTST_okay ||
+		    unmap[1].status != GNTST_okay)
+			pr_err_once("gnttab unmap failed: rc=%d st0=%d st1=%d\n",
+				    rc, unmap[0].status, unmap[1].status);
 	}
 
 out:


