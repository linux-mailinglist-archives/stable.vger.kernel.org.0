Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7DA4C490D7D
	for <lists+stable@lfdr.de>; Mon, 17 Jan 2022 18:03:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242019AbiAQRDl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Jan 2022 12:03:41 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:51812 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242021AbiAQRCB (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 17 Jan 2022 12:02:01 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id EFCFA6119C;
        Mon, 17 Jan 2022 17:02:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5B29EC36AE3;
        Mon, 17 Jan 2022 17:01:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1642438920;
        bh=e9qHwmWQeW+I8N/3hk78hKYr7tPj2scOY6Gr/oCbo4I=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dXPzrl2fsmiwZeU4YLn8F6rF9I2f/Djey4zEzYgYU+N19q9bFiMb0QXRly8C0SDOF
         F0V+uwVPTSNtDIpCF0/HnOLh8qvXfSkCqc/HQxM7wKTKkNF/NgkpyW/NNt55pAxVJC
         clzAkBOl0glMrDPsa81WwSsTxbvQ+NWTU9JKJZoaiCADw0PSYnYIZAuIz2/0O8bpoa
         pTUof3qksIhfKgtEk3Ucd+wL6e56q2UvJLdEVQ/ya/ljrW3NNORbvUTvZ4kywTAS6w
         hOb4hnE062wOu/pNenQtvHIUwxk1/ejKF6je5b81/svWSYZKHbd1aW38O7ekgrf0sW
         OMQjddDFm41Mw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Alexey Kardashevskiy <aik@ozlabs.ru>,
        Fabiano Rosas <farosas@linux.ibm.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Sasha Levin <sashal@kernel.org>, npiggin@gmail.com,
        paulus@ozlabs.org, ravi.bangoria@linux.ibm.com,
        bharata@linux.ibm.com, linuxppc-dev@lists.ozlabs.org
Subject: [PATCH AUTOSEL 5.15 14/44] KVM: PPC: Book3S: Suppress failed alloc warning in H_COPY_TOFROM_GUEST
Date:   Mon, 17 Jan 2022 12:00:57 -0500
Message-Id: <20220117170127.1471115-14-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220117170127.1471115-1-sashal@kernel.org>
References: <20220117170127.1471115-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Alexey Kardashevskiy <aik@ozlabs.ru>

[ Upstream commit 792020907b11c6f9246c21977cab3bad985ae4b6 ]

H_COPY_TOFROM_GUEST is an hcall for an upper level VM to access its nested
VMs memory. The userspace can trigger WARN_ON_ONCE(!(gfp & __GFP_NOWARN))
in __alloc_pages() by constructing a tiny VM which only does
H_COPY_TOFROM_GUEST with a too big GPR9 (number of bytes to copy).

This silences the warning by adding __GFP_NOWARN.

Spotted by syzkaller.

Signed-off-by: Alexey Kardashevskiy <aik@ozlabs.ru>
Reviewed-by: Fabiano Rosas <farosas@linux.ibm.com>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://lore.kernel.org/r/20210901084550.1658699-1-aik@ozlabs.ru
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/powerpc/kvm/book3s_hv_nested.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/powerpc/kvm/book3s_hv_nested.c b/arch/powerpc/kvm/book3s_hv_nested.c
index ed8a2c9f56299..89295b52a97c3 100644
--- a/arch/powerpc/kvm/book3s_hv_nested.c
+++ b/arch/powerpc/kvm/book3s_hv_nested.c
@@ -582,7 +582,7 @@ long kvmhv_copy_tofrom_guest_nested(struct kvm_vcpu *vcpu)
 	if (eaddr & (0xFFFUL << 52))
 		return H_PARAMETER;
 
-	buf = kzalloc(n, GFP_KERNEL);
+	buf = kzalloc(n, GFP_KERNEL | __GFP_NOWARN);
 	if (!buf)
 		return H_NO_MEM;
 
-- 
2.34.1

