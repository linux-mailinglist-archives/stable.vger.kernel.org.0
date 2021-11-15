Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7A2CB451387
	for <lists+stable@lfdr.de>; Mon, 15 Nov 2021 20:52:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348329AbhKOTwM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 14:52:12 -0500
Received: from mail.kernel.org ([198.145.29.99]:44642 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1343637AbhKOTVc (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 14:21:32 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 469EE63361;
        Mon, 15 Nov 2021 18:43:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637001812;
        bh=Q5zjcowLXCgqtp8SfhHkbhKdn/gk/gQrke78Df4ajHM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cxAwFqlXzl6UIEpPHQ0EtjuPC+uHeNd5wtD+fT0VXk9bNNz3OL1L68wYZB6mrV7Ea
         Vy5iO3iUSmD/RyVymPL1g+xmmvkulTi93WBEBUK4MsoPxXE81OUZ7LJ0eXnOIeAZse
         jzlrMFammWjQ+xgIhJMTG8WG+7Oe629eXkWGE1Fg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
        Andrii Nakryiko <andrii@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 330/917] libbpf: Dont crash on object files with no symbol tables
Date:   Mon, 15 Nov 2021 17:57:05 +0100
Message-Id: <20211115165439.948895580@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211115165428.722074685@linuxfoundation.org>
References: <20211115165428.722074685@linuxfoundation.org>
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
index e4f83c304ec92..51180f300d2e1 100644
--- a/tools/lib/bpf/libbpf.c
+++ b/tools/lib/bpf/libbpf.c
@@ -2993,6 +2993,12 @@ static int bpf_object__elf_collect(struct bpf_object *obj)
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



