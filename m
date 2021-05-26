Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 438B6391D88
	for <lists+stable@lfdr.de>; Wed, 26 May 2021 19:06:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233694AbhEZRH5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 26 May 2021 13:07:57 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:56527 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233887AbhEZRHw (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 26 May 2021 13:07:52 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1622048779;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=3eMZlfZHQWXKOFFJCkTQoeYFfxuKoO/7kEJcxULdtfA=;
        b=S5/uPX6lm83EoMkLhIwjUBiBA77UuRyrisGc6B//QOg0dKIlhVGc1aAT/Loh3g/u1OZ8sX
        yoGl9C3z+Xu2DXP/2AVl4iuemQuwdqGBFPCTE/OrJ8XtXbraqRm6uJWkZii29a43WGSLw7
        j236SDYc8wRbYplZIf50oZ4l3uH6/4w=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-487-eOzp3-qTNumzXHepl-96QA-1; Wed, 26 May 2021 13:06:15 -0400
X-MC-Unique: eOzp3-qTNumzXHepl-96QA-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 0BAEE107ACCD;
        Wed, 26 May 2021 17:06:13 +0000 (UTC)
Received: from dhcp-27-174.brq.redhat.com (unknown [10.40.192.132])
        by smtp.corp.redhat.com (Postfix) with SMTP id 2DF1916935;
        Wed, 26 May 2021 17:06:06 +0000 (UTC)
Received: by dhcp-27-174.brq.redhat.com (nbSMTP-1.00) for uid 1000
        oleg@redhat.com; Wed, 26 May 2021 19:06:12 +0200 (CEST)
Date:   Wed, 26 May 2021 19:06:06 +0200
From:   Oleg Nesterov <oleg@redhat.com>
To:     Petr Mladek <pmladek@suse.com>
Cc:     akpm@linux-foundation.org, bp@suse.de, davidchao@google.com,
        jenhaochen@google.com, jkosina@suse.cz, josh@joshtriplett.org,
        liumartin@google.com, mhocko@suse.cz, mingo@redhat.com,
        mm-commits@vger.kernel.org, nathan@kernel.org,
        ndesaulniers@google.com, paulmck@linux.vnet.ibm.com,
        peterz@infradead.org, rostedt@goodmis.org, stable@vger.kernel.org,
        tglx@linutronix.de, tj@kernel.org, vbabka@suse.cz,
        linux-kernel@vger.kernel.org
Subject: Re: +
 kthread-fix-kthread_mod_delayed_work-vs-kthread_cancel_delayed_work_sync-race.patch
 added to -mm tree
Message-ID: <20210526170604.GC4581@redhat.com>
References: <20210520214737.MrGGKbPrJ%akpm@linux-foundation.org>
 <20210521163526.GA17916@redhat.com>
 <YKvBVIJAc8/Qasdu@alley>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YKvBVIJAc8/Qasdu@alley>
User-Agent: Mutt/1.5.24 (2015-08-30)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 05/24, Petr Mladek wrote:
>
> Your patch changes the semantic. The current semantic is the same for
> the workqueue's counter-part mod_delayed_work_on().

OK, I see, thanks. I was confused by the comment.

> We should actually keep the "ret" value as is to stay compatible with
> workqueue API:
>
> 	/*
> 	 * Canceling could run in parallel from kthread_cancel_delayed_work_sync
> 	 * and change work's canceling count as the spinlock is released and regain
> 	 * in __kthread_cancel_work so we need to check the count again. Otherwise,
> 	 * we might incorrectly queue the dwork and further cause
> 	 * cancel_delayed_work_sync thread waiting for flush dwork endlessly.
> 	 *
> 	 * Keep the ret code. The API primary informs the caller
> 	 * whether some pending work has been canceled (not proceed).
> 	 */
> 	if (work->canceling)
> 		goto out;

Agreed, we should keep the "ret" value.

but unless I am confused again this doesn't match mod_delayed_work_on()
which always returns true if it races with cancel(). Nevermind, I think
this doesn't matter.

Thanks,

Oleg.

