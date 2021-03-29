Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C475434CABA
	for <lists+stable@lfdr.de>; Mon, 29 Mar 2021 10:41:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234834AbhC2Ijo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Mar 2021 04:39:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:55206 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234565AbhC2Ign (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 29 Mar 2021 04:36:43 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 559EB61964;
        Mon, 29 Mar 2021 08:35:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1617006959;
        bh=f5Jd1I1YqHOtxAZ2CJiWWDMJ6igW5Nk4+P5kqtAdMQQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KWQt18RpujctYbGdWRd2iev6ImyuRTedG5f7F0pWZh3UoqQU0o0/NPl/FHE9Pipvn
         YWlICyLdUop/aJNrMub/0NjEJR7xAVxSC0vMRZ/WF65YbimeXiL/R1WRU8ptKLxK3n
         UlMkMWjjI0c+EJ5eG82/aZ42Pda1PuEI91qvHMRY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Namhyung Kim <namhyung@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.11 169/254] libbpf: Fix error path in bpf_object__elf_init()
Date:   Mon, 29 Mar 2021 09:58:05 +0200
Message-Id: <20210329075638.722281973@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210329075633.135869143@linuxfoundation.org>
References: <20210329075633.135869143@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Namhyung Kim <namhyung@kernel.org>

[ Upstream commit 8f3f5792f2940c16ab63c614b26494c8689c9c1e ]

When it failed to get section names, it should call into
bpf_object__elf_finish() like others.

Fixes: 88a82120282b ("libbpf: Factor out common ELF operations and improve logging")
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Link: https://lore.kernel.org/bpf/20210317145414.884817-1-namhyung@kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/lib/bpf/libbpf.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
index a0d4fc4de402..8913e5e7bedb 100644
--- a/tools/lib/bpf/libbpf.c
+++ b/tools/lib/bpf/libbpf.c
@@ -1180,7 +1180,8 @@ static int bpf_object__elf_init(struct bpf_object *obj)
 	if (!elf_rawdata(elf_getscn(obj->efile.elf, obj->efile.shstrndx), NULL)) {
 		pr_warn("elf: failed to get section names strings from %s: %s\n",
 			obj->path, elf_errmsg(-1));
-		return -LIBBPF_ERRNO__FORMAT;
+		err = -LIBBPF_ERRNO__FORMAT;
+		goto errout;
 	}
 
 	/* Old LLVM set e_machine to EM_NONE */
-- 
2.30.1



