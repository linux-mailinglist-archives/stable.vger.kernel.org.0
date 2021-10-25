Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 41EF743A2AD
	for <lists+stable@lfdr.de>; Mon, 25 Oct 2021 21:48:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236921AbhJYTvB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 25 Oct 2021 15:51:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:38048 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238490AbhJYTs7 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 25 Oct 2021 15:48:59 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E9923610FD;
        Mon, 25 Oct 2021 19:41:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1635190877;
        bh=H2o8Q1nEAydlrH9P21o8OMrE5YHfgY6l6ep9qgXcRXg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gPlUvNYDtPshP9nKCoHp4DQmSSMRVuDSwVbKIZeBh2XVvPQW2PM0WfJRAG7/7+q3H
         UPtnIHzn8g4JLlE7N/MESz7l8xENe5F+Nf7SPKsXpAXJuTqq/xm0r8Pla+LHl9K0O9
         OYHJ6/2miavJfteqC4FE3Y592Wr76RqfB88CMBHU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Yu Zhao <yuzhao@google.com>,
        Alexey Gladkov <legion@kernel.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>
Subject: [PATCH 5.14 093/169] ucounts: Move get_ucounts from cred_alloc_blank to key_change_session_keyring
Date:   Mon, 25 Oct 2021 21:14:34 +0200
Message-Id: <20211025191029.202567156@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211025191017.756020307@linuxfoundation.org>
References: <20211025191017.756020307@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Eric W. Biederman <ebiederm@xmission.com>

commit 5ebcbe342b1c12fae44b4f83cbeae1520e09857e upstream.

Setting cred->ucounts in cred_alloc_blank does not make sense.  The
uid and user_ns are deliberately not set in cred_alloc_blank but
instead the setting is delayed until key_change_session_keyring.

So move dealing with ucounts into key_change_session_keyring as well.

Unfortunately that movement of get_ucounts adds a new failure mode to
key_change_session_keyring.  I do not see anything stopping the parent
process from calling setuid and changing the relevant part of it's
cred while keyctl_session_to_parent is running making it fundamentally
necessary to call get_ucounts in key_change_session_keyring.  Which
means that the new failure mode cannot be avoided.

A failure of key_change_session_keyring results in a single threaded
parent keeping it's existing credentials.  Which results in the parent
process not being able to access the session keyring and whichever
keys are in the new keyring.

Further get_ucounts is only expected to fail if the number of bits in
the refernece count for the structure is too few.

Since the code has no other way to report the failure of get_ucounts
and because such failures are not expected to be common add a WARN_ONCE
to report this problem to userspace.

Between the WARN_ONCE and the parent process not having access to
the keys in the new session keyring I expect any failure of get_ucounts
will be noticed and reported and we can find another way to handle this
condition.  (Possibly by just making ucounts->count an atomic_long_t).

Cc: stable@vger.kernel.org
Fixes: 905ae01c4ae2 ("Add a reference to ucounts for each cred")
Link: https://lkml.kernel.org/r/7k0ias0uf.fsf_-_@disp2133
Tested-by: Yu Zhao <yuzhao@google.com>
Reviewed-by: Alexey Gladkov <legion@kernel.org>
Signed-off-by: "Eric W. Biederman" <ebiederm@xmission.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/cred.c                |    2 --
 security/keys/process_keys.c |    8 ++++++++
 2 files changed, 8 insertions(+), 2 deletions(-)

--- a/kernel/cred.c
+++ b/kernel/cred.c
@@ -225,8 +225,6 @@ struct cred *cred_alloc_blank(void)
 #ifdef CONFIG_DEBUG_CREDENTIALS
 	new->magic = CRED_MAGIC;
 #endif
-	new->ucounts = get_ucounts(&init_ucounts);
-
 	if (security_cred_alloc_blank(new, GFP_KERNEL_ACCOUNT) < 0)
 		goto error;
 
--- a/security/keys/process_keys.c
+++ b/security/keys/process_keys.c
@@ -918,6 +918,13 @@ void key_change_session_keyring(struct c
 		return;
 	}
 
+	/* If get_ucounts fails more bits are needed in the refcount */
+	if (unlikely(!get_ucounts(old->ucounts))) {
+		WARN_ONCE(1, "In %s get_ucounts failed\n", __func__);
+		put_cred(new);
+		return;
+	}
+
 	new->  uid	= old->  uid;
 	new-> euid	= old-> euid;
 	new-> suid	= old-> suid;
@@ -927,6 +934,7 @@ void key_change_session_keyring(struct c
 	new-> sgid	= old-> sgid;
 	new->fsgid	= old->fsgid;
 	new->user	= get_uid(old->user);
+	new->ucounts	= old->ucounts;
 	new->user_ns	= get_user_ns(old->user_ns);
 	new->group_info	= get_group_info(old->group_info);
 


