Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 38C9A1F2327
	for <lists+stable@lfdr.de>; Tue,  9 Jun 2020 01:13:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728482AbgFHXNG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Jun 2020 19:13:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:60924 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728018AbgFHXNE (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 8 Jun 2020 19:13:04 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4961F2151B;
        Mon,  8 Jun 2020 23:13:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1591657983;
        bh=vPWsooLNYbqZlC9v8/kSs1fxNvvHkbEXp1xydXheOIg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=BmT2KObkzpCrg2O0xdBIOgRghcKkYLcFkfy0Spu8IIWl2CUsmOoa5pok4Q+HYAXaw
         f9UrUBDr4Vtsx31IdHrLtsOsXWzxwLROfOg++fpCisXjJXZkhMhltinTmcDlfSNgjY
         zkARERxkquWVQBu/13svhGEq+8VWJ3W4cIddBFiw=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     "Eric W. Biederman" <ebiederm@xmission.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-fsdevel@vger.kernel.org
Subject: [PATCH AUTOSEL 5.6 044/606] exec: Move would_dump into flush_old_exec
Date:   Mon,  8 Jun 2020 19:02:49 -0400
Message-Id: <20200608231211.3363633-44-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200608231211.3363633-1-sashal@kernel.org>
References: <20200608231211.3363633-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: "Eric W. Biederman" <ebiederm@xmission.com>

commit f87d1c9559164294040e58f5e3b74a162bf7c6e8 upstream.

I goofed when I added mm->user_ns support to would_dump.  I missed the
fact that in the case of binfmt_loader, binfmt_em86, binfmt_misc, and
binfmt_script bprm->file is reassigned.  Which made the move of
would_dump from setup_new_exec to __do_execve_file before exec_binprm
incorrect as it can result in would_dump running on the script instead
of the interpreter of the script.

The net result is that the code stopped making unreadable interpreters
undumpable.  Which allows them to be ptraced and written to disk
without special permissions.  Oops.

The move was necessary because the call in set_new_exec was after
bprm->mm was no longer valid.

To correct this mistake move the misplaced would_dump from
__do_execve_file into flos_old_exec, before exec_mmap is called.

I tested and confirmed that without this fix I can attach with gdb to
a script with an unreadable interpreter, and with this fix I can not.

Cc: stable@vger.kernel.org
Fixes: f84df2a6f268 ("exec: Ensure mm->user_ns contains the execed files")
Signed-off-by: "Eric W. Biederman" <ebiederm@xmission.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/exec.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/exec.c b/fs/exec.c
index a58625f27652..77603ceed51f 100644
--- a/fs/exec.c
+++ b/fs/exec.c
@@ -1277,6 +1277,8 @@ int flush_old_exec(struct linux_binprm * bprm)
 	 */
 	set_mm_exe_file(bprm->mm, bprm->file);
 
+	would_dump(bprm, bprm->file);
+
 	/*
 	 * Release all of the old mmap stuff
 	 */
@@ -1820,8 +1822,6 @@ static int __do_execve_file(int fd, struct filename *filename,
 	if (retval < 0)
 		goto out;
 
-	would_dump(bprm, bprm->file);
-
 	retval = exec_binprm(bprm);
 	if (retval < 0)
 		goto out;
-- 
2.25.1

