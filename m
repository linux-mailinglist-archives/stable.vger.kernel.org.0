Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 99B7C45C5FE
	for <lists+stable@lfdr.de>; Wed, 24 Nov 2021 15:02:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350194AbhKXOEq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Nov 2021 09:04:46 -0500
Received: from mail.kernel.org ([198.145.29.99]:51016 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1351022AbhKXOAp (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 24 Nov 2021 09:00:45 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8D19A632EE;
        Wed, 24 Nov 2021 13:09:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637759367;
        bh=w9ZQlESNE5VpDrcj1WzFu+MC0cLSfXkK/gHetCSybwQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YH8ydYxSl+s9l0JhMQ/cHdAaAzXtnnmkGtssUE9Ul1qILakAv1Rc+3b6RgLNRcfY+
         VnXVLXJzIAuI3UG8HgFDXb8wSf87zhw5Zu9xLD4vPKPYAR9nouh/efGRxXaFg9C0Jo
         RzPWXzQYx7uRQ7zIQ6iI5nWAGarSSwvxP249VNn4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Gerald Schaefer <gerald.schaefer@linux.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>
Subject: [PATCH 5.15 217/279] s390/setup: avoid reserving memory above identity mapping
Date:   Wed, 24 Nov 2021 12:58:24 +0100
Message-Id: <20211124115726.246383184@linuxfoundation.org>
X-Mailer: git-send-email 2.34.0
In-Reply-To: <20211124115718.776172708@linuxfoundation.org>
References: <20211124115718.776172708@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Vasily Gorbik <gor@linux.ibm.com>

commit 420f48f636b98fd685f44a3acc4c0a7c0840910d upstream.

Such reserved memory region, if not cleaned up later causes problems when
memblock_free_all() is called to release free pages to the buddy allocator
and those reserved regions are carried over to reserve_bootmem_region()
which marks the pages as PageReserved.

Instead use memblock_set_current_limit() to make sure memblock allocations
do not go over identity mapping (which could happen when "mem=" option
is used or during kdump).

Cc: stable@vger.kernel.org
Fixes: 73045a08cf55 ("s390: unify identity mapping limits handling")
Reported-by: Gerald Schaefer <gerald.schaefer@linux.ibm.com>
Reviewed-by: Heiko Carstens <hca@linux.ibm.com>
Signed-off-by: Vasily Gorbik <gor@linux.ibm.com>
Signed-off-by: Heiko Carstens <hca@linux.ibm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/s390/kernel/setup.c |   10 +---------
 1 file changed, 1 insertion(+), 9 deletions(-)

--- a/arch/s390/kernel/setup.c
+++ b/arch/s390/kernel/setup.c
@@ -634,14 +634,6 @@ static struct notifier_block kdump_mem_n
 #endif
 
 /*
- * Make sure that the area above identity mapping is protected
- */
-static void __init reserve_above_ident_map(void)
-{
-	memblock_reserve(ident_map_size, ULONG_MAX);
-}
-
-/*
  * Reserve memory for kdump kernel to be loaded with kexec
  */
 static void __init reserve_crashkernel(void)
@@ -1005,11 +997,11 @@ void __init setup_arch(char **cmdline_p)
 	setup_control_program_code();
 
 	/* Do some memory reservations *before* memory is added to memblock */
-	reserve_above_ident_map();
 	reserve_kernel();
 	reserve_initrd();
 	reserve_certificate_list();
 	reserve_mem_detect_info();
+	memblock_set_current_limit(ident_map_size);
 	memblock_allow_resize();
 
 	/* Get information about *all* installed memory */


