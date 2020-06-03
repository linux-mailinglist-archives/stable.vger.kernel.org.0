Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 588A01EC683
	for <lists+stable@lfdr.de>; Wed,  3 Jun 2020 03:14:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728449AbgFCBNz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 2 Jun 2020 21:13:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46050 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728377AbgFCBNk (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 2 Jun 2020 21:13:40 -0400
Received: from mail-pf1-x442.google.com (mail-pf1-x442.google.com [IPv6:2607:f8b0:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B411CC08C5C1
        for <stable@vger.kernel.org>; Tue,  2 Jun 2020 18:13:40 -0700 (PDT)
Received: by mail-pf1-x442.google.com with SMTP id b16so395839pfi.13
        for <stable@vger.kernel.org>; Tue, 02 Jun 2020 18:13:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=sargun.me; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=nhWgywlp7hGFzT3uDr0Y1hpZYhM+popoEVRUKB4VQWc=;
        b=KcuhYU82+vDQQx/DeVCMpJeN14+0ym8WxhWxeXEkaQ+3yezTYF4Ee5fw/subrNMumN
         KyeAfCGCmRn0kJMIhZMcogDXCSfT+sBBqmi7wdOtjgBK8yInPiCqMLFgrVCWXL2KYFXQ
         wAigHdmOLJYq7IXym1xyUJRMKY8oH/Rez9kpo=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=nhWgywlp7hGFzT3uDr0Y1hpZYhM+popoEVRUKB4VQWc=;
        b=NtHtwCurAVq88liNqFuXjJUn4DwjU2oiSeisCMoXS4rqN7YPHmq0xjao/Ju7QuIM1G
         GcMgfy2g44lRG6P8F3ZsRKTuibbL90nw6s1VT9yBsVogGSFSCyTzPwBVfIpl+XsD75z3
         G8audWHPCMZoKzAu9vD3B9DIagQ6m4RaRMD0kb1PVxFtg0wrokbCec1GVm64UDta1Hf2
         cwpzH1UwpnPFTD56C3U2SonGHJA6rs1exzBqO/ijlo+Bp3rQyCix7o9ZFKo4wFLe812K
         Gkzo+IgkJw0bNXdfsOUAHR82J57iA4GII7HbC7E/byJDMOX7lX1z4oEGYmuAZfiYe1oX
         C9iw==
X-Gm-Message-State: AOAM530QHVtOCasG+8+zGIFjMua3i/UXbcBIUT4ptJAoWd8/+cJg70CQ
        BQCGLPOJsQqoKUbDyrCxN1tMNQ==
X-Google-Smtp-Source: ABdhPJziu0Ir+oIrvYqeFGcbFb1EEVntTRUVR8VaEiMPDVEUmaVr/EmBGAHwManIvwfanKgve0+dwg==
X-Received: by 2002:a17:90a:7bcb:: with SMTP id d11mr2287916pjl.209.1591146820050;
        Tue, 02 Jun 2020 18:13:40 -0700 (PDT)
Received: from ubuntu.netflix.com (203.20.25.136.in-addr.arpa. [136.25.20.203])
        by smtp.gmail.com with ESMTPSA id a12sm263222pjw.35.2020.06.02.18.13.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 02 Jun 2020 18:13:39 -0700 (PDT)
From:   Sargun Dhillon <sargun@sargun.me>
To:     Kees Cook <keescook@chromium.org>, linux-kernel@vger.kernel.org
Cc:     Sargun Dhillon <sargun@sargun.me>, Tycho Andersen <tycho@tycho.ws>,
        Matt Denton <mpdenton@google.com>,
        Jann Horn <jannh@google.com>, Chris Palmer <palmer@google.com>,
        Aleksa Sarai <cyphar@cyphar.com>,
        Robert Sesek <rsesek@google.com>,
        Christian Brauner <christian.brauner@ubuntu.com>,
        containers@lists.linux-foundation.org,
        Giuseppe Scrivano <gscrivan@redhat.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Daniel Wagner <daniel.wagner@bmw-carit.de>,
        "David S . Miller" <davem@davemloft.net>,
        John Fastabend <john.r.fastabend@intel.com>,
        Tejun Heo <tj@kernel.org>, stable@vger.kernel.org,
        cgroups@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: [PATCH v3 2/4] pid: Use file_receive helper to copy FDs
Date:   Tue,  2 Jun 2020 18:10:42 -0700
Message-Id: <20200603011044.7972-3-sargun@sargun.me>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200603011044.7972-1-sargun@sargun.me>
References: <20200603011044.7972-1-sargun@sargun.me>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The code to copy file descriptors was duplicated in pidfd_getfd.
Rather than continue to duplicate it, this hoists the code out of
kernel/pid.c and uses the newly added file_receive helper.

Earlier, when this was implemented there was some back-and-forth
about how the semantics should work around copying around file
descriptors [1], and it was decided that the default behaviour
should be to not modify cgroup data. As a matter of least surprise,
this approach follows the default semantics as presented by SCM_RIGHTS.

In the future, a flag can be added to avoid manipulating the cgroup
data on copy.

[1]: https://lore.kernel.org/lkml/20200107175927.4558-1-sargun@sargun.me/

Signed-off-by: Sargun Dhillon <sargun@sargun.me>
Suggested-by: Kees Cook <keescook@chromium.org>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Christian Brauner <christian.brauner@ubuntu.com>
Cc: Daniel Wagner <daniel.wagner@bmw-carit.de>
Cc: David S. Miller <davem@davemloft.net>
Cc: Jann Horn <jannh@google.com>
Cc: John Fastabend <john.r.fastabend@intel.com>
Cc: Tejun Heo <tj@kernel.org>
Cc: Tycho Andersen <tycho@tycho.ws>
Cc: stable@vger.kernel.org
Cc: cgroups@vger.kernel.org
Cc: linux-fsdevel@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
---
 kernel/pid.c | 20 +++++++++-----------
 1 file changed, 9 insertions(+), 11 deletions(-)

diff --git a/kernel/pid.c b/kernel/pid.c
index c835b844aca7..1642cf940aa1 100644
--- a/kernel/pid.c
+++ b/kernel/pid.c
@@ -606,7 +606,7 @@ static int pidfd_getfd(struct pid *pid, int fd)
 {
 	struct task_struct *task;
 	struct file *file;
-	int ret;
+	int ret, err;
 
 	task = get_pid_task(pid, PIDTYPE_PID);
 	if (!task)
@@ -617,18 +617,16 @@ static int pidfd_getfd(struct pid *pid, int fd)
 	if (IS_ERR(file))
 		return PTR_ERR(file);
 
-	ret = security_file_receive(file);
-	if (ret) {
-		fput(file);
-		return ret;
-	}
-
 	ret = get_unused_fd_flags(O_CLOEXEC);
-	if (ret < 0)
-		fput(file);
-	else
-		fd_install(ret, file);
+	if (ret >= 0) {
+		err = file_receive(ret, file);
+		if (err) {
+			put_unused_fd(ret);
+			ret = err;
+		}
+	}
 
+	fput(file);
 	return ret;
 }
 
-- 
2.25.1

