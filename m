Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CF48A3D6250
	for <lists+stable@lfdr.de>; Mon, 26 Jul 2021 18:16:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236578AbhGZPf3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Jul 2021 11:35:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:51906 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237855AbhGZPeu (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 26 Jul 2021 11:34:50 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 858706056B;
        Mon, 26 Jul 2021 16:15:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1627316118;
        bh=ZzRv0JOfJjaUGMuerpvp3Et3Y0kb7NsmdPJtLOwTmOU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nHK7UbVrDyIAndmMm15I3nx4Qzptt45Ze5pb9p6HMdxrQj4ZwUsQTXttuEbMsAN0b
         1IVOU9Koq2+2edYNFrJCIGWFDzukdE+mrYWZCrkS9Ban74hEGeJ4AA4AdMdbkXydVP
         Jn9Xg5uoAjxmq3f0GKC7CHYUt5klXYNaDfEtJcXI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Alexander Potapenko <glider@google.com>,
        Marco Elver <elver@google.com>,
        Dmitry Vyukov <dvyukov@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 5.13 196/223] kfence: move the size check to the beginning of __kfence_alloc()
Date:   Mon, 26 Jul 2021 17:39:48 +0200
Message-Id: <20210726153852.606420670@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210726153846.245305071@linuxfoundation.org>
References: <20210726153846.245305071@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Alexander Potapenko <glider@google.com>

commit 235a85cb32bb123854ad31de46fdbf04c1d57cda upstream.

Check the allocation size before toggling kfence_allocation_gate.

This way allocations that can't be served by KFENCE will not result in
waiting for another CONFIG_KFENCE_SAMPLE_INTERVAL without allocating
anything.

Link: https://lkml.kernel.org/r/20210714092222.1890268-1-glider@google.com
Signed-off-by: Alexander Potapenko <glider@google.com>
Suggested-by: Marco Elver <elver@google.com>
Reviewed-by: Marco Elver <elver@google.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: Marco Elver <elver@google.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: <stable@vger.kernel.org>	[5.12+]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/kfence/core.c |   10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

--- a/mm/kfence/core.c
+++ b/mm/kfence/core.c
@@ -734,6 +734,13 @@ void kfence_shutdown_cache(struct kmem_c
 void *__kfence_alloc(struct kmem_cache *s, size_t size, gfp_t flags)
 {
 	/*
+	 * Perform size check before switching kfence_allocation_gate, so that
+	 * we don't disable KFENCE without making an allocation.
+	 */
+	if (size > PAGE_SIZE)
+		return NULL;
+
+	/*
 	 * allocation_gate only needs to become non-zero, so it doesn't make
 	 * sense to continue writing to it and pay the associated contention
 	 * cost, in case we have a large number of concurrent allocations.
@@ -757,9 +764,6 @@ void *__kfence_alloc(struct kmem_cache *
 	if (!READ_ONCE(kfence_enabled))
 		return NULL;
 
-	if (size > PAGE_SIZE)
-		return NULL;
-
 	return kfence_guarded_alloc(s, size, flags);
 }
 


