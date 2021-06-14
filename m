Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4A8D03A649C
	for <lists+stable@lfdr.de>; Mon, 14 Jun 2021 13:25:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234776AbhFNL0u (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Jun 2021 07:26:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:50580 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236351AbhFNLY4 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 14 Jun 2021 07:24:56 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B0EBD619B5;
        Mon, 14 Jun 2021 10:54:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1623668064;
        bh=G3wpbeV2J39SQ326Nf8dhShfVnNbaKE63kdWZcPqBQQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ctnVt2RzkJv3IsR/+kg7bZG3iHwzNZdP6Yajn543xVdJMikk+pJJUGE9PBRe6/3/y
         KvsE6nTTYZr/Jc0xXTAU4FoxMMKsv/1Fo9Q2pXbPyBwyBe4YwNmlkEX3UCUcT/kudG
         VWgAvxHA9pWEAMzc5p0+/Q+eVk82lrb9EfvtBETs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH 5.12 166/173] kvm: fix previous commit for 32-bit builds
Date:   Mon, 14 Jun 2021 12:28:18 +0200
Message-Id: <20210614102703.692179423@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210614102658.137943264@linuxfoundation.org>
References: <20210614102658.137943264@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Paolo Bonzini <pbonzini@redhat.com>

commit 4422829e8053068e0225e4d0ef42dc41ea7c9ef5 upstream.

array_index_nospec does not work for uint64_t on 32-bit builds.
However, the size of a memory slot must be less than 20 bits wide
on those system, since the memory slot must fit in the user
address space.  So just store it in an unsigned long.

Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/linux/kvm_host.h |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -1124,8 +1124,8 @@ __gfn_to_hva_memslot(struct kvm_memory_s
 	 * table walks, do not let the processor speculate loads outside
 	 * the guest's registered memslots.
 	 */
-	unsigned long offset = array_index_nospec(gfn - slot->base_gfn,
-						  slot->npages);
+	unsigned long offset = gfn - slot->base_gfn;
+	offset = array_index_nospec(offset, slot->npages);
 	return slot->userspace_addr + offset * PAGE_SIZE;
 }
 


