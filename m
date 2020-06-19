Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 324DB200D2C
	for <lists+stable@lfdr.de>; Fri, 19 Jun 2020 16:57:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389804AbgFSOyB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Jun 2020 10:54:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:48514 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389800AbgFSOyA (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 19 Jun 2020 10:54:00 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8867E217D8;
        Fri, 19 Jun 2020 14:53:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592578440;
        bh=pCuZwKveT1WQk1wUP/h07aVdSsfF4vSo5HcypKbx6n0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=o86Wt5Fd0doVyoZSJA9Zz9ZFb2Uw2QQwJKjDitAxSLj3wy+uoATfn/avw1KKfKGtZ
         OT7+TERtJW1gkvjBRPE9bCN3IDwUmlteZTCwRRcDezbT5B54lkAgiakuVJc9LDCc6u
         6xkOJGhftVS9mazpUb2PSRSehh/OBu8xAqULaZKs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        kernel test robot <rong.a.chen@intel.com>,
        Lorenz Bauer <lmb@cloudflare.com>
Subject: [PATCH 4.19 006/267] selftests: bpf: fix use of undeclared RET_IF macro
Date:   Fri, 19 Jun 2020 16:29:51 +0200
Message-Id: <20200619141649.161195522@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200619141648.840376470@linuxfoundation.org>
References: <20200619141648.840376470@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Lorenz Bauer <lmb@cloudflare.com>

commit 634efb750435 ("selftests: bpf: Reset global state between
reuseport test runs") uses a macro RET_IF which doesn't exist in
the v4.19 tree. It is defined as follows:

        #define RET_IF(condition, tag, format...) ({
                if (CHECK_FAIL(condition)) {
                        printf(tag " " format);
                        return;
                }
        })

CHECK_FAIL in turn is defined as:

        #define CHECK_FAIL(condition) ({
                int __ret = !!(condition);
                int __save_errno = errno;
                if (__ret) {
                        test__fail();
                        fprintf(stdout, "%s:FAIL:%d\n", __func__, __LINE__);
                }
                errno = __save_errno;
                __ret;
        })

Replace occurences of RET_IF with CHECK. This will abort the test binary
if clearing the intermediate state fails.

Fixes: 634efb750435 ("selftests: bpf: Reset global state between reuseport test runs")
Reported-by: kernel test robot <rong.a.chen@intel.com>
Signed-off-by: Lorenz Bauer <lmb@cloudflare.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/testing/selftests/bpf/test_select_reuseport.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/tools/testing/selftests/bpf/test_select_reuseport.c
+++ b/tools/testing/selftests/bpf/test_select_reuseport.c
@@ -616,13 +616,13 @@ static void cleanup_per_test(void)
 
 	for (i = 0; i < NR_RESULTS; i++) {
 		err = bpf_map_update_elem(result_map, &i, &zero, BPF_ANY);
-		RET_IF(err, "reset elem in result_map",
-		       "i:%u err:%d errno:%d\n", i, err, errno);
+		CHECK(err, "reset elem in result_map",
+		      "i:%u err:%d errno:%d\n", i, err, errno);
 	}
 
 	err = bpf_map_update_elem(linum_map, &zero, &zero, BPF_ANY);
-	RET_IF(err, "reset line number in linum_map", "err:%d errno:%d\n",
-	       err, errno);
+	CHECK(err, "reset line number in linum_map", "err:%d errno:%d\n",
+	      err, errno);
 
 	for (i = 0; i < REUSEPORT_ARRAY_SIZE; i++)
 		close(sk_fds[i]);


