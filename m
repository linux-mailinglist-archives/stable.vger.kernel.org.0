Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EE278472ED8
	for <lists+stable@lfdr.de>; Mon, 13 Dec 2021 15:21:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239068AbhLMOUc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Dec 2021 09:20:32 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:35216 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234203AbhLMOU3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Dec 2021 09:20:29 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 23402B81071;
        Mon, 13 Dec 2021 14:20:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 42521C34602;
        Mon, 13 Dec 2021 14:20:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1639405226;
        bh=CYVJQkz8G2L85MLOQlmPwd9eag/MhqdmKIgcPUeLlLY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HGMxQkDA/lfPQege9u6j2zFYLsQhBdllYWe82tB0PSCbV0kGKsPtE0xJTqYqPynWX
         Bg5dY2XZH0xGoTe5ILd0UZ8j9h1yJgadDmtDtUoD73JpOzyPysQiHg8Q7w3m639uSE
         0Axds7v/OFyRz3olQaeZA/hERwX2I8Xs6hAy8gzrgiyBrTimOnFBPpuAXCojRBI1nF
         ThkaFnGayC/qBnckwVBMOZFw+KitQUv+sbwkXL2rFLjD+iIEkx7jVKDCtqYg18hl/D
         BUp2qBG9/fBmC054u+hlXD3oi6AICMyyWVoXpfGUTct03Mk5CCu+v80ffgDg0muRFP
         UoUcDcH7ArYxw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Sasha Levin <sashal@kernel.org>, kvm@vger.kernel.org
Subject: [PATCH MANUALSEL 5.10 4/4] KVM: downgrade two BUG_ONs to WARN_ON_ONCE
Date:   Mon, 13 Dec 2021 09:20:18 -0500
Message-Id: <20211213142020.352376-4-sashal@kernel.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211213142020.352376-1-sashal@kernel.org>
References: <20211213142020.352376-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Paolo Bonzini <pbonzini@redhat.com>

[ Upstream commit 5f25e71e311478f9bb0a8ef49e7d8b95316491d7 ]

This is not an unrecoverable situation.  Users of kvm_read_guest_offset_cached
and kvm_write_guest_offset_cached must expect the read/write to fail, and
therefore it is possible to just return early with an error value.

Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 virt/kvm/kvm_main.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 97ac3c6fd4441..4a7d377b3a500 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -2590,7 +2590,8 @@ int kvm_write_guest_offset_cached(struct kvm *kvm, struct gfn_to_hva_cache *ghc,
 	int r;
 	gpa_t gpa = ghc->gpa + offset;
 
-	BUG_ON(len + offset > ghc->len);
+	if (WARN_ON_ONCE(len + offset > ghc->len))
+		return -EINVAL;
 
 	if (slots->generation != ghc->generation) {
 		if (__kvm_gfn_to_hva_cache_init(slots, ghc, ghc->gpa, ghc->len))
@@ -2627,7 +2628,8 @@ int kvm_read_guest_offset_cached(struct kvm *kvm, struct gfn_to_hva_cache *ghc,
 	int r;
 	gpa_t gpa = ghc->gpa + offset;
 
-	BUG_ON(len + offset > ghc->len);
+	if (WARN_ON_ONCE(len + offset > ghc->len))
+		return -EINVAL;
 
 	if (slots->generation != ghc->generation) {
 		if (__kvm_gfn_to_hva_cache_init(slots, ghc, ghc->gpa, ghc->len))
-- 
2.33.0

