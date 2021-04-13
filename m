Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5F1B235E371
	for <lists+stable@lfdr.de>; Tue, 13 Apr 2021 18:04:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346781AbhDMQEs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 13 Apr 2021 12:04:48 -0400
Received: from mail-ed1-f51.google.com ([209.85.208.51]:33755 "EHLO
        mail-ed1-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346791AbhDMQEM (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 13 Apr 2021 12:04:12 -0400
Received: by mail-ed1-f51.google.com with SMTP id w18so20091624edc.0
        for <stable@vger.kernel.org>; Tue, 13 Apr 2021 09:03:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kinvolk.io; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=3FvqmXbTPGrExPdYFPrOm7MfDEznWQ3cYJunL5tX4XI=;
        b=QnUaa/ObnOTdkd9TXid6IcrAuQRmrpANhQd/Cl/ecdkS4vV8JdhUGaB3TX1BaZEkJl
         OLPkpNcWWih05sUoZGIts+wX+ho3yP3gfTX24SzZEnp3WBBUiOxgJ7OBlJeQTJ9vufc4
         EeDy1jwWolYm8HcDn75LtEXjHw3X39ADV84RU=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=3FvqmXbTPGrExPdYFPrOm7MfDEznWQ3cYJunL5tX4XI=;
        b=I6Z92v6zW+/wr9F0BZ5TaKHb1TsfZc8Xvb8F+U+j8EFDZOxgDK8F7LXOLOG6NrzakC
         nUGqYyCCBegtf0tHtZ4kZTG2mU9c6ilyyvYDM3Dw1+R8QNIoBXJ0c29K8Gq4IeeNgx1X
         8y013iZScHMM6VO6A6Y80N/nzRfxolCb9FkEPim10FzgODLfsbtKqTfU+zkPp4GmSHZ3
         cDjJL4nPI+YbOC8nxY39owqsiiwXwluKdfMwZ2yNr+rlef5l08+gZ1HexG7Q5jQZKNaL
         U07DJfZoj4+3vhMlMDeb3vsCFjahmk3T2BFiMNgKM3VCF8HZcPn3OgfXsjI7j5XlQwB2
         wScQ==
X-Gm-Message-State: AOAM530etTLfp2kkOHu8d+KvKqcem6XpYan0piEZp4oWjvxBep2mkWfS
        2BpnMYd2tM/oK9wJOOo+NlO0Hg==
X-Google-Smtp-Source: ABdhPJxiZ+44bDa0LRDztD06kkg+VeqXHdVoBjsBPwk4/EjYsZpLyi+eafqUP7UkUkNMecAXtkdv2A==
X-Received: by 2002:a50:82e5:: with SMTP id 92mr263078edg.141.1618329772096;
        Tue, 13 Apr 2021 09:02:52 -0700 (PDT)
Received: from localhost.localdomain ([2a02:8109:9880:57f0:ba7c:cdd5:fff7:623c])
        by smtp.gmail.com with ESMTPSA id gb4sm8162852ejc.122.2021.04.13.09.02.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 13 Apr 2021 09:02:51 -0700 (PDT)
From:   Rodrigo Campos <rodrigo@kinvolk.io>
To:     Kees Cook <keescook@chromium.org>,
        Andy Lutomirski <luto@amacapital.net>,
        Will Drewry <wad@chromium.org>, linux-kernel@vger.kernel.org,
        containers@lists.linux-foundation.org
Cc:     Rodrigo Campos <rodrigo@kinvolk.io>,
        Sargun Dhillon <sargun@sargun.me>,
        =?UTF-8?q?Mauricio=20V=C3=A1squez=20Bernal?= <mauricio@kinvolk.io>,
        Alban Crequy <alban@kinvolk.io>, stable@vger.kernel.org
Subject: [PATCH 1/1] seccomp: Always "goto wait" if the list is empty
Date:   Tue, 13 Apr 2021 18:01:51 +0200
Message-Id: <20210413160151.3301-2-rodrigo@kinvolk.io>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210413160151.3301-1-rodrigo@kinvolk.io>
References: <20210413160151.3301-1-rodrigo@kinvolk.io>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

It is possible for the thread with the seccomp filter attached (target)
to be waken up by an addfd message, but the list be empty. This happens
when the addfd ioctl on the other side (seccomp agent) is interrupted by
a signal such as SIGURG. In that case, the target erroneously and
prematurely returns from the syscall to userspace even though the
seccomp agent didn't ask for it.

This happens in the following scenario:

seccomp_notify_addfd()                                           | seccomp_do_user_notification()
                                                                 |
                                                                 |  err = wait_for_completion_interruptible(&n.ready);
 complete(&knotif->ready);                                       |
 ret = wait_for_completion_interruptible(&kaddfd.completion);    |
 // interrupted                                                  |
                                                                 |
 mutex_lock(&filter->notify_lock);                               |
 list_del(&kaddfd.list);                                         |
 mutex_unlock(&filter->notify_lock);                             |
                                                                 |  mutex_lock(&match->notify_lock);
                                                                 |  // This is false, addfd is false
                                                                 |  if (addfd && n.state != SECCOMP_NOTIFY_REPLIED)
                                                                 |
                                                                 |  ret = n.val;
                                                                 |  err = n.error;
                                                                 |  flags = n.flags;

So, the process blocked in seccomp_do_user_notification() will see a
response. As n is 0 initialized and wasn't set, it will see a 0 as
return value from the syscall.

The seccomp agent, when retrying the interrupted syscall, will see an
ENOENT error as the notification no longer exists (it was already
answered by this bug).

This patch fixes the issue by splitting the if in two parts: if we were
woken up and the state is not replied, we will always do a "goto wait".
And if that happens and there is an addfd element on the list, we will
add the fd before "goto wait".

This issue is present since 5.9, when addfd was added.

Fixes: 7cf97b1254550
Cc: stable@vger.kernel.org # 5.9+
Signed-off-by: Rodrigo Campos <rodrigo@kinvolk.io>
---
 kernel/seccomp.c | 19 ++++++++++++++-----
 1 file changed, 14 insertions(+), 5 deletions(-)

diff --git a/kernel/seccomp.c b/kernel/seccomp.c
index 63b40d12896b..1b34598f0e07 100644
--- a/kernel/seccomp.c
+++ b/kernel/seccomp.c
@@ -1107,11 +1107,20 @@ static int seccomp_do_user_notification(int this_syscall,
 	err = wait_for_completion_interruptible(&n.ready);
 	mutex_lock(&match->notify_lock);
 	if (err == 0) {
-		/* Check if we were woken up by a addfd message */
-		addfd = list_first_entry_or_null(&n.addfd,
-						 struct seccomp_kaddfd, list);
-		if (addfd && n.state != SECCOMP_NOTIFY_REPLIED) {
-			seccomp_handle_addfd(addfd);
+
+		if (n.state != SECCOMP_NOTIFY_REPLIED) {
+			/*
+			 * It is possible to be waken-up by an addfd message but
+			 * the list be empty. This can happen if the addfd
+			 * ioctl() is interrupted, as it deletes the element.
+			 *
+			 * So, check if indeed there is an element in the list.
+			 */
+			addfd = list_first_entry_or_null(&n.addfd,
+							 struct seccomp_kaddfd, list);
+			if (addfd)
+				seccomp_handle_addfd(addfd);
+
 			mutex_unlock(&match->notify_lock);
 			goto wait;
 		}
-- 
2.30.2

