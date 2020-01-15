Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7CF4213C849
	for <lists+stable@lfdr.de>; Wed, 15 Jan 2020 16:47:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726483AbgAOPr5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 Jan 2020 10:47:57 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:22475 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726248AbgAOPr4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 15 Jan 2020 10:47:56 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1579103275;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=arRXQ/teKt7R05GOntW6gyZaqxy+Pia//dbokI8QBCI=;
        b=BxntD6Xs8XLJn0U4CwxTvNI85jtgZ1k7tw+y0edrFKUWG+xFkAGFga8jAq/72kdyzHlQwM
        5+aVq2e5VW1ysJQt8T31b69FXApJY0ypZ2rGiC7a5J5fuYV/keDgYn7ssmaC0+9qPKpKQX
        nbfUru0LQxOXHup/W9VE1Qh8+YEA0Mk=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-58-UM_qjk9iMqyjd3A6rIoaTQ-1; Wed, 15 Jan 2020 10:47:52 -0500
X-MC-Unique: UM_qjk9iMqyjd3A6rIoaTQ-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 46AFA113E72C;
        Wed, 15 Jan 2020 15:47:51 +0000 (UTC)
Received: from llong.remote.csb (dhcp-17-59.bos.redhat.com [10.18.17.59])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 6FBB11001B03;
        Wed, 15 Jan 2020 15:47:50 +0000 (UTC)
Subject: Re: [PATCH] locking/rwsem: Fix kernel crash when spinning on
 RWSEM_OWNER_UNKNOWN
To:     David Laight <David.Laight@ACULAB.COM>,
        Christoph Hellwig <hch@lst.de>
Cc:     Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@redhat.com>,
        Will Deacon <will.deacon@arm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
References: <20200114190303.5778-1-longman@redhat.com>
 <20200115065055.GA21219@lst.de>
 <021830af-fd89-50e5-ad26-6061e5abdce1@redhat.com>
 <45b976af3cf74555af7214993e7d614b@AcuMS.aculab.com>
From:   Waiman Long <longman@redhat.com>
Organization: Red Hat
Message-ID: <4ac00b33-5397-3c69-6cba-cf3d9d375ea9@redhat.com>
Date:   Wed, 15 Jan 2020 10:47:49 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <45b976af3cf74555af7214993e7d614b@AcuMS.aculab.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 1/15/20 10:16 AM, David Laight wrote:
> From: linux-kernel-owner@vger.kernel.org <linux-kernel-owner@vger.kernel.org> On Behalf Of Waiman Long
>> Sent: 15 January 2020 14:27
> ...
>>>>  		if ((wstate == WRITER_HANDOFF) &&
>>>> -		    (rwsem_spin_on_owner(sem, 0) == OWNER_NULL))
>>>> +		    rwsem_spin_on_owner(sem, RWSEM_NONSPINNABLE) == OWNER_NULL)
>>> Nit: the inner braces in the first half of the conditional aren't required
>>> either.
>> I typically over-parenthesize the code to make it easier to read as we
>> don't need to think too much about operator precedence to see if it is
>> doing the right thing.
> The problem is it actually makes it harder to read.
> It is difficult for the 'mark 1 eyeball' to follow lots of sets of brackets.
> Since == (etc) are the lowest priority operators (apart from ?:) they
> never need ().
>
> 	David
>
> -
> Registered Address Lakeside, Bramley Road, Mount Farm, Milton Keynes, MK1 1PT, UK
> Registration No: 1397386 (Wales)
>
It depends. I find it hard to read an expression with "&" and "&&"
without parentheses. Anyway, I will admit that the above code is
inconsistent in term of how parentheses are used. So I will change that.

Cheers,
Longman

