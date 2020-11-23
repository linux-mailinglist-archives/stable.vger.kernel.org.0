Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5082C2C06DE
	for <lists+stable@lfdr.de>; Mon, 23 Nov 2020 13:43:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731457AbgKWMfK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 23 Nov 2020 07:35:10 -0500
Received: from mail.kernel.org ([198.145.29.99]:47142 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731487AbgKWMfJ (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 23 Nov 2020 07:35:09 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1C4B62065E;
        Mon, 23 Nov 2020 12:35:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1606134908;
        bh=qA9fL4rqujlpZBdsl3uGA3WgnfkXV4SHUiZeGzIiW58=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=EfSMS7Ak5z14eZeIOJ3qJ4i3cNFkUMTcm+I+oXyCbzZXv8t4KcARsfXQ9rOLwWKr1
         GfpkOtALY93XYboKtj+NY+VhE6J/ppGfCyIvZtBruCEnrqhOpdkW7YYuulQJpdAyBP
         LKBReFDsi6GGOH3bLb8z0t/ZfYLKdmqxtbe0q8BI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Aaron Lewis <aaronlewis@google.com>,
        Alexander Graf <graf@amazon.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 036/158] selftests: kvm: Fix the segment descriptor layout to match the actual layout
Date:   Mon, 23 Nov 2020 13:21:04 +0100
Message-Id: <20201123121821.677400596@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201123121819.943135899@linuxfoundation.org>
References: <20201123121819.943135899@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Aaron Lewis <aaronlewis@google.com>

[ Upstream commit df11f7dd5834146defa448acba097e8d7703cc42 ]

Fix the layout of 'struct desc64' to match the layout described in the
SDM Vol 3, Chapter 3 "Protected-Mode Memory Management", section 3.4.5
"Segment Descriptors", Figure 3-8 "Segment Descriptor".  The test added
later in this series relies on this and crashes if this layout is not
correct.

Signed-off-by: Aaron Lewis <aaronlewis@google.com>
Reviewed-by: Alexander Graf <graf@amazon.com>
Message-Id: <20201012194716.3950330-2-aaronlewis@google.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/kvm/include/x86_64/processor.h | 2 +-
 tools/testing/selftests/kvm/lib/x86_64/processor.c     | 3 ++-
 2 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/tools/testing/selftests/kvm/include/x86_64/processor.h b/tools/testing/selftests/kvm/include/x86_64/processor.h
index ff234018219cf..aead07c24afcf 100644
--- a/tools/testing/selftests/kvm/include/x86_64/processor.h
+++ b/tools/testing/selftests/kvm/include/x86_64/processor.h
@@ -57,7 +57,7 @@ enum x86_register {
 struct desc64 {
 	uint16_t limit0;
 	uint16_t base0;
-	unsigned base1:8, s:1, type:4, dpl:2, p:1;
+	unsigned base1:8, type:4, s:1, dpl:2, p:1;
 	unsigned limit1:4, avl:1, l:1, db:1, g:1, base2:8;
 	uint32_t base3;
 	uint32_t zero1;
diff --git a/tools/testing/selftests/kvm/lib/x86_64/processor.c b/tools/testing/selftests/kvm/lib/x86_64/processor.c
index 6698cb741e10a..7d8f7fc736467 100644
--- a/tools/testing/selftests/kvm/lib/x86_64/processor.c
+++ b/tools/testing/selftests/kvm/lib/x86_64/processor.c
@@ -446,11 +446,12 @@ static void kvm_seg_fill_gdt_64bit(struct kvm_vm *vm, struct kvm_segment *segp)
 	desc->limit0 = segp->limit & 0xFFFF;
 	desc->base0 = segp->base & 0xFFFF;
 	desc->base1 = segp->base >> 16;
-	desc->s = segp->s;
 	desc->type = segp->type;
+	desc->s = segp->s;
 	desc->dpl = segp->dpl;
 	desc->p = segp->present;
 	desc->limit1 = segp->limit >> 16;
+	desc->avl = segp->avl;
 	desc->l = segp->l;
 	desc->db = segp->db;
 	desc->g = segp->g;
-- 
2.27.0



