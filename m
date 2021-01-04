Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 924652E9D05
	for <lists+stable@lfdr.de>; Mon,  4 Jan 2021 19:30:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726098AbhADS3m (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 4 Jan 2021 13:29:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40706 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725889AbhADS3m (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 4 Jan 2021 13:29:42 -0500
Received: from mail-qt1-x829.google.com (mail-qt1-x829.google.com [IPv6:2607:f8b0:4864:20::829])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9A6B0C061574
        for <stable@vger.kernel.org>; Mon,  4 Jan 2021 10:29:01 -0800 (PST)
Received: by mail-qt1-x829.google.com with SMTP id z3so19092611qtw.9
        for <stable@vger.kernel.org>; Mon, 04 Jan 2021 10:29:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=toxicpanda-com.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=O64pWj+RvIFAfFiH8tuZ7s1NGNc6FTJ4sG3Ieys6QrY=;
        b=wRqj6SbS94Mj+/ajDacS4ibcd8nDAfYxcO6ARwoktN/jEmvDLC3RF+VKi981XBR3u0
         MfXkeeTx4TQb3nmtnpUoCKbtl543Pl0aYGNsEY0kKR/FUxVW9MEElEdnf575ax1OpdCo
         V5kdFEn5IWe2xNr27knYhP9u/mM8y6DzOVkiX7hvkkLy66ejfii/yJAZKf1/0Q8lUHEc
         vaPHVcASr29v71Hdg88wJQKD2ppHGVE9g5/BJnqXCx6AYzR9QP3KeaHUX+ShBjfkIyXk
         2dqrushw/5NcJFRA1xb/Iak/9LwPOMSF0cxzWKOqZnk9NaZMa4A+46KfTtc/ghljmo91
         KH6A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=O64pWj+RvIFAfFiH8tuZ7s1NGNc6FTJ4sG3Ieys6QrY=;
        b=msbPVgN+3jmvucjMaObV2moMshUO1drq+V4y2sdNpJfc9eb7rWQzamRMqiJlxDPN/P
         SsumySw9lKUKgjlklnxE7zWI5yKiWLe6V2KAHSYSpcAUQ94Z1WFDjC4R7dr10nb7fM71
         PRNswhfl5tmsw589gOG1zjvJkNyhWxZBwrfdhFz/L2QMekvjXGP9XBl+ig48PBp0wB1j
         HWKLzVv7SHYWoSNWlLOaj+3gLyhzZTfbRFLl/SYAtZH49lxNvmkC1tSsVSKGEIMhfMMI
         5sMOHabQP1DjY3c4i+aQU2o7rRcvTz6BYWBYhbY+z5ZSSWCdhyhJ/OUZNIp6HdpvVg5o
         gexA==
X-Gm-Message-State: AOAM530NxxLwT1rjp9nbZVbKVMn2ji/vb5bkSWN/Uj2vNzLQGx3LGV0h
        J95/H+iL5bRNr+y5KVoy1aNYSA==
X-Google-Smtp-Source: ABdhPJyOqUlMmHAhtDTDmWvr6dZhJzmJ++gFs3tKBd5eBbDDWHSnoo1YN+VQtUFiKLcQuZ9eX8YU2Q==
X-Received: by 2002:ac8:70c1:: with SMTP id g1mr71430704qtp.108.1609784940788;
        Mon, 04 Jan 2021 10:29:00 -0800 (PST)
Received: from [192.168.1.45] (cpe-174-109-172-136.nc.res.rr.com. [174.109.172.136])
        by smtp.gmail.com with ESMTPSA id e10sm36838491qtr.92.2021.01.04.10.28.59
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 04 Jan 2021 10:29:00 -0800 (PST)
Subject: Re: [PATCH] btrfs: Use the normal writeback path for flushing
 delalloc
To:     fdmanana@gmail.com
Cc:     linux-btrfs <linux-btrfs@vger.kernel.org>, kernel-team@fb.com,
        stable@vger.kernel.org,
        =?UTF-8?Q?Ren=c3=a9_Rebe?= <rene@exactcode.de>
References: <7a1048dfbc8d2f5f3869f072146ec3e499bc0ac2.1609779712.git.josef@toxicpanda.com>
 <CAL3q7H5-L7Qs1ecZXPNiQ58rOCMXbpRaPPVFaEEnL0Gcmmfyvw@mail.gmail.com>
From:   Josef Bacik <josef@toxicpanda.com>
Message-ID: <82aa5616-4d57-ddda-69f3-8bb6497583e3@toxicpanda.com>
Date:   Mon, 4 Jan 2021 13:28:59 -0500
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.5.1
MIME-Version: 1.0
In-Reply-To: <CAL3q7H5-L7Qs1ecZXPNiQ58rOCMXbpRaPPVFaEEnL0Gcmmfyvw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 1/4/21 12:23 PM, Filipe Manana wrote:
> On Mon, Jan 4, 2021 at 5:06 PM Josef Bacik <josef@toxicpanda.com> wrote:
>>
>> This is a revert for 38d715f494f2 ("btrfs: use
>> btrfs_start_delalloc_roots in shrink_delalloc").  A user reported a
>> problem where performance was significantly worse with this patch
>> applied.  The problem needs to be fixed with proper pre-flushing, and
>> changes to how we deal with the work queues for the inodes.  However
>> that work is much more complicated than is acceptable for stable, and
>> simply reverting this patch fixes the problem.  The original patch was
>> a cleanup of the code, so it's fine to revert it.  My numbers for the
>> original reported test, which was untarring a copy of the firefox
>> sources, are as follows
>>
>> 5.9     0m54.258s
>> 5.10    1m26.212s
>> Fix     0m35.038s
>>
>> cc: stable@vger.kernel.org # 5.10
>> Reported-by: René Rebe <rene@exactcode.de>
>> Fixes: 38d715f494f2 ("btrfs: use btrfs_start_delalloc_roots in shrink_delalloc")
>> Signed-off-by: Josef Bacik <josef@toxicpanda.com>
>> ---
>> Dave, this is ontop of linus's branch, because we've changed the arguments for
>> btrfs_start_delalloc_roots in misc-next, and this needs to go back to 5.10 ASAP.
>> I can send a misc-next version if you want to have it there as well while we're
>> waiting for it to go into linus's tree, just let me know.
> 
> Adding this to stable releases will also make the following fix not
> work on stable releases:
> 
> https://lore.kernel.org/linux-btrfs/39c2a60aa682f69f9823f51aa119d37ef4b9f834.1606909923.git.fdmanana@suse.com/
> 
> Since now the async reclaim task can trigger writeback through
> writeback_inodes_sb_nr() and not only through
> btrfs_start_delalloc_roots().
> Other than changing that patch to make extent_write_cache_pages() do
> nothing when the inode has the bit BTRFS_INODE_NO_DELALLOC_FLUSH set,
> I'm not seeing other simple ways to do it.

Hmmm shit, ok let me see if I can make the perf regression go away while still 
using btrfs_start_delalloc_roots().  Thanks,

Josef
