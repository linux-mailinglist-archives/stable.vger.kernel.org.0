Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6FB0D2D1F39
	for <lists+stable@lfdr.de>; Tue,  8 Dec 2020 01:47:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728794AbgLHAqu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 7 Dec 2020 19:46:50 -0500
Received: from mail.kernel.org ([198.145.29.99]:59800 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728735AbgLHAqu (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 7 Dec 2020 19:46:50 -0500
Date:   Mon, 07 Dec 2020 16:46:09 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1607388369;
        bh=j/vL2wqV0LJjwoxjiR3HOb2JYmwiIxqjW+rhfJhJ5m4=;
        h=From:To:Subject:From;
        b=w8yTKsFZOU/aeMslbnLAqBgVtK6/zQWgEc1e7jp11s5mNotIkHuAbNeLneK1A0hXv
         JNK7bp9MErXgWgxmigQTjzzHzD0tqu1Pr0NFcQY/YBrZI3v6qCp4MdgUYibfxRng3L
         XfCeXq+TCe8ov7pKWVhClL9Vv8/A4uznchiCcaoU=
From:   akpm@linux-foundation.org
To:     dong.menglong@zte.com.cn, jwilk@jwilk.net,
        mm-commits@vger.kernel.org, nhorman@tuxdriver.com,
        pabs3@bonedaddy.net, stable@vger.kernel.org
Subject:  [merged] coredump-fix-core_pattern-parse-error.patch
 removed from -mm tree
Message-ID: <20201208004609.lEjCN5cfC%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch titled
     Subject: coredump: fix core_pattern parse error
has been removed from the -mm tree.  Its filename was
     coredump-fix-core_pattern-parse-error.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Menglong Dong <dong.menglong@zte.com.cn>
Subject: coredump: fix core_pattern parse error

'format_corename()' will splite 'core_pattern' on spaces when it is in
pipe mode, and take helper_argv[0] as the path to usermode executable.

It works fine in most cases. However, if there is a space between
'|' and '/file/path', such as
'| /usr/lib/systemd/systemd-coredump %P %u %g',
helper_argv[0] will be parsed as '', and users will get a
'Core dump to | disabled'.

It is not friendly to users, as the pattern above was valid previously. 
Fix this by ignoring the spaces between '|' and '/file/path'.

Link: https://lkml.kernel.org/r/5fb62870.1c69fb81.8ef5d.af76@mx.google.com
Fixes: 315c69261dd3 ("coredump: split pipe command whitespace before expanding template")
Signed-off-by: Menglong Dong <dong.menglong@zte.com.cn>
Cc: Paul Wise <pabs3@bonedaddy.net>
Cc: Jakub Wilk <jwilk@jwilk.net> [https://bugs.debian.org/924398]
Cc: Neil Horman <nhorman@tuxdriver.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/coredump.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/fs/coredump.c~coredump-fix-core_pattern-parse-error
+++ a/fs/coredump.c
@@ -229,7 +229,8 @@ static int format_corename(struct core_n
 		 */
 		if (ispipe) {
 			if (isspace(*pat_ptr)) {
-				was_space = true;
+				if (cn->used != 0)
+					was_space = true;
 				pat_ptr++;
 				continue;
 			} else if (was_space) {
_

Patches currently in -mm which might be from dong.menglong@zte.com.cn are


