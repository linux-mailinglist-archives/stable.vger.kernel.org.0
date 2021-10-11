Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 83DDB42913A
	for <lists+stable@lfdr.de>; Mon, 11 Oct 2021 16:15:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241590AbhJKOQg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Oct 2021 10:16:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:37968 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236716AbhJKOOc (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 11 Oct 2021 10:14:32 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 153D961352;
        Mon, 11 Oct 2021 14:04:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1633961087;
        bh=8fezxCJFjDsKvW5ukJWrJsfQPh+RcvRx3k2yBB2rrpA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tulRX9fDnjzP6Ny+2mXdtS63bIvjZN9w8VYIt27aZBlmKDf2a6V3lXoBaDsyO8T7O
         krhfoCdNGnvK747hXFXkxm7X/A6dAXN+YX78oLyTm1ENWkIELmlrKeYlr+EFG30WXr
         GrdG2dhmYIKuyi1p3yT6gN6YYeZXqWf3aXsaw8UQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jan Beulich <jbeulich@suse.com>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        Juergen Gross <jgross@suse.com>
Subject: [PATCH 4.19 04/28] xen/privcmd: fix error handling in mmap-resource processing
Date:   Mon, 11 Oct 2021 15:46:54 +0200
Message-Id: <20211011134640.856296875@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211011134640.711218469@linuxfoundation.org>
References: <20211011134640.711218469@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jan Beulich <jbeulich@suse.com>

commit e11423d6721dd63b23fb41ade5e8d0b448b17780 upstream.

xen_pfn_t is the same size as int only on 32-bit builds (and not even
on Arm32). Hence pfns[] can't be used directly to read individual error
values returned from xen_remap_domain_mfn_array(); every other error
indicator would be skipped/ignored on 64-bit.

Fixes: 3ad0876554ca ("xen/privcmd: add IOCTL_PRIVCMD_MMAP_RESOURCE")
Cc: stable@vger.kernel.org
Signed-off-by: Jan Beulich <jbeulich@suse.com>
Reviewed-by: Boris Ostrovsky <boris.ostrovsky@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

Link: https://lore.kernel.org/r/aa6d6a67-6889-338a-a910-51e889f792d5@suse.com
Signed-off-by: Juergen Gross <jgross@suse.com>
---
 drivers/xen/privcmd.c |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

--- a/drivers/xen/privcmd.c
+++ b/drivers/xen/privcmd.c
@@ -835,11 +835,12 @@ static long privcmd_ioctl_mmap_resource(
 		unsigned int domid =
 			(xdata.flags & XENMEM_rsrc_acq_caller_owned) ?
 			DOMID_SELF : kdata.dom;
-		int num;
+		int num, *errs = (int *)pfns;
 
+		BUILD_BUG_ON(sizeof(*errs) > sizeof(*pfns));
 		num = xen_remap_domain_mfn_array(vma,
 						 kdata.addr & PAGE_MASK,
-						 pfns, kdata.num, (int *)pfns,
+						 pfns, kdata.num, errs,
 						 vma->vm_page_prot,
 						 domid,
 						 vma->vm_private_data);
@@ -849,7 +850,7 @@ static long privcmd_ioctl_mmap_resource(
 			unsigned int i;
 
 			for (i = 0; i < num; i++) {
-				rc = pfns[i];
+				rc = errs[i];
 				if (rc < 0)
 					break;
 			}


