Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F133A451060
	for <lists+stable@lfdr.de>; Mon, 15 Nov 2021 19:44:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242877AbhKOSrG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 13:47:06 -0500
Received: from mail.kernel.org ([198.145.29.99]:50338 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S242371AbhKOSof (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 13:44:35 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id DEC546336F;
        Mon, 15 Nov 2021 18:06:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1636999561;
        bh=kgmBzZi3GvPr3hxk+l+cBnuFj4r5v0Lk6/AZWmY4MAE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=J4LOMvR8IYnPcnAsj8Rp9zSWupKf9SxKg8HuDlxfLq3G7YpiBsMG21zGARB/vhMLh
         ieKLQwOu3/3zGjdh9vxro9lPAfIYNEI+fPNvJOST44tpNg2T6Ue6i76r5B25by6txd
         Xx/6QiEvXKftABnE9RYWrx72s7irq36B6tnKLnpU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
        Andrii Nakryiko <andrii@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.14 342/849] libbpf: Dont crash on object files with no symbol tables
Date:   Mon, 15 Nov 2021 17:57:05 +0100
Message-Id: <20211115165431.805972041@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211115165419.961798833@linuxfoundation.org>
References: <20211115165419.961798833@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Toke Høiland-Jørgensen <toke@redhat.com>

[ Upstream commit 03e601f48b2da6fb44d0f7b86957a8f6bacfb347 ]

If libbpf encounters an ELF file that has been stripped of its symbol
table, it will crash in bpf_object__add_programs() when trying to
dereference the obj->efile.symbols pointer.

Fix this by erroring out of bpf_object__elf_collect() if it is not able
able to find the symbol table.

v2:
  - Move check into bpf_object__elf_collect() and add nice error message

Fixes: 6245947c1b3c ("libbpf: Allow gaps in BPF program sections to support overriden weak functions")
Signed-off-by: Toke Høiland-Jørgensen <toke@redhat.com>
Signed-off-by: Andrii Nakryiko <andrii@kernel.org>
Link: https://lore.kernel.org/bpf/20210901114812.204720-1-toke@redhat.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/lib/bpf/libbpf.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
index f1bc09e606cd1..994266b565c1a 100644
--- a/tools/lib/bpf/libbpf.c
+++ b/tools/lib/bpf/libbpf.c
@@ -2990,6 +2990,12 @@ static int bpf_object__elf_collect(struct bpf_object *obj)
 		}
 	}
 
+	if (!obj->efile.symbols) {
+		pr_warn("elf: couldn't find symbol table in %s, stripped object file?\n",
+			obj->path);
+		return -ENOENT;
+	}
+
 	scn = NULL;
 	while ((scn = elf_nextscn(elf, scn)) != NULL) {
 		idx++;
-- 
2.33.0



