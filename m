Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 450C21BC67F
	for <lists+stable@lfdr.de>; Tue, 28 Apr 2020 19:21:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728022AbgD1RV1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Apr 2020 13:21:27 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:52925 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726406AbgD1RV1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 28 Apr 2020 13:21:27 -0400
Received: from 3.general.kamal.us.vpn ([10.172.68.53] helo=ascalon)
        by youngberry.canonical.com with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.86_2)
        (envelope-from <kamal@canonical.com>)
        id 1jTTvB-0004Kd-TD; Tue, 28 Apr 2020 17:21:26 +0000
Received: from kamal by ascalon with local (Exim 4.90_1)
        (envelope-from <kamal@ascalon>)
        id 1jTTv9-0002Ic-Jj; Tue, 28 Apr 2020 10:21:23 -0700
From:   Kamal Mostafa <kamal@canonical.com>
To:     stable@vger.kernel.org
Cc:     Kamal Mostafa <kamal@canonical.com>
Subject: [linux-5.4.y][PATCH] bpf: Test_progs, fix test_get_stack_rawtp_err.c build
Date:   Tue, 28 Apr 2020 10:21:21 -0700
Message-Id: <20200428172121.8635-1-kamal@canonical.com>
X-Mailer: git-send-email 2.17.1
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The linux-5.4.y commit 8781011a302b ("bpf: Test_progs, add test to catch
retval refine error handling") fails to build when libbpf headers are
not installed, as it tries to include <bpf/bpf_helpers.h>:

  progs/test_get_stack_rawtp_err.c:4:10:
      fatal error: 'bpf/bpf_helpers.h' file not found

For 5.4-stable (only) the new test prog needs to include "bpf_helpers.h"
instead (like all the rest of progs/*.c do) because 5.4-stable does not
carry commit e01a75c15969 ("libbpf: Move bpf_{helpers, helper_defs,
endian, tracing}.h into libbpf").

Signed-off-by: Kamal Mostafa <kamal@canonical.com>
Fixes: 8781011a302b ("bpf: Test_progs, add test to catch retval refine error handling")
Cc: <stable@vger.kernel.org> # v5.4
---
 tools/testing/selftests/bpf/progs/test_get_stack_rawtp_err.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/testing/selftests/bpf/progs/test_get_stack_rawtp_err.c b/tools/testing/selftests/bpf/progs/test_get_stack_rawtp_err.c
index 8941a41c2a55..cce6d605c017 100644
--- a/tools/testing/selftests/bpf/progs/test_get_stack_rawtp_err.c
+++ b/tools/testing/selftests/bpf/progs/test_get_stack_rawtp_err.c
@@ -1,7 +1,7 @@
 // SPDX-License-Identifier: GPL-2.0
 
 #include <linux/bpf.h>
-#include <bpf/bpf_helpers.h>
+#include "bpf_helpers.h"
 
 #define MAX_STACK_RAWTP 10
 
-- 
2.17.1

