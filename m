Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 30D7F47ADB2
	for <lists+stable@lfdr.de>; Mon, 20 Dec 2021 15:55:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236844AbhLTOyB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Dec 2021 09:54:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34368 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237180AbhLTOv7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Dec 2021 09:51:59 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 83EC7C08EAF9;
        Mon, 20 Dec 2021 06:46:57 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 21FF4611BF;
        Mon, 20 Dec 2021 14:46:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0719DC36AE7;
        Mon, 20 Dec 2021 14:46:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1640011616;
        bh=CYVJQkz8G2L85MLOQlmPwd9eag/MhqdmKIgcPUeLlLY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KqvHGL39qjEGaVwNp39dAbTlt4NeQy7vFTeCYEq+kHgFarWSXsoEF51p2gzNaaPyj
         KkgIFe2IosdmPt05lEmumr+88rmRpRGFfezYJYnAtOnv4LKb0Dc1d6R2wotUCCcj99
         r84ahC+YFLBAeR4PIrztAM3GFUGXv0puvmuHFrNw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 02/99] KVM: downgrade two BUG_ONs to WARN_ON_ONCE
Date:   Mon, 20 Dec 2021 15:33:35 +0100
Message-Id: <20211220143029.436400411@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211220143029.352940568@linuxfoundation.org>
References: <20211220143029.352940568@linuxfoundation.org>
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



