Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3B91E1F6036
	for <lists+stable@lfdr.de>; Thu, 11 Jun 2020 05:00:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726399AbgFKDAA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 10 Jun 2020 23:00:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38312 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726387AbgFKC77 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 10 Jun 2020 22:59:59 -0400
Received: from mail-pf1-x441.google.com (mail-pf1-x441.google.com [IPv6:2607:f8b0:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C505BC08C5C1
        for <stable@vger.kernel.org>; Wed, 10 Jun 2020 19:59:59 -0700 (PDT)
Received: by mail-pf1-x441.google.com with SMTP id d66so2025464pfd.6
        for <stable@vger.kernel.org>; Wed, 10 Jun 2020 19:59:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=lP4DTVpqVtxlC9MaFsoDN9/npQaHlEe1E0smsNRDWZY=;
        b=ewreE9bF2kyTwnZRJ5UVCC2ltyCjUSmztW1aNJ6VlB/VObo3KwT+InjCahCm8eQgLV
         uizAtftEHbnJZxdwxttgyeTlWySA8txlDR1rN9TjDc7oZrThm+OGpQjI+V2eFhNnaJEg
         MdkJOgqIhqsMjDg3CaemZwzwEIfrizUaDagP4=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=lP4DTVpqVtxlC9MaFsoDN9/npQaHlEe1E0smsNRDWZY=;
        b=Q7zyqpBsXCRczZOalIK+W4jnNGsCoKOTAolhF2haqDM9jMgVhJz54ectxu4JaRwsLp
         U8GM7K+q8eA9scQL936uZqQ6GYe1AAh9RTZe7466KAxC5NXCiu51DKAvKQBzCTV/dWXo
         KVtDO25S0iEUxQWy2LLhLD7m+AQJucyzRrgusvrrcdTRXeBY146MtlMm3/1Wvwg5Jads
         n83kSsFWZDulUXU8r1zjvASlwbtGvYgeYyFWfGI6+QASoUjOZgmw+67BsmPg+Vc7oydP
         vRjztXALqH9tCO24EvtuMOAsWMwhgWwBri3i7Q3jtOehgMN5RPaUknNM1+SlpZek3dtF
         JaIQ==
X-Gm-Message-State: AOAM533f7QfmREpcDGial4KuXYjyQ/iOwen4u8Eew7mRem7ze4gL3OcF
        +R8kF5TRTYP+pFXprBARdmL5+g==
X-Google-Smtp-Source: ABdhPJxRQ3wfBebdsxh56BY1Z64vWDb6HxWrd6T2L4+yh/OHQXKSrQd+GdnwY1k6ib8nqwMT1Bt+uA==
X-Received: by 2002:a62:6804:: with SMTP id d4mr5595936pfc.100.1591844397704;
        Wed, 10 Jun 2020 19:59:57 -0700 (PDT)
Received: from www.outflux.net (smtp.outflux.net. [198.145.64.163])
        by smtp.gmail.com with ESMTPSA id q193sm1295053pfq.158.2020.06.10.19.59.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 10 Jun 2020 19:59:56 -0700 (PDT)
Date:   Wed, 10 Jun 2020 19:59:55 -0700
From:   Kees Cook <keescook@chromium.org>
To:     Sargun Dhillon <sargun@sargun.me>
Cc:     Christian Brauner <christian.brauner@ubuntu.com>,
        containers@lists.linux-foundation.org,
        Giuseppe Scrivano <gscrivan@redhat.com>,
        Robert Sesek <rsesek@google.com>,
        Chris Palmer <palmer@google.com>, Jann Horn <jannh@google.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Daniel Wagner <daniel.wagner@bmw-carit.de>,
        linux-kernel@vger.kernel.org, Matt Denton <mpdenton@google.com>,
        John Fastabend <john.r.fastabend@intel.com>,
        linux-fsdevel@vger.kernel.org, Tejun Heo <tj@kernel.org>,
        Al Viro <viro@zeniv.linux.org.uk>, cgroups@vger.kernel.org,
        stable@vger.kernel.org, "David S . Miller" <davem@davemloft.net>
Subject: Re: [PATCH v3 1/4] fs, net: Standardize on file_receive helper to
 move fds across processes
Message-ID: <202006101953.899EFB53@keescook>
References: <20200604012452.vh33nufblowuxfed@wittgenstein>
 <202006031845.F587F85A@keescook>
 <20200604125226.eztfrpvvuji7cbb2@wittgenstein>
 <20200605075435.GA3345@ircssh-2.c.rugged-nimbus-611.internal>
 <202006091235.930519F5B@keescook>
 <20200609200346.3fthqgfyw3bxat6l@wittgenstein>
 <202006091346.66B79E07@keescook>
 <037A305F-B3F8-4CFA-B9F8-CD4C9EF9090B@ubuntu.com>
 <202006092227.D2D0E1F8F@keescook>
 <20200610081237.GA23425@ircssh-2.c.rugged-nimbus-611.internal>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200610081237.GA23425@ircssh-2.c.rugged-nimbus-611.internal>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Jun 10, 2020 at 08:12:38AM +0000, Sargun Dhillon wrote:
> As an aside, all of this junk should be dropped:
> +	ret = get_user(size, &uaddfd->size);
> +	if (ret)
> +		return ret;
> +
> +	ret = copy_struct_from_user(&addfd, sizeof(addfd), uaddfd, size);
> +	if (ret)
> +		return ret;
> 
> and the size member of the seccomp_notif_addfd struct. I brought this up 
> off-list with Tycho that ioctls have the size of the struct embedded in them. We 
> should just use that. The ioctl definition is based on this[2]:
> #define _IOC(dir,type,nr,size) \
> 	(((dir)  << _IOC_DIRSHIFT) | \
> 	 ((type) << _IOC_TYPESHIFT) | \
> 	 ((nr)   << _IOC_NRSHIFT) | \
> 	 ((size) << _IOC_SIZESHIFT))
> 
> 
> We should just use copy_from_user for now. In the future, we can either 
> introduce new ioctl names for new structs, or extract the size dynamically from 
> the ioctl (and mask it out on the switch statement in seccomp_notify_ioctl.

Yeah, that seems reasonable. Here's the diff for that part:

diff --git a/include/uapi/linux/seccomp.h b/include/uapi/linux/seccomp.h
index 7b6028b399d8..98bf19b4e086 100644
--- a/include/uapi/linux/seccomp.h
+++ b/include/uapi/linux/seccomp.h
@@ -118,7 +118,6 @@ struct seccomp_notif_resp {
 
 /**
  * struct seccomp_notif_addfd
- * @size: The size of the seccomp_notif_addfd datastructure
  * @id: The ID of the seccomp notification
  * @flags: SECCOMP_ADDFD_FLAG_*
  * @srcfd: The local fd number
@@ -126,7 +125,6 @@ struct seccomp_notif_resp {
  * @newfd_flags: The O_* flags the remote FD should have applied
  */
 struct seccomp_notif_addfd {
-	__u64 size;
 	__u64 id;
 	__u32 flags;
 	__u32 srcfd;
diff --git a/kernel/seccomp.c b/kernel/seccomp.c
index 3c913f3b8451..00cbdad6c480 100644
--- a/kernel/seccomp.c
+++ b/kernel/seccomp.c
@@ -1297,14 +1297,9 @@ static long seccomp_notify_addfd(struct seccomp_filter *filter,
 	struct seccomp_notif_addfd addfd;
 	struct seccomp_knotif *knotif;
 	struct seccomp_kaddfd kaddfd;
-	u64 size;
 	int ret;
 
-	ret = get_user(size, &uaddfd->size);
-	if (ret)
-		return ret;
-
-	ret = copy_struct_from_user(&addfd, sizeof(addfd), uaddfd, size);
+	ret = copy_from_user(&addfd, uaddfd, sizeof(addfd));
 	if (ret)
 		return ret;
 

> 
> ----
> +#define SECCOMP_IOCTL_NOTIF_ADDFD	SECCOMP_IOR(3,	\
> +						struct seccomp_notif_addfd)
> 
> Lastly, what I believe to be a small mistake, it should be SECCOMP_IOW, based on 
> the documentation in ioctl.h -- "_IOW means userland is writing and kernel is 
> reading."

Oooooh. Yeah; good catch. Uhm, that means SECCOMP_IOCTL_NOTIF_ID_VALID
is wrong too, yes? Tycho, Christian, how disruptive would this be to
fix? (Perhaps support both and deprecate the IOR version at some point
in the future?)

Diff for just addfd's change:

diff --git a/include/uapi/linux/seccomp.h b/include/uapi/linux/seccomp.h
index 7b6028b399d8..98bf19b4e086 100644
--- a/include/uapi/linux/seccomp.h
+++ b/include/uapi/linux/seccomp.h
@@ -146,7 +144,7 @@ struct seccomp_notif_addfd {
 						struct seccomp_notif_resp)
 #define SECCOMP_IOCTL_NOTIF_ID_VALID	SECCOMP_IOR(2, __u64)
 /* On success, the return value is the remote process's added fd number */
-#define SECCOMP_IOCTL_NOTIF_ADDFD	SECCOMP_IOR(3,	\
+#define SECCOMP_IOCTL_NOTIF_ADDFD	SECCOMP_IOW(3,	\
 						struct seccomp_notif_addfd)
 
 #endif /* _UAPI_LINUX_SECCOMP_H */

-- 
Kees Cook
