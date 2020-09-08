Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 14540261AB8
	for <lists+stable@lfdr.de>; Tue,  8 Sep 2020 20:39:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731778AbgIHSjI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Sep 2020 14:39:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:56078 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731331AbgIHQJA (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 8 Sep 2020 12:09:00 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A89B624059;
        Tue,  8 Sep 2020 15:48:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1599580116;
        bh=dHp68Ju7MZ8MzQV+IYA/UvzVLU+N3F3/x1koRgcbyjA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FkovZfKCi8jHrdowVGRfMBwfHXkhPlvmwuyXrqhqtqDlVqsRX7zAJ81Oz5ChbOKUe
         E9Ue+clJmLSf9Yd1299jwXb6Igtx66/MGj0d7HuPudEcwGxLhDrCx/Hk4GM4AM3BJc
         M74qGmCx/NWWO09E1Jtrqzdz1qSVauTu/EH7nQuk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jesper Dangaard Brouer <brouer@redhat.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 37/88] selftests/bpf: Fix massive output from test_maps
Date:   Tue,  8 Sep 2020 17:25:38 +0200
Message-Id: <20200908152222.961572365@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200908152221.082184905@linuxfoundation.org>
References: <20200908152221.082184905@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jesper Dangaard Brouer <brouer@redhat.com>

[ Upstream commit fa4505675e093e895b7ec49a76d44f6b5ad9602e ]

When stdout output from the selftests tool 'test_maps' gets redirected
into e.g file or pipe, then the output lines increase a lot (from 21
to 33949 lines).  This is caused by the printf that happens before the
fork() call, and there are user-space buffered printf data that seems
to be duplicated into the forked process.

To fix this fflush() stdout before the fork loop in __run_parallel().

Fixes: 1a97cf1fe503 ("selftests/bpf: speedup test_maps")
Signed-off-by: Jesper Dangaard Brouer <brouer@redhat.com>
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Link: https://lore.kernel.org/bpf/159842985651.1050885.2154399297503372406.stgit@firesoul
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/bpf/test_maps.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/tools/testing/selftests/bpf/test_maps.c b/tools/testing/selftests/bpf/test_maps.c
index 9b552c0fc47db..4e202217fae10 100644
--- a/tools/testing/selftests/bpf/test_maps.c
+++ b/tools/testing/selftests/bpf/test_maps.c
@@ -1017,6 +1017,8 @@ static void __run_parallel(int tasks, void (*fn)(int task, void *data),
 	pid_t pid[tasks];
 	int i;
 
+	fflush(stdout);
+
 	for (i = 0; i < tasks; i++) {
 		pid[i] = fork();
 		if (pid[i] == 0) {
-- 
2.25.1



