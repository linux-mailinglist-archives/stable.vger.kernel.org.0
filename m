Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 466676B808C
	for <lists+stable@lfdr.de>; Mon, 13 Mar 2023 19:30:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230499AbjCMSaY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Mar 2023 14:30:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33852 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230429AbjCMSaQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Mar 2023 14:30:16 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4044A1CAE8;
        Mon, 13 Mar 2023 11:29:50 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id DFA256147F;
        Mon, 13 Mar 2023 18:29:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 43167C433EF;
        Mon, 13 Mar 2023 18:29:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1678732178;
        bh=jtR/7qjQA06Y1v8Tn9wjFdP2xd72RupgUIhnR4S+y44=;
        h=Date:To:From:Subject:From;
        b=waZvZPurAPEzoOOFqHfsGidUQacnegBmsds3Gp5lB3IAh8tMz0tVniTerP7OvdsJa
         uo59dq9/FH5YzZlmr9kv0f6QkXP+mJ3CE3wKrZfz4oYcAZjOhYW5E76xnMpFK3ZL3d
         En555jU3gkG1hyT9APd5cqJt3rGRCL4ORs85VAWQ=
Date:   Mon, 13 Mar 2023 11:29:37 -0700
To:     mm-commits@vger.kernel.org, stable@vger.kernel.org,
        ebiederm@xmission.com, omosnace@redhat.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + kernel-sysc-fix-and-improve-control-flow-in-__sys_setresid.patch added to mm-nonmm-unstable branch
Message-Id: <20230313182938.43167C433EF@smtp.kernel.org>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch titled
     Subject: kernel/sys.c: fix and improve control flow in __sys_setres[ug]id()
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     kernel-sysc-fix-and-improve-control-flow-in-__sys_setresid.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/kernel-sysc-fix-and-improve-control-flow-in-__sys_setresid.patch

This patch will later appear in the mm-nonmm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: Ondrej Mosnacek <omosnace@redhat.com>
Subject: kernel/sys.c: fix and improve control flow in __sys_setres[ug]id()
Date: Fri, 17 Feb 2023 17:21:54 +0100

Linux Security Modules (LSMs) that implement the "capable" hook will
usually emit an access denial message to the audit log whenever they
"block" the current task from using the given capability based on their
security policy.

The occurrence of a denial is used as an indication that the given task
has attempted an operation that requires the given access permission, so
the callers of functions that perform LSM permission checks must take care
to avoid calling them too early (before it is decided if the permission is
actually needed to perform the requested operation).

