Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7A8B2451F5B
	for <lists+stable@lfdr.de>; Tue, 16 Nov 2021 01:37:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356138AbhKPAiw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 19:38:52 -0500
Received: from mail.kernel.org ([198.145.29.99]:45212 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1343901AbhKOTWY (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 14:22:24 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9B28B63604;
        Mon, 15 Nov 2021 18:48:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637002122;
        bh=Lw0+NkiXf9T06Ew1A29Vd9r2UccXwd1i0OyZz3s9Xeo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pKQbMOdol3pD+Vm7sxBsfHFBlTZ8VEdfEbYdCWHueugSr/LgkjAqLsR5k3RgyKGuy
         pwjH+GTFecbjN4bqsAmaU6KeH3pA7OwOp5duj6FlzYJKaAOUI2yNozxbZlu1LxyVRG
         sPkV5sMww2K7hqm2iF1YsqBXjYH7dRpnzFWj2vHg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Randy Dunlap <rdunlap@infradead.org>,
        Johannes Berg <johannes@sipsolutions.net>,
        Andy Walls <awalls@md.metrocast.net>,
        linux-um@lists.infradead.org, Richard Weinberger <richard@nod.at>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 445/917] media: ivtv: fix build for UML
Date:   Mon, 15 Nov 2021 17:59:00 +0100
Message-Id: <20211115165443.866072932@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211115165428.722074685@linuxfoundation.org>
References: <20211115165428.722074685@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Randy Dunlap <rdunlap@infradead.org>

[ Upstream commit 6cb67bea945bdf0ad40e633cd2d9fbeb0855675b ]

Prevent the use of page table macros and types from 2 conflicting
places. This fixes multiple build errors and warnings, e.g.:

../arch/x86/include/asm/pgtable_64_types.h:21:34: error: conflicting types for ‘pte_t’
 typedef struct { pteval_t pte; } pte_t;
                                  ^~~~~
In file included from ../include/linux/mm_types_task.h:16:0,
                 from ../include/linux/mm_types.h:5,
                 from ../include/linux/buildid.h:5,
                 from ../include/linux/module.h:14,
                 from ../drivers/media/pci/ivtv/ivtv-driver.h:40,
                 from ../drivers/media/pci/ivtv/ivtvfb.c:29:
../arch/um/include/asm/page.h:57:39: note: previous declaration of ‘pte_t’ was here
 typedef struct { unsigned long pte; } pte_t;

../arch/x86/include/asm/pgtable_types.h:284:43: error: expected ‘)’ before ‘prot’
 static inline pgprot_t pgprot_nx(pgprot_t prot)
                                           ^
../include/linux/pgtable.h:914:26: note: in definition of macro ‘pgprot_nx’
 #define pgprot_nx(prot) (prot)
                          ^~~~
In file included from ../arch/x86/include/asm/memtype.h:6:0,
                 from ../drivers/media/pci/ivtv/ivtvfb.c:40:
../arch/x86/include/asm/pgtable_types.h:288:0: warning: "pgprot_nx" redefined
 #define pgprot_nx pgprot_nx

../arch/x86/include/asm/page_types.h:11:0: warning: "PAGE_SIZE" redefined
 #define PAGE_SIZE  (_AC(1,UL) << PAGE_SHIFT)

In file included from ../include/linux/mm_types_task.h:16:0,
                 from ../include/linux/mm_types.h:5,
                 from ../include/linux/buildid.h:5,
                 from ../include/linux/module.h:14,
                 from ../drivers/media/pci/ivtv/ivtv-driver.h:40,
                 from ../drivers/media/pci/ivtv/ivtvfb.c:29:
../arch/um/include/asm/page.h:14:0: note: this is the location of the previous definition
 #define PAGE_SIZE (_AC(1, UL) << PAGE_SHIFT)

Fixes: 68f5d3f3b654 ("um: add PCI over virtio emulation driver")
Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Cc: Johannes Berg <johannes@sipsolutions.net>
Cc: Andy Walls <awalls@md.metrocast.net>
Cc: linux-um@lists.infradead.org
Cc: Richard Weinberger <richard@nod.at>
Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/pci/ivtv/ivtvfb.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/media/pci/ivtv/ivtvfb.c b/drivers/media/pci/ivtv/ivtvfb.c
index e2d56dca5be40..5ad03b2a50bdb 100644
--- a/drivers/media/pci/ivtv/ivtvfb.c
+++ b/drivers/media/pci/ivtv/ivtvfb.c
@@ -36,7 +36,7 @@
 #include <linux/fb.h>
 #include <linux/ivtvfb.h>
 
-#ifdef CONFIG_X86_64
+#if defined(CONFIG_X86_64) && !defined(CONFIG_UML)
 #include <asm/memtype.h>
 #endif
 
@@ -1157,7 +1157,7 @@ static int ivtvfb_init_card(struct ivtv *itv)
 {
 	int rc;
 
-#ifdef CONFIG_X86_64
+#if defined(CONFIG_X86_64) && !defined(CONFIG_UML)
 	if (pat_enabled()) {
 		if (ivtvfb_force_pat) {
 			pr_info("PAT is enabled. Write-combined framebuffer caching will be disabled.\n");
-- 
2.33.0



