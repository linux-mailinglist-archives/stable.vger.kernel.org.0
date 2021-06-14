Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8464F3A6C55
	for <lists+stable@lfdr.de>; Mon, 14 Jun 2021 18:46:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234589AbhFNQsf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Jun 2021 12:48:35 -0400
Received: from mail-pl1-f175.google.com ([209.85.214.175]:46620 "EHLO
        mail-pl1-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234886AbhFNQsf (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 14 Jun 2021 12:48:35 -0400
Received: by mail-pl1-f175.google.com with SMTP id e1so6874025pld.13
        for <stable@vger.kernel.org>; Mon, 14 Jun 2021 09:46:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=XE6H10v+4K87NjIk8prkM4d2wneLI3dvub+7esrDVfg=;
        b=R0hyyNf1j+XUxrhZftIz5PLMAsBn54xSfjcVXYP907o++1arq7NfEa45NVVz42sL8q
         GBGVdvdrlosa2afujLnozFUBk6Ce/L8avJARYyxS3JFAO5Z8PE/vZQfhledSVQX6FneX
         nwVEInObC20oR9SLh5V7CUs1c+gzSpjgElVt4=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=XE6H10v+4K87NjIk8prkM4d2wneLI3dvub+7esrDVfg=;
        b=dqapMBFoxAWBHspyWoA/R0DjmFIZ8a0v3rJc5IGK9BWnoTP3NxKl4+R93aUGCU76h5
         wZq5qqNR7CkN3qJgNHHlfGjgOZ1MqwDhfBzQ+MYRQQPqohlit44AAdD7YRKyWx7FL4Tc
         JP5LS6JRD90/KkBFqDjpZGuOWx3LIziBqqCz3Q6/SXd+x/bpotkDTKCRCuX+P4zt1ewb
         urvVQ5U+9KGSy64hT0Ib/M86gonNtQCuGBRePX5TJHpFm3IOSgvpwTCRp1vv4Nx2BKAT
         na40DFmZqGq7RptBqAHg1LE93W6KO+EfBGakl06ogu+x8ZD782/DoXIioAiRvALwKmk/
         tq0w==
X-Gm-Message-State: AOAM532utvBtXxhny+Un8NbGz8quZ1PEbtw1jDfQjO89ivbIzpRurygz
        WebGNFVN/iRjcwXT28bIIGzhcQ==
X-Google-Smtp-Source: ABdhPJwcnxSn1eMsO+zkQwEPX5UKACvwFkKztnZW0P/eg+HPzt4AjZie3C6XQvs4YKSO1foMkaDXbA==
X-Received: by 2002:a17:90b:901:: with SMTP id bo1mr20049707pjb.0.1623689117081;
        Mon, 14 Jun 2021 09:45:17 -0700 (PDT)
Received: from www.outflux.net (smtp.outflux.net. [198.145.64.163])
        by smtp.gmail.com with ESMTPSA id ms5sm20953pjb.19.2021.06.14.09.45.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 14 Jun 2021 09:45:16 -0700 (PDT)
Date:   Mon, 14 Jun 2021 09:45:15 -0700
From:   Kees Cook <keescook@chromium.org>
To:     youling257 <youling257@gmail.com>
Cc:     torvalds@linux-foundation.org, christian.brauner@ubuntu.com,
        andrea.righi@canonical.com, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, regressions@lists.linux.dev,
        linux-security-module@vger.kernel.org,
        Paul Moore <paul@paul-moore.com>,
        Stephen Smalley <stephen.smalley.work@gmail.com>,
        SElinux list <selinux@vger.kernel.org>
Subject: Re: [PATCH] proc: Track /proc/$pid/attr/ opener mm_struct
Message-ID: <202106140941.7CE5AE64@keescook>
References: <20210608171221.276899-1-keescook@chromium.org>
 <20210614100234.12077-1-youling257@gmail.com>
 <202106140826.7912F27CD@keescook>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <202106140826.7912F27CD@keescook>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Jun 14, 2021 at 08:32:35AM -0700, Kees Cook wrote:
> On Mon, Jun 14, 2021 at 06:02:34PM +0800, youling257 wrote:
> > I used mainline kernel on android, this patch cause "failed to retrieve pid context" problem.
> > 
> > 06-14 02:15:51.165  1685  1685 E ServiceManager: SELinux: getpidcon(pid=1682) failed to retrieve pid context.

I found getpidcon() in libselinux:
https://github.com/SELinuxProject/selinux/blob/master/libselinux/src/procattr.c#L159

> > 06-14 02:15:51.166  1685  1685 E ServiceManager: add_service('batteryproperties',1) uid=0 - PERMISSION DENIED
> > 06-14 02:15:51.166  1682  1682 I ServiceManager: addService() batteryproperties failed (err -1 - no service manager yet?).  Retrying...
> > 06-14 02:15:51.197  1685  1685 E ServiceManager: SELinux: getpidcon(pid=1695) failed to retrieve pid context.
> > 06-14 02:15:51.197  1685  1685 E ServiceManager: add_service('android.security.keystore',1) uid=1017 - PERMISSION DENIED
> > 06-14 02:15:51.198  1695  1695 I ServiceManager: addService() android.security.keystore failed (err -1 - no service manager yet?).  Retrying...
> > 06-14 02:15:51.207  1685  1685 E ServiceManager: SELinux: getpidcon(pid=1708) failed to retrieve pid context.
> > 06-14 02:15:51.207  1685  1685 E ServiceManager: add_service('android.service.gatekeeper.IGateKeeperService',1) uid=1000 - PERMISSION DENIED
> > 06-14 02:15:51.207  1708  1708 I ServiceManager: addService() android.service.gatekeeper.IGateKeeperService failed (err -1 - no service manager yet?).  Retrying...
> > 06-14 02:15:51.275  1685  1685 E ServiceManager: SELinux: getpidcon(pid=1693) failed to retrieve pid context.
> > 06-14 02:15:51.275  1692  1692 I cameraserver: ServiceManager: 0xf6d309e0
> > 06-14 02:15:51.275  1685  1685 E ServiceManager: add_service('drm.drmManager',1) uid=1019 - PERMISSION DENIED
> > 06-14 02:15:51.276  1693  1693 I ServiceManager: addService() drm.drmManager failed (err -1 - no service manager yet?).  Retrying...
> > 
> 
> Argh. Are you able to uncover what userspace is doing here?

It looks like this is a case of attempting to _read_ the attr file, and
the new opener check was requiring the opener/target relationship pass
the mm_access() checks, which is clearly too strict.

> So far, my test cases are:
> 
> 1) self: open, write, close: allowed
> 2) self: open, clone thread. thread: change privileges, write, close: allowed
> 3) self: open, give to privileged process. privileged process: write: reject