The __sys_setres[ug]id() functions violate this convention by first
calling ns_capable_setid() and only then checking if the operation
requires the capability or not.  It means that any caller that has the
capability granted by DAC (task's capability set) but not by MAC (LSMs)
will generate a "denied" audit record, even if is doing an operation for
which the capability is not required.

Fix this by reordering the checks such that ns_capable_setid() is checked
last and -EPERM is returned immediately if it returns false.

While there, also do two small optimizations:
* move the capability check before prepare_creds() and
* bail out early in case of a no-op.

Link: https://lkml.kernel.org/r/20230217162154.837549-1-omosnace@redhat.com
Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Signed-off-by: Ondrej Mosnacek <omosnace@redhat.com>
Cc: Eric W. Biederman <ebiederm@xmission.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


--- a/kernel/sys.c~kernel-sysc-fix-and-improve-control-flow-in-__sys_setresid
+++ a/kernel/sys.c
@@ -665,6 +665,7 @@ long __sys_setresuid(uid_t ruid, uid_t e
 	struct cred *new;
 	int retval;
 	kuid_t kruid, keuid, ksuid;
+	bool ruid_new, euid_new, suid_new;
 
 	kruid = make_kuid(ns, ruid);
 	keuid = make_kuid(ns, euid);
@@ -679,25 +680,29 @@ long __sys_setresuid(uid_t ruid, uid_t e
 	if ((suid != (uid_t) -1) && !uid_valid(ksuid))
 		return -EINVAL;
 
+	old = current_cred();
+
+	/* check for no-op */
+	if ((ruid == (uid_t) -1 || uid_eq(kruid, old->uid)) &&
+	    (euid == (uid_t) -1 || (uid_eq(keuid, old->euid) &&
+				    uid_eq(keuid, old->fsuid))) &&
+	    (suid == (uid_t) -1 || uid_eq(ksuid, old->suid)))
+		return 0;
+
+	ruid_new = ruid != (uid_t) -1        && !uid_eq(kruid, old->uid) &&
+		   !uid_eq(kruid, old->euid) && !uid_eq(kruid, old->suid);
+	euid_new = euid != (uid_t) -1        && !uid_eq(keuid, old->uid) &&
+		   !uid_eq(keuid, old->euid) && !uid_eq(keuid, old->suid);
+	suid_new = suid != (uid_t) -1        && !uid_eq(ksuid, old->uid) &&
+		   !uid_eq(ksuid, old->euid) && !uid_eq(ksuid, old->suid);
+	if ((ruid_new || euid_new || suid_new) &&
+	    !ns_capable_setid(old->user_ns, CAP_SETUID))
+		return -EPERM;
+
 	new = prepare_creds();
 	if (!new)
 		return -ENOMEM;
 
-	old = current_cred();
-
-	retval = -EPERM;
-	if (!ns_capable_setid(old->user_ns, CAP_SETUID)) {
-		if (ruid != (uid_t) -1        && !uid_eq(kruid, old->uid) &&
-		    !uid_eq(kruid, old->euid) && !uid_eq(kruid, old->suid))
-			goto error;
-		if (euid != (uid_t) -1        && !uid_eq(keuid, old->uid) &&
-		    !uid_eq(keuid, old->euid) && !uid_eq(keuid, old->suid))
-			goto error;
-		if (suid != (uid_t) -1        && !uid_eq(ksuid, old->uid) &&
-		    !uid_eq(ksuid, old->euid) && !uid_eq(ksuid, old->suid))
-			goto error;
-	}
-
 	if (ruid != (uid_t) -1) {
 		new->uid = kruid;
 		if (!uid_eq(kruid, old->uid)) {
@@ -762,6 +767,7 @@ long __sys_setresgid(gid_t rgid, gid_t e
 	struct cred *new;
 	int retval;
 	kgid_t krgid, kegid, ksgid;
+	bool rgid_new, egid_new, sgid_new;
 
 	krgid = make_kgid(ns, rgid);
 	kegid = make_kgid(ns, egid);
@@ -774,23 +780,28 @@ long __sys_setresgid(gid_t rgid, gid_t e
 	if ((sgid != (gid_t) -1) && !gid_valid(ksgid))
 		return -EINVAL;
 
+	old = current_cred();
+
+	/* check for no-op */
+	if ((rgid == (gid_t) -1 || gid_eq(krgid, old->gid)) &&
+	    (egid == (gid_t) -1 || (gid_eq(kegid, old->egid) &&
+				    gid_eq(kegid, old->fsgid))) &&
+	    (sgid == (gid_t) -1 || gid_eq(ksgid, old->sgid)))
+		return 0;
+
+	rgid_new = rgid != (gid_t) -1        && !gid_eq(krgid, old->gid) &&
+		   !gid_eq(krgid, old->egid) && !gid_eq(krgid, old->sgid);
+	egid_new = egid != (gid_t) -1        && !gid_eq(kegid, old->gid) &&
+		   !gid_eq(kegid, old->egid) && !gid_eq(kegid, old->sgid);
+	sgid_new = sgid != (gid_t) -1        && !gid_eq(ksgid, old->gid) &&
+		   !gid_eq(ksgid, old->egid) && !gid_eq(ksgid, old->sgid);
+	if ((rgid_new || egid_new || sgid_new) &&
+	    !ns_capable_setid(old->user_ns, CAP_SETGID))
+		return -EPERM;
+
 	new = prepare_creds();
 	if (!new)
 		return -ENOMEM;
-	old = current_cred();
-
-	retval = -EPERM;
-	if (!ns_capable_setid(old->user_ns, CAP_SETGID)) {
-		if (rgid != (gid_t) -1        && !gid_eq(krgid, old->gid) &&
-		    !gid_eq(krgid, old->egid) && !gid_eq(krgid, old->sgid))
-			goto error;
-		if (egid != (gid_t) -1        && !gid_eq(kegid, old->gid) &&
-		    !gid_eq(kegid, old->egid) && !gid_eq(kegid, old->sgid))
-			goto error;
-		if (sgid != (gid_t) -1        && !gid_eq(ksgid, old->gid) &&
-		    !gid_eq(ksgid, old->egid) && !gid_eq(ksgid, old->sgid))
-			goto error;
-	}
 
 	if (rgid != (gid_t) -1)
 		new->gid = krgid;
_

Patches currently in -mm which might be from omosnace@redhat.com are

kernel-sysc-fix-and-improve-control-flow-in-__sys_setresid.patch

