Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4539224BBE2
	for <lists+stable@lfdr.de>; Thu, 20 Aug 2020 14:35:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727099AbgHTMfL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 Aug 2020 08:35:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:53222 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729554AbgHTJs0 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 20 Aug 2020 05:48:26 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1D7A520724;
        Thu, 20 Aug 2020 09:48:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597916905;
        bh=AMJbALkJjz8scBdcbtE9UUJgKG/4dLleB2UZksKqIAc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mBMYdr9uH39AF2DG+CgR4OGM8pxmMrHQhYAsueXsVQlTCGREe3n9EwzVaDsKMmREe
         HC0Sq3DK8v63G1J+lot6b8EcbruRKnfSEQX+Iq1FWsc0iWHjS89Lmgq9f+zg879hjV
         ZHgDD3QMVtKEFCGOPHfG92IX9VNJ7lQ7pP95Mzxc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jesper Dangaard Brouer <brouer@redhat.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andriin@fb.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 088/152] selftests/bpf: test_progs use another shell exit on non-actions
Date:   Thu, 20 Aug 2020 11:20:55 +0200
Message-Id: <20200820091558.240620751@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200820091553.615456912@linuxfoundation.org>
References: <20200820091553.615456912@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jesper Dangaard Brouer <brouer@redhat.com>

[ Upstream commit 3220fb667842a9725cbb71656f406eadb03c094b ]

This is a follow up adjustment to commit 6c92bd5cd465 ("selftests/bpf:
Test_progs indicate to shell on non-actions"), that returns shell exit
indication EXIT_FAILURE (value 1) when user selects a non-existing test.

The problem with using EXIT_FAILURE is that a shell script cannot tell
the difference between a non-existing test and the test failing.

This patch uses value 2 as shell exit indication.
(Aside note unrecognized option parameters use value 64).

Fixes: 6c92bd5cd465 ("selftests/bpf: Test_progs indicate to shell on non-actions")
Signed-off-by: Jesper Dangaard Brouer <brouer@redhat.com>
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Acked-by: Andrii Nakryiko <andriin@fb.com>
Link: https://lore.kernel.org/bpf/159410593992.1093222.90072558386094370.stgit@firesoul
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/bpf/test_progs.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/tools/testing/selftests/bpf/test_progs.c b/tools/testing/selftests/bpf/test_progs.c
index a7d06724c18c2..48bbe8e0ce48d 100644
--- a/tools/testing/selftests/bpf/test_progs.c
+++ b/tools/testing/selftests/bpf/test_progs.c
@@ -7,6 +7,8 @@
 #include <argp.h>
 #include <string.h>
 
+#define EXIT_NO_TEST		2
+
 /* defined in test_progs.h */
 struct test_env env;
 
@@ -585,7 +587,7 @@ int main(int argc, char **argv)
 	free(env.subtest_selector.num_set);
 
 	if (env.succ_cnt + env.fail_cnt + env.skip_cnt == 0)
-		return EXIT_FAILURE;
+		return EXIT_NO_TEST;
 
 	return env.fail_cnt ? EXIT_FAILURE : EXIT_SUCCESS;
 }
-- 
2.25.1



