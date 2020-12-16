Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 74CAE2DC600
	for <lists+stable@lfdr.de>; Wed, 16 Dec 2020 19:15:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729783AbgLPSO6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 16 Dec 2020 13:14:58 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:55091 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727668AbgLPSO5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 16 Dec 2020 13:14:57 -0500
Received: from 2.general.kamal.us.vpn ([10.172.68.52] helo=ascalon)
        by youngberry.canonical.com with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.86_2)
        (envelope-from <kamal@canonical.com>)
        id 1kpbJX-00064u-1y; Wed, 16 Dec 2020 18:14:15 +0000
Received: from kamal by ascalon with local (Exim 4.90_1)
        (envelope-from <kamal@ascalon>)
        id 1kpbJS-00082a-Rg; Wed, 16 Dec 2020 10:14:10 -0800
From:   Kamal Mostafa <kamal@canonical.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>
Cc:     Kamal Mostafa <kamal@canonical.com>, stable@vger.kernel.org
Subject: [PATCH 5.4.y] Revert "selftests/ftrace: check for do_sys_openat2 in user-memory test"
Date:   Wed, 16 Dec 2020 10:13:53 -0800
Message-Id: <20201216181353.30321-1-kamal@canonical.com>
X-Mailer: git-send-email 2.17.1
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This reverts commit 9110e2f2633dc9383a3a4711a0067094f6948783.

This commit is not suitable for 5.4-stable because the openat2 system
call does not exist in v5.4.

Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 .../selftests/ftrace/test.d/kprobe/kprobe_args_user.tc        | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/tools/testing/selftests/ftrace/test.d/kprobe/kprobe_args_user.tc b/tools/testing/selftests/ftrace/test.d/kprobe/kprobe_args_user.tc
index a753c73d869a..0f60087583d8 100644
--- a/tools/testing/selftests/ftrace/test.d/kprobe/kprobe_args_user.tc
+++ b/tools/testing/selftests/ftrace/test.d/kprobe/kprobe_args_user.tc
@@ -11,16 +11,12 @@ grep -A10 "fetcharg:" README | grep -q '\[u\]<offset>' || exit_unsupported
 :;: "user-memory access syntax and ustring working on user memory";:
 echo 'p:myevent do_sys_open path=+0($arg2):ustring path2=+u0($arg2):string' \
 	> kprobe_events
-echo 'p:myevent2 do_sys_openat2 path=+0($arg2):ustring path2=+u0($arg2):string' \
-	>> kprobe_events
 
 grep myevent kprobe_events | \
 	grep -q 'path=+0($arg2):ustring path2=+u0($arg2):string'
 echo 1 > events/kprobes/myevent/enable
-echo 1 > events/kprobes/myevent2/enable
 echo > /dev/null
 echo 0 > events/kprobes/myevent/enable
-echo 0 > events/kprobes/myevent2/enable
 
 grep myevent trace | grep -q 'path="/dev/null" path2="/dev/null"'
 
-- 
2.17.1

