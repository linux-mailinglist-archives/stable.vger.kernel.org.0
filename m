Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CB04049A998
	for <lists+stable@lfdr.de>; Tue, 25 Jan 2022 05:26:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350745AbiAYDYR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 22:24:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46612 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1444559AbiAXVBI (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 16:01:08 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9553CC055A84;
        Mon, 24 Jan 2022 12:02:15 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 35D076130D;
        Mon, 24 Jan 2022 20:02:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 15E25C340E5;
        Mon, 24 Jan 2022 20:02:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643054534;
        bh=LxtqiCU/HnTQBi7Y6RaZ5mzfJ2enE8ac2ayAJ6KDquo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MiJRrYFzm/cSjxF+/wzmcWYO+AbWlh8A3aSmUQx/ANk837ZrX2SaxXwLQhFfb1HOC
         1dgc8nL/ZGzupU8ru+akJw40jabh5duKirQVMkkSpO4zwGCTLbpNrU3/Gst7bOgCTF
         xlTW7ereVAXFoR8l8FO5yxWG8zoIsPgKgrVRDShw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Alexey Kardashevskiy <aik@ozlabs.ru>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 419/563] KVM: PPC: Book3S: Suppress warnings when allocating too big memory slots
Date:   Mon, 24 Jan 2022 19:43:04 +0100
Message-Id: <20220124184038.943871029@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124184024.407936072@linuxfoundation.org>
References: <20220124184024.407936072@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Alexey Kardashevskiy <aik@ozlabs.ru>

[ Upstream commit 511d25d6b789fffcb20a3eb71899cf974a31bd9d ]

The userspace can trigger "vmalloc size %lu allocation failure: exceeds
total pages" via the KVM_SET_USER_MEMORY_REGION ioctl.

This silences the warning by checking the limit before calling vzalloc()
and returns ENOMEM if failed.

This does not call underlying valloc helpers as __vmalloc_node() is only
exported when CONFIG_TEST_VMALLOC_MODULE and __vmalloc_node_range() is
not exported at all.

Spotted by syzkaller.

Signed-off-by: Alexey Kardashevskiy <aik@ozlabs.ru>
[mpe: Use 'size' for the variable rather than 'cb']
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://lore.kernel.org/r/20210901084512.1658628-1-aik@ozlabs.ru
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/powerpc/kvm/book3s_hv.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/arch/powerpc/kvm/book3s_hv.c b/arch/powerpc/kvm/book3s_hv.c
index 175967a195c44..527c205d5a5f5 100644
--- a/arch/powerpc/kvm/book3s_hv.c
+++ b/arch/powerpc/kvm/book3s_hv.c
@@ -4557,8 +4557,12 @@ static int kvmppc_core_prepare_memory_region_hv(struct kvm *kvm,
 	unsigned long npages = mem->memory_size >> PAGE_SHIFT;
 
 	if (change == KVM_MR_CREATE) {
-		slot->arch.rmap = vzalloc(array_size(npages,
-					  sizeof(*slot->arch.rmap)));
+		unsigned long size = array_size(npages, sizeof(*slot->arch.rmap));
+
+		if ((size >> PAGE_SHIFT) > totalram_pages())
+			return -ENOMEM;
+
+		slot->arch.rmap = vzalloc(size);
 		if (!slot->arch.rmap)
 			return -ENOMEM;
 	}
-- 
2.34.1



