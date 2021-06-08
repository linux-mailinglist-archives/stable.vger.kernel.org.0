Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4C4EC3A0070
	for <lists+stable@lfdr.de>; Tue,  8 Jun 2021 20:46:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235367AbhFHSnP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Jun 2021 14:43:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:34990 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234926AbhFHSlO (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 8 Jun 2021 14:41:14 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7ADBC61436;
        Tue,  8 Jun 2021 18:35:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1623177312;
        bh=XHMwUJtfZ2U8HOHYKis63FpLPw24U/D76zmH031ivhs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TT36wyiPsgqZTlBNrm4kLapWZLtaYofOV+YnizBSO6mHsy5zXbUfMFAkIp78i5/CP
         s0kMl5ENzq1elu90kejctjmV9OaJxbbYnaZmWeDUgkTmaSfnEFuB0Bdk+l8IFHydib
         3kfnrBtIVAFH2h7PDLTO2FTDJDWCKWll+bOmqUSI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn.topel@gmail.com>,
        Andrii Nakryiko <andrii@kernel.org>,
        Luke Nelson <luke.r.nels@gmail.com>,
        Tiezhu Yang <yangtiezhu@loongson.cn>
Subject: [PATCH 4.19 48/58] selftests/bpf: Avoid running unprivileged tests with alignment requirements
Date:   Tue,  8 Jun 2021 20:27:29 +0200
Message-Id: <20210608175933.859670829@linuxfoundation.org>
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

From: Björn Töpel <bjorn.topel@gmail.com>

commit c77b0589ca29ad1859fe7d7c1ecd63c0632379fa upstream

Some architectures have strict alignment requirements. In that case,
the BPF verifier detects if a program has unaligned accesses and
rejects them. A user can pass BPF_F_ANY_ALIGNMENT to a program to
override this check. That, however, will only work when a privileged
user loads a program. An unprivileged user loading a program with this
flag will be rejected prior entering the verifier.

Hence, it does not make sense to load unprivileged programs without
strict alignment when testing the verifier. This patch avoids exactly
that.

Signed-off-by: Björn Töpel <bjorn.topel@gmail.com>
Signed-off-by: Andrii Nakryiko <andrii@kernel.org>
Acked-by: Luke Nelson <luke.r.nels@gmail.com>
Link: https://lore.kernel.org/bpf/20201118071640.83773-3-bjorn.topel@gmail.com
Signed-off-by: Tiezhu Yang <yangtiezhu@loongson.cn>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/testing/selftests/bpf/test_verifier.c |   13 +++++++++++++
 1 file changed, 13 insertions(+)

--- a/tools/testing/selftests/bpf/test_verifier.c
+++ b/tools/testing/selftests/bpf/test_verifier.c
@@ -13045,6 +13045,19 @@ static void get_unpriv_disabled()
 
 static bool test_as_unpriv(struct bpf_test *test)
 {
+#ifndef CONFIG_HAVE_EFFICIENT_UNALIGNED_ACCESS
+	/* Some architectures have strict alignment requirements. In
+	 * that case, the BPF verifier detects if a program has
+	 * unaligned accesses and rejects them. A user can pass
+	 * BPF_F_ANY_ALIGNMENT to a program to override this
+	 * check. That, however, will only work when a privileged user
+	 * loads a program. An unprivileged user loading a program
+	 * with this flag will be rejected prior entering the
+	 * verifier.
+	 */
+	if (test->flags & F_NEEDS_EFFICIENT_UNALIGNED_ACCESS)
+		return false;
+#endif
 	return !test->prog_type ||
 	       test->prog_type == BPF_PROG_TYPE_SOCKET_FILTER ||
 	       test->prog_type == BPF_PROG_TYPE_CGROUP_SKB;


