Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 185D129B88D
	for <lists+stable@lfdr.de>; Tue, 27 Oct 2020 17:09:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1799339AbgJ0Plm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Oct 2020 11:41:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:53500 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1800120AbgJ0PfF (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Oct 2020 11:35:05 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id ECD6D2225E;
        Tue, 27 Oct 2020 15:35:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603812904;
        bh=ZxkpQIgEWIQoiM8qTiWxMoB60zakyUYyXHGwt/vZj9E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qpDa3OK30pERBS8rHaWnJhx6It1eThE3sPsnDJrzd+7U0CgUfO33FYvoXjtp8pYGX
         JhTifNvK/oFGJafav7YKpoRhELGJVo+O+u11Vwivs6Fm4vuH9Gu0V+2WNTyMXsH4eO
         ZIpMI13wiSmwm+onPKKPxQnfpSxM4BHtBwVLm5i0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Andrii Nakryiko <andriin@fb.com>,
        =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.9 343/757] bpf: disallow attaching modify_return tracing functions to other BPF programs
Date:   Tue, 27 Oct 2020 14:49:53 +0100
Message-Id: <20201027135506.657819238@linuxfoundation.org>
X-Mailer: git-send-email 2.29.1
In-Reply-To: <20201027135450.497324313@linuxfoundation.org>
References: <20201027135450.497324313@linuxfoundation.org>
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
index fba52d9ec8fc4..5b9d2cf06fc6b 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -11046,6 +11046,11 @@ static int check_attach_btf_id(struct bpf_verifier_env *env)
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



