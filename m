Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1BCB83A6366
	for <lists+stable@lfdr.de>; Mon, 14 Jun 2021 13:11:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234905AbhFNLMT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Jun 2021 07:12:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:42876 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235678AbhFNLLG (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 14 Jun 2021 07:11:06 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 615E861950;
        Mon, 14 Jun 2021 10:47:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1623667669;
        bh=27kYeqCQHC+7oB//+3h8Rl8uVvRD+9U76fLMbkQRlsM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=h0zP0yORCVaAL5XZhOIq2B7GavHfFUbqwKtvNfFEchAsVZBGzCf2IiSbgps7M+GzJ
         C4j4JuIRKCuloTQJ+OCrjRLrPPE2ReJXhjAZsEMtOSzQAq6fKj6LZPVfok02vUtulK
         52ycx6GOg/Pag+BIv0SFC2F7R1rnr9FYCPvv11Q4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jiri Olsa <jolsa@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.12 006/173] bpf: Forbid trampoline attach for functions with variable arguments
Date:   Mon, 14 Jun 2021 12:25:38 +0200
Message-Id: <20210614102658.369519771@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210614102658.137943264@linuxfoundation.org>
References: <20210614102658.137943264@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jiri Olsa <jolsa@kernel.org>

[ Upstream commit 31379397dcc364a59ce764fabb131b645c43e340 ]

We can't currently allow to attach functions with variable arguments.
The problem is that we should save all the registers for arguments,
which is probably doable, but if caller uses more than 6 arguments,
we need stack data, which will be wrong, because of the extra stack
frame we do in bpf trampoline, so we could crash.

Also currently there's malformed trampoline code generated for such
functions at the moment as described in:

  https://lore.kernel.org/bpf/20210429212834.82621-1-jolsa@kernel.org/

Signed-off-by: Jiri Olsa <jolsa@kernel.org>
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Acked-by: Andrii Nakryiko <andrii@kernel.org>
Link: https://lore.kernel.org/bpf/20210505132529.401047-1-jolsa@kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/bpf/btf.c | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/kernel/bpf/btf.c b/kernel/bpf/btf.c
index b1a76fe046cb..6bd003568fa5 100644
--- a/kernel/bpf/btf.c
+++ b/kernel/bpf/btf.c
@@ -5126,6 +5126,12 @@ int btf_distill_func_proto(struct bpf_verifier_log *log,
 	m->ret_size = ret;
 
 	for (i = 0; i < nargs; i++) {
+		if (i == nargs - 1 && args[i].type == 0) {
+			bpf_log(log,
+				"The function %s with variable args is unsupported.\n",
+				tname);
+			return -EINVAL;
+		}
 		ret = __get_type_size(btf, args[i].type, &t);
 		if (ret < 0) {
 			bpf_log(log,
@@ -5133,6 +5139,12 @@ int btf_distill_func_proto(struct bpf_verifier_log *log,
 				tname, i, btf_kind_str[BTF_INFO_KIND(t->info)]);
 			return -EINVAL;
 		}
+		if (ret == 0) {
+			bpf_log(log,
+				"The function %s has malformed void argument.\n",
+				tname);
+			return -EINVAL;
+		}
 		m->arg_size[i] = ret;
 	}
 	m->nr_args = nargs;
-- 
2.30.2



