Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 82EDD35BFCA
	for <lists+stable@lfdr.de>; Mon, 12 Apr 2021 11:20:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239124AbhDLJG4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Apr 2021 05:06:56 -0400
Received: from mail.kernel.org ([198.145.29.99]:57432 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239993AbhDLJE0 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Apr 2021 05:04:26 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 95FEB61285;
        Mon, 12 Apr 2021 09:02:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1618218125;
        bh=dWSUi5Gfr9eYdzkPHZh9tRTFmME/SJI8qKg2Gp6MiDc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XDFF5skSY/ES62NWdk1KeSyYvDz7O55C8CexKW1jOF0J9hNE3YPRrOjZd7jvzk23j
         gQVIofAKSUc+hmr4n04jzJ/TFSqrrHNv8Ys/QtiEbYlYtb9aUpz1MylY5+V8NabJTg
         9QaZ/FGbyMuGdiFgoRN0kEXXKtbc5yBQZpLy/4Tg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Lorenz Bauer <lmb@cloudflare.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>
Subject: [PATCH 5.11 053/210] bpf: link: Refuse non-O_RDWR flags in BPF_OBJ_GET
Date:   Mon, 12 Apr 2021 10:39:18 +0200
Message-Id: <20210412084017.771117815@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210412084016.009884719@linuxfoundation.org>
References: <20210412084016.009884719@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Lorenz Bauer <lmb@cloudflare.com>

commit 25fc94b2f02d832fa8e29419699dcc20b0b05c6a upstream.

Invoking BPF_OBJ_GET on a pinned bpf_link checks the path access
permissions based on file_flags, but the returned fd ignores flags.
This means that any user can acquire a "read-write" fd for a pinned
link with mode 0664 by invoking BPF_OBJ_GET with BPF_F_RDONLY in
file_flags. The fd can be used to invoke BPF_LINK_DETACH, etc.

Fix this by refusing non-O_RDWR flags in BPF_OBJ_GET. This works
because OBJ_GET by default returns a read write mapping and libbpf
doesn't expose a way to override this behaviour for programs
and links.

Fixes: 70ed506c3bbc ("bpf: Introduce pinnable bpf_link abstraction")
Signed-off-by: Lorenz Bauer <lmb@cloudflare.com>
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Acked-by: Andrii Nakryiko <andrii@kernel.org>
Acked-by: Daniel Borkmann <daniel@iogearbox.net>
Link: https://lore.kernel.org/bpf/20210326160501.46234-1-lmb@cloudflare.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/bpf/inode.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/kernel/bpf/inode.c
+++ b/kernel/bpf/inode.c
@@ -546,7 +546,7 @@ int bpf_obj_get_user(const char __user *
 	else if (type == BPF_TYPE_MAP)
 		ret = bpf_map_new_fd(raw, f_flags);
 	else if (type == BPF_TYPE_LINK)
-		ret = bpf_link_new_fd(raw);
+		ret = (f_flags != O_RDWR) ? -EINVAL : bpf_link_new_fd(raw);
 	else
 		return -ENOENT;
 


