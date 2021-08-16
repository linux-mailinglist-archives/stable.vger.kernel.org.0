Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 18AFD3ED68B
	for <lists+stable@lfdr.de>; Mon, 16 Aug 2021 15:23:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236669AbhHPNWB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Aug 2021 09:22:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:43336 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239145AbhHPNSq (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 16 Aug 2021 09:18:46 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A73226323B;
        Mon, 16 Aug 2021 13:14:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1629119668;
        bh=91cMfIzDPzFLBPH9m4BAoqY/R69kSyAYdxpOmr0aVr4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Wf58Mwn6j+cG6p0KS42clVIwhxeknJ85ZHBg/SqA5FIoDvStI3pZoUA0S8QVjoJM8
         KM7Lm3AiwpmFmEOdrEddBclLBrae6UyRz8skdkizBkR8UGhiVaYcoJSJg7evgIipfp
         c5YXj7Nl1OL41udbjz5seBU9f2K5dZEN2qlctDvQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Quentin Perret <qperret@google.com>,
        David Brazdil <dbrazdil@google.com>,
        Marc Zyngier <maz@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.13 115/151] KVM: arm64: Fix off-by-one in range_is_memory
Date:   Mon, 16 Aug 2021 15:02:25 +0200
Message-Id: <20210816125447.850735164@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210816125444.082226187@linuxfoundation.org>
References: <20210816125444.082226187@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: David Brazdil <dbrazdil@google.com>

[ Upstream commit facee1be7689f8cf573b9ffee6a5c28ee193615e ]

Hyp checks whether an address range only covers RAM by checking the
start/endpoints against a list of memblock_region structs. However,
the endpoint here is exclusive but internally is treated as inclusive.
Fix the off-by-one error that caused valid address ranges to be
rejected.

Cc: Quentin Perret <qperret@google.com>
Fixes: 90134ac9cabb6 ("KVM: arm64: Protect the .hyp sections from the host")
Signed-off-by: David Brazdil <dbrazdil@google.com>
Signed-off-by: Marc Zyngier <maz@kernel.org>
Link: https://lore.kernel.org/r/20210728153232.1018911-2-dbrazdil@google.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/kvm/hyp/nvhe/mem_protect.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/kvm/hyp/nvhe/mem_protect.c b/arch/arm64/kvm/hyp/nvhe/mem_protect.c
index 4b60c0056c04..fa1b77fe629d 100644
--- a/arch/arm64/kvm/hyp/nvhe/mem_protect.c
+++ b/arch/arm64/kvm/hyp/nvhe/mem_protect.c
@@ -190,7 +190,7 @@ static bool range_is_memory(u64 start, u64 end)
 {
 	struct kvm_mem_range r1, r2;
 
-	if (!find_mem_range(start, &r1) || !find_mem_range(end, &r2))
+	if (!find_mem_range(start, &r1) || !find_mem_range(end - 1, &r2))
 		return false;
 	if (r1.start != r2.start)
 		return false;
-- 
2.30.2



