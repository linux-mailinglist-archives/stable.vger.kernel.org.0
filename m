Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C4631180BC6
	for <lists+stable@lfdr.de>; Tue, 10 Mar 2020 23:41:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727707AbgCJWlE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Mar 2020 18:41:04 -0400
Received: from vmicros1.altlinux.org ([194.107.17.57]:58882 "EHLO
        vmicros1.altlinux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726307AbgCJWlE (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 10 Mar 2020 18:41:04 -0400
Received: from mua.local.altlinux.org (mua.local.altlinux.org [192.168.1.14])
        by vmicros1.altlinux.org (Postfix) with ESMTP id 236F272CCF0;
        Wed, 11 Mar 2020 01:41:01 +0300 (MSK)
Received: by mua.local.altlinux.org (Postfix, from userid 508)
        id 1A1F07CC7FF; Wed, 11 Mar 2020 01:41:01 +0300 (MSK)
Date:   Wed, 11 Mar 2020 01:41:01 +0300
From:   "Dmitry V. Levin" <ldv@altlinux.org>
To:     Bernd Edlinger <bernd.edlinger@hotmail.de>
Cc:     "Eric W. Biederman" <ebiederm@xmission.com>,
        Christian Brauner <christian.brauner@ubuntu.com>,
        Kees Cook <keescook@chromium.org>,
        Jann Horn <jannh@google.com>, Jonathan Corbet <corbet@lwn.net>,
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
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "linux-api@vger.kernel.org" <linux-api@vger.kernel.org>
Subject: Re: [PATCH 2/4] selftests/ptrace: add test cases for dead-locks
Message-ID: <20200310224100.GA1563@altlinux.org>
References: <878sk94eay.fsf@x220.int.ebiederm.org>
 <AM6PR03MB517086003BD2C32E199690A3E4FE0@AM6PR03MB5170.eurprd03.prod.outlook.com>
 <87r1y12yc7.fsf@x220.int.ebiederm.org>
 <87k13t2xpd.fsf@x220.int.ebiederm.org>
 <87d09l2x5n.fsf@x220.int.ebiederm.org>
 <AM6PR03MB5170F0F9DC18F5EA77C9A857E4FE0@AM6PR03MB5170.eurprd03.prod.outlook.com>
 <871rq12vxu.fsf@x220.int.ebiederm.org>
 <AM6PR03MB5170DF45E3245F55B95CCD91E4FE0@AM6PR03MB5170.eurprd03.prod.outlook.com>
 <877dzt1fnf.fsf@x220.int.ebiederm.org>
 <AM6PR03MB51703199741A2C27A78980FFE4FF0@AM6PR03MB5170.eurprd03.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AM6PR03MB51703199741A2C27A78980FFE4FF0@AM6PR03MB5170.eurprd03.prod.outlook.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Mar 10, 2020 at 02:44:01PM +0100, Bernd Edlinger wrote:
> This adds test cases for ptrace deadlocks.
> 
> Additionally fixes a compile problem in get_syscall_info.c,
> observed with gcc-4.8.4:
> 
> get_syscall_info.c: In function 'get_syscall_info':
> get_syscall_info.c:93:3: error: 'for' loop initial declarations are only
>                                  allowed in C99 mode
>    for (unsigned int i = 0; i < ARRAY_SIZE(args); ++i) {
>    ^
> get_syscall_info.c:93:3: note: use option -std=c99 or -std=gnu99 to compile
>                                your code
[...]
> @@ -1,6 +1,6 @@
>  # SPDX-License-Identifier: GPL-2.0-only
> -CFLAGS += -iquote../../../../include/uapi -Wall
> +CFLAGS += -std=c99 -pthread -iquote../../../../include/uapi -Wall

Wouldn't it be better to choose -std=gnu99 over -std=c99?


-- 
ldv
