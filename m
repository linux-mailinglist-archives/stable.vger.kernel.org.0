Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CB2233643E2
	for <lists+stable@lfdr.de>; Mon, 19 Apr 2021 15:32:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239791AbhDSNW5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Apr 2021 09:22:57 -0400
Received: from mail.kernel.org ([198.145.29.99]:56310 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241525AbhDSNUv (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 19 Apr 2021 09:20:51 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C19C7613F6;
        Mon, 19 Apr 2021 13:17:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1618838234;
        bh=mSWW58JyVorAzLFuHZfKOcHAom1nBHNhedAniIa80eY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=xoYaURQtcmdZOFVAE1JiVOb8bbKSATq1S/RkeCiYqfXGcWwXXrLV2nvj/vfaE6Igz
         VVCD80RaEebnnM4qLvrOds1c2NEeHQiOUdEN0W2k+/X+NRN/pvy3xvGNJak5MOKPKJ
         REpQDn8tsjnJqLxL+H19evg/LnuhnC5MMb9mbYoY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Daniel Borkmann <daniel@iogearbox.net>,
        John Fastabend <john.fastabend@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 092/103] bpf: Use correct permission flag for mixed signed bounds arithmetic
Date:   Mon, 19 Apr 2021 15:06:43 +0200
Message-Id: <20210419130530.956055833@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210419130527.791982064@linuxfoundation.org>
References: <20210419130527.791982064@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Daniel Borkmann <daniel@iogearbox.net>

[ Upstream commit 9601148392520e2e134936e76788fc2a6371e7be ]

We forbid adding unknown scalars with mixed signed bounds due to the
spectre v1 masking mitigation. Hence this also needs bypass_spec_v1
flag instead of allow_ptr_leaks.

Fixes: 2c78ee898d8f ("bpf: Implement CAP_BPF")
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Reviewed-by: John Fastabend <john.fastabend@gmail.com>
Acked-by: Alexei Starovoitov <ast@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/bpf/verifier.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
index 12cd2997f982..2eaefd9c4152 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -5522,7 +5522,7 @@ static int adjust_ptr_min_max_vals(struct bpf_verifier_env *env,
 			dst, reg_type_str[ptr_reg->type]);
 		return -EACCES;
 	case PTR_TO_MAP_VALUE:
-		if (!env->allow_ptr_leaks && !known && (smin_val < 0) != (smax_val < 0)) {
+		if (!env->env->bypass_spec_v1 && !known && (smin_val < 0) != (smax_val < 0)) {
 			verbose(env, "R%d has unknown scalar with mixed signed bounds, pointer arithmetic with it prohibited for !root\n",
 				off_reg == dst_reg ? dst : src);
 			return -EACCES;
-- 
2.30.2



