Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B3011241700
	for <lists+stable@lfdr.de>; Tue, 11 Aug 2020 09:14:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728025AbgHKHOL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 11 Aug 2020 03:14:11 -0400
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:56062 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726421AbgHKHOL (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 11 Aug 2020 03:14:11 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1597130050;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=7taEksxxYp4Lw+2qZxoNy2iF1srvZ3aDAErPoBdIaOg=;
        b=VmmpyS50GYsF2x/HxQOZ9DUDArgqfWMad7Xf7urxPA4xFAVOFq4jU7VDJqsIe3uIdoMeAt
        fiPx7JcDCs6QL2JD4J+Fhh5CYd493lOOVQ9HaKjmDNb6eYg+FVsALTv8fa27rNi+A8dvKl
        hy02nvI2Drmqo6rHNyDXJde3ZXwHcvk=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-338-Z2LIelprNeGnEB_3QLmlKg-1; Tue, 11 Aug 2020 03:14:06 -0400
X-MC-Unique: Z2LIelprNeGnEB_3QLmlKg-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 7A4FD1902EA1;
        Tue, 11 Aug 2020 07:14:05 +0000 (UTC)
Received: from dhcp-27-174.brq.redhat.com (unknown [10.40.192.186])
        by smtp.corp.redhat.com (Postfix) with SMTP id CEE5361462;
        Tue, 11 Aug 2020 07:14:03 +0000 (UTC)
Received: by dhcp-27-174.brq.redhat.com (nbSMTP-1.00) for uid 1000
        oleg@redhat.com; Tue, 11 Aug 2020 09:14:05 +0200 (CEST)
Date:   Tue, 11 Aug 2020 09:14:02 +0200
From:   Oleg Nesterov <oleg@redhat.com>
To:     Peter Zijlstra <peterz@infradead.org>
Cc:     Jann Horn <jannh@google.com>, Jens Axboe <axboe@kernel.dk>,
        io-uring <io-uring@vger.kernel.org>,
        stable <stable@vger.kernel.org>, Josef <josef.grieb@gmail.com>
Subject: Re: [PATCH 2/2] io_uring: use TWA_SIGNAL for task_work if the task
 isn't running
Message-ID: <20200811071401.GB21797@redhat.com>
References: <CAG48ez0+=+Q0tjdFxjbbZbZJNkimYL9Bd5odr0T9oWwty6qgoQ@mail.gmail.com>
 <03c0e282-5317-ea45-8760-2c3f56eec0c0@kernel.dk>
 <20200810211057.GG3982@worktop.programming.kicks-ass.net>
 <5628f79b-6bfb-b054-742a-282663cb2565@kernel.dk>
 <CAG48ez2dEyxe_ioQaDC3JTdSyLsdOiFKZvk6LGP00ELSfSvhvg@mail.gmail.com>
 <1629f8a9-cee0-75f1-810a-af32968c4055@kernel.dk>
 <dfc3bf88-39a3-bd38-b7b6-5435262013d5@kernel.dk>
 <CAG48ez2EzOpWZbhnuBxVBXjRbLZULJJeeTBsdbL6Hzh9-1YYhA@mail.gmail.com>
 <20200811064516.GA21797@redhat.com>
 <20200811065659.GQ3982@worktop.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200811065659.GQ3982@worktop.programming.kicks-ass.net>
User-Agent: Mutt/1.5.24 (2015-08-30)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 08/11, Peter Zijlstra wrote:
>
> On Tue, Aug 11, 2020 at 08:45:16AM +0200, Oleg Nesterov wrote:
> >
> > ->jobctl is always modified with ->siglock held, do we really need
> > WRITE_ONCE() ?
>
> In theory, yes. The compiler doesn't know about locks, it can tear
> writes whenever it feels like it.

Yes, but why does this matter? Could you spell please?

Oleg.

