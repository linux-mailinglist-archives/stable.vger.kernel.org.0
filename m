Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D28A63A0043
	for <lists+stable@lfdr.de>; Tue,  8 Jun 2021 20:46:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235054AbhFHSlP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Jun 2021 14:41:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:34990 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235362AbhFHSjv (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 8 Jun 2021 14:39:51 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 118C161434;
        Tue,  8 Jun 2021 18:34:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1623177263;
        bh=YPG47taUkBXMmvO5CD6jXL0RfrS/D6hlBbzIUwi9O3Q=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gBMJ8PI2mtUS19hASc0wbtAYW9DKq9xam4TMhGrmbiO5pPCZntwNtQ5YPtgTkL3x1
         kUIg4pHat8yGv7IdQxlpHz3yAMcHlm+o08TWV3k8h61bI/2kLF6Wsv1RKrKT3Ek/jK
         EO+5qYoNwl2Irzj9mLaEMoQoHghB4BmNR+Lii1AE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Tiezhu Yang <yangtiezhu@loongson.cn>
Subject: [PATCH 4.19 40/58] bpf: fix test suite to enable all unpriv program types
Date:   Tue,  8 Jun 2021 20:27:21 +0200
Message-Id: <20210608175933.595508385@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210608175932.263480586@linuxfoundation.org>
References: <20210608175932.263480586@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Daniel Borkmann <daniel@iogearbox.net>

commit 36641ad61db5ce9befd5eb0071abb36eaff16cfc upstream

Given BPF_PROG_TYPE_CGROUP_SKB program types are also valid in an
unprivileged setting, lets not omit these tests and potentially
have issues fall through the cracks. Make this more obvious by
adding a small test_as_unpriv() helper.

Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Acked-by: Alexei Starovoitov <ast@kernel.org>
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Signed-off-by: Tiezhu Yang <yangtiezhu@loongson.cn>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/testing/selftests/bpf/test_verifier.c |   12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

--- a/tools/testing/selftests/bpf/test_verifier.c
+++ b/tools/testing/selftests/bpf/test_verifier.c
@@ -4798,6 +4798,7 @@ static struct bpf_test tests[] = {
 		.fixup_cgroup_storage = { 1 },
 		.result = REJECT,
 		.errstr = "get_local_storage() doesn't support non-zero flags",
+		.errstr_unpriv = "R2 leaks addr into helper function",
 		.prog_type = BPF_PROG_TYPE_CGROUP_SKB,
 	},
 	{
@@ -12963,6 +12964,13 @@ static void get_unpriv_disabled()
 	fclose(fd);
 }
 
+static bool test_as_unpriv(struct bpf_test *test)
+{
+	return !test->prog_type ||
+	       test->prog_type == BPF_PROG_TYPE_SOCKET_FILTER ||
+	       test->prog_type == BPF_PROG_TYPE_CGROUP_SKB;
+}
+
 static int do_test(bool unpriv, unsigned int from, unsigned int to)
 {
 	int i, passes = 0, errors = 0, skips = 0;
@@ -12973,10 +12981,10 @@ static int do_test(bool unpriv, unsigned
 		/* Program types that are not supported by non-root we
 		 * skip right away.
 		 */
-		if (!test->prog_type && unpriv_disabled) {
+		if (test_as_unpriv(test) && unpriv_disabled) {
 			printf("#%d/u %s SKIP\n", i, test->descr);
 			skips++;
-		} else if (!test->prog_type) {
+		} else if (test_as_unpriv(test)) {
 			if (!unpriv)
 				set_admin(false);
 			printf("#%d/u %s ", i, test->descr);


