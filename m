Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 985819B386
	for <lists+stable@lfdr.de>; Fri, 23 Aug 2019 17:38:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405862AbfHWPiH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 23 Aug 2019 11:38:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:53500 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726964AbfHWPiH (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 23 Aug 2019 11:38:07 -0400
Received: from localhost (unknown [12.236.144.82])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9733121726;
        Fri, 23 Aug 2019 15:38:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1566574686;
        bh=VA1ZiaQZX4KwPmP2agYkzSplsL+J6b11+mfxePrt3jk=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=i3831KWdpPley/W5ozTytDpqX07vK78qPizycnS7u2yOvy9EG5bDkqDtLrDJztyY4
         fINHp195FnOPw16A0Z5Jh8KNMYnm/FZJ09cXFDPE7LXZR07CJ2R3to8qVl3/xDd5us
         LL51jfxgB7/9cfdJ6ycCYCA85hI1/n+2A+nJ6drM=
Date:   Fri, 23 Aug 2019 11:38:05 -0400
From:   Sasha Levin <sashal@kernel.org>
To:     Jan Stancek <jstancek@redhat.com>
Cc:     Greg KH <greg@kroah.com>, CKI Project <cki-project@redhat.com>,
        Linux Stable maillist <stable@vger.kernel.org>,
        Memory Management <mm-qe@redhat.com>,
        Xiong Zhou <xzhou@redhat.com>
Subject: Re: =?utf-8?B?4p2MIEZBSUw=?= =?utf-8?Q?=3A?= Stable queue: queue-5.2
Message-ID: <20190823153805.GD1581@sasha-vm>
References: <cki.A52B1C532D.YEFB2VN58T@redhat.com>
 <20190822233717.GA24034@kroah.com>
 <900819847.7915389.1566543455477.JavaMail.zimbra@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <900819847.7915389.1566543455477.JavaMail.zimbra@redhat.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Aug 23, 2019 at 02:57:35AM -0400, Jan Stancek wrote:
>
>
>----- Original Message -----
>> On Thu, Aug 22, 2019 at 06:48:50PM -0400, CKI Project wrote:
>> >
>> > Hello,
>> >
>> > We ran automated tests on a patchset that was proposed for merging into
>> > this
>> > kernel tree. The patches were applied to:
>> >
>> >        Kernel repo:
>> >        https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git
>> >             Commit: aad39e30fb9e - Linux 5.2.9
>> >
>> > The results of these automated tests are provided below.
>> >
>> >     Overall result: FAILED (see details below)
>> >              Merge: OK
>> >            Compile: OK
>> >              Tests: FAILED
>> >
>> > All kernel binaries, config files, and logs are available for download
>> > here:
>> >
>> >   https://artifacts.cki-project.org/pipelines/116984
>> >
>> >
>> >
>> > One or more kernel tests failed:
>> >
>> >   aarch64:
>> >     ❌ LTP lite
>> >     ❌ Loopdev Sanity
>>
>> Odd, what suddenly broke?  No new patches had been added to the queue
>> since Tuesday, except I removed a single patch.  Removing a patch
>> shouldn't break anything, right?
>
>It's a race:
>  [ 1289.578972] LTP: starting mtest06 (  mmap1)
>  ...
>  [ 1455.794564] kernel BUG at mm/filemap.c:171!
>
>Here's a verbose description:
>  https://lore.kernel.org/lkml/50b8914e20d1d62bb2dee42d342836c2c16ebee7.1563438048.git.jstancek@redhat.com/
>
>Final (less verbose) patch:
>  e1b98fa31664 ("locking/rwsem: Add missing ACQUIRE to read_slowpath exit when queue is empty")
>
>Code review found also this issue, which is theoretical and very unlikely, but it's a small patch:
>  99143f82a255 ("lcoking/rwsem: Add missing ACQUIRE to read_slowpath sleep loop")

Okay, so this is not a new regression in 5.2 but rather something that
we just ended up hitting now.

We can queue up the fixes for the next release.

--
Thanks,
Sasha
