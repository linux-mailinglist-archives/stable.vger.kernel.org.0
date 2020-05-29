Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 593B91E722E
	for <lists+stable@lfdr.de>; Fri, 29 May 2020 03:45:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391017AbgE2Bp1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 28 May 2020 21:45:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34704 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2390874AbgE2Bp0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 28 May 2020 21:45:26 -0400
Received: from mail-qk1-x742.google.com (mail-qk1-x742.google.com [IPv6:2607:f8b0:4864:20::742])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5176AC08C5C7
        for <stable@vger.kernel.org>; Thu, 28 May 2020 18:45:26 -0700 (PDT)
Received: by mail-qk1-x742.google.com with SMTP id b27so885795qka.4
        for <stable@vger.kernel.org>; Thu, 28 May 2020 18:45:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=joelfernandes.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=FWoWaWY5KM23AYzWVy94Ib6AwRh0YS5J0NG11YqB1Pw=;
        b=ljwfIphn/IgE4EWe2g3dD1aTEVtSiCe28jc71XALkBNVurxJTaUKPOWXJhBdc4ksxQ
         GLKylVYSvSf3odCukxIoQGuZbsMSBCEJgIjkR01Nts202IxxdTVfUruXv4yA31zXmQll
         72jnxMvLntlO+c43FidSQdq8hndV0B2y2/c4E=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=FWoWaWY5KM23AYzWVy94Ib6AwRh0YS5J0NG11YqB1Pw=;
        b=BcAVR4DWpb0/N201miFwQGYBNSF2rh+xGCyH1N2wNSN3UCCtqXgSotJrnkLjix3ufs
         AAb4c2YONxQJHwZ1SMwfe3ONyfs3z0ffIxe0Bs7bnV29G3uwBRERZf92FNJJHTvJyBbU
         xf7dfEmbVXluP0z/3+odiWT7ei683J2hCyXX4vXRmp05+3cLWexSh78HI7qK5mVm8fb7
         4sTfujugZvkUXb8vlzCYYzCsJajdLeMgErlBCOo/IVPFIycASr6BAipi4pdG4W6RD7pG
         WWMSNmj8Q8zMn5xwP1ilag/U7JBR0t3RImYgLEwrICrvM1EKm0LNzKqD5gEo+2LlNYZ7
         luZg==
X-Gm-Message-State: AOAM531ZBQ579HQlQHXf3rPQLeLwP7DpGMrEU2jgaO7I3unBJlMFyoa3
        0H5EUPDSqv7ZUT9ctBvOAyHRfA==
X-Google-Smtp-Source: ABdhPJwtoS5MCEQFa+6WvLrIJxfLSReoNiug0nYoR9oWXo1804zIGLVBSMYxudoAu0qfcq8dT9llEw==
X-Received: by 2002:ae9:e703:: with SMTP id m3mr5733051qka.114.1590716725268;
        Thu, 28 May 2020 18:45:25 -0700 (PDT)
Received: from localhost ([2620:15c:6:12:9c46:e0da:efbf:69cc])
        by smtp.gmail.com with ESMTPSA id a5sm4396685qtw.22.2020.05.28.18.45.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 28 May 2020 18:45:24 -0700 (PDT)
Date:   Thu, 28 May 2020 21:45:24 -0400
From:   Joel Fernandes <joel@joelfernandes.org>
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Matthew Blecker <matthewb@google.com>,
        Jesse Barnes <jsbarnes@google.com>,
        Mike Frysinger <vapier@google.com>,
        Christian Brauner <christian@brauner.io>,
        vpillai <vpillai@digitalocean.com>, vineethrp@gmail.com,
        Peter Zijlstra <peterz@infradead.org>,
        stable <stable@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        mingo@kernel.org
Subject: Re: [PATCH] sched/headers: Fix sched_setattr userspace compilation
 breakage
Message-ID: <20200529014524.GA38759@google.com>
References: <20200528135552.GA87103@google.com>
 <CAHk-=wjgtD6drydXP5h_r90v0sCSQe7BMk7AiYADhJ-x9HGgkg@mail.gmail.com>
 <20200528230859.GB225299@google.com>
 <CAHk-=whf6b=OijDL=+PUTBsrhURzLZQ5xAq5tWDqOQpTmePFDA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAHk-=whf6b=OijDL=+PUTBsrhURzLZQ5xAq5tWDqOQpTmePFDA@mail.gmail.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, May 28, 2020 at 04:23:26PM -0700, Linus Torvalds wrote:
> On Thu, May 28, 2020 at 4:09 PM Joel Fernandes <joel@joelfernandes.org> wrote:
> >
> > > So no, this patch is fundamentally wrong. It negates the whole point
> > > of having a uapi header at all.
> >
> > Sorry, I naively assumed that headers in 'include/uapi/' are safe to include
> > from userspace. I feel terrible.
> 
> Well, they "kind of" are safe to include.
> 
> It's just that normally they are meant for system integrators to
> include as part of the system header files. So they are designed not
> to be safe for normal programs, but for library writers.
> 
> And to make things more confusing, sometimes people _do_ include
> kernel header files directly, just because they want to get features
> that either haven't been exposed by the system libraries, or because
> the system libraries copied the uapi header files for an older version
> of the kernel, and you want the shiny new feature, so...
> 
> And some of those header files are easier to do that with than others...

