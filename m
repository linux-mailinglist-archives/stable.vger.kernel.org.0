Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 56DE5289C9
	for <lists+stable@lfdr.de>; Thu, 23 May 2019 21:43:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388839AbfEWTmJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 May 2019 15:42:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:55494 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389817AbfEWTT1 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 23 May 2019 15:19:27 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6945C2184E;
        Thu, 23 May 2019 19:19:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1558639166;
        bh=zkgKbgTQe4MsLCdeZZDrW0+Gxfyjtd9pkdNs93f7NG4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KIBIU48QJJaVI6t9biN5aUvdftLegMJ1XmkX8BAksBOYeYaSNZn980uB0LN9wSiA1
         lJMY1ftc70i6HBf4SihU3zqT8z64ZMLTbI+Iw6Q0rNl6Q3+BZG3y5P6vPMD2LShh/m
         523tJSSTGzgGb19AarULpass3yxT2I1wVhej8SQk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Tommi Rantala <tommi.t.rantala@nokia.com>,
        Stanislav Fomichev <sdf@google.com>,
        Sasha Levin <sashal@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>
Subject: [PATCH 4.19 111/114] Revert "selftests/bpf: skip verifier tests for unsupported program types"
Date:   Thu, 23 May 2019 21:06:50 +0200
Message-Id: <20190523181740.798196828@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190523181731.372074275@linuxfoundation.org>
References: <20190523181731.372074275@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

This reverts commit 118d38a3577f7728278f6afda8436af05a6bec7f which is
commit 8184d44c9a577a2f1842ed6cc844bfd4a9981d8e upstream.

Tommi reports that this patch breaks the build, it's not really needed
so let's revert it.

Reported-by: Tommi Rantala <tommi.t.rantala@nokia.com>
Cc: Stanislav Fomichev <sdf@google.com>
Cc: Sasha Levin <sashal@kernel.org>
Acked-by: Daniel Borkmann <daniel@iogearbox.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/testing/selftests/bpf/test_verifier.c |    9 +--------
 1 file changed, 1 insertion(+), 8 deletions(-)

--- a/tools/testing/selftests/bpf/test_verifier.c
+++ b/tools/testing/selftests/bpf/test_verifier.c
@@ -32,7 +32,6 @@
 #include <linux/if_ether.h>
 
 #include <bpf/bpf.h>
-#include <bpf/libbpf.h>
 
 #ifdef HAVE_GENHDR
 # include "autoconf.h"
@@ -57,7 +56,6 @@
 
 #define UNPRIV_SYSCTL "kernel/unprivileged_bpf_disabled"
 static bool unpriv_disabled = false;
-static int skips;
 
 struct bpf_test {
 	const char *descr;
@@ -12772,11 +12770,6 @@ static void do_test_single(struct bpf_te
 	fd_prog = bpf_verify_program(prog_type ? : BPF_PROG_TYPE_SOCKET_FILTER,
 				     prog, prog_len, test->flags & F_LOAD_WITH_STRICT_ALIGNMENT,
 				     "GPL", 0, bpf_vlog, sizeof(bpf_vlog), 1);
-	if (fd_prog < 0 && !bpf_probe_prog_type(prog_type, 0)) {
-		printf("SKIP (unsupported program type %d)\n", prog_type);
-		skips++;
-		goto close_fds;
-	}
 
 	expected_ret = unpriv && test->result_unpriv != UNDEF ?
 		       test->result_unpriv : test->result;
@@ -12912,7 +12905,7 @@ static void get_unpriv_disabled()
 
 static int do_test(bool unpriv, unsigned int from, unsigned int to)
 {
-	int i, passes = 0, errors = 0;
+	int i, passes = 0, errors = 0, skips = 0;
 
 	for (i = from; i < to; i++) {
 		struct bpf_test *test = &tests[i];


