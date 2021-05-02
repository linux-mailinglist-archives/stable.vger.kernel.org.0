Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 77091370BDA
	for <lists+stable@lfdr.de>; Sun,  2 May 2021 16:03:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232416AbhEBOEj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 2 May 2021 10:04:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:49374 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232198AbhEBOEb (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 2 May 2021 10:04:31 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 66C63613D2;
        Sun,  2 May 2021 14:03:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1619964217;
        bh=s4bEDhrcdO7IwratN3VIoVQJwBOVOaLx+cy+meq0g8w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=oQygdp4CYK1guXyR/Ps/Zrv3K13dPkwFZoZ5iJMh+PrBAeVP3TRbBLPSmaFjxeeMh
         PR8L7mM5KPPMcLFvpTojXdedGj8FFeop8Av0Ef8PXpXtdT3MNzT/o7Zt54MM2swvpu
         X1JVKgdMRuTazH/ogn7NoFgJqYzSfapGOwMhayrlAP01IYngJ1CrRp/K64cw8XhM9A
         j9xJAEQhdnOiccx+AZyOacETNgmRrGjL/GSwRl5zKgnlylli39fKXl/rCaY1wijOg6
         HFeU+FbxzG4wOHar9fiRETeGGVGmpJ59lmQrrx5JrDmfkzfS1Ud8E4imjAz3UoiHdu
         JV990J7ZTF2gw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 5.12 15/79] genirq/matrix: Prevent allocation counter corruption
Date:   Sun,  2 May 2021 10:02:12 -0400
Message-Id: <20210502140316.2718705-15-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210502140316.2718705-1-sashal@kernel.org>
References: <20210502140316.2718705-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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

