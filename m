Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1C8B818AFB3
	for <lists+stable@lfdr.de>; Thu, 19 Mar 2020 10:19:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726987AbgCSJTL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 19 Mar 2020 05:19:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:45256 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727399AbgCSJTJ (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 19 Mar 2020 05:19:09 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AC9CD20722;
        Thu, 19 Mar 2020 09:19:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1584609549;
        bh=4ELwAs4r++m0CrqR7Z3cbvZffSziVHNOV9Nhno1MLfI=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=F3E4jwytvaGrRTPAf4qrnrm/mg2eNuHO4eBbywNXHTMGWB7NxPJCwfM56vTbUifxK
         e2qf3Io0STy6LvAB50RtzUHRynYxJGvdUTpD3cSFW2FBYKSXcAuD9ETBKKZNw1k6nI
         QEWGK3MroGnEypvUw009yBQRQ4ibVOlcu2m8WGKc=
Date:   Thu, 19 Mar 2020 10:19:07 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Bernd Edlinger <bernd.edlinger@hotmail.de>
Cc:     Kirill Tkhai <ktkhai@virtuozzo.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
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
        "linux-api@vger.kernel.org" <linux-api@vger.kernel.org>
Subject: Re: [PATCH v4 3/5] exec: Add a exec_update_mutex to replace
 cred_guard_mutex
Message-ID: <20200319091907.GC3495501@kroah.com>
References: <AM6PR03MB5170E9E71B9F84330B098BADE4FA0@AM6PR03MB5170.eurprd03.prod.outlook.com>
 <6002ac56-025a-d50f-e89d-1bf42a072323@virtuozzo.com>
 <AM6PR03MB5170353DF3575FF7742BB155E4FB0@AM6PR03MB5170.eurprd03.prod.outlook.com>
 <532ce6a3-f0df-e3e4-6966-473c608246e1@virtuozzo.com>
 <AM6PR03MB51705D8A5631B53844CE447CE4F60@AM6PR03MB5170.eurprd03.prod.outlook.com>
 <13c4d333-9c33-8036-3142-dac22c392c60@virtuozzo.com>
 <AM6PR03MB5170110A5D332DD0C1AC929FE4F70@AM6PR03MB5170.eurprd03.prod.outlook.com>
 <f7c1508a-a456-6ae4-a81e-8e8aa41d8d39@virtuozzo.com>
 <AM6PR03MB5170946BCC61F5D6CA233390E4F40@AM6PR03MB5170.eurprd03.prod.outlook.com>
 <AM6PR03MB51703082215BDFE074E9D735E4F40@AM6PR03MB5170.eurprd03.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AM6PR03MB51703082215BDFE074E9D735E4F40@AM6PR03MB5170.eurprd03.prod.outlook.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Mar 19, 2020 at 10:13:20AM +0100, Bernd Edlinger wrote:
> Ah, sorry this is actuall v4 5/5.
> Should I send a new version or can you handle it?

This thread is a total crazy mess of different versions.

I know I can't unwind any of this, so I _STRONGLY_ suggest resending the
whole series, properly versioned, as a new thread.

Would you want to try to pick out the proper patches from this pile?

thanks,

greg k-h
