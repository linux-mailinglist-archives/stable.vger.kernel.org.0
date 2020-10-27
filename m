Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 483F429BF52
	for <lists+stable@lfdr.de>; Tue, 27 Oct 2020 18:07:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1793659AbgJ0PHl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Oct 2020 11:07:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:36454 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1789443AbgJ0PCR (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Oct 2020 11:02:17 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 30B4C22264;
        Tue, 27 Oct 2020 15:02:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603810936;
        bh=a+59OxeN9xs6Fxpc/rKpyBqirWjAQKAuC7Piklj+mMI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=y10WjN/QJc9CKkST7qkp99GnZdWKFFd5Eel81m/j7vclHas2ZxzoXJ+g6wJpI/XNv
         0WVdzvmV2lb7gtjqko0/hBs3iCW3Oid41Tz6jfu8K9SBMtQ372aHEsWrx1c9xw79WC
         hor601pvNS1hpgE061noyzXYAAQsaUUvTQuqWk90=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Andrii Nakryiko <andriin@fb.com>,
        =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.8 285/633] bpf: disallow attaching modify_return tracing functions to other BPF programs
Date:   Tue, 27 Oct 2020 14:50:28 +0100
Message-Id: <20201027135536.051765016@linuxfoundation.org>
X-Mailer: git-send-email 2.29.1
In-Reply-To: <20201027135522.655719020@linuxfoundation.org>
References: <20201027135522.655719020@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Toke Høiland-Jørgensen <toke@redhat.com>

[ Upstream commit 1af9270e908cd50a4f5d815c9b6f794c7d57ed07 ]

>From the checks and commit messages for modify_return, it seems it was
never the intention that it should be possible to attach a tracing program
with expected_attach_type == BPF_MODIFY_RETURN to another BPF program.
However, check_attach_modify_return() will only look at the function name,
so if the target function starts with "security_", the attach will be
allowed even for bpf2bpf attachment.

Fix this oversight by also blocking the modification if a target program is
supplied.

Fixes: 18644cec714a ("bpf: Fix use-after-free in fmod_ret check")
Fixes: 6ba43b761c41 ("bpf: Attachment verification for BPF_MODIFY_RETURN")
Acked-by: Andrii Nakryiko <andriin@fb.com>
Signed-off-by: Toke Høiland-Jørgensen <toke@redhat.com>
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/bpf/verifier.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
index 89b07db146763..c953dfbbaa6a9 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -10862,6 +10862,11 @@ static int check_attach_btf_id(struct bpf_verifier_env *env)
 		}
 
 		if (prog->expected_attach_type == BPF_MODIFY_RETURN) {
+			if (tgt_prog) {
+				verbose(env, "can't modify return codes of BPF programs\n");
+				ret = -EINVAL;
+				goto out;
+			}
 			ret = check_attach_modify_return(prog, addr);
 			if (ret)
 				verbose(env, "%s() is not modifiable\n",
-- 
2.25.1



