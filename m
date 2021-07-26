Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DBD463D615F
	for <lists+stable@lfdr.de>; Mon, 26 Jul 2021 18:13:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229646AbhGZPa4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Jul 2021 11:30:56 -0400
Received: from mail.kernel.org ([198.145.29.99]:43048 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237811AbhGZP3Y (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 26 Jul 2021 11:29:24 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A029561054;
        Mon, 26 Jul 2021 16:08:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1627315727;
        bh=94exHNgOFgx3+nFXZIit88/KnP+RZ+AIwgyEEvUIS5g=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=g5UOHFt86sJc95uZ/bxhu9k8W7yxd5FqUg+bo6aocctRqNho2iflFlfV0rC2FdQtw
         3o+uCY3w9Z7rchwHInmoVYly15hGFRUEvxySxNx1AyFNII2sr8qN62zVUSpuQ/S47o
         Urngnkt6ZABUJBANhMsiY+df2NqEgAL9A1++PO4I=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Like Xu <likexu@tencent.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.13 043/223] KVM: x86/pmu: Clear anythread deprecated bit when 0xa leaf is unsupported on the SVM
Date:   Mon, 26 Jul 2021 17:37:15 +0200
Message-Id: <20210726153847.665478110@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210726153846.245305071@linuxfoundation.org>
References: <20210726153846.245305071@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Like Xu <like.xu.linux@gmail.com>

[ Upstream commit 7234c362ccb3c2228f06f19f93b132de9cfa7ae4 ]

The AMD platform does not support the functions Ah CPUID leaf. The returned
results for this entry should all remain zero just like the native does:

AMD host:
   0x0000000a 0x00: eax=0x00000000 ebx=0x00000000 ecx=0x00000000 edx=0x00000000
(uncanny) AMD guest:
   0x0000000a 0x00: eax=0x00000000 ebx=0x00000000 ecx=0x00000000 edx=0x00008000

Fixes: cadbaa039b99 ("perf/x86/intel: Make anythread filter support conditional")
Signed-off-by: Like Xu <likexu@tencent.com>
Message-Id: <20210628074354.33848-1-likexu@tencent.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/kvm/cpuid.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
index ca7866d63e98..739be5da3bca 100644
--- a/arch/x86/kvm/cpuid.c
+++ b/arch/x86/kvm/cpuid.c
@@ -765,7 +765,8 @@ static inline int __do_cpuid_func(struct kvm_cpuid_array *array, u32 function)
 
 		edx.split.num_counters_fixed = min(cap.num_counters_fixed, MAX_FIXED_COUNTERS);
 		edx.split.bit_width_fixed = cap.bit_width_fixed;
-		edx.split.anythread_deprecated = 1;
+		if (cap.version)
+			edx.split.anythread_deprecated = 1;
 		edx.split.reserved1 = 0;
 		edx.split.reserved2 = 0;
 
-- 
2.30.2



