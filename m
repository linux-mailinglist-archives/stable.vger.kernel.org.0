Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E8597426990
	for <lists+stable@lfdr.de>; Fri,  8 Oct 2021 13:37:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241955AbhJHLjU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 8 Oct 2021 07:39:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:39484 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240857AbhJHLhw (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 8 Oct 2021 07:37:52 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 684C56138B;
        Fri,  8 Oct 2021 11:32:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1633692751;
        bh=yiR6CRBPkd+nCsBqvNZjU4SjBTQL38kxHm59o9ifNHg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hFlT+ls+oCigGVellYoqDcmJ0QaG0qD4JfUlHETmRxskCA98HToBRYu3aNyreSxBQ
         YPLgs5A+sZG3Z2vnoDHS7cSQ+iNbj3uIv73oSf7RMW/2v2KDndhhD75mtqJonK/Ddl
         dh55DfUHmVweOAHFfiK5BIopsVwiwNz7jY59RXUg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jan Beulich <jbeulich@suse.com>,
        Stefano Stabellini <sstabellini@kernel.org>,
        Juergen Gross <jgross@suse.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.14 28/48] swiotlb-xen: ensure to issue well-formed XENMEM_exchange requests
Date:   Fri,  8 Oct 2021 13:28:04 +0200
Message-Id: <20211008112720.957368153@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211008112720.008415452@linuxfoundation.org>
References: <20211008112720.008415452@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jan Beulich <jbeulich@suse.com>

[ Upstream commit 9074c79b62b6e0d91d7f716c6e4e9968eaf9e043 ]

While the hypervisor hasn't been enforcing this, we would still better
avoid issuing requests with GFNs not aligned to the requested order.
Instead of altering the value also in the call to panic(), drop it
there for being static and hence easy to determine without being part
of the panic message.

Signed-off-by: Jan Beulich <jbeulich@suse.com>
Reviewed-by: Stefano Stabellini <sstabellini@kernel.org>
Link: https://lore.kernel.org/r/7b3998e3-1233-4e5a-89ec-d740e77eb166@suse.com
Signed-off-by: Juergen Gross <jgross@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/xen/swiotlb-xen.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/xen/swiotlb-xen.c b/drivers/xen/swiotlb-xen.c
index dbb18dc956f3..de4f55154d49 100644
--- a/drivers/xen/swiotlb-xen.c
+++ b/drivers/xen/swiotlb-xen.c
@@ -232,10 +232,11 @@ retry:
 	/*
 	 * Get IO TLB memory from any location.
 	 */
-	start = memblock_alloc(PAGE_ALIGN(bytes), PAGE_SIZE);
+	start = memblock_alloc(PAGE_ALIGN(bytes),
+			       IO_TLB_SEGSIZE << IO_TLB_SHIFT);
 	if (!start)
-		panic("%s: Failed to allocate %lu bytes align=0x%lx\n",
-		      __func__, PAGE_ALIGN(bytes), PAGE_SIZE);
+		panic("%s: Failed to allocate %lu bytes\n",
+		      __func__, PAGE_ALIGN(bytes));
 
 	/*
 	 * And replace that memory with pages under 4GB.
-- 
2.33.0



