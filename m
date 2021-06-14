Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 59F1C3A6282
	for <lists+stable@lfdr.de>; Mon, 14 Jun 2021 13:00:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233668AbhFNLBS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Jun 2021 07:01:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:36434 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234690AbhFNK6e (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 14 Jun 2021 06:58:34 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id EFB24613E9;
        Mon, 14 Jun 2021 10:41:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1623667315;
        bh=P2NiAcDDakW4b0/dW1SMWHEB1xRgaqQX6RaVY4jIeQ8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XtMGWPHNaMRCCrvoecwRqTvxOUf7EyPRnkTd1HzqO8k5+r+92B3n2FFzV9iJLLyJC
         W55bF18RMfwj71fBm4htJ8Tb9nIp83XUFM+bC8d1xGq6WTNPLb6d0+VfhmxFBk9iRE
         YRTLxoDGlgSqnuke7ji2BOHQoCUdqhVBkwPp/HvA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jiri Olsa <jolsa@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 006/131] bpf: Forbid trampoline attach for functions with variable arguments
Date:   Mon, 14 Jun 2021 12:26:07 +0200
Message-Id: <20210614102653.187278759@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210614102652.964395392@linuxfoundation.org>
References: <20210614102652.964395392@linuxfoundation.org>
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
index ed7d02e8bc93..aaf2fbaa0cc7 100644
--- a/kernel/bpf/btf.c
+++ b/kernel/bpf/btf.c
@@ -4960,6 +4960,12 @@ int btf_distill_func_proto(struct bpf_verifier_log *log,
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
@@ -4967,6 +4973,12 @@ int btf_distill_func_proto(struct bpf_verifier_log *log,
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



