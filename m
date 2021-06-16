Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CB1463A9714
	for <lists+stable@lfdr.de>; Wed, 16 Jun 2021 12:17:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231638AbhFPKT6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 16 Jun 2021 06:19:58 -0400
Received: from smtp-out1.suse.de ([195.135.220.28]:35832 "EHLO
        smtp-out1.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231452AbhFPKT6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 16 Jun 2021 06:19:58 -0400
Received: from imap.suse.de (imap-alt.suse-dmz.suse.de [192.168.254.47])
        (using TLSv1.2 with cipher ECDHE-ECDSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id 79D1C21A44;
        Wed, 16 Jun 2021 10:17:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
        t=1623838671; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=0hTfhsz/kEt5WGDatXsImGrsFOHUS+gN7wSm/18jlfk=;
        b=uZksO3ALRtJVWWZOFxJa04O7Wx1v0zfQ2CKNQqeI1J74Vq3gq0OoNPc7KzrWdO3UDfu4Ta
        edYrMgAOvhk4+fk0GPiKfQytAkviax6a4o3GszYlkxJKjJXgpBWaUf7kI3WJPKiEiT7v52
        mCKeW/huyfIXAkpVkrojHvXdcCU4i7A=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
        s=susede2_ed25519; t=1623838671;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=0hTfhsz/kEt5WGDatXsImGrsFOHUS+gN7wSm/18jlfk=;
        b=gOrEhfJt0904rYnalONzJoZ+xnTEj7/vLJ3HM8h6td56PwCt7uEe8CNnCaxhsFl6d/hMSj
        NvXqCy3Ftekp+0AA==
Received: from imap3-int (imap-alt.suse-dmz.suse.de [192.168.254.47])
        by imap.suse.de (Postfix) with ESMTP id 4F067118DD;
        Wed, 16 Jun 2021 10:17:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
        t=1623838671; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=0hTfhsz/kEt5WGDatXsImGrsFOHUS+gN7wSm/18jlfk=;
        b=uZksO3ALRtJVWWZOFxJa04O7Wx1v0zfQ2CKNQqeI1J74Vq3gq0OoNPc7KzrWdO3UDfu4Ta
        edYrMgAOvhk4+fk0GPiKfQytAkviax6a4o3GszYlkxJKjJXgpBWaUf7kI3WJPKiEiT7v52
        mCKeW/huyfIXAkpVkrojHvXdcCU4i7A=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
        s=susede2_ed25519; t=1623838671;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=0hTfhsz/kEt5WGDatXsImGrsFOHUS+gN7wSm/18jlfk=;
        b=gOrEhfJt0904rYnalONzJoZ+xnTEj7/vLJ3HM8h6td56PwCt7uEe8CNnCaxhsFl6d/hMSj
        NvXqCy3Ftekp+0AA==
Received: from director2.suse.de ([192.168.254.72])
        by imap3-int with ESMTPSA
        id I5IwEs/PyWDnRwAALh3uQQ
        (envelope-from <vbabka@suse.cz>); Wed, 16 Jun 2021 10:17:51 +0000
Subject: Re: Questions about backports of fixes for "CoW after fork() issue"
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Liu Shixin <liushixin2@huawei.com>,
        Linus Torvalds <torvalds@linux-foundation.org>
Cc:     Suren Baghdasaryan <surenb@google.com>, stable@vger.kernel.org,
        "Jann Horn," <jannh@google.com>,
        Mikulas Patocka <mpatocka@redhat.com>
References: <f546c93e-0e36-03a1-fb08-67f46c83d2e7@huawei.com>
 <YMmfke61mTcPV4vB@kroah.com>
 <CAJuCfpG8p7AasufvqehNOLdoXw5ZQFuQhi6mhqPvA3GbPn1puQ@mail.gmail.com>
 <add3f456-052e-6f40-2949-0685b563fdee@huawei.com>
 <YMnGKd79OGeOvRap@kroah.com>
From:   Vlastimil Babka <vbabka@suse.cz>
Message-ID: <7827ed6e-7f7c-cabb-4f97-b81610016ab3@suse.cz>
Date:   Wed, 16 Jun 2021 12:17:51 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <YMnGKd79OGeOvRap@kroah.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 6/16/21 11:36 AM, Greg Kroah-Hartman wrote:
> On Wed, Jun 16, 2021 at 05:28:54PM +0800, Liu Shixin wrote:
>> On 2021/6/16 15:11, Suren Baghdasaryan wrote:
>> > On Tue, Jun 15, 2021 at 11:52 PM Greg Kroah-Hartman
>> > <gregkh@linuxfoundation.org> wrote:
>> >> On Wed, Jun 16, 2021 at 02:47:15PM +0800, Liu Shixin wrote:
>> >>> Hi, Suren,
>> >>>
>> >>> I read the previous discussion about fixing CVE-2020-29374 in stable 4.14 and 4.19 in
>> >>> <https://lore.kernel.org/linux-mm/20210401181741.168763-1-surenb@google.com/>
>> >>>
>> >>> https://lore.kernel.org/linux-mm/20210401181741.168763-1-surenb@google.com/
>> >>>
>> >>> And the results of the discussion is that you backports of 17839856fd58 for 4.14 and
>> >>>
>> >>> 4.19 kernels.
>> >>>
>> >>> But the bug about dax and strace in the discussion has not been solved, right? I don't
>> >>>
>> >>> find a conclusion on this issue, am I missing something? Does this problem still exist in
>> >>>
>> >>> the stable 4.14 and 4.19 kernel?
>> > That is my understanding after discussions with Andrea but I did not
>> > verify that myself. As Greg pointed out, the best way would be to try
>> > it out.
>> > Thanks,
>> > Suren.
>> >
>> >> As the code is all there for you, can you just test them and see for
>> >> yourself?
>> >>
>> >> thanks,
>> >>
>> >> greg k-h
>> > .
>> >
>> Thank you both for replies. I have tested it in stable 4.19 kernel and the bug is existed as expected.

If you can reproduce it, great. That means a root cause can be found and fixed,
hopefully in a minimal way.

> Great, can you provide a working backport of the patches needed to solve
> this for 4.19 so that we can apply them?

We probably don't want to blindly backport the upstream patches (that also fixed
dax+ptrace as a side-effect) because they changed the semantics a lot and led to
further fixes, which is IMHO too risky to do now in stable. Linus also thought so:

https://lore.kernel.org/linux-mm/CAHk-=whUKYdWbKfFzXXnK8n04oCMwEgSnG8Y3tgE=YZUjiDvbA@mail.gmail.com/#t

> thanks,
> 
> greg k-h
> 

