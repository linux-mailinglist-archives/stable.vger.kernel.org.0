Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 388D211B141
	for <lists+stable@lfdr.de>; Wed, 11 Dec 2019 16:30:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387647AbfLKP3w (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 11 Dec 2019 10:29:52 -0500
Received: from mail.kernel.org ([198.145.29.99]:36596 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387925AbfLKP3g (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 11 Dec 2019 10:29:36 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 555142465B;
        Wed, 11 Dec 2019 15:29:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576078175;
        bh=IpzqZ8U2q1cIKIIYL06rQOFBJOT+/SNNiKO5NCgdzgY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0OQ8oQtfkok95UgRMhau9VaKNBP/bUd6S0W0nDNulOuBk0UScPC00KoHk3/bH/WBZ
         GqyGBftl3p/+vSuyq6Uhp4kgQqRPHA7k4wjb+dF24v0qBNjZkOOpEXdaje1+CH1oSB
         hWRkUG9wk0hn5FWx05w0LNJ1ygPf8XemjYdMqBfA=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Mike Rapoport <rppt@linux.ibm.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Daniel Colascione <dancol@google.com>,
        Jann Horn <jannh@google.com>,
        Lokesh Gidra <lokeshgidra@google.com>,
        Nick Kralevich <nnk@google.com>,
        Nosh Minwalla <nosh@google.com>,
        Pavel Emelyanov <ovzxemul@gmail.com>,
        Tim Murray <timmurray@google.com>,
        Aleksa Sarai <cyphar@cyphar.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Sasha Levin <sashal@kernel.org>, linux-fsdevel@vger.kernel.org
Subject: [PATCH AUTOSEL 4.14 58/58] userfaultfd: require CAP_SYS_PTRACE for UFFD_FEATURE_EVENT_FORK
Date:   Wed, 11 Dec 2019 10:28:31 -0500
Message-Id: <20191211152831.23507-58-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191211152831.23507-1-sashal@kernel.org>
References: <20191211152831.23507-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mike Rapoport <rppt@linux.ibm.com>

[ Upstream commit 3c1c24d91ffd536de0a64688a9df7f49e58fadbc ]

A while ago Andy noticed
(http://lkml.kernel.org/r/CALCETrWY+5ynDct7eU_nDUqx=okQvjm=Y5wJvA4ahBja=CQXGw@mail.gmail.com)
that UFFD_FEATURE_EVENT_FORK used by an unprivileged user may have
security implications.

As the first step of the solution the following patch limits the availably
of UFFD_FEATURE_EVENT_FORK only for those having CAP_SYS_PTRACE.

The usage of CAP_SYS_PTRACE ensures compatibility with CRIU.

Yet, if there are other users of non-cooperative userfaultfd that run
without CAP_SYS_PTRACE, they would be broken :(

Current implementation of UFFD_FEATURE_EVENT_FORK modifies the file
descriptor table from the read() implementation of uffd, which may have
security implications for unprivileged use of the userfaultfd.

Limit availability of UFFD_FEATURE_EVENT_FORK only for callers that have
CAP_SYS_PTRACE.

Link: http://lkml.kernel.org/r/1572967777-8812-2-git-send-email-rppt@linux.ibm.com
Signed-off-by: Mike Rapoport <rppt@linux.ibm.com>
Reviewed-by: Andrea Arcangeli <aarcange@redhat.com>
Cc: Daniel Colascione <dancol@google.com>
Cc: Jann Horn <jannh@google.com>
Cc: Lokesh Gidra <lokeshgidra@google.com>
Cc: Nick Kralevich <nnk@google.com>
Cc: Nosh Minwalla <nosh@google.com>
Cc: Pavel Emelyanov <ovzxemul@gmail.com>
Cc: Tim Murray <timmurray@google.com>
Cc: Aleksa Sarai <cyphar@cyphar.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/userfaultfd.c | 18 +++++++++++-------
 1 file changed, 11 insertions(+), 7 deletions(-)

diff --git a/fs/userfaultfd.c b/fs/userfaultfd.c
index a609d480606da..e2b2196fd9428 100644
--- a/fs/userfaultfd.c
+++ b/fs/userfaultfd.c
@@ -1807,13 +1807,12 @@ static int userfaultfd_api(struct userfaultfd_ctx *ctx,
 	if (copy_from_user(&uffdio_api, buf, sizeof(uffdio_api)))
 		goto out;
 	features = uffdio_api.features;
-	if (uffdio_api.api != UFFD_API || (features & ~UFFD_API_FEATURES)) {
-		memset(&uffdio_api, 0, sizeof(uffdio_api));
-		if (copy_to_user(buf, &uffdio_api, sizeof(uffdio_api)))
-			goto out;
-		ret = -EINVAL;
-		goto out;
-	}
+	ret = -EINVAL;
+	if (uffdio_api.api != UFFD_API || (features & ~UFFD_API_FEATURES))
+		goto err_out;
+	ret = -EPERM;
+	if ((features & UFFD_FEATURE_EVENT_FORK) && !capable(CAP_SYS_PTRACE))
+		goto err_out;
 	/* report all available features and ioctls to userland */
 	uffdio_api.features = UFFD_API_FEATURES;
 	uffdio_api.ioctls = UFFD_API_IOCTLS;
@@ -1826,6 +1825,11 @@ static int userfaultfd_api(struct userfaultfd_ctx *ctx,
 	ret = 0;
 out:
 	return ret;
+err_out:
+	memset(&uffdio_api, 0, sizeof(uffdio_api));
+	if (copy_to_user(buf, &uffdio_api, sizeof(uffdio_api)))
+		ret = -EFAULT;
+	goto out;
 }
 
 static long userfaultfd_ioctl(struct file *file, unsigned cmd,
-- 
2.20.1

