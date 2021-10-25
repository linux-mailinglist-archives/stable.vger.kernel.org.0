Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ADADA439C35
	for <lists+stable@lfdr.de>; Mon, 25 Oct 2021 18:59:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234152AbhJYRCE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 25 Oct 2021 13:02:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:54340 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234151AbhJYRCE (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 25 Oct 2021 13:02:04 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1EA52603E7;
        Mon, 25 Oct 2021 16:59:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1635181182;
        bh=6H8hFO/A50Azi8V/YTYPHUkKtU198WHr2HkH2FB4dJ8=;
        h=From:To:Cc:Subject:Date:From;
        b=at0I9LQPIRsFknc8V8zeTsmdJgyDOGhJDI9zNar1FvwaeGdqCj3IqO/YDIJSSC/vl
         0gRmaWNKMYrpPBJZNoYPa2Ax5Do6k05X9JBlF8piOEh5GU+JPU5jYBzSk0iRBLIz4Q
         geG2t5wAKTVLaiKb5/BTuXg9V3tKJQczI0FwisCKC5r7z9Pd+qvfU4Nv9QzOrI/XGe
         BXm8YsDSPy697A/8E5PqnzH69iREzBXDBZBWJFpcemcU2rEtqhxWvO5awMapr86K/O
         NJOo4eRQN2uwsuU+vLWNQ9R9x7ZCrJRayjFWeK9UbH7iPdBxfRY2BDqOJYb5SpWxfX
         Tl+w+BaRTkxYQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Quentin Perret <qperret@google.com>, Will Deacon <will@kernel.org>,
        Marc Zyngier <maz@kernel.org>, Sasha Levin <sashal@kernel.org>,
        catalin.marinas@arm.com, linux-arm-kernel@lists.infradead.org,
        kvmarm@lists.cs.columbia.edu
Subject: [PATCH AUTOSEL 5.14 01/18] KVM: arm64: Report corrupted refcount at EL2
Date:   Mon, 25 Oct 2021 12:59:14 -0400
Message-Id: <20211025165939.1393655-1-sashal@kernel.org>
X-Mailer: git-send-email 2.33.0
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Quentin Perret <qperret@google.com>

[ Upstream commit 7615c2a514788559c6684234b8fc27f3a843c2c6 ]

Some of the refcount manipulation helpers used at EL2 are instrumented
to catch a corrupted state, but not all of them are treated equally. Let's
make things more consistent by instrumenting hyp_page_ref_dec_and_test()
as well.

Acked-by: Will Deacon <will@kernel.org>
Suggested-by: Will Deacon <will@kernel.org>
Signed-off-by: Quentin Perret <qperret@google.com>
Signed-off-by: Marc Zyngier <maz@kernel.org>
Link: https://lore.kernel.org/r/20211005090155.734578-6-qperret@google.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/kvm/hyp/nvhe/page_alloc.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/arm64/kvm/hyp/nvhe/page_alloc.c b/arch/arm64/kvm/hyp/nvhe/page_alloc.c
index 41fc25bdfb34..da2d3c0bfb7f 100644
--- a/arch/arm64/kvm/hyp/nvhe/page_alloc.c
+++ b/arch/arm64/kvm/hyp/nvhe/page_alloc.c
@@ -152,6 +152,7 @@ static inline void hyp_page_ref_inc(struct hyp_page *p)
 
 static inline int hyp_page_ref_dec_and_test(struct hyp_page *p)
 {
+	BUG_ON(!p->refcount);
 	p->refcount--;
 	return (p->refcount == 0);
 }
-- 
2.33.0

