Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DC214428EBD
	for <lists+stable@lfdr.de>; Mon, 11 Oct 2021 15:49:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237481AbhJKNvo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Oct 2021 09:51:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:39338 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237349AbhJKNvI (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 11 Oct 2021 09:51:08 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 02E8460FD7;
        Mon, 11 Oct 2021 13:48:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1633960125;
        bh=rO92xfwd8ztuQQ7QEWDlKv9RsldvGRVYJx0jTy55PWo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cV/Yywemh2qla2jpbGT4M2Cp6+030NBJVMeONs1KViRbo1VzY1qVm9wGpRopbiYo/
         mkkZQ+LAh4om/LIsXOhP64xgQVAdJ2YM1jVpvHs+bYQoQNU3SMBdbEYLp//SHXTTaf
         iMyMg8M99ec7gVQwgm/jz+ads/FkonDlPcxiaOgY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jan Beulich <jbeulich@suse.com>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        Juergen Gross <jgross@suse.com>
Subject: [PATCH 5.4 05/52] xen/privcmd: fix error handling in mmap-resource processing
Date:   Mon, 11 Oct 2021 15:45:34 +0200
Message-Id: <20211011134503.901978188@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211011134503.715740503@linuxfoundation.org>
References: <20211011134503.715740503@linuxfoundation.org>
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
@@ -810,11 +810,12 @@ static long privcmd_ioctl_mmap_resource(
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
@@ -824,7 +825,7 @@ static long privcmd_ioctl_mmap_resource(
 			unsigned int i;
 
 			for (i = 0; i < num; i++) {
-				rc = pfns[i];
+				rc = errs[i];
 				if (rc < 0)
 					break;
 			}


