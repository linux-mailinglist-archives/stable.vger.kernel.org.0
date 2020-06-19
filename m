Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 00917200FBF
	for <lists+stable@lfdr.de>; Fri, 19 Jun 2020 17:23:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390646AbgFSPVk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Jun 2020 11:21:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:52894 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2392872AbgFSPVj (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 19 Jun 2020 11:21:39 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2221C21582;
        Fri, 19 Jun 2020 15:21:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592580098;
        bh=t8EX+OcVvPjkVogK7HTxyL6ukX9m/HBgPkG41B/CT7o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=R17mCMi7mECBnmd9ZFD20i605zfkNvzzCvrLeKK9togTXwkNv9RGuzECxxCWlU4ZI
         qYES9g1/Hgkxq422XALl6PhPQ/yJLBaBLHtBgReTFs+rzd5nmJ0TnSROYviaJLf1bH
         IZcTZEPWhul2Y5H+n+MGH2rsmd0UY3H2GGGoxuek=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Andrii Nakryiko <andriin@fb.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.7 122/376] selftests/bpf: Fix memory leak in test selector
Date:   Fri, 19 Jun 2020 16:30:40 +0200
Message-Id: <20200619141716.120864269@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200619141710.350494719@linuxfoundation.org>
References: <20200619141710.350494719@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Andrii Nakryiko <andriin@fb.com>

[ Upstream commit f25d5416d64c796aa639136eb0b076c8bd579b54 ]

Free test selector substrings, which were strdup()'ed.

Fixes: b65053cd94f4 ("selftests/bpf: Add whitelist/blacklist of test names to test_progs")
Signed-off-by: Andrii Nakryiko <andriin@fb.com>
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Link: https://lore.kernel.org/bpf/20200429012111.277390-6-andriin@fb.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/bpf/test_progs.c | 20 ++++++++++++++++----
 1 file changed, 16 insertions(+), 4 deletions(-)

diff --git a/tools/testing/selftests/bpf/test_progs.c b/tools/testing/selftests/bpf/test_progs.c
index b521e0a512b6..86d0020c9eec 100644
--- a/tools/testing/selftests/bpf/test_progs.c
+++ b/tools/testing/selftests/bpf/test_progs.c
@@ -420,6 +420,18 @@ static int libbpf_print_fn(enum libbpf_print_level level,
 	return 0;
 }
 
+static void free_str_set(const struct str_set *set)
+{
+	int i;
+
+	if (!set)
+		return;
+
+	for (i = 0; i < set->cnt; i++)
+		free((void *)set->strs[i]);
+	free(set->strs);
+}
+
 static int parse_str_list(const char *s, struct str_set *set)
 {
 	char *input, *state = NULL, *next, **tmp, **strs = NULL;
@@ -756,11 +768,11 @@ int main(int argc, char **argv)
 	fprintf(stdout, "Summary: %d/%d PASSED, %d SKIPPED, %d FAILED\n",
 		env.succ_cnt, env.sub_succ_cnt, env.skip_cnt, env.fail_cnt);
 
-	free(env.test_selector.blacklist.strs);
-	free(env.test_selector.whitelist.strs);
+	free_str_set(&env.test_selector.blacklist);
+	free_str_set(&env.test_selector.whitelist);
 	free(env.test_selector.num_set);
-	free(env.subtest_selector.blacklist.strs);
-	free(env.subtest_selector.whitelist.strs);
+	free_str_set(&env.subtest_selector.blacklist);
+	free_str_set(&env.subtest_selector.whitelist);
 	free(env.subtest_selector.num_set);
 
 	return env.fail_cnt ? EXIT_FAILURE : EXIT_SUCCESS;
-- 
2.25.1



