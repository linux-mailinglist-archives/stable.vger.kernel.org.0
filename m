Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AC820328626
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 18:05:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232973AbhCARFG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 12:05:06 -0500
Received: from mail.kernel.org ([198.145.29.99]:59374 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236658AbhCAQ6a (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 11:58:30 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 000DA64FDB;
        Mon,  1 Mar 2021 16:36:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614616611;
        bh=GDGJ3g4Scd+bDKAlv7eaA97XD7KuACxjL/H4cfk6TYc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jIGaKuz/q5AJVmzV2UO0Hhs0HvtTAPVb28m4e3nTpuc7P+DMsLmTAhlNyk4h1Zqix
         jR2+GYgATaSOGeMOI2c0Om24FWNxZ6uoF49nvUiLP8nYFtoUOWk/pSDAMvEVUEHcUM
         XIqZ6KN6MVHsIOIlLT3VYlMJe5CntAyiaOcDtsos=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, kernel test robot <lkp@intel.com>,
        Andrii Nakryiko <andrii@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Yonghong Song <yhs@fb.com>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 035/247] bpf: Avoid warning when re-casting __bpf_call_base into __bpf_call_base_args
Date:   Mon,  1 Mar 2021 17:10:55 +0100
Message-Id: <20210301161033.401793295@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210301161031.684018251@linuxfoundation.org>
References: <20210301161031.684018251@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Andrii Nakryiko <andrii@kernel.org>

[ Upstream commit 6943c2b05bf09fd5c5729f7d7d803bf3f126cb9a ]

BPF interpreter uses extra input argument, so re-casts __bpf_call_base into
__bpf_call_base_args. Avoid compiler warning about incompatible function
prototypes by casting to void * first.

Fixes: 1ea47e01ad6e ("bpf: add support for bpf_call to interpreter")
Reported-by: kernel test robot <lkp@intel.com>
Signed-off-by: Andrii Nakryiko <andrii@kernel.org>
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Acked-by: Yonghong Song <yhs@fb.com>
Link: https://lore.kernel.org/bpf/20210112075520.4103414-3-andrii@kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/filter.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/linux/filter.h b/include/linux/filter.h
index d61dc72ebb960..117f9380069a8 100644
--- a/include/linux/filter.h
+++ b/include/linux/filter.h
@@ -746,7 +746,7 @@ void sk_filter_uncharge(struct sock *sk, struct sk_filter *fp);
 u64 __bpf_call_base(u64 r1, u64 r2, u64 r3, u64 r4, u64 r5);
 #define __bpf_call_base_args \
 	((u64 (*)(u64, u64, u64, u64, u64, const struct bpf_insn *)) \
-	 __bpf_call_base)
+	 (void *)__bpf_call_base)
 
 struct bpf_prog *bpf_int_jit_compile(struct bpf_prog *prog);
 void bpf_jit_compile(struct bpf_prog *prog);
-- 
2.27.0



