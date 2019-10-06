Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 280F9CD79D
	for <lists+stable@lfdr.de>; Sun,  6 Oct 2019 20:02:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729561AbfJFRcY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 6 Oct 2019 13:32:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:58876 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729557AbfJFRcY (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 6 Oct 2019 13:32:24 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 22C822133F;
        Sun,  6 Oct 2019 17:32:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1570383143;
        bh=fjJrdjq9ByRxGdjY6wKrvDvBEtcNvBtzbjBhKXMgaT0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UzMuSkyD+PMAWEA7YppHXXThhuWfkFyXh+920M3jWGLioyfD5alQmpRge4i+BnnmI
         I0kpifbFPoDek2A4LQEOVQx9g6KdgS8KE1TfIyPEqB0ftgKLXqpT2LC4nnlQthjrm6
         KbgqopKPS/UOPdxckewjC4TWXWcKtTvVmLr5TOuU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jann Horn <jannh@google.com>,
        Casey Schaufler <casey@schaufler-ca.com>
Subject: [PATCH 4.19 102/106] Smack: Dont ignore other bprm->unsafe flags if LSM_UNSAFE_PTRACE is set
Date:   Sun,  6 Oct 2019 19:21:48 +0200
Message-Id: <20191006171204.088611292@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191006171124.641144086@linuxfoundation.org>
References: <20191006171124.641144086@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jann Horn <jannh@google.com>

commit 3675f052b43ba51b99b85b073c7070e083f3e6fb upstream.

There is a logic bug in the current smack_bprm_set_creds():
If LSM_UNSAFE_PTRACE is set, but the ptrace state is deemed to be
acceptable (e.g. because the ptracer detached in the meantime), the other
->unsafe flags aren't checked. As far as I can tell, this means that
something like the following could work (but I haven't tested it):

 - task A: create task B with fork()
 - task B: set NO_NEW_PRIVS
 - task B: install a seccomp filter that makes open() return 0 under some
   conditions
 - task B: replace fd 0 with a malicious library
 - task A: attach to task B with PTRACE_ATTACH
 - task B: execve() a file with an SMACK64EXEC extended attribute
 - task A: while task B is still in the middle of execve(), exit (which
   destroys the ptrace relationship)

Make sure that if any flags other than LSM_UNSAFE_PTRACE are set in
bprm->unsafe, we reject the execve().

Cc: stable@vger.kernel.org
Fixes: 5663884caab1 ("Smack: unify all ptrace accesses in the smack")
Signed-off-by: Jann Horn <jannh@google.com>
Signed-off-by: Casey Schaufler <casey@schaufler-ca.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 security/smack/smack_lsm.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/security/smack/smack_lsm.c
+++ b/security/smack/smack_lsm.c
@@ -947,7 +947,8 @@ static int smack_bprm_set_creds(struct l
 
 		if (rc != 0)
 			return rc;
-	} else if (bprm->unsafe)
+	}
+	if (bprm->unsafe & ~LSM_UNSAFE_PTRACE)
 		return -EPERM;
 
 	bsp->smk_task = isp->smk_task;


