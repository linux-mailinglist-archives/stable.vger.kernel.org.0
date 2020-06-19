Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 926CD201070
	for <lists+stable@lfdr.de>; Fri, 19 Jun 2020 17:31:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2393719AbgFSPa2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Jun 2020 11:30:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:34304 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2393479AbgFSPa2 (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 19 Jun 2020 11:30:28 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9513A20757;
        Fri, 19 Jun 2020 15:30:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592580627;
        bh=r6EliizRfhM4+8HlSDWbsKnzlj+GEis6zN/fAjxUXHM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NJvT+V7aL39BEY01z8CnXTiY4qCQCZ1Ur2sb88rDpdFd+HX6wY3pTsiJvFst6xlT0
         zYMRLdbPrwP/FfooXJAClKCWEzaM/RLFAjAUZFMMl9MMPR1ofW87dGxe7olp7ViLYY
         7aFriK4v39MnybTkKor9N7YW39xW40m3CZM1ZblQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, stable@kernel.org,
        Al Viro <viro@zeniv.linux.org.uk>
Subject: [PATCH 5.7 322/376] sparc64: fix misuses of access_process_vm() in genregs32_[sg]et()
Date:   Fri, 19 Jun 2020 16:34:00 +0200
Message-Id: <20200619141725.573811905@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200619141710.350494719@linuxfoundation.org>
References: <20200619141710.350494719@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Al Viro <viro@zeniv.linux.org.uk>

commit 142cd25293f6a7ecbdff4fb0af17de6438d46433 upstream.

We do need access_process_vm() to access the target's reg_window.
However, access to caller's memory (storing the result in
genregs32_get(), fetching the new values in case of genregs32_set())
should be done by normal uaccess primitives.

Fixes: ad4f95764040 ([SPARC64]: Fix user accesses in regset code.)
Cc: stable@kernel.org
Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/sparc/kernel/ptrace_64.c |   17 +++--------------
 1 file changed, 3 insertions(+), 14 deletions(-)

--- a/arch/sparc/kernel/ptrace_64.c
+++ b/arch/sparc/kernel/ptrace_64.c
@@ -572,19 +572,13 @@ static int genregs32_get(struct task_str
 			for (; count > 0 && pos < 32; count--) {
 				if (access_process_vm(target,
 						      (unsigned long)
-						      &reg_window[pos],
+						      &reg_window[pos++],
 						      &reg, sizeof(reg),
 						      FOLL_FORCE)
 				    != sizeof(reg))
 					return -EFAULT;
-				if (access_process_vm(target,
-						      (unsigned long) u,
-						      &reg, sizeof(reg),
-						      FOLL_FORCE | FOLL_WRITE)
-				    != sizeof(reg))
+				if (put_user(reg, u++))
 					return -EFAULT;
-				pos++;
-				u++;
 			}
 		}
 	}
@@ -684,12 +678,7 @@ static int genregs32_set(struct task_str
 			}
 		} else {
 			for (; count > 0 && pos < 32; count--) {
-				if (access_process_vm(target,
-						      (unsigned long)
-						      u,
-						      &reg, sizeof(reg),
-						      FOLL_FORCE)
-				    != sizeof(reg))
+				if (get_user(reg, u++))
 					return -EFAULT;
 				if (access_process_vm(target,
 						      (unsigned long)


