Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 13A922A4A7E
	for <lists+stable@lfdr.de>; Tue,  3 Nov 2020 16:58:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727961AbgKCP6u (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Nov 2020 10:58:50 -0500
Received: from mail.kernel.org ([198.145.29.99]:42212 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726312AbgKCP6u (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 3 Nov 2020 10:58:50 -0500
Received: from [192.168.0.112] (unknown [117.89.214.195])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8133F20870;
        Tue,  3 Nov 2020 15:58:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604419129;
        bh=f29d1wETJnFFOtXCHry4rt0aAdsEHjADIZSHXNcZEw4=;
        h=Subject:To:References:Cc:From:Date:In-Reply-To:From;
        b=mDmilPl3uHLlORwpgRDaKaE+rOVUG8Oo71Cbiy9N42GlzeZ5WECj2DTNmmTZpsa0U
         965hDAg7OT0Iz0S5+CQg473ryEPxeyaE7keYtQnncduHSjc3jhTIHHfr/IAAuo/WkT
         JGdC5BfRgrFb59B5i8bMdFZP9cmCi/khNzphFIyo=
Subject: Re: [PATCH] erofs: derive atime instead of leaving it empty
To:     Gao Xiang <hsiangkao@redhat.com>, Chao Yu <yuchao0@huawei.com>
References: <20201031195102.21221-1-hsiangkao.ref@aol.com>
 <20201031195102.21221-1-hsiangkao@aol.com>
 <20201103025033.GA788000@xiangao.remote.csb>
Cc:     linux-erofs@lists.ozlabs.org, LKML <linux-kernel@vger.kernel.org>,
        nl6720 <nl6720@gmail.com>, stable <stable@vger.kernel.org>
From:   Chao Yu <chao@kernel.org>
Message-ID: <275b73d7-9865-91c0-ecf2-bceed09a4dae@kernel.org>
Date:   Tue, 3 Nov 2020 23:58:42 +0800
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:45.0) Gecko/20100101
 Thunderbird/45.8.0
MIME-Version: 1.0
In-Reply-To: <20201103025033.GA788000@xiangao.remote.csb>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Xiang,

On 2020-11-3 10:50, Gao Xiang wrote:
> Hi Chao,
>
> On Sun, Nov 01, 2020 at 03:51:02AM +0800, Gao Xiang wrote:
>> From: Gao Xiang <hsiangkao@redhat.com>
>>
>> EROFS has _only one_ ondisk timestamp (ctime is currently
>> documented and recorded, we might also record mtime instead
>> with a new compat feature if needed) for each extended inode
>> since EROFS isn't mainly for archival purposes so no need to
>> keep all timestamps on disk especially for Android scenarios
>> due to security concerns. Also, romfs/cramfs don't have their
>> own on-disk timestamp, and squashfs only records mtime instead.
>>
>> Let's also derive access time from ondisk timestamp rather than
>> leaving it empty, and if mtime/atime for each file are really
>> needed for specific scenarios as well, we can also use xattrs
>> to record them then.
>>
>> Reported-by: nl6720 <nl6720@gmail.com>
>> [ Gao Xiang: It'd be better to backport for user-friendly concern. ]
>> Fixes: 431339ba9042 ("staging: erofs: add inode operations")
>> Cc: stable <stable@vger.kernel.org> # 4.19+
>> Signed-off-by: Gao Xiang <hsiangkao@redhat.com>
>
> May I ask for some extra free slots to review this patch plus
> [PATCH 1/4] of
> https://lore.kernel.org/r/20201022145724.27284-1-hsiangkao@aol.com
>
> since it'd be also in linux-next for a while before sending out
> to Linus. And the debugging messages may also be an annoying
> thing for users.

Sorry for the delay review, will check the details tomorrow. :)

Thanks,

>
> Thanks a lot!
>
> Thanks,
> Gao Xiang
>
