Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7C1F629C05A
	for <lists+stable@lfdr.de>; Tue, 27 Oct 2020 18:14:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1817189AbgJ0ROX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Oct 2020 13:14:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:60186 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1783890AbgJ0O6n (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Oct 2020 10:58:43 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C56BE20714;
        Tue, 27 Oct 2020 14:58:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603810722;
        bh=XEh+266qbHO/JplKpkkP76/x6r4YBQwRmHueb4pivNs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=A5sADgWUYbc4fvtmnBGspCNguI188E2OAxAJpBPJrCL8MwyUFN50OXKwuxTXkGroG
         NPCV7tzwo8xcNcmKa3w4sYmyzrV+I6SPAfyx26wKtwiz1ODVLV/rsplMjMjMlmWl1e
         T1N9SU2WzcoxfCrdZQcs95zmaZWuB00tFT3Ixj70=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ilya Leoshkevich <iii@linux.ibm.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andriin@fb.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.8 239/633] selftests/bpf: Fix endianness issue in sk_assign
Date:   Tue, 27 Oct 2020 14:49:42 +0100
Message-Id: <20201027135533.883182575@linuxfoundation.org>
X-Mailer: git-send-email 2.29.1
In-Reply-To: <20201027135522.655719020@linuxfoundation.org>
References: <20201027135522.655719020@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ilya Leoshkevich <iii@linux.ibm.com>

[ Upstream commit b6ed6cf4a3acdeab9aed8e0a524850761ec9b152 ]

server_map's value size is 8, but the test tries to put an int there.
This sort of works on x86 (unless followed by non-0), but hard fails on
s390.

Fix by using __s64 instead of int.

Fixes: 2d7824ffd25c ("selftests: bpf: Add test for sk_assign")
Signed-off-by: Ilya Leoshkevich <iii@linux.ibm.com>
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Acked-by: Andrii Nakryiko <andriin@fb.com>
Link: https://lore.kernel.org/bpf/20200915113815.3768217-1-iii@linux.ibm.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/bpf/prog_tests/sk_assign.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/testing/selftests/bpf/prog_tests/sk_assign.c b/tools/testing/selftests/bpf/prog_tests/sk_assign.c
index 47fa04adc1471..21c2d265c3e8e 100644
--- a/tools/testing/selftests/bpf/prog_tests/sk_assign.c
+++ b/tools/testing/selftests/bpf/prog_tests/sk_assign.c
@@ -265,7 +265,7 @@ void test_sk_assign(void)
 		TEST("ipv6 udp port redir", AF_INET6, SOCK_DGRAM, false),
 		TEST("ipv6 udp addr redir", AF_INET6, SOCK_DGRAM, true),
 	};
-	int server = -1;
+	__s64 server = -1;
 	int server_map;
 	int self_net;
 
-- 
2.25.1



