Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9816641748E
	for <lists+stable@lfdr.de>; Fri, 24 Sep 2021 15:07:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345865AbhIXNH0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 Sep 2021 09:07:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:36370 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1346141AbhIXNEs (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 24 Sep 2021 09:04:48 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7120C6147F;
        Fri, 24 Sep 2021 12:55:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1632488141;
        bh=cIXcfOR/+TOXHdp4afKzggIE4Kwl4Z3ap5N5DS2DPoE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mkCEleZ+BOLoP0l7TLuQeT5hx6yPwclrzEMrzx73vTBCRoNy/Ymcse/s8ESB1iCP+
         0G6Jt1h1RMuVZ0/cufo3rzSxObKxVu/x366qMFfeLDt5dxV+ZJfuoxDWsZ5qA41paK
         /xsDYuJ0Puuuo2y49A9My9okRsC3sS8skadufbHk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jann Horn <jannh@google.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Casey Schaufler <casey@schaufler-ca.com>,
        Paul Moore <paul@paul-moore.com>
Subject: [PATCH 5.14 099/100] selinux,smack: fix subjective/objective credential use mixups
Date:   Fri, 24 Sep 2021 14:44:48 +0200
Message-Id: <20210924124344.807935067@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210924124341.214446495@linuxfoundation.org>
References: <20210924124341.214446495@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Paul Moore <paul@paul-moore.com>

commit a3727a8bac0a9e77c70820655fd8715523ba3db7 upstream.

Jann Horn reported a problem with commit eb1231f73c4d ("selinux:
clarify task subjective and objective credentials") where some LSM
hooks were attempting to access the subjective credentials of a task
other than the current task.  Generally speaking, it is not safe to
access another task's subjective credentials and doing so can cause
a number of problems.

Further, while looking into the problem, I realized that Smack was
suffering from a similar problem brought about by a similar commit
1fb057dcde11 ("smack: differentiate between subjective and objective
task credentials").

This patch addresses this problem by restoring the use of the task's
objective credentials in those cases where the task is other than the
current executing task.  Not only does this resolve the problem
reported by Jann, it is arguably the correct thing to do in these
cases.

Cc: stable@vger.kernel.org
Fixes: eb1231f73c4d ("selinux: clarify task subjective and objective credentials")
Fixes: 1fb057dcde11 ("smack: differentiate between subjective and objective task credentials")
Reported-by: Jann Horn <jannh@google.com>
Acked-by: Eric W. Biederman <ebiederm@xmission.com>
Acked-by: Casey Schaufler <casey@schaufler-ca.com>
Signed-off-by: Paul Moore <paul@paul-moore.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 security/selinux/hooks.c   |    4 ++--
 security/smack/smack_lsm.c |    4 ++--
 2 files changed, 4 insertions(+), 4 deletions(-)

--- a/security/selinux/hooks.c
+++ b/security/selinux/hooks.c
@@ -2155,7 +2155,7 @@ static int selinux_ptrace_access_check(s
 static int selinux_ptrace_traceme(struct task_struct *parent)
 {
 	return avc_has_perm(&selinux_state,
-			    task_sid_subj(parent), task_sid_obj(current),
+			    task_sid_obj(parent), task_sid_obj(current),
 			    SECCLASS_PROCESS, PROCESS__PTRACE, NULL);
 }
 
@@ -6218,7 +6218,7 @@ static int selinux_msg_queue_msgrcv(stru
 	struct ipc_security_struct *isec;
 	struct msg_security_struct *msec;
 	struct common_audit_data ad;
-	u32 sid = task_sid_subj(target);
+	u32 sid = task_sid_obj(target);
 	int rc;
 
 	isec = selinux_ipc(msq);
--- a/security/smack/smack_lsm.c
+++ b/security/smack/smack_lsm.c
@@ -2016,7 +2016,7 @@ static int smk_curacc_on_task(struct tas
 				const char *caller)
 {
 	struct smk_audit_info ad;
-	struct smack_known *skp = smk_of_task_struct_subj(p);
+	struct smack_known *skp = smk_of_task_struct_obj(p);
 	int rc;
 
 	smk_ad_init(&ad, caller, LSM_AUDIT_DATA_TASK);
@@ -3480,7 +3480,7 @@ static void smack_d_instantiate(struct d
  */
 static int smack_getprocattr(struct task_struct *p, char *name, char **value)
 {
-	struct smack_known *skp = smk_of_task_struct_subj(p);
+	struct smack_known *skp = smk_of_task_struct_obj(p);
 	char *cp;
 	int slen;
 