I've now added:

4) self: open privileged process's attr, read, close: allowed

Can folks please test this patch to double-check?


diff --git a/fs/proc/base.c b/fs/proc/base.c
index 7118ebe38fa6..7c55301674e0 100644
--- a/fs/proc/base.c
+++ b/fs/proc/base.c
@@ -2676,7 +2676,14 @@ static int proc_pident_readdir(struct file *file, struct dir_context *ctx,
 #ifdef CONFIG_SECURITY
 static int proc_pid_attr_open(struct inode *inode, struct file *file)
 {
-	return __mem_open(inode, file, PTRACE_MODE_READ_FSCREDS);
+	struct mm_struct *mm = __mem_open(inode, file, PTRACE_MODE_READ_FSCREDS);
+
+	/* Reads do not require mm_struct access. */
+	if (IS_ERR(mm))
+		mm = NULL;
+
+	file->private_data = mm;
+	return 0;
 }
 
 static ssize_t proc_pid_attr_read(struct file * file, char __user * buf,
@@ -2709,7 +2716,7 @@ static ssize_t proc_pid_attr_write(struct file * file, const char __user * buf,
 	int rv;
 
 	/* A task may only write when it was the opener. */
-	if (file->private_data != current->mm)
+	if (!file->private_data || file->private_data != current->mm)
 		return -EPERM;
 
 	rcu_read_lock();


Wheee.

-- 
Kees Cook
