Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B00FE499A03
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 22:48:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1456490AbiAXVjP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 16:39:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53290 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1453859AbiAXVbF (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 16:31:05 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1D81EC0AD1A2;
        Mon, 24 Jan 2022 12:19:42 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id DB231B81229;
        Mon, 24 Jan 2022 20:19:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0C797C340E5;
        Mon, 24 Jan 2022 20:19:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643055579;
        bh=AtSJyWWQBR0qTc4KjdnINqtOHj8XVN61e4NKDvYhRxE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gY8CsRtTLG6PbffeC/BTK9mihgRbOdGFGYgvkGa+2ZxcPwK8iZk2MUxe71XB8cmb6
         g/BTD9xm/LZ6DR/Sd3pxJV8Zvzy+S09Sb7q128PtnJsrWQLQ5WkM/r0yKDx8+uqbHF
         4UbVs/Yf6by+IyoeyIE5Gv56FlR3W9SsDU96Mn3U=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Maxim Mikityanskiy <maximmi@nvidia.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 198/846] bpf: Fix the test_task_vma selftest to support output shorter than 1 kB
Date:   Mon, 24 Jan 2022 19:35:15 +0100
Message-Id: <20220124184107.775121833@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124184100.867127425@linuxfoundation.org>
References: <20220124184100.867127425@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Maxim Mikityanskiy <maximmi@nvidia.com>

[ Upstream commit da54ab14953c38d98cb3e34c564c06c3739394b2 ]

The test for bpf_iter_task_vma assumes that the output will be longer
than 1 kB, as the comment above the loop says. Due to this assumption,
the loop becomes infinite if the output turns to be shorter than 1 kB.
The return value of read_fd_into_buffer is 0 when the end of file was
reached, and len isn't being increased any more.

This commit adds a break on EOF to handle short output correctly. For
the reference, this is the contents that I get when running test_progs
under vmtest.sh, and it's shorter than 1 kB:

00400000-00401000 r--p 00000000 fe:00 25867     /root/bpf/test_progs
00401000-00674000 r-xp 00001000 fe:00 25867     /root/bpf/test_progs
00674000-0095f000 r--p 00274000 fe:00 25867     /root/bpf/test_progs
0095f000-00983000 r--p 0055e000 fe:00 25867     /root/bpf/test_progs
00983000-00a8a000 rw-p 00582000 fe:00 25867     /root/bpf/test_progs
00a8a000-0484e000 rw-p 00000000 00:00 0
7f6c64000000-7f6c64021000 rw-p 00000000 00:00 0
7f6c64021000-7f6c68000000 ---p 00000000 00:00 0
7f6c6ac8f000-7f6c6ac90000 r--s 00000000 00:0d 8032
anon_inode:bpf-map
7f6c6ac90000-7f6c6ac91000 ---p 00000000 00:00 0
7f6c6ac91000-7f6c6b491000 rw-p 00000000 00:00 0
7f6c6b491000-7f6c6b492000 r--s 00000000 00:0d 8032
anon_inode:bpf-map
7f6c6b492000-7f6c6b493000 rw-s 00000000 00:0d 8032
anon_inode:bpf-map
7ffc1e23d000-7ffc1e25e000 rw-p 00000000 00:00 0
7ffc1e3b8000-7ffc1e3bc000 r--p 00000000 00:00 0
7ffc1e3bc000-7ffc1e3bd000 r-xp 00000000 00:00 0
7fffffffe000-7ffffffff000 --xp 00000000 00:00 0

Fixes: e8168840e16c ("selftests/bpf: Add test for bpf_iter_task_vma")
Signed-off-by: Maxim Mikityanskiy <maximmi@nvidia.com>
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Link: https://lore.kernel.org/bpf/20211130181811.594220-1-maximmi@nvidia.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/bpf/prog_tests/bpf_iter.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/tools/testing/selftests/bpf/prog_tests/bpf_iter.c b/tools/testing/selftests/bpf/prog_tests/bpf_iter.c
index 77ac24b191d4c..dc18e5ae0febc 100644
--- a/tools/testing/selftests/bpf/prog_tests/bpf_iter.c
+++ b/tools/testing/selftests/bpf/prog_tests/bpf_iter.c
@@ -1208,13 +1208,14 @@ static void test_task_vma(void)
 		goto out;
 
 	/* Read CMP_BUFFER_SIZE (1kB) from bpf_iter. Read in small chunks
-	 * to trigger seq_file corner cases. The expected output is much
-	 * longer than 1kB, so the while loop will terminate.
+	 * to trigger seq_file corner cases.
 	 */
 	len = 0;
 	while (len < CMP_BUFFER_SIZE) {
 		err = read_fd_into_buffer(iter_fd, task_vma_output + len,
 					  min(read_size, CMP_BUFFER_SIZE - len));
+		if (!err)
+			break;
 		if (CHECK(err < 0, "read_iter_fd", "read_iter_fd failed\n"))
 			goto out;
 		len += err;
-- 
2.34.1



