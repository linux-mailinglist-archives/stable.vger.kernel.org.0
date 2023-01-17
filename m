Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 710C666DDF4
	for <lists+stable@lfdr.de>; Tue, 17 Jan 2023 13:45:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235947AbjAQMpn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 17 Jan 2023 07:45:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33898 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236398AbjAQMpj (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 17 Jan 2023 07:45:39 -0500
Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 376B418B26;
        Tue, 17 Jan 2023 04:45:36 -0800 (PST)
Received: from dggpeml100012.china.huawei.com (unknown [172.30.72.56])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4Nx7qt4q96zJrK0;
        Tue, 17 Jan 2023 20:44:10 +0800 (CST)
Received: from localhost.localdomain (10.67.175.61) by
 dggpeml100012.china.huawei.com (7.185.36.121) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.34; Tue, 17 Jan 2023 20:45:33 +0800
From:   Zheng Yejian <zhengyejian1@huawei.com>
To:     <linux-kselftest@vger.kernel.org>, <stable@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
CC:     <rostedt@goodmis.org>, <mingo@redhat.com>, <shuah@kernel.org>,
        <chenzhongjin@huawei.com>, <sashal@kernel.org>,
        <zanussi@kernel.org>, <zhengyejian1@huawei.com>
Subject: [PATCH 5.10] Revert "selftests/ftrace: Update synthetic event syntax errors"
Date:   Tue, 17 Jan 2023 20:47:09 +0800
Message-ID: <20230117124709.2341012-1-zhengyejian1@huawei.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.67.175.61]
X-ClientProxiedBy: dggems702-chm.china.huawei.com (10.3.19.179) To
 dggpeml100012.china.huawei.com (7.185.36.121)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This reverts commit 31c2e369b5335d70e913afee3ae11e54d61afef2.

The reverted commit belongs to patchset which updated synthetic event
command parsing and testcase 'trigger-synthetic_event_syntax_errors.tc'
Link: https://lore.kernel.org/all/20210211020950.102294806@goodmis.org/

However this testcase update was backported alone without feature
update, which makes the testcase cannot pass on stable branch.

Revert this commit to make the testcase correct.

Fixes: 31c2e369b533 ("selftests/ftrace: Update synthetic event syntax errors")
Reported-by: Chen Zhongjin <chenzhongjin@huawei.com>
Signed-off-by: Zheng Yejian <zhengyejian1@huawei.com>
---
 .../trigger-synthetic_event_syntax_errors.tc  | 35 +++++--------------
 1 file changed, 8 insertions(+), 27 deletions(-)

diff --git a/tools/testing/selftests/ftrace/test.d/trigger/inter-event/trigger-synthetic_event_syntax_errors.tc b/tools/testing/selftests/ftrace/test.d/trigger/inter-event/trigger-synthetic_event_syntax_errors.tc
index 955e3ceea44b..ada594fe16cb 100644
--- a/tools/testing/selftests/ftrace/test.d/trigger/inter-event/trigger-synthetic_event_syntax_errors.tc
+++ b/tools/testing/selftests/ftrace/test.d/trigger/inter-event/trigger-synthetic_event_syntax_errors.tc
@@ -1,38 +1,19 @@
 #!/bin/sh
 # SPDX-License-Identifier: GPL-2.0
 # description: event trigger - test synthetic_events syntax parser errors
-# requires: synthetic_events error_log "char name[]' >> synthetic_events":README
+# requires: synthetic_events error_log
 
 check_error() { # command-with-error-pos-by-^
     ftrace_errlog_check 'synthetic_events' "$1" 'synthetic_events'
 }
 
-check_dyn_error() { # command-with-error-pos-by-^
-    ftrace_errlog_check 'synthetic_events' "$1" 'dynamic_events'
-}
-
 check_error 'myevent ^chr arg'			# INVALID_TYPE
-check_error 'myevent ^unsigned arg'		# INCOMPLETE_TYPE
-
-check_error 'myevent char ^str]; int v'		# BAD_NAME
-check_error '^mye-vent char str[]'		# BAD_NAME
-check_error 'myevent char ^st-r[]'		# BAD_NAME
-
-check_error 'myevent char str;^[]'		# INVALID_FIELD
-check_error 'myevent char str; ^int'		# INVALID_FIELD
-
-check_error 'myevent char ^str[; int v'		# INVALID_ARRAY_SPEC
-check_error 'myevent char ^str[kdjdk]'		# INVALID_ARRAY_SPEC
-check_error 'myevent char ^str[257]'		# INVALID_ARRAY_SPEC
-
-check_error '^mye;vent char str[]'		# INVALID_CMD
-check_error '^myevent ; char str[]'		# INVALID_CMD
-check_error '^myevent; char str[]'		# INVALID_CMD
-check_error '^myevent ;char str[]'		# INVALID_CMD
-check_error '^; char str[]'			# INVALID_CMD
-check_error '^;myevent char str[]'		# INVALID_CMD
-check_error '^myevent'				# INVALID_CMD
-
-check_dyn_error '^s:junk/myevent char str['	# INVALID_DYN_CMD
+check_error 'myevent ^char str[];; int v'	# INVALID_TYPE
+check_error 'myevent char ^str]; int v'		# INVALID_NAME
+check_error 'myevent char ^str;[]'		# INVALID_NAME
+check_error 'myevent ^char str[; int v'		# INVALID_TYPE
+check_error '^mye;vent char str[]'		# BAD_NAME
+check_error 'myevent char str[]; ^int'		# INVALID_FIELD
+check_error '^myevent'				# INCOMPLETE_CMD
 
 exit 0
-- 
2.25.1

