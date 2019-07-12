Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EBCF266CA5
	for <lists+stable@lfdr.de>; Fri, 12 Jul 2019 14:22:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726466AbfGLMVV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 12 Jul 2019 08:21:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:55402 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727566AbfGLMVV (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 12 Jul 2019 08:21:21 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9C40420863;
        Fri, 12 Jul 2019 12:21:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1562934080;
        bh=MX8nE+ej6pJ+TGyg49LdGQN4IIk50a+OomxmjDRcTbI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rqFIojF/7siECYZXEQ9PyXlL3nlRpm+jYw9IcLo+IuwBFOBzzcVfEqzyTYtCWSjEI
         9f1qPjn5UG6N6kbpBe6AG7U9BqCZu1bfipMWGgU0gY3WWEJsY/4pA00CFoB3xJS5f/
         5txExeVTEWT6e3o5/1bXSjqoyofnsRBkCnWaAEVM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Toshiaki Makita <toshiaki.makita1@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 38/91] bpf, devmap: Fix premature entry free on destroying map
Date:   Fri, 12 Jul 2019 14:18:41 +0200
Message-Id: <20190712121623.468664858@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190712121621.422224300@linuxfoundation.org>
References: <20190712121621.422224300@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit d4dd153d551634683fccf8881f606fa9f3dfa1ef ]

dev_map_free() waits for flush_needed bitmap to be empty in order to
ensure all flush operations have completed before freeing its entries.
However the corresponding clear_bit() was called before using the
entries, so the entries could be used after free.

All access to the entries needs to be done before clearing the bit.
It seems commit a5e2da6e9787 ("bpf: netdev is never null in
__dev_map_flush") accidentally changed the clear_bit() and memory access
order.

Note that the problem happens only in __dev_map_flush(), not in
dev_map_flush_old(). dev_map_flush_old() is called only after nulling
out the corresponding netdev_map entry, so dev_map_free() never frees
the entry thus no such race happens there.

Fixes: a5e2da6e9787 ("bpf: netdev is never null in __dev_map_flush")
Signed-off-by: Toshiaki Makita <toshiaki.makita1@gmail.com>
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/bpf/devmap.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/kernel/bpf/devmap.c b/kernel/bpf/devmap.c
index 2faad033715f..99353ac28cd4 100644
--- a/kernel/bpf/devmap.c
+++ b/kernel/bpf/devmap.c
@@ -291,10 +291,10 @@ void __dev_map_flush(struct bpf_map *map)
 		if (unlikely(!dev))
 			continue;
 
-		__clear_bit(bit, bitmap);
-
 		bq = this_cpu_ptr(dev->bulkq);
 		bq_xmit_all(dev, bq, XDP_XMIT_FLUSH, true);
+
+		__clear_bit(bit, bitmap);
 	}
 }
 
-- 
2.20.1



