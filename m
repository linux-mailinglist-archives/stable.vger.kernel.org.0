Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ACCA438A228
	for <lists+stable@lfdr.de>; Thu, 20 May 2021 11:37:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233240AbhETJip (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 May 2021 05:38:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:34688 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232233AbhETJgp (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 20 May 2021 05:36:45 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5407D6140A;
        Thu, 20 May 2021 09:30:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1621503006;
        bh=s4bEDhrcdO7IwratN3VIoVQJwBOVOaLx+cy+meq0g8w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SgHMtiqe8lDgZhT6QPJPAEY0Nvf9tzBRkbI3aP0hGQXEv9YDUs1mK18f9IExZd+SP
         aV2I7iuBtmMTo088twcwbKFAyJRHRfPRV0/jhH0lc5/EWeLh60BGBHjAmYZV7HYZnT
         Hd1NICIzgy1sDZ81uLdGf9UkigRhY+9xHng5znno=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 026/425] genirq/matrix: Prevent allocation counter corruption
Date:   Thu, 20 May 2021 11:16:35 +0200
Message-Id: <20210520092132.254686766@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210520092131.308959589@linuxfoundation.org>
References: <20210520092131.308959589@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Vitaly Kuznetsov <vkuznets@redhat.com>

[ Upstream commit c93a5e20c3c2dabef8ea360a3d3f18c6f68233ab ]

When irq_matrix_free() is called for an unallocated vector the
managed_allocated and total_allocated counters get out of sync with the
real state of the matrix. Later, when the last interrupt is freed, these
counters will underflow resulting in UINTMAX because the counters are
unsigned.

While this is certainly a problem of the calling code, this can be catched
in the allocator by checking the allocation bit for the to be freed vector
which simplifies debugging.

An example of the problem described above:
https://lore.kernel.org/lkml/20210318192819.636943062@linutronix.de/

Add the missing sanity check and emit a warning when it triggers.

Suggested-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Link: https://lore.kernel.org/r/20210319111823.1105248-1-vkuznets@redhat.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/irq/matrix.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/kernel/irq/matrix.c b/kernel/irq/matrix.c
index 651a4ad6d711..8e586858bcf4 100644
--- a/kernel/irq/matrix.c
+++ b/kernel/irq/matrix.c
@@ -423,7 +423,9 @@ void irq_matrix_free(struct irq_matrix *m, unsigned int cpu,
 	if (WARN_ON_ONCE(bit < m->alloc_start || bit >= m->alloc_end))
 		return;
 
-	clear_bit(bit, cm->alloc_map);
+	if (WARN_ON_ONCE(!test_and_clear_bit(bit, cm->alloc_map)))
+		return;
+
 	cm->allocated--;
 	if(managed)
 		cm->managed_allocated--;
-- 
2.30.2



