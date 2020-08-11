Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8EFD0241C0F
	for <lists+stable@lfdr.de>; Tue, 11 Aug 2020 16:05:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728684AbgHKOFp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 11 Aug 2020 10:05:45 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:22744 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728516AbgHKOFo (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 11 Aug 2020 10:05:44 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1597154742;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=eaUyZri1JTLFO+mMoLsk80VcTVuthOVVi1PbXrcLMgg=;
        b=V16zZAFKkvVPhHNfH6faZw0yrrmi2qI//5yK5u+nM0jTlsy4PcYSAXHiLa8ZK1Qqxxxid/
        PEbOzkr8HDopX7Ob3NuLjy7nseYrt1qL0OPcpkNk+CzDtw/Bzp7YLpWwH8InCPSQ4/EUHK
        L4mYvLM+H97/97/I9jPUHCwkDWWRPsY=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-530-gpgahVDuPAGrX-0e__X6yA-1; Tue, 11 Aug 2020 10:05:40 -0400
X-MC-Unique: gpgahVDuPAGrX-0e__X6yA-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 7FF038031DC;
        Tue, 11 Aug 2020 14:05:28 +0000 (UTC)
Received: from dhcp-27-174.brq.redhat.com (unknown [10.40.192.186])
        by smtp.corp.redhat.com (Postfix) with SMTP id C889260E1C;
        Tue, 11 Aug 2020 14:05:26 +0000 (UTC)
Received: by dhcp-27-174.brq.redhat.com (nbSMTP-1.00) for uid 1000
        oleg@redhat.com; Tue, 11 Aug 2020 16:05:28 +0200 (CEST)
Date:   Tue, 11 Aug 2020 16:05:25 +0200
From:   Oleg Nesterov <oleg@redhat.com>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Peter Zijlstra <peterz@infradead.org>,
        Jann Horn <jannh@google.com>,
        io-uring <io-uring@vger.kernel.org>,
        stable <stable@vger.kernel.org>, Josef <josef.grieb@gmail.com>
Subject: Re: [PATCH 2/2] io_uring: use TWA_SIGNAL for task_work if the task
 isn't running
Message-ID: <20200811140525.GE21797@redhat.com>
References: <CAG48ez2dEyxe_ioQaDC3JTdSyLsdOiFKZvk6LGP00ELSfSvhvg@mail.gmail.com>
 <1629f8a9-cee0-75f1-810a-af32968c4055@kernel.dk>
 <dfc3bf88-39a3-bd38-b7b6-5435262013d5@kernel.dk>
 <CAG48ez2EzOpWZbhnuBxVBXjRbLZULJJeeTBsdbL6Hzh9-1YYhA@mail.gmail.com>
 <20200811064516.GA21797@redhat.com>
 <20200811065659.GQ3982@worktop.programming.kicks-ass.net>
 <20200811071401.GB21797@redhat.com>
 <20200811074538.GS3982@worktop.programming.kicks-ass.net>
 <20200811081033.GD21797@redhat.com>
 <efc48e5e-d4fc-bbaf-467c-24210eb77d9b@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <efc48e5e-d4fc-bbaf-467c-24210eb77d9b@kernel.dk>
User-Agent: Mutt/1.5.24 (2015-08-30)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 08/11, Jens Axboe wrote:
>
> I'd really like to get this done at the same time as the io_uring
> change. Are you open to doing the READ_ONCE() based JOBCTL_TASK_WORK
> addition for 5.9?

Yes, the patch looks fine to me. In fact I was going to add this
optimization from the very beginning, but then decided to make that
patch as simple as possible.

And in any case I personally like this change much more than 1/2 +
2/2 which I honestly don't understand ;)

Oleg.

