Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 339F41DAE83
	for <lists+stable@lfdr.de>; Wed, 20 May 2020 11:18:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726403AbgETJS3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 20 May 2020 05:18:29 -0400
Received: from sender4-of-o53.zoho.com ([136.143.188.53]:21347 "EHLO
        sender4-of-o53.zoho.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726224AbgETJS2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 20 May 2020 05:18:28 -0400
ARC-Seal: i=1; a=rsa-sha256; t=1589966288; cv=none; 
        d=zohomail.com; s=zohoarc; 
        b=ihVFbntSonZCZUhUlfR1ZBdOUzVjWAFTOdTKRKxJ96RoQQLAK/XgxzZztgtFxCVdgr3IU0We04RHc9wSxVVLD4VFGTD/xVpDqtgr/EBMePIhBFidUAgTtNXj96vBggbxxaV2LT3gx/aCZQjIGz28jKkzoLjm5PTAFhPG/AW1N1g=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.com; s=zohoarc; 
        t=1589966288; h=Content-Type:Cc:Date:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:To; 
        bh=ReO2NAMmKkmb2ZqyEv+fYW8Cp7V4KH9ubYzkNATgBsE=; 
        b=TjPuBz76AimuwpxaRCO15Lfdec8ABp3xQPTwXf2p9agmOmLbdkNnQrypv0W5E1lHcMz/VhQC1S5eoA19Zg5AELRodIGHykqasc2Hsfk6MGioBfbL98sR8y8TCY/3R/CjuH771ZegMoD0eQzbXkPLrtE94p+5SQHoty6RUx1jWXw=
ARC-Authentication-Results: i=1; mx.zohomail.com;
        dkim=pass  header.i=embedjournal.com;
        spf=pass  smtp.mailfrom=siddharth@embedjournal.com;
        dmarc=pass header.from=<siddharth@embedjournal.com> header.from=<siddharth@embedjournal.com>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1589966288;
        s=zoho; d=embedjournal.com; i=siddharth@embedjournal.com;
        h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:Content-Type:In-Reply-To;
        bh=ReO2NAMmKkmb2ZqyEv+fYW8Cp7V4KH9ubYzkNATgBsE=;
        b=f5dwztbp+ivj5TedRVVHhUDRDP+0V/3qfnig6c/ijEx5Nx4emWG9+44DMujQ5yDL
        avfyp3lDEp4lGzPkTiYgT9GxIOWAPl9q5pz9EwfcJ1O7woMGYVz7lE8wJ1q5Jep96sh
        QN43I4v1xleTDRuGtv0BxTmh7mCrXoSWmvVf+6ps=
Received: from localhost (27.7.68.227 [27.7.68.227]) by mx.zohomail.com
        with SMTPS id 1589966285913263.86547243524865; Wed, 20 May 2020 02:18:05 -0700 (PDT)
Date:   Wed, 20 May 2020 14:48:00 +0530
From:   Siddharth Chandrasekaran <siddharth@embedjournal.com>
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     Siddharth Chandrasekaran <csiddharth@vmware.com>,
        srostedt@vmware.com, stable@vger.kernel.org, srivatsab@vmware.com,
        dchinner@redhat.com, darrick.wong@oracle.com,
        srivatsa@csail.mit.edu
Subject: Re: [PATCH v2] Backport xfs security fix to 4.9 and 4.4 stable trees
Message-ID: <20200520091800.GA5069@csiddharth-a01.vmware.com>
References: <cover.1589544531.git.csiddharth@vmware.com>
 <20200515152230.GA2599290@kroah.com>
 <20200515155838.GA9039@csiddharth-a01.vmware.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20200515155838.GA9039@csiddharth-a01.vmware.com>
X-ZohoMailClient: External
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, May 15, 2020 at 09:28:38PM +0530, Siddharth Chandrasekaran wrote:
>On Fri, May 15, 2020 at 05:22:30PM +0200, Greg KH wrote:
>> On Fri, May 15, 2020 at 08:41:07PM +0530, Siddharth Chandrasekaran wrote:
>> > Hello,
>> >
>> > Lack of proper validation that cached inodes are free during allocation can,
>> > cause a crash in fs/xfs/xfs_icache.c (refer: CVE-2018-13093). To address this
>> > issue, I'm backporting upstream commit [1] to 4.4 and 4.9 stable trees
>> > (a backport of [1] to 4.14 already exists).
>> >
>> > Also, commit [1] references another commit [2] which added checks only to
>> > xfs_iget_cache_miss(). In this patch, those checks have been moved into a
>> > dedicated checker method and both xfs_iget_cache_miss() and
>> > xfs_iget_cache_hit() are made to call that method. This code reorg in commit
>> > [1], makes commit [2] redundant in the history of the 4.9 and 4.4 stable
>> > trees. So commit [2] is not being backported.
>> >
>> > -- Sid
>> >
>> > [1]: afca6c5b2595 ("xfs: validate cached inodes are free when allocated")
>> > [2]: ee457001ed6c ("xfs: catch inode allocation state mismatch corruption")
>> >
>> > change log:
>> > v2:
>> >  - Reword cover letter.
>> >  - Fix accidental worong patch that got mailed.
>>
>> As the XFS maintainers want to see xfstests pass with any changes made,
>> have you done so for the 4.9 and 4.4 trees with this patch applied?
>
>I haven't run them yet. I'll do so and get back with the results
>shortly.
>
Hi Greg,

I am having some issue setting up my xfstests testing environment. On a
Ubuntu 20.04 LTS VM, I installed 4.9.223 kernel with this patch applied.
Then cloned xfstests-dev repository from [1] and setup the test
environment as explained in the top-level README file. After this, I did
the following:

  - Added a new disk (/dev/sdb1) and created 2 partitions of (64 GB each).
  - Formatted /dev/sdb1 to xfs and dropped a few kernel source tarballs
    into to it.
  - Copied local.config.example to local.config and modified it as:
	export TEST_DEV=/dev/sdb1
	export TEST_DIR=/mnt/t0
	export SCRATCH_DEV=/dev/sdb2
	export SCRATCH_MNT=/mnt/scratch
  - Executed: sudo ./check -g all

When executing the tests, I observed multiple failures. In addition to
test failures, the testing script just froze after executing some some
test cases (more frequently test 269) when trying to perform a mount or
umount operation on either of the newly added partitions.

So I presumed the patch was buggy and reverted the change to re try the
test. Interestingly, that too failed and produced similar results. dmesg
is filled with xfs errors, with the most frequent being:

   XFS (dm-0): metadata I/O error: block 0x3 ("xfs_trans_read_buf_map") error 5 numblks 1

obviously, I must be doing something wrong; I can try to dig deeper
figure it out myself but wanted to check with you first, if you can spot
something obviously wrong in what I'm doing.

Thanks!

-- Sid.

[1]: https://git.kernel.org/pub/scm/fs/xfs/xfstests-dev.git
