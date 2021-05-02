Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1709A370C54
	for <lists+stable@lfdr.de>; Sun,  2 May 2021 16:05:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233152AbhEBOFz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 2 May 2021 10:05:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:50872 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232511AbhEBOFh (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 2 May 2021 10:05:37 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B23D3613D4;
        Sun,  2 May 2021 14:04:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1619964286;
        bh=s4bEDhrcdO7IwratN3VIoVQJwBOVOaLx+cy+meq0g8w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=b/bbNB+Hki02qjPXK64lHpJMtHIvh8TUClep/LNudz3tuMZyFJAxItMG3saEtwbq3
         MB5gMlhrgzt/da3f2gkAIKBIPRvL0pgXo+I2uTPnp6Ijk6hrpOTxs+nVKqqfWR1Vv/
         9GyV78i6LEPtjyQnddgabNUC6hMR0QiFQSudElieShD45uEzq9VwmAqh3lBvAdXIBk
         NNoAosjivdN/qkAlmQwjNqjDstiI5ghZ7de3kCVn7CUC4uQQt3c5V7AhTlK/nwE4av
         9pU1u5w9KH71dzYQq8MUaWTd8vgeMNrfijOZ0jzBtqvpK9XrhED2eC+AvbQy5r/dkK
         qV12yVJ3Tok5w==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 5.4 09/34] genirq/matrix: Prevent allocation counter corruption
Date:   Sun,  2 May 2021 10:04:09 -0400
Message-Id: <20210502140434.2719553-9-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210502140434.2719553-1-sashal@kernel.org>
References: <20210502140434.2719553-1-sashal@kernel.org>
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

