Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6771929B8E4
	for <lists+stable@lfdr.de>; Tue, 27 Oct 2020 17:10:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1802082AbgJ0Ppc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Oct 2020 11:45:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:47710 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1799314AbgJ0Pav (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Oct 2020 11:30:51 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C8C282225E;
        Tue, 27 Oct 2020 15:30:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603812651;
        bh=1O3HA3EBzE4msZhuBrHkLy8BBzalcw41zC2njxyqYX4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=L/L+PfFqEIZMGI7Ba9U2Cme+KCJVtVm6gGdHu/keImsw5Bv2fjSc04mFP9iu2ElNg
         KFKP/Wj6eNmotsf00NqO1Avpjn2J7Y6p7Jz9oDM9jKEG2qXL976g8HRZg5DspXVYmN
         ZWJh33qbdq4YRi+tdvCFP2oUjkEcl3royzkOzl48=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ilya Leoshkevich <iii@linux.ibm.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andriin@fb.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.9 284/757] selftests/bpf: Fix endianness issue in test_sockopt_sk
Date:   Tue, 27 Oct 2020 14:48:54 +0100
Message-Id: <20201027135503.897598737@linuxfoundation.org>
X-Mailer: git-send-email 2.29.1
In-Reply-To: <20201027135450.497324313@linuxfoundation.org>
References: <20201027135450.497324313@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ilya Leoshkevich <iii@linux.ibm.com>

[ Upstream commit fec47bbc10b243690f5d0ee484a0bbdee273e71b ]

getsetsockopt() calls getsockopt() with optlen == 1, but then checks
the resulting int. It is ok on little endian, but not on big endian.

Fix by checking char instead.

Fixes: 8a027dc0d8f5 ("selftests/bpf: add sockopt test that exercises sk helpers")
Signed-off-by: Ilya Leoshkevich <iii@linux.ibm.com>
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Acked-by: Andrii Nakryiko <andriin@fb.com>
Link: https://lore.kernel.org/bpf/20200915113928.3768496-1-iii@linux.ibm.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/bpf/prog_tests/sockopt_sk.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/tools/testing/selftests/bpf/prog_tests/sockopt_sk.c b/tools/testing/selftests/bpf/prog_tests/sockopt_sk.c
index 5f54c6aec7f07..b25c9c45c1484 100644
--- a/tools/testing/selftests/bpf/prog_tests/sockopt_sk.c
+++ b/tools/testing/selftests/bpf/prog_tests/sockopt_sk.c
@@ -45,9 +45,9 @@ static int getsetsockopt(void)
 		goto err;
 	}
 
-	if (*(int *)big_buf != 0x08) {
+	if (*big_buf != 0x08) {
 		log_err("Unexpected getsockopt(IP_TOS) optval 0x%x != 0x08",
-			*(int *)big_buf);
+			(int)*big_buf);
 		goto err;
 	}
 
-- 
2.25.1



