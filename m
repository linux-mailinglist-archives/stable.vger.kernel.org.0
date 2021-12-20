Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9D58047ADEA
	for <lists+stable@lfdr.de>; Mon, 20 Dec 2021 15:59:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239593AbhLTO4k (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Dec 2021 09:56:40 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:42192 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237613AbhLTOwo (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Dec 2021 09:52:44 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2E3E7611CD;
        Mon, 20 Dec 2021 14:52:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0E036C36AF7;
        Mon, 20 Dec 2021 14:52:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1640011963;
        bh=Emm6T7pwA/+Z6G0W9UiEMZ7qT/ArAlPegWjRyye7VzU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Zi9hi/21Q/5uXYtzLytFpwcXN+ioa2D73JCDfsEm/7cvr1A2zw5NohzV/ZNG/rw7G
         PMD3wUPWZa9D7CmtGDRURssEfZIuhT1vvwm29fMRSCeG/2BLZ0qv6yzCRJKyNVBRMO
         Yv1yCjPhh9UzeVy81+0ZDdrDvjDT97+mkJJRxqcs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 004/177] KVM: downgrade two BUG_ONs to WARN_ON_ONCE
Date:   Mon, 20 Dec 2021 15:32:34 +0100
Message-Id: <20211220143040.208415536@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211220143040.058287525@linuxfoundation.org>
References: <20211220143040.058287525@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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



