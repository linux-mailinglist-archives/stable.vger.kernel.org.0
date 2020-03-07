Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4E12517CDB7
	for <lists+stable@lfdr.de>; Sat,  7 Mar 2020 12:00:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726017AbgCGLAK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 7 Mar 2020 06:00:10 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:55794 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725909AbgCGLAK (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 7 Mar 2020 06:00:10 -0500
Received: from ip5f5bf7ec.dynamic.kabel-deutschland.de ([95.91.247.236] helo=wittgenstein)
        by youngberry.canonical.com with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.86_2)
        (envelope-from <christian.brauner@ubuntu.com>)
        id 1jAXBg-0001tv-6r; Sat, 07 Mar 2020 11:00:08 +0000
Date:   Sat, 7 Mar 2020 12:00:07 +0100
From:   Christian Brauner <christian.brauner@ubuntu.com>
To:     minyard@acm.org
Cc:     linux-kernel@vger.kernel.org, Corey Minyard <cminyard@mvista.com>,
        stable@vger.kernel.org, Adrian Reber <areber@redhat.com>,
        Oleg Nesterov <oleg@redhat.com>,
        Dmitry Safonov <0x7f454c46@gmail.com>,
        Andrei Vagin <avagin@gmail.com>
Subject: Re: [PATCH v2] pid: Fix error return value in some cases
Message-ID: <20200307110007.fmtaaqt2udsgohtp@wittgenstein>
References: <20200306172314.12232-1-minyard@acm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20200306172314.12232-1-minyard@acm.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Mar 06, 2020 at 11:23:14AM -0600, minyard@acm.org wrote:
> From: Corey Minyard <cminyard@mvista.com>
> 
> Recent changes to alloc_pid() allow the pid number to be specified on
> the command line.  If set_tid_size is set, then the code scanning the
> levels will hard-set retval to -EPERM, overriding it's previous -ENOMEM
> value.
> 
> After the code scanning the levels, there are error returns that do not
> set retval, assuming it is still set to -ENOMEM.
> 
> So set retval back to -ENOMEM after scanning the levels.
> 
> Fixes: 49cb2fc42ce4 "fork: extend clone3() to support setting a PID"
> Signed-off-by: Corey Minyard <cminyard@mvista.com>
> Cc: <stable@vger.kernel.org> # 5.5
> Cc: Adrian Reber <areber@redhat.com>
> Cc: Christian Brauner <christian.brauner@ubuntu.com>
> Cc: Oleg Nesterov <oleg@redhat.com>
> Cc: Dmitry Safonov <0x7f454c46@gmail.com>
> Cc: Andrei Vagin <avagin@gmail.com>

Thanks! I've pulled the patch now and applied.

I think that restores the old behavior. If you don't mind, I'll add a
comment on top of it saying something like:
"ENOMEM is not the most obvious choice but it's the what we've been
 exposing to userspace for a long time and it's also documented
 behavior. So we can't easily change it to something more sensible."

Acked-by: Christian Brauner <christian.brauner@ubuntu.com>
