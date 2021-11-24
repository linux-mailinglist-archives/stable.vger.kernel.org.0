Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 26D9A45C691
	for <lists+stable@lfdr.de>; Wed, 24 Nov 2021 15:07:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352419AbhKXOKU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Nov 2021 09:10:20 -0500
Received: from mail.kernel.org ([198.145.29.99]:53632 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1346674AbhKXOGc (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 24 Nov 2021 09:06:32 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1B2986125F;
        Wed, 24 Nov 2021 13:12:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637759560;
        bh=aS74qLvOSDeCEN3oKU+EhEsJtlz4Of8y6BZtILjRghs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YDnRqGL8vo5aw+OpW7ie3kiHMaddLFMHGqHBxEAB8R9NtXl0MMc1SZO03QCiIwg33
         dnAz8vaAMnTFdmU+8J3hKwZY3Y8GgEQwomF078nwHE+6XG6QRybExgHY83vj6EWzop
         btXbr+xGGjMkQswoXYAczvFwhmWKJPkn/jGjBk0A=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Andy Lutomirski <luto@kernel.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Thomas Backlund <tmb@iki.fi>
Subject: [PATCH 5.15 263/279] signal/x86: In emulate_vsyscall force a signal instead of calling do_exit
Date:   Wed, 24 Nov 2021 12:59:10 +0100
Message-Id: <20211124115727.794406414@linuxfoundation.org>
X-Mailer: git-send-email 2.34.0
In-Reply-To: <20211124115718.776172708@linuxfoundation.org>
References: <20211124115718.776172708@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Eric W. Biederman <ebiederm@xmission.com>

commit 695dd0d634df8903e5ead8aa08d326f63b23368a upstream.

Directly calling do_exit with a signal number has the problem that
all of the side effects of the signal don't happen, such as
killing all of the threads of a process instead of just the
calling thread.

So replace do_exit(SIGSYS) with force_fatal_sig(SIGSYS) which
causes the signal handling to take it's normal path and work
as expected.

Cc: Andy Lutomirski <luto@kernel.org>
Link: https://lkml.kernel.org/r/20211020174406.17889-17-ebiederm@xmission.com
Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>
Cc: Thomas Backlund <tmb@iki.fi>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/entry/vsyscall/vsyscall_64.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/arch/x86/entry/vsyscall/vsyscall_64.c
+++ b/arch/x86/entry/vsyscall/vsyscall_64.c
@@ -226,7 +226,8 @@ bool emulate_vsyscall(unsigned long erro
 	if ((!tmp && regs->orig_ax != syscall_nr) || regs->ip != address) {
 		warn_bad_vsyscall(KERN_DEBUG, regs,
 				  "seccomp tried to change syscall nr or ip");
-		do_exit(SIGSYS);
+		force_fatal_sig(SIGSYS);
+		return true;
 	}
 	regs->orig_ax = -1;
 	if (tmp)