Got it. Thank you Linus for the detailed reply, I really appreciate that.

> > The problem is <sched.h> still does not get us 'struct sched_attr' even
> > though the manpage of sched_setattr(2) says including <sched.h> is all that's
> > needed.
> 
> Ouch. But clearly you get it from -somewhere- since it then complains
> about the double declaration.
> 
> Strange.

The reason is, since <sched.h> did not provide struct sched_attr as the
manpage said, so I did the include of uapi's linux/sched/types.h myself:

 #include <sched.h>
 // inclusion of this header to get struct sched_attr will break due to
 // another structure struct sched_param redefinition.
 #include <linux/sched/types.h>

 glibc's <sched.h> already defines struct sched_param (which is a POSIX
 struct), so my inclusion of <linux/sched/types.h> above which is a UAPI
 header exported by the kernel, breaks because the following commit moved
 sched_param into the UAPI:
 e2d1e2aec572a ("sched/headers: Move various ABI definitions to <uapi/linux/sched/types.h>")

 Simply reverting that part of the patch also fixes it, like below. Would
 that be an acceptable fix? Then I can go patch glibc to get struct
 sched_attr by including the UAPI's <linux/sched/types.h>. Otherwise, I
 suspect glibc will also break if it tried to include the UAPI header.

 If this is the wrong fix still, I'm sorry and I'll continue to research the
 solution.

> > Also, even if glibc included 'include/uapi/linux/sched/types.h' to get struct
> > sched_attr's definition, we would run into the same issue I reported right?
> > The 'struct sched_param' is already defined by glibc, and this header
> > redefines it.
> 
> That's kind of the point: glibc sets up whatever system headers it
> wants. The uapi ones are there to _help_ it, but it's not like glibc
> _has_ to use them.
> 
> In fact, traditionally we didn't have any uapi header files at all,
> and we just expected the system libraries to scrape them and make
> their own private copies.
> 
> The uapi headers are _meant_ to make that easier, and to allow system
> headers to then co-exists with the inevitable "I need to get newer
> headers because I'm using a bleeding edge feature that glibc isn't
> exposing" crowd.
> 
> Put another way: a very non-portable programs _could_ include the uapi
> headers directly, if the system library headers were set up that way.

This might be painful for struct sched_attr because new attributes keep
getting added to it, so having the UAPI help glibc and other libcs in this
regard might be attractive.

---8<-----------------------

From: "Joel Fernandes (Google)" <joel@joelfernandes.org>
Subject: [PATCH] sched/headers: Fix sched_setattr userspace compilation

This is a partial revert of e2d1e2aec572a to fix the following.

On a modern Linux distro, compiling the following program fails:
 #include<stdlib.h>
 #include<stdint.h>

 // pthread.h includes sched.h internally.
 #include<pthread.h>

 // inclusion of this header to get struct sched_attr will break due to
 // struct sched_param redefinition.
 #include<linux/sched/types.h>

 void main() {
         struct sched_attr sa;

         return;
 }

Compiler errors are:
/usr/include/linux/sched/types.h:8:8: \
			error: redefinition of ‘struct sched_param’
    8 | struct sched_param {
      |        ^~~~~~~~~~~
In file included from /usr/include/x86_64-linux-gnu/bits/sched.h:74,
                 from /usr/include/sched.h:43,
                 from /usr/include/pthread.h:23,
                 from /tmp/s.c:4:
/usr/include/x86_64-linux-gnu/bits/types/struct_sched_param.h:23:8:
note: originally defined here
   23 | struct sched_param
      |        ^~~~~~~~~~~

This also causes a problem with using sched_attr in Chrome. The issue is
sched_param is already provided by glibc.

Fixes: e2d1e2aec572a ("sched/headers: Move various ABI definitions to <uapi/linux/sched/types.h>"
Signed-off-by: Joel Fernandes (Google) <joel@joelfernandes.org>
---
 include/linux/sched.h            | 5 ++++-
 include/uapi/linux/sched/types.h | 4 ----
 2 files changed, 4 insertions(+), 5 deletions(-)

diff --git a/include/linux/sched.h b/include/linux/sched.h
index fc2d2ede2d9ef..e6917b9d919fd 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -55,13 +55,16 @@ struct robust_list_head;
 struct root_domain;
 struct rq;
 struct sched_attr;
-struct sched_param;
 struct seq_file;
 struct sighand_struct;
 struct signal_struct;
 struct task_delay_info;
 struct task_group;
 
+struct sched_param {
+       int sched_priority;
+};
+
 /*
  * Task state bitmask. NOTE! These bits are also
  * encoded in fs/proc/array.c: get_task_state().
diff --git a/include/uapi/linux/sched/types.h b/include/uapi/linux/sched/types.h
index c852153ddb0d3..f863e747ff5f8 100644
--- a/include/uapi/linux/sched/types.h
+++ b/include/uapi/linux/sched/types.h
@@ -4,10 +4,6 @@
 
 #include <linux/types.h>
 
-struct sched_param {
-	int sched_priority;
-};
-
 #define SCHED_ATTR_SIZE_VER0	48	/* sizeof first published struct */
 #define SCHED_ATTR_SIZE_VER1	56	/* add: util_{min,max} */
 
-- 
2.27.0.rc0.183.gde8f92d652-goog

