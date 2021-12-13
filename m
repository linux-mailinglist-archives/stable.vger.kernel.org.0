Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E1E8D472EC9
	for <lists+stable@lfdr.de>; Mon, 13 Dec 2021 15:21:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238952AbhLMOUV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Dec 2021 09:20:21 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:41822 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234107AbhLMOUR (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Dec 2021 09:20:17 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id CF63C6109E;
        Mon, 13 Dec 2021 14:20:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B2258C34603;
        Mon, 13 Dec 2021 14:20:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1639405216;
        bh=Emm6T7pwA/+Z6G0W9UiEMZ7qT/ArAlPegWjRyye7VzU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dDLgAGPwC5QLENpmFQf5l983/clizVqtQGWJ1snlcEtrJfKZFo9HbS8wztoRIzg2W
         MtLDmk5lOa3zT+hQgUU065EUGcQcVIAyzZHodDfklO1vUs9h6k5nb02iEV3EOQGA9H
         IWKOOvx7CkL5UnlzZq6vWTC2VKecZEpj1nqoZdfESOneWvjtp2RMqySEEFFfX6r/Be
         hr8gI0XYt8OKlqrUZeAa5yNJ4T/KjGRd/LuVbs668K4FS1Zvdwak/W1BdSbY7ZUtOu
         6hXaOiX+dQUsQyDJDRYDzFU6rOfrNtQW2xoxDzTe14qaxEffZ0JnvcN3Np0pU9LtNB
         3MCmQgl6ulOFA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Sasha Levin <sashal@kernel.org>, kvm@vger.kernel.org
Subject: [PATCH MANUALSEL 5.15 8/9] KVM: downgrade two BUG_ONs to WARN_ON_ONCE
Date:   Mon, 13 Dec 2021 09:19:41 -0500
Message-Id: <20211213141944.352249-8-sashal@kernel.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211213141944.352249-1-sashal@kernel.org>
References: <20211213141944.352249-1-sashal@kernel.org>
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
index ce1847bc898b2..c6bfd4e15d28a 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -3001,7 +3001,8 @@ int kvm_write_guest_offset_cached(struct kvm *kvm, struct gfn_to_hva_cache *ghc,
 	int r;
 	gpa_t gpa = ghc->gpa + offset;
 
-	BUG_ON(len + offset > ghc->len);
+	if (WARN_ON_ONCE(len + offset > ghc->len))
+		return -EINVAL;
 
 	if (slots->generation != ghc->generation) {
 		if (__kvm_gfn_to_hva_cache_init(slots, ghc, ghc->gpa, ghc->len))
@@ -3038,7 +3039,8 @@ int kvm_read_guest_offset_cached(struct kvm *kvm, struct gfn_to_hva_cache *ghc,
 	int r;
 	gpa_t gpa = ghc->gpa + offset;
 
-	BUG_ON(len + offset > ghc->len);
+	if (WARN_ON_ONCE(len + offset > ghc->len))
+		return -EINVAL;
 
 	if (slots->generation != ghc->generation) {
 		if (__kvm_gfn_to_hva_cache_init(slots, ghc, ghc->gpa, ghc->len))
-- 
2.33.0

