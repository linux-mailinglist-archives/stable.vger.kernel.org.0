Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 446BC261E7D
	for <lists+stable@lfdr.de>; Tue,  8 Sep 2020 21:52:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730673AbgIHTwR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Sep 2020 15:52:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:38040 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730585AbgIHPtg (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 8 Sep 2020 11:49:36 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EE17C2483F;
        Tue,  8 Sep 2020 15:45:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1599579905;
        bh=qHeCeREw8luRvssVaXq9yusH73MMUoN9KoeWxWLV7R0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=g02QSsOxuWV9fDNA68KenXLnMomX30M9HRI0oyyGNR4ABwPQAycrNLAXabxx9CmzX
         w7iMEMws5NeEpdZxhU9VamTEK1kiGtCU6VXXZqIMGV9ul8I7db3hwx0XrAXvGeRTHZ
         MnyzPmeHmq2BHbiohliQB50krkXMZe0aDfdnzXJY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jesper Dangaard Brouer <brouer@redhat.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 051/129] selftests/bpf: Fix massive output from test_maps
Date:   Tue,  8 Sep 2020 17:24:52 +0200
Message-Id: <20200908152232.260940342@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200908152229.689878733@linuxfoundation.org>
References: <20200908152229.689878733@linuxfoundation.org>
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
index c812f0178b643..1c4219ceced2f 100644
--- a/tools/testing/selftests/bpf/test_maps.c
+++ b/tools/testing/selftests/bpf/test_maps.c
@@ -1282,6 +1282,8 @@ static void __run_parallel(unsigned int tasks,
 	pid_t pid[tasks];
 	int i;
 
+	fflush(stdout);
+
 	for (i = 0; i < tasks; i++) {
 		pid[i] = fork();
 		if (pid[i] == 0) {
-- 
2.25.1



