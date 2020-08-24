Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7DB4C24F51A
	for <lists+stable@lfdr.de>; Mon, 24 Aug 2020 10:44:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728751AbgHXIoh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Aug 2020 04:44:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:40456 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728427AbgHXIod (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 24 Aug 2020 04:44:33 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AADA72075B;
        Mon, 24 Aug 2020 08:44:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1598258673;
        bh=fIHeNq+fwaVaSWsFR5chX7jTNDuNYdyTKVPJb18KZRY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qyHvJ9eRuyGxrOiG5xsrXgCrGrWyZ+r4t9cVqluFBLEkuQsqmZjNlWr8bvoYaX6aG
         9Ce/fsulH4gvmf5jKUTt1u/AWGykouhgHdaOFqirqsmJX9G3yLUdAGjAbP88aX30tC
         +I9qwYVptpBFgQuQePAKJBvLsK7Mr+NtZI+OsPwg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Juergen Gross <jgross@suse.com>,
        Ard Biesheuvel <ardb@kernel.org>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.7 103/124] efi: avoid error message when booting under Xen
Date:   Mon, 24 Aug 2020 10:30:37 +0200
Message-Id: <20200824082414.485788191@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200824082409.368269240@linuxfoundation.org>
References: <20200824082409.368269240@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Juergen Gross <jgross@suse.com>

[ Upstream commit 6163a985e50cb19d5bdf73f98e45b8af91a77658 ]

efifb_probe() will issue an error message in case the kernel is booted
as Xen dom0 from UEFI as EFI_MEMMAP won't be set in this case. Avoid
that message by calling efi_mem_desc_lookup() only if EFI_MEMMAP is set.

Fixes: 38ac0287b7f4 ("fbdev/efifb: Honour UEFI memory map attributes when mapping the FB")
Signed-off-by: Juergen Gross <jgross@suse.com>
Acked-by: Ard Biesheuvel <ardb@kernel.org>
Acked-by: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Signed-off-by: Juergen Gross <jgross@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/video/fbdev/efifb.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/video/fbdev/efifb.c b/drivers/video/fbdev/efifb.c
index 65491ae74808d..e57c00824965c 100644
--- a/drivers/video/fbdev/efifb.c
+++ b/drivers/video/fbdev/efifb.c
@@ -453,7 +453,7 @@ static int efifb_probe(struct platform_device *dev)
 	info->apertures->ranges[0].base = efifb_fix.smem_start;
 	info->apertures->ranges[0].size = size_remap;
 
-	if (efi_enabled(EFI_BOOT) &&
+	if (efi_enabled(EFI_MEMMAP) &&
 	    !efi_mem_desc_lookup(efifb_fix.smem_start, &md)) {
 		if ((efifb_fix.smem_start + efifb_fix.smem_len) >
 		    (md.phys_addr + (md.num_pages << EFI_PAGE_SHIFT))) {
-- 
2.25.1



