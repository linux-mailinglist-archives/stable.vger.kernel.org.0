Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E00AF2B5F99
	for <lists+stable@lfdr.de>; Tue, 17 Nov 2020 13:59:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728661AbgKQM5c (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 17 Nov 2020 07:57:32 -0500
Received: from mail.kernel.org ([198.145.29.99]:54720 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728654AbgKQM5c (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 17 Nov 2020 07:57:32 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2A526223AB;
        Tue, 17 Nov 2020 12:57:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605617851;
        bh=qA9fL4rqujlpZBdsl3uGA3WgnfkXV4SHUiZeGzIiW58=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=BsMhZxZPvtXHwq/rbiwN99y9jbU3C44DKaiHqzBYS3vCcazCjZ3b48l8yc+XBIQJe
         6yzu8GdEvt42goZSwPl3Okr6629DkD6ICvr0XdpuLVwI470KJgpimj53nLzVPDZjY4
         /NG+rXE3HGG1XtkKEE3hTyZgz8QtI8YLZUs56dlc=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Aaron Lewis <aaronlewis@google.com>,
        Alexander Graf <graf@amazon.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sasha Levin <sashal@kernel.org>, kvm@vger.kernel.org,
        linux-kselftest@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 03/11] selftests: kvm: Fix the segment descriptor layout to match the actual layout
Date:   Tue, 17 Nov 2020 07:57:17 -0500
Message-Id: <20201117125725.599833-3-sashal@kernel.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20201117125725.599833-1-sashal@kernel.org>
References: <20201117125725.599833-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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

