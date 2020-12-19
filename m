Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C900C2DEF7B
	for <lists+stable@lfdr.de>; Sat, 19 Dec 2020 14:05:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727079AbgLSNEn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 19 Dec 2020 08:04:43 -0500
Received: from mail.kernel.org ([198.145.29.99]:52388 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728897AbgLSNE1 (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 19 Dec 2020 08:04:27 -0500
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Authentication-Results: mail.kernel.org; dkim=permerror (bad message/signature format)
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 5.4 31/34] Revert "selftests/ftrace: check for do_sys_openat2 in user-memory test"
Date:   Sat, 19 Dec 2020 14:03:28 +0100
Message-Id: <20201219125342.928341441@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201219125341.384025953@linuxfoundation.org>
References: <20201219125341.384025953@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Kamal Mostafa <kamal@canonical.com>

This reverts commit 9110e2f2633dc9383a3a4711a0067094f6948783.

This commit is not suitable for 5.4-stable because the openat2 system
call does not exist in v5.4.

Signed-off-by: Kamal Mostafa <kamal@canonical.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/testing/selftests/ftrace/test.d/kprobe/kprobe_args_user.tc |    4 ----
 1 file changed, 4 deletions(-)

--- a/tools/testing/selftests/ftrace/test.d/kprobe/kprobe_args_user.tc
+++ b/tools/testing/selftests/ftrace/test.d/kprobe/kprobe_args_user.tc
@@ -11,16 +11,12 @@ grep -A10 "fetcharg:" README | grep -q '
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
 


