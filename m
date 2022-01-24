Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6A72E4990C8
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 21:07:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1376884AbiAXUEV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 15:04:21 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:47026 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354144AbiAXUCU (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 15:02:20 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 00DD0B8119E;
        Mon, 24 Jan 2022 20:02:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 273ADC340E5;
        Mon, 24 Jan 2022 20:02:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643054537;
        bh=e21FpSYim1ygMkk92DWrzZG+FchegcpQRTza2xVC53M=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=vD5DOltpALMmFmalo5t2YDxcVjeGyDkpNyMy2SeN7ML2W5NxOWaldCZGs+QQ7zYEH
         HzGIdj8DX1Hw/0pCvLMPh7KdRvGaJTD2EcB+cIqpiCa2aWpKkMPhd8s9oMBaqG02kQ
         DttIORv1dxX+PQJnHaCSBSpNAyvatbexRrJ8S3Hk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Alexey Kardashevskiy <aik@ozlabs.ru>,
        Fabiano Rosas <farosas@linux.ibm.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 420/563] KVM: PPC: Book3S: Suppress failed alloc warning in H_COPY_TOFROM_GUEST
Date:   Mon, 24 Jan 2022 19:43:05 +0100
Message-Id: <20220124184038.983374046@linuxfoundation.org>
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
index a5f1ae892ba68..d0b6c8c16c48a 100644
--- a/arch/powerpc/kvm/book3s_hv_nested.c
+++ b/arch/powerpc/kvm/book3s_hv_nested.c
@@ -510,7 +510,7 @@ long kvmhv_copy_tofrom_guest_nested(struct kvm_vcpu *vcpu)
 	if (eaddr & (0xFFFUL << 52))
 		return H_PARAMETER;
 
-	buf = kzalloc(n, GFP_KERNEL);
+	buf = kzalloc(n, GFP_KERNEL | __GFP_NOWARN);
 	if (!buf)
 		return H_NO_MEM;
 
-- 
2.34.1



