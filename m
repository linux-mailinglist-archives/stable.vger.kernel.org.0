Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DAACC182137
	for <lists+stable@lfdr.de>; Wed, 11 Mar 2020 19:50:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730972AbgCKSuA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 11 Mar 2020 14:50:00 -0400
Received: from mail-pj1-f65.google.com ([209.85.216.65]:39496 "EHLO
        mail-pj1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730952AbgCKSt7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 11 Mar 2020 14:49:59 -0400
Received: by mail-pj1-f65.google.com with SMTP id d8so1451545pje.4
        for <stable@vger.kernel.org>; Wed, 11 Mar 2020 11:49:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=1O5mNwRKS3WQZf3p7S3pD40Ezb3WQVwbR9o3MD95weI=;
        b=m+VDswWkn7oQWzwAESTvbUWn0hrwmnnEnt9dMsZtQKuIuHrc/4r8XX+lx3mOiCCcLf
         wm8Cz5DjMVhJvDP2VVG0zJ6SHpUILyY5dzan67JIz+4vG+F5i9SL1nVUXx4dramPRkPf
         S6tllCNLWc9gmhewcz7zNJik0de/BY4hu9fI8=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=1O5mNwRKS3WQZf3p7S3pD40Ezb3WQVwbR9o3MD95weI=;
        b=mFaS78QgrWENXHrBvJfKtKEZBjitK/1RgFF3PpYSeKHyaI4tUXDWC4zWU+joBEiJEn
         68CHxHgJiOibiAhwIBpOmVFBZeXS/fVANYfZUy/Fg56UwCVmAB4kUxl13BvcBKb1rTli
         s/+1afAijL/EayfcY06ISJ4nBr8nVus/NyVNCQ1d7rcj0hMtSrgGUYlXhJIo7a0R2PTU
         j8IW69jRVbqkWMfp/H7kTMrFy8GERmubNO+amF8gZ2wnX7/HfJ+WpuFEzoSO/IjF7np+
         uMuejAZbosmrbGzpewGNFhf3y3DY/Z6YUdcI03w32OvwAm/Nuv+qJPsZIg0RfrI+D9DO
         UG7Q==
X-Gm-Message-State: ANhLgQ2UF1pFgAc5y0xImba4k4bAz03AKaesozYMsbrflZA0sQ3u0zg9
        fQPfTMSCWt8ItAOMVKxPXM5pSA==
X-Google-Smtp-Source: ADFU+vuib6jYbHkTB4keLnEAQw9IkBZ0gBuO2NqH2stMX84aRVJNXeHWoxrV2IDBqjWVCcvlTbvu+Q==
X-Received: by 2002:a17:90a:d80b:: with SMTP id a11mr131940pjv.21.1583952596740;
        Wed, 11 Mar 2020 11:49:56 -0700 (PDT)
Received: from www.outflux.net (smtp.outflux.net. [198.145.64.163])
        by smtp.gmail.com with ESMTPSA id 13sm49989285pgo.13.2020.03.11.11.49.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 11 Mar 2020 11:49:55 -0700 (PDT)
Date:   Wed, 11 Mar 2020 11:49:54 -0700
From:   Kees Cook <keescook@chromium.org>
To:     "Eric W. Biederman" <ebiederm@xmission.com>
Cc:     Jann Horn <jannh@google.com>,
        Christian Brauner <christian.brauner@ubuntu.com>,
        Bernd Edlinger <bernd.edlinger@hotmail.de>,
        Jonathan Corbet <corbet@lwn.net>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Andrew Morton <akpm@linux-foundation.org>,
        Alexey Dobriyan <adobriyan@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Oleg Nesterov <oleg@redhat.com>,
        Frederic Weisbecker <frederic@kernel.org>,
        Andrei Vagin <avagin@gmail.com>,
        Ingo Molnar <mingo@kernel.org>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Yuyang Du <duyuyang@gmail.com>,
        David Hildenbrand <david@redhat.com>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Anshuman Khandual <anshuman.khandual@arm.com>,
        David Howells <dhowells@redhat.com>,
        James Morris <jamorris@linux.microsoft.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Shakeel Butt <shakeelb@google.com>,
        Jason Gunthorpe <jgg@ziepe.ca>,
        Christian Kellner <christian@kellner.me>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Aleksa Sarai <cyphar@cyphar.com>,
        "Dmitry V. Levin" <ldv@altlinux.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "linux-api@vger.kernel.org" <linux-api@vger.kernel.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Sargun Dhillon <sargun@sargun.me>
Subject: Re: [PATCH] pidfd: Stop taking cred_guard_mutex
Message-ID: <202003111148.19578AA@keescook>
References: <877dztz415.fsf@x220.int.ebiederm.org>
 <20200309201729.yk5sd26v4bz4gtou@wittgenstein>
 <87k13txnig.fsf@x220.int.ebiederm.org>
 <20200310085540.pztaty2mj62xt2nm@wittgenstein>
 <87wo7svy96.fsf_-_@x220.int.ebiederm.org>
 <CAG48ez2cUZMVOAXfHPNjKjYsMSaWkjUjOCHo0KYZ+oXQUW4viA@mail.gmail.com>
 <87k13sui1p.fsf@x220.int.ebiederm.org>
 <CAG48ez2vRgaEVJ=Rs8gn6HkGO6syL8MpSOUq7BNN+OUE1uYxCA@mail.gmail.com>
 <CAG48ez1LjW1xAGe-5tNtstCWxG2bkiHaQUMOcJNjx=z-2Wc2Jw@mail.gmail.com>
 <87lfo8rkqo.fsf@x220.int.ebiederm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87lfo8rkqo.fsf@x220.int.ebiederm.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Mar 10, 2020 at 03:57:35PM -0500, Eric W. Biederman wrote:
> So ptrace_attach and seccomp use the cred_guard_mutex to guarantee
> a deadlock.

Well, that's the result, but seccomp uses it because it wants to
be certain that credentials and no_new_privs are changed together
"atomically".

-- 
Kees Cook
