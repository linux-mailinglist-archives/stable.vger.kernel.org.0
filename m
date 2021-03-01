Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 58826328D8C
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 20:13:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241224AbhCATNG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 14:13:06 -0500
Received: from mail.kernel.org ([198.145.29.99]:39034 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241258AbhCATIx (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 14:08:53 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 858A36508D;
        Mon,  1 Mar 2021 17:35:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614620137;
        bh=6b2QrOX9/gzCzQU5EEARQydUnihWYReaU693DwVrVIA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GR0mKqLcEe4CtlH/k3GiA+X299pu6+i8I03mPiACeW+jsib7Ht2OPdWPj+4SfNzmJ
         lVKacNfllOSlKuHzwWiUi02Yr/E1Ysj2+oNmXT40aR3jQUiiNV4FygLYeMhPraJcag
         FazwqRBWSzFxGo4bbmO58Mlb3v9+2RhgYTTCV1aE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, kernel test robot <lkp@intel.com>,
        Andrii Nakryiko <andrii@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Yonghong Song <yhs@fb.com>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.11 044/775] bpf: Avoid warning when re-casting __bpf_call_base into __bpf_call_base_args
Date:   Mon,  1 Mar 2021 17:03:32 +0100
Message-Id: <20210301161203.901192270@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210301161201.679371205@linuxfoundation.org>
References: <20210301161201.679371205@linuxfoundation.org>
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
index 29c27656165b2..5edf2b6608812 100644
--- a/include/linux/filter.h
+++ b/include/linux/filter.h
@@ -886,7 +886,7 @@ void sk_filter_uncharge(struct sock *sk, struct sk_filter *fp);
 u64 __bpf_call_base(u64 r1, u64 r2, u64 r3, u64 r4, u64 r5);
 #define __bpf_call_base_args \
 	((u64 (*)(u64, u64, u64, u64, u64, const struct bpf_insn *)) \
-	 __bpf_call_base)
+	 (void *)__bpf_call_base)
 
 struct bpf_prog *bpf_int_jit_compile(struct bpf_prog *prog);
 void bpf_jit_compile(struct bpf_prog *prog);
-- 
2.27.0



