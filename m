Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9A5563A913
	for <lists+stable@lfdr.de>; Sun,  9 Jun 2019 19:07:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729199AbfFIRHM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 9 Jun 2019 13:07:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:46904 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387771AbfFIRGz (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 9 Jun 2019 13:06:55 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 27D9C204EC;
        Sun,  9 Jun 2019 17:06:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1560100014;
        bh=lelvo0io8nkp8qWK8JdAYNl7dl/qXAIZPC9tzGmuaNI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JfXgpSu9cGylMQgvqLV2Hhz7TR99egM18L2wONkL84LNdGQao49QvrDLWEk0qrCLh
         ey6HIG1WG0ajZ4MUtm/cHvsRrx+l0aFcBULNh8PsO7p4NHWA4iLMbMSA9onwr65ick
         e2QbbEwh2Mckj2CzSEDG+QerHpG+ZeOBYhKFQe3A=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, John David Anglin <dave.anglin@bell.net>,
        Helge Deller <deller@gmx.de>
Subject: [PATCH 4.4 235/241] parisc: Use implicit space register selection for loading the coherence index of I/O pdirs
Date:   Sun,  9 Jun 2019 18:42:57 +0200
Message-Id: <20190609164155.546256729@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190609164147.729157653@linuxfoundation.org>
References: <20190609164147.729157653@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: John David Anglin <dave.anglin@bell.net>

commit 63923d2c3800919774f5c651d503d1dd2adaddd5 upstream.

We only support I/O to kernel space. Using %sr1 to load the coherence
index may be racy unless interrupts are disabled. This patch changes the
code used to load the coherence index to use implicit space register
selection. This saves one instruction and eliminates the race.

Tested on rp3440, c8000 and c3750.

Signed-off-by: John David Anglin <dave.anglin@bell.net>
Cc: stable@vger.kernel.org
Signed-off-by: Helge Deller <deller@gmx.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/parisc/ccio-dma.c  |    4 +---
 drivers/parisc/sba_iommu.c |    3 +--
 2 files changed, 2 insertions(+), 5 deletions(-)

--- a/drivers/parisc/ccio-dma.c
+++ b/drivers/parisc/ccio-dma.c
@@ -563,8 +563,6 @@ ccio_io_pdir_entry(u64 *pdir_ptr, space_
 	/* We currently only support kernel addresses */
 	BUG_ON(sid != KERNEL_SPACE);
 
-	mtsp(sid,1);
-
 	/*
 	** WORD 1 - low order word
 	** "hints" parm includes the VALID bit!
@@ -595,7 +593,7 @@ ccio_io_pdir_entry(u64 *pdir_ptr, space_
 	** Grab virtual index [0:11]
 	** Deposit virt_idx bits into I/O PDIR word
 	*/
-	asm volatile ("lci %%r0(%%sr1, %1), %0" : "=r" (ci) : "r" (vba));
+	asm volatile ("lci %%r0(%1), %0" : "=r" (ci) : "r" (vba));
 	asm volatile ("extru %1,19,12,%0" : "+r" (ci) : "r" (ci));
 	asm volatile ("depw  %1,15,12,%0" : "+r" (pa) : "r" (ci));
 
--- a/drivers/parisc/sba_iommu.c
+++ b/drivers/parisc/sba_iommu.c
@@ -573,8 +573,7 @@ sba_io_pdir_entry(u64 *pdir_ptr, space_t
 	pa = virt_to_phys(vba);
 	pa &= IOVP_MASK;
 
-	mtsp(sid,1);
-	asm("lci 0(%%sr1, %1), %0" : "=r" (ci) : "r" (vba));
+	asm("lci 0(%1), %0" : "=r" (ci) : "r" (vba));
 	pa |= (ci >> PAGE_SHIFT) & 0xff;  /* move CI (8 bits) into lowest byte */
 
 	pa |= SBA_PDIR_VALID_BIT;	/* set "valid" bit */


