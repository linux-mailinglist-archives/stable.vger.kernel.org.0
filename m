Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A6714450F0B
	for <lists+stable@lfdr.de>; Mon, 15 Nov 2021 19:23:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238967AbhKOSZp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 13:25:45 -0500
Received: from mail.kernel.org ([198.145.29.99]:33236 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238731AbhKOSVY (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 13:21:24 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id EDD456340F;
        Mon, 15 Nov 2021 17:52:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1636998773;
        bh=e+FjDHHEFmEezDd3d+IF3IkWDZDhHBLlzcd3hMULkjA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Im9CYH0LT1c7EGIKT+Eeo8iB84Uqf/BtSnh2+FJtbvmRBw964amzcedx//vb7eeEU
         P2LZQcANh1G4TMJ50i5sDV0LWVj4eI+UcK0MeQp959vIMfpbEqTUFte2pMuG3AciTq
         VmgjDPGr74AlZXpZOg+hqNhrfURpvRFXGWCFhv0I=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Will Deacon <will@kernel.org>,
        Quentin Perret <qperret@google.com>,
        Marc Zyngier <maz@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.14 056/849] KVM: arm64: Report corrupted refcount at EL2
Date:   Mon, 15 Nov 2021 17:52:19 +0100
Message-Id: <20211115165421.917175490@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211115165419.961798833@linuxfoundation.org>
References: <20211115165419.961798833@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
index a6e874e61a40e..0bd7701ad1df5 100644
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



