Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 234B61675EA
	for <lists+stable@lfdr.de>; Fri, 21 Feb 2020 09:32:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731756AbgBUIcA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 21 Feb 2020 03:32:00 -0500
Received: from mail.kernel.org ([198.145.29.99]:49410 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730362AbgBUINU (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 21 Feb 2020 03:13:20 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9DF9520578;
        Fri, 21 Feb 2020 08:13:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1582272800;
        bh=1xCCUDJRyOV29jDvyw2qulGXTvVC0OZvGv+a2Mz9d4o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qB9r8viDJcZNhIfYzU2isHTWu+t6+naQ6eyRsyh6OR1Vb961Xf3KDGQzFiBfZUkIw
         VovJa0mCjQuto18NBjdTFtNblRYMYEC2LRpP09nttcRZmaAXHnVuXgrHJpVzUHrIDK
         oC5XiXC1G6Kb+gWf8tSayJA+AIIVt2jeXvFsRhXA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Chris Down <chris@chrisdown.name>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andriin@fb.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 279/344] bpf, btf: Always output invariant hit in pahole DWARF to BTF transform
Date:   Fri, 21 Feb 2020 08:41:18 +0100
Message-Id: <20200221072415.109588769@linuxfoundation.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200221072349.335551332@linuxfoundation.org>
References: <20200221072349.335551332@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Chris Down <chris@chrisdown.name>

[ Upstream commit 2a67a6ccb01f21b854715d86ff6432a18b97adb3 ]

When trying to compile with CONFIG_DEBUG_INFO_BTF enabled, I got this
error:

    % make -s
    Failed to generate BTF for vmlinux
    Try to disable CONFIG_DEBUG_INFO_BTF
    make[3]: *** [vmlinux] Error 1

Compiling again without -s shows the true error (that pahole is
missing), but since this is fatal, we should show the error
unconditionally on stderr as well, not silence it using the `info`
function. With this patch:

    % make -s
    BTF: .tmp_vmlinux.btf: pahole (pahole) is not available
    Failed to generate BTF for vmlinux
    Try to disable CONFIG_DEBUG_INFO_BTF
    make[3]: *** [vmlinux] Error 1

Signed-off-by: Chris Down <chris@chrisdown.name>
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Acked-by: Andrii Nakryiko <andriin@fb.com>
Link: https://lore.kernel.org/bpf/20200122000110.GA310073@chrisdown.name
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 scripts/link-vmlinux.sh | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/scripts/link-vmlinux.sh b/scripts/link-vmlinux.sh
index 4363799403561..408b5c0b99b1b 100755
--- a/scripts/link-vmlinux.sh
+++ b/scripts/link-vmlinux.sh
@@ -108,13 +108,13 @@ gen_btf()
 	local bin_arch
 
 	if ! [ -x "$(command -v ${PAHOLE})" ]; then
-		info "BTF" "${1}: pahole (${PAHOLE}) is not available"
+		echo >&2 "BTF: ${1}: pahole (${PAHOLE}) is not available"
 		return 1
 	fi
 
 	pahole_ver=$(${PAHOLE} --version | sed -E 's/v([0-9]+)\.([0-9]+)/\1\2/')
 	if [ "${pahole_ver}" -lt "113" ]; then
-		info "BTF" "${1}: pahole version $(${PAHOLE} --version) is too old, need at least v1.13"
+		echo >&2 "BTF: ${1}: pahole version $(${PAHOLE} --version) is too old, need at least v1.13"
 		return 1
 	fi
 
-- 
2.20.1



