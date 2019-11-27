Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2E98B10BD40
	for <lists+stable@lfdr.de>; Wed, 27 Nov 2019 22:28:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731470AbfK0V1P (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 27 Nov 2019 16:27:15 -0500
Received: from mail.kernel.org ([198.145.29.99]:51288 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731454AbfK0U7l (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 27 Nov 2019 15:59:41 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D2B0920678;
        Wed, 27 Nov 2019 20:59:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574888381;
        bh=xSTAfSAwQlR+mw6DZnVx2dvVH4DuAFNoVR9OKpY6MwA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=P9d+fncSRKmJU2Tlq16ekulf2lOtR/Fe7xlI8cwP9OGaPyxqkSAvMub9xj4E1ZOw1
         5mZGYV4bxFvR2PoMIQn8YmqkYKI42Vo/Ra2+dM+YEUj7tV+QBja7F9rPH2EvOUYwFD
         sSbcehlKRSE4E0bskbjxWwgkL6RZ91Yqepv/+jSM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Michael Ellerman <mpe@ellerman.id.au>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 113/306] powerpc/mm/radix: Fix small page at boundary when splitting
Date:   Wed, 27 Nov 2019 21:29:23 +0100
Message-Id: <20191127203123.465081644@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191127203114.766709977@linuxfoundation.org>
References: <20191127203114.766709977@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Michael Ellerman <mpe@ellerman.id.au>

[ Upstream commit 81d1b54dec95209ab5e5be2cf37182885f998753 ]

When we have CONFIG_STRICT_KERNEL_RWX enabled, we want to split the
linear mapping at the text/data boundary so we can map the kernel
text read only.

Currently we always use a small page at the text/data boundary, even
when that's not necessary:

  Mapped 0x0000000000000000-0x0000000000e00000 with 2.00 MiB pages
  Mapped 0x0000000000e00000-0x0000000001000000 with 64.0 KiB pages
  Mapped 0x0000000001000000-0x0000000040000000 with 2.00 MiB pages

This is because the check that the mapping crosses the __init_begin
boundary is too strict, it also returns true when we map exactly up to
the boundary.

So fix it to check that the mapping would actually map past
__init_begin, and with that we see:

  Mapped 0x0000000000000000-0x0000000040000000 with 2.00 MiB pages
  Mapped 0x0000000040000000-0x0000000100000000 with 1.00 GiB pages

Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/powerpc/mm/pgtable-radix.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/powerpc/mm/pgtable-radix.c b/arch/powerpc/mm/pgtable-radix.c
index b387c7b917b7e..69caeb5bccb21 100644
--- a/arch/powerpc/mm/pgtable-radix.c
+++ b/arch/powerpc/mm/pgtable-radix.c
@@ -295,14 +295,14 @@ static int __meminit create_physical_mapping(unsigned long start,
 
 		if (split_text_mapping && (mapping_size == PUD_SIZE) &&
 			(addr < __pa_symbol(__init_begin)) &&
-			(addr + mapping_size) >= __pa_symbol(__init_begin)) {
+			(addr + mapping_size) > __pa_symbol(__init_begin)) {
 			max_mapping_size = PMD_SIZE;
 			goto retry;
 		}
 
 		if (split_text_mapping && (mapping_size == PMD_SIZE) &&
 		    (addr < __pa_symbol(__init_begin)) &&
-		    (addr + mapping_size) >= __pa_symbol(__init_begin)) {
+		    (addr + mapping_size) > __pa_symbol(__init_begin)) {
 			mapping_size = PAGE_SIZE;
 			psize = mmu_virtual_psize;
 		}
-- 
2.20.1



