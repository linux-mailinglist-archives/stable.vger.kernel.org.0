Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9B2752A0AAE
	for <lists+stable@lfdr.de>; Fri, 30 Oct 2020 17:06:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726396AbgJ3QGr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 30 Oct 2020 12:06:47 -0400
Received: from smtp-bc0c.mail.infomaniak.ch ([45.157.188.12]:36407 "EHLO
        smtp-bc0c.mail.infomaniak.ch" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725355AbgJ3QGq (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 30 Oct 2020 12:06:46 -0400
X-Greylist: delayed 12464 seconds by postgrey-1.27 at vger.kernel.org; Fri, 30 Oct 2020 12:06:45 EDT
Received: from smtp-2-0001.mail.infomaniak.ch (unknown [10.5.36.108])
        by smtp-3-3000.mail.infomaniak.ch (Postfix) with ESMTPS id 4CN6cx2KK4zllGw2;
        Fri, 30 Oct 2020 17:06:41 +0100 (CET)
Received: from ns3096276.ip-94-23-54.eu (unknown [94.23.54.103])
        by smtp-2-0001.mail.infomaniak.ch (Postfix) with ESMTPA id 4CN6cw2Rr9zlh8TQ;
        Fri, 30 Oct 2020 17:06:40 +0100 (CET)
Subject: Re: [PATCH v1 1/2] ptrace: Set PF_SUPERPRIV when checking capability
To:     Jann Horn <jannh@google.com>
Cc:     Christian Brauner <christian.brauner@ubuntu.com>,
        Kees Cook <keescook@chromium.org>,
        Oleg Nesterov <oleg@redhat.com>,
        Eric Paris <eparis@redhat.com>,
        James Morris <jmorris@namei.org>,
        "Serge E . Hallyn" <serge@hallyn.com>,
        Tyler Hicks <tyhicks@linux.microsoft.com>,
        Will Drewry <wad@chromium.org>,
        kernel list <linux-kernel@vger.kernel.org>,
        stable <stable@vger.kernel.org>,
        =?UTF-8?Q?Micka=c3=abl_Sala=c3=bcn?= <mic@linux.microsoft.com>
References: <20201030123849.770769-1-mic@digikod.net>
 <20201030123849.770769-2-mic@digikod.net>
 <CAG48ez1LFAKoi-nvipsar2SAH0eNhKkOzWj4Fuf9wNCtpWsH9A@mail.gmail.com>
From:   =?UTF-8?Q?Micka=c3=abl_Sala=c3=bcn?= <mic@digikod.net>
Message-ID: <94a86084-5aab-4a2c-e654-f55130190c1a@digikod.net>
Date:   Fri, 30 Oct 2020 17:06:39 +0100
User-Agent: 
MIME-Version: 1.0
In-Reply-To: <CAG48ez1LFAKoi-nvipsar2SAH0eNhKkOzWj4Fuf9wNCtpWsH9A@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


On 30/10/2020 16:47, Jann Horn wrote:
> On Fri, Oct 30, 2020 at 1:39 PM Mickaël Salaün <mic@digikod.net> wrote:
>> Commit 69f594a38967 ("ptrace: do not audit capability check when outputing
>> /proc/pid/stat") replaced the use of ns_capable() with
>> has_ns_capability{,_noaudit}() which doesn't set PF_SUPERPRIV.
>>
>> Commit 6b3ad6649a4c ("ptrace: reintroduce usage of subjective credentials in
>> ptrace_has_cap()") replaced has_ns_capability{,_noaudit}() with
>> security_capable(), which doesn't set PF_SUPERPRIV neither.
>>
>> Since commit 98f368e9e263 ("kernel: Add noaudit variant of ns_capable()"), a
>> new ns_capable_noaudit() helper is available.  Let's use it!
>>
>> As a result, the signature of ptrace_has_cap() is restored to its original one.
>>
>> Cc: Christian Brauner <christian.brauner@ubuntu.com>
>> Cc: Eric Paris <eparis@redhat.com>
>> Cc: Jann Horn <jannh@google.com>
>> Cc: Kees Cook <keescook@chromium.org>
>> Cc: Oleg Nesterov <oleg@redhat.com>
>> Cc: Serge E. Hallyn <serge@hallyn.com>
>> Cc: Tyler Hicks <tyhicks@linux.microsoft.com>
>> Cc: stable@vger.kernel.org
>> Fixes: 6b3ad6649a4c ("ptrace: reintroduce usage of subjective credentials in ptrace_has_cap()")
>> Fixes: 69f594a38967 ("ptrace: do not audit capability check when outputing /proc/pid/stat")
>> Signed-off-by: Mickaël Salaün <mic@linux.microsoft.com>
> 
> Yeah... I guess this makes sense. (We'd have to undo or change it if
> we ever end up needing to use a different set of credentials, e.g.
> from ->f_cred, but I guess that's really something we should avoid
> anyway.)
> 
> Reviewed-by: Jann Horn <jannh@google.com>
> 
> with one nit:
> 
> 
> [...]
>>  /* Returns 0 on success, -errno on denial. */
>>  static int __ptrace_may_access(struct task_struct *task, unsigned int mode)
>>  {
>> -       const struct cred *cred = current_cred(), *tcred;
>> +       const struct cred *const cred = current_cred(), *tcred;
> 
> This is an unrelated change, and almost no kernel code marks local
> pointer variables as "const". I would drop this change from the patch.

This give guarantee that the cred variable will not be used for
something else than current_cred(), which kinda prove that this patch
doesn't change the behavior of __ptrace_may_access() by not using cred
in ptrace_has_cap(). It doesn't hurt and I think it could be useful to
spot issues when backporting.

> 
>>         struct mm_struct *mm;
>>         kuid_t caller_uid;
>>         kgid_t caller_gid;
