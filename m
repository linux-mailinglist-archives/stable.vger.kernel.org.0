Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2D256126BC0
	for <lists+stable@lfdr.de>; Thu, 19 Dec 2019 19:59:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728355AbfLSS7I (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 19 Dec 2019 13:59:08 -0500
Received: from mail.kernel.org ([198.145.29.99]:49134 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729339AbfLSSxu (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 19 Dec 2019 13:53:50 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 23DC520674;
        Thu, 19 Dec 2019 18:53:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576781629;
        bh=cV8BtaBdwTKnozME35vtYwxR3ObGSo3brVmHIXTUxiY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0ievnbt7fnlbToY4noqcNkATIKltdZvAgGOQh5/tblOYvOh5J5QF5PEBC4ftNz5mq
         kXbY3VK5SFjPXn9X9YrQyt/9as2KEYrBQ+EkZkWOrc+UHahcsGUa7QUggAXeXPttDK
         V8OSxMvSobJSq/gYaK97odUgF/biGC2U5ugAMszs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Mike Rapoport <rppt@linux.ibm.com>,
        Max Filippov <jcmvbkbc@gmail.com>
Subject: [PATCH 5.4 16/80] xtensa: use MEMBLOCK_ALLOC_ANYWHERE for KASAN shadow map
Date:   Thu, 19 Dec 2019 19:34:08 +0100
Message-Id: <20191219183053.711885287@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191219183031.278083125@linuxfoundation.org>
References: <20191219183031.278083125@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Max Filippov <jcmvbkbc@gmail.com>

commit e64681b487c897ec871465083bf0874087d47b66 upstream.

KASAN shadow map doesn't need to be accessible through the linear kernel
mapping, allocate its pages with MEMBLOCK_ALLOC_ANYWHERE so that high
memory can be used. This frees up to ~100MB of low memory on xtensa
configurations with KASAN and high memory.

Cc: stable@vger.kernel.org # v5.1+
Fixes: f240ec09bb8a ("memblock: replace memblock_alloc_base(ANYWHERE) with memblock_phys_alloc")
Reviewed-by: Mike Rapoport <rppt@linux.ibm.com>
Signed-off-by: Max Filippov <jcmvbkbc@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/xtensa/mm/kasan_init.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/arch/xtensa/mm/kasan_init.c
+++ b/arch/xtensa/mm/kasan_init.c
@@ -56,7 +56,9 @@ static void __init populate(void *start,
 
 		for (k = 0; k < PTRS_PER_PTE; ++k, ++j) {
 			phys_addr_t phys =
-				memblock_phys_alloc(PAGE_SIZE, PAGE_SIZE);
+				memblock_phys_alloc_range(PAGE_SIZE, PAGE_SIZE,
+							  0,
+							  MEMBLOCK_ALLOC_ANYWHERE);
 
 			if (!phys)
 				panic("Failed to allocate page table page\n");


