Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 292FC3C5407
	for <lists+stable@lfdr.de>; Mon, 12 Jul 2021 12:52:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349427AbhGLH4p (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Jul 2021 03:56:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:39978 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1351743AbhGLHwE (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Jul 2021 03:52:04 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9319B60FF1;
        Mon, 12 Jul 2021 07:49:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626076156;
        bh=mlsodlo56xVhdnsyEhX1VWTrujhMujl7nlO2NdZwdLw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YhCeY1mE/T0ahfbYMumNLKAqLo0NyaL59y2T+9NbojuE8nEbID8LYHp1ftBbCPfR2
         tymEOdYNJ3fCgeiJ2lKcK2n7njEBFfEniQ+gDhimMWGrcrRgGFfMsinenN2S15kxkZ
         2pd+eJyWyqLW3s9zyZ61YNzKWr/21gm5hSogltO4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Andrii Nakryiko <andrii@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.13 479/800] selftests/bpf: Fix ringbuf test fetching map FD
Date:   Mon, 12 Jul 2021 08:08:22 +0200
Message-Id: <20210712061018.150707908@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210712060912.995381202@linuxfoundation.org>
References: <20210712060912.995381202@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Andrii Nakryiko <andrii@kernel.org>

[ Upstream commit 0c38740c08962ab109267cb23f4a40df2ccf2bbf ]

Seems like 4d1b62986125 ("selftests/bpf: Convert few tests to light skeleton.")
and 704e2beba23c ("selftests/bpf: Test ringbuf mmap read-only and read-write
restrictions") were done independently on bpf and bpf-next trees and are in
conflict with each other, despite a clean merge. Fix fetching of ringbuf's
map_fd to use light skeleton properly.

Fixes: 704e2beba23c ("selftests/bpf: Test ringbuf mmap read-only and read-write restrictions")
Fixes: 4d1b62986125 ("selftests/bpf: Convert few tests to light skeleton.")
Signed-off-by: Andrii Nakryiko <andrii@kernel.org>
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Link: https://lore.kernel.org/bpf/20210618002824.2081922-1-andrii@kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/bpf/prog_tests/ringbuf.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/testing/selftests/bpf/prog_tests/ringbuf.c b/tools/testing/selftests/bpf/prog_tests/ringbuf.c
index f9a8ae331963..2a0549ae13f3 100644
--- a/tools/testing/selftests/bpf/prog_tests/ringbuf.c
+++ b/tools/testing/selftests/bpf/prog_tests/ringbuf.c
@@ -102,7 +102,7 @@ void test_ringbuf(void)
 	if (CHECK(err != 0, "skel_load", "skeleton load failed\n"))
 		goto cleanup;
 
-	rb_fd = bpf_map__fd(skel->maps.ringbuf);
+	rb_fd = skel->maps.ringbuf.map_fd;
 	/* good read/write cons_pos */
 	mmap_ptr = mmap(NULL, page_size, PROT_READ | PROT_WRITE, MAP_SHARED, rb_fd, 0);
 	ASSERT_OK_PTR(mmap_ptr, "rw_cons_pos");
-- 
2.30.2



