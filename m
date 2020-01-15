Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 67C7113C7AF
	for <lists+stable@lfdr.de>; Wed, 15 Jan 2020 16:28:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726550AbgAOP2J (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 Jan 2020 10:28:09 -0500
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:34145 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728961AbgAOP2J (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 15 Jan 2020 10:28:09 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1579102088;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=2Qxjk+FWUcIFc8mBeai26DC01Hb/aY+95E+sd5g+NAo=;
        b=IY9NEL11U+Qy3P2WQ3FtlOvcU2bPJ8WyiZa6DJ64SmdvpDGP14AWYXcBfgOR8wIim4ldjl
        p6ZqLczCC+Lj1lmcc3KuepMdYXxVZg6wnTaf6Vc3I7iO0Rg1F1MtbvqLEP/QyAoGW61H8z
        EHpUlCWskK5HX3YEG9saZFESHFp5Tag=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-100-Ez7YFDxGPLmBrB0qBFl2qA-1; Wed, 15 Jan 2020 10:28:05 -0500
X-MC-Unique: Ez7YFDxGPLmBrB0qBFl2qA-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 1F6468F000B;
        Wed, 15 Jan 2020 15:28:04 +0000 (UTC)
Received: from llong.remote.csb (dhcp-17-59.bos.redhat.com [10.18.17.59])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 35DA91001B03;
        Wed, 15 Jan 2020 15:28:03 +0000 (UTC)
Subject: Re: [PATCH] locking/rwsem: Fix kernel crash when spinning on
 RWSEM_OWNER_UNKNOWN
To:     Christoph Hellwig <hch@lst.de>
Cc:     Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@redhat.com>,
        Will Deacon <will.deacon@arm.com>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
References: <20200114190303.5778-1-longman@redhat.com>
 <20200115065055.GA21219@lst.de>
From:   Waiman Long <longman@redhat.com>
Organization: Red Hat
Message-ID: <db64e331-fe31-c2d9-8b0c-aa99de34c56d@redhat.com>
Date:   Wed, 15 Jan 2020 10:28:02 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <20200115065055.GA21219@lst.de>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 1/15/20 1:50 AM, Christoph Hellwig wrote:
> On Tue, Jan 14, 2020 at 02:03:03PM -0500, Waiman Long wrote:
>> The commit 91d2a812dfb9 ("locking/rwsem: Make handoff writer
>> optimistically spin on owner") will allow a recently woken up waiting
>> writer to spin on the owner. Unfortunately, if the owner happens to be
>> RWSEM_OWNER_UNKNOWN, the code will incorrectly spin on it leading to a
>> kernel crash. This is fixed by passing the proper non-spinnable bits
>> to rwsem_spin_on_owner() so that RWSEM_OWNER_UNKNOWN will be treated
>> as a non-spinnable target.
>>
>> Fixes: 91d2a812dfb9 ("locking/rwsem: Make handoff writer optimistically spin on owner")
>>
>> Reported-by: Christoph Hellwig <hch@lst.de>
>> Signed-off-by: Waiman Long <longman@redhat.com>
> This survives all the tests that showed the problems with the original
> code:
>
> Tested-by: Christoph Hellwig <hch@lst.de>
>
Thanks for the testing.
>>  		if ((wstate == WRITER_HANDOFF) &&
>> -		    (rwsem_spin_on_owner(sem, 0) == OWNER_NULL))
>> +		    rwsem_spin_on_owner(sem, RWSEM_NONSPINNABLE) == OWNER_NULL)
> Nit: the inner braces in the first half of the conditional aren't required
> either.

Yes, it is inconsistent and so is not good. I will post a v2 patch to
fix that.

Cheers,
Longman

