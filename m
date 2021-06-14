Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D47B53A609D
	for <lists+stable@lfdr.de>; Mon, 14 Jun 2021 12:34:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233191AbhFNKgH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Jun 2021 06:36:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:40118 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233197AbhFNKea (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 14 Jun 2021 06:34:30 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6627D61356;
        Mon, 14 Jun 2021 10:31:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1623666718;
        bh=5bqUyuGC4qPAzcsbT4hkqG7eCZ5cUtOm6k0n5Fu7zvY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JkIg3n3gr6Qyb/qhcmBRUVah5XVM9EAHxUimGbfnSV5gwjD1xpLl93Ur20HblxbpX
         qgq43OC3u7uTZelmQQ58b1y+ppwsqLoxvcwARt73Hi/ZNHove8ylT3Qg6LFtlYtN3k
         Sac1pM7mNem/eWDAz3njAi1sX5LEZ7I/yzTndPyM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH 4.9 37/42] kvm: fix previous commit for 32-bit builds
Date:   Mon, 14 Jun 2021 12:27:28 +0200
Message-Id: <20210614102643.881341114@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210614102642.700712386@linuxfoundation.org>
References: <20210614102642.700712386@linuxfoundation.org>
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
@@ -939,8 +939,8 @@ __gfn_to_hva_memslot(struct kvm_memory_s
 	 * table walks, do not let the processor speculate loads outside
 	 * the guest's registered memslots.
 	 */
-	unsigned long offset = array_index_nospec(gfn - slot->base_gfn,
-						  slot->npages);
+	unsigned long offset = gfn - slot->base_gfn;
+	offset = array_index_nospec(offset, slot->npages);
 	return slot->userspace_addr + offset * PAGE_SIZE;
 }
 


