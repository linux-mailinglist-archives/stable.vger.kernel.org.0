Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 658D33C4E5E
	for <lists+stable@lfdr.de>; Mon, 12 Jul 2021 12:41:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244420AbhGLHSW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Jul 2021 03:18:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:54930 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S244038AbhGLHRV (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Jul 2021 03:17:21 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id BC94061166;
        Mon, 12 Jul 2021 07:14:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626074072;
        bh=ITf2kOBFrHtibITov2rWIXDp69ztjP1YPqNT9WUSwPU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=x49E+p6HlkKjo52N2rxN9zcqg+CwExodZoRkR3i+PuQhvE+cJwyL16h7seMLqRLPz
         n7TDKQpgZC/SuGEg4YS8pKm8tYllMKj+SeBGYG/bTP9Nz2qalOuuKVGT0kP0hmeByu
         btRuU78Sflg5Qbopftub/vEreoSm/g4WoH3YItOU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Maciej=20=C5=BBenczykowski?= <maze@google.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Lorenz Bauer <lmb@cloudflare.com>,
        Sasha Levin <sashal@kernel.org>,
        Greg Kroah-Hartman <gregkh@google.com>
Subject: [PATCH 5.12 456/700] bpf: Fix regression on BPF_OBJ_GET with non-O_RDWR flags
Date:   Mon, 12 Jul 2021 08:08:59 +0200
Message-Id: <20210712061025.074814049@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210712060924.797321836@linuxfoundation.org>
References: <20210712060924.797321836@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Maciej Żenczykowski <maze@google.com>

[ Upstream commit 5dec6d96d12d33900ec315972c8e47a73bcc378d ]

This reverts commit d37300ed1821 ("bpf: program: Refuse non-O_RDWR flags
in BPF_OBJ_GET"). It breaks Android userspace which expects to be able to
fetch programs with just read permissions.

See: https://cs.android.com/android/platform/superproject/+/master:frameworks/libs/net/common/native/bpf_syscall_wrappers/include/BpfSyscallWrappers.h;drc=7005c764be23d31fa1d69e826b4a2f6689a8c81e;l=124

Side-note: another option to fix it would be to extend bpf_prog_new_fd()
and to pass in used file mode flags in the same way as we do for maps via
bpf_map_new_fd(). Meaning, they'd end up in anon_inode_getfd() and thus
would be retained for prog fd operations with bpf() syscall. Right now
these flags are not checked with progs since they are immutable for their
lifetime (as opposed to maps which can be updated from user space). In
future this could potentially change with new features, but at that point
it's still fine to do the bpf_prog_new_fd() extension when needed. For a
simple stable fix, a revert is less churn.

Fixes: d37300ed1821 ("bpf: program: Refuse non-O_RDWR flags in BPF_OBJ_GET")
Signed-off-by: Maciej Żenczykowski <maze@google.com>
[ Daniel: added side-note to commit message ]
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Acked-by: Lorenz Bauer <lmb@cloudflare.com>
Acked-by: Greg Kroah-Hartman <gregkh@google.com>
Link: https://lore.kernel.org/bpf/20210618105526.265003-1-zenczykowski@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/bpf/inode.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/bpf/inode.c b/kernel/bpf/inode.c
index d2de2abec35b..dc56237d6960 100644
--- a/kernel/bpf/inode.c
+++ b/kernel/bpf/inode.c
@@ -543,7 +543,7 @@ int bpf_obj_get_user(const char __user *pathname, int flags)
 		return PTR_ERR(raw);
 
 	if (type == BPF_TYPE_PROG)
-		ret = (f_flags != O_RDWR) ? -EINVAL : bpf_prog_new_fd(raw);
+		ret = bpf_prog_new_fd(raw);
 	else if (type == BPF_TYPE_MAP)
 		ret = bpf_map_new_fd(raw, f_flags);
 	else if (type == BPF_TYPE_LINK)
-- 
2.30.2



