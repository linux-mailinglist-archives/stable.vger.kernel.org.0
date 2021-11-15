Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 98F52451E67
	for <lists+stable@lfdr.de>; Tue, 16 Nov 2021 01:33:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241745AbhKPAf4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 19:35:56 -0500
Received: from mail.kernel.org ([198.145.29.99]:45126 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1344862AbhKOTZh (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 14:25:37 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7223D633EB;
        Mon, 15 Nov 2021 19:05:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637003151;
        bh=kqC7wm5U/eyXb96o6R6unWTUlZ1GOF9YecKSLu0H5xA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=I3NZ6hQFAy1EM+vCjovYe4ZUHla4ykkqvJUXjX6kFBKJ1C0JqiB/GLz8OhjQMfOiv
         PExXTjntXsiup6RGCDjrfOFfzg6r+GNCPJo2DzBaPIbOJBqkCwXhkFm1AW3u8gTk7f
         FvTNX0EAQE/sPpvF7lnguX1u3+4auZEyb6+nBeZ4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Andrew Halaney <ahalaney@redhat.com>,
        "Steven Rostedt (VMware)" <rostedt@goodmis.org>,
        Randy Dunlap <rdunlap@infradead.org>,
        Borislav Petkov <bp@suse.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 829/917] init: make unknown command line param message clearer
Date:   Mon, 15 Nov 2021 18:05:24 +0100
Message-Id: <20211115165457.161900345@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211115165428.722074685@linuxfoundation.org>
References: <20211115165428.722074685@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Andrew Halaney <ahalaney@redhat.com>

[ Upstream commit 8bc2b3dca7292347d8e715fb723c587134abe013 ]

The prior message is confusing users, which is the exact opposite of the
goal.  If the message is being seen, one of the following situations is
happening:

 1. the param is misspelled
 2. the param is not valid due to the kernel configuration
 3. the param is intended for init but isn't after the '--'
    delineator on the command line

To make that more clear to the user, explicitly mention "kernel command
line" and also note that the params are still passed to user space to
avoid causing any alarm over params intended for init.

Link: https://lkml.kernel.org/r/20211013223502.96756-1-ahalaney@redhat.com
Fixes: 86d1919a4fb0 ("init: print out unknown kernel parameters")
Signed-off-by: Andrew Halaney <ahalaney@redhat.com>
Suggested-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
Acked-by: Randy Dunlap <rdunlap@infradead.org>
Cc: Borislav Petkov <bp@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 init/main.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/init/main.c b/init/main.c
index 3c4054a955458..bcd132d4e7bdd 100644
--- a/init/main.c
+++ b/init/main.c
@@ -924,7 +924,9 @@ static void __init print_unknown_bootoptions(void)
 	for (p = &envp_init[2]; *p; p++)
 		end += sprintf(end, " %s", *p);
 
-	pr_notice("Unknown command line parameters:%s\n", unknown_options);
+	/* Start at unknown_options[1] to skip the initial space */
+	pr_notice("Unknown kernel command line parameters \"%s\", will be passed to user space.\n",
+		&unknown_options[1]);
 	memblock_free_ptr(unknown_options, len);
 }
 
-- 
2.33.0



