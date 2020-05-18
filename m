Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7F16B1D8589
	for <lists+stable@lfdr.de>; Mon, 18 May 2020 20:19:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731249AbgERRyJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 May 2020 13:54:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:58574 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731245AbgERRyI (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 18 May 2020 13:54:08 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7390F207C4;
        Mon, 18 May 2020 17:54:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1589824447;
        bh=0bGfIT093qQ9vQN8ZTgqObBdEYENQQ1lD1pDuR4jFqA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=erdnY+359YOtGOncEsLcvdwHl+tfn5y9IUW2hcLWuzv7+lJiWhf880TZEUEpeJmQL
         rgT9TCL99a8uHlBNYpILjtPzApmX/FflfFo9xCjAh836V5Xu2ktlFGIVWw5Y6F0DfG
         zzvt/20cN2kmmDSYWk2rfu2QywDWEiMF3Ki3DyJw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, kernel test robot <rong.a.chen@intel.com>,
        Hangbin Liu <liuhangbin@gmail.com>
Subject: [PATCH 5.4 016/147] selftests/bpf: fix goto cleanup label not defined
Date:   Mon, 18 May 2020 19:35:39 +0200
Message-Id: <20200518173515.782204255@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200518173513.009514388@linuxfoundation.org>
References: <20200518173513.009514388@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Hangbin Liu <liuhangbin@gmail.com>

kernel test robot found a warning when build bpf selftest for 5.4.y stable
tree:

prog_tests/stacktrace_build_id_nmi.c:55:3: error: label ‘cleanup’ used but not defined
   goto cleanup;
   ^~~~

This is because we are lacking upstream commit dde53c1b763b
("selftests/bpf: Convert few more selftest to skeletons"). But this
commit is too large and need more backports. To fix it, the
easiest way is just use the current goto label 'close_prog'.

Reported-by: kernel test robot <rong.a.chen@intel.com>
Fixes: da43712a7262 ("selftests/bpf: Skip perf hw events test if the setup disabled it")
Signed-off-by: Hangbin Liu <liuhangbin@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 tools/testing/selftests/bpf/prog_tests/stacktrace_build_id_nmi.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/tools/testing/selftests/bpf/prog_tests/stacktrace_build_id_nmi.c
+++ b/tools/testing/selftests/bpf/prog_tests/stacktrace_build_id_nmi.c
@@ -52,7 +52,7 @@ retry:
 	if (pmu_fd < 0 && errno == ENOENT) {
 		printf("%s:SKIP:no PERF_COUNT_HW_CPU_CYCLES\n", __func__);
 		test__skip();
-		goto cleanup;
+		goto close_prog;
 	}
 	if (CHECK(pmu_fd < 0, "perf_event_open", "err %d errno %d\n",
 		  pmu_fd, errno))


