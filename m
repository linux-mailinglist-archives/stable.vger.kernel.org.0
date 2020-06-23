Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B89DD20585A
	for <lists+stable@lfdr.de>; Tue, 23 Jun 2020 19:16:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732913AbgFWRQP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Jun 2020 13:16:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:45210 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732565AbgFWRQP (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 23 Jun 2020 13:16:15 -0400
Received: from localhost (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5655720780;
        Tue, 23 Jun 2020 17:16:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592932574;
        bh=zIFMUdRtrDfrUjfIdnOYBBIbHPhs1Vg38taEV1Fq9eM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=SecGrRkG/Ps5OBToybDUH6vdXzzo7ec+Uka790MxbylSYhFK3e1AJGxv1J9PvLY6J
         aGmj2p2wQByUQN/bHB2rxunDDKKi/a6fKfHp9RhdgGeoAqXz2VCrSJ8AhF8TyaV8dH
         1TWh9xsRPzalXKSS7tVZQdAhU89iLCGY2nCPfKBM=
Date:   Tue, 23 Jun 2020 13:16:13 -0400
From:   Sasha Levin <sashal@kernel.org>
To:     Naresh Kamboju <naresh.kamboju@linaro.org>
Cc:     open list <linux-kernel@vger.kernel.org>,
        linux- stable <stable@vger.kernel.org>,
        Miklos Szeredi <mszeredi@redhat.com>,
        linux-unionfs@vger.kernel.org, lkft-triage@lists.linaro.org
Subject: Re: [PATCH AUTOSEL 4.14 090/108] ovl: verify permissions in
 ovl_path_open()
Message-ID: <20200623171613.GB1931@sasha-vm>
References: <20200618012600.608744-1-sashal@kernel.org>
 <20200618012600.608744-90-sashal@kernel.org>
 <CA+G9fYuBGRz9=Q5KyCat0qk_8aiGvNsreY05rcGSjMZpvM1FJg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <CA+G9fYuBGRz9=Q5KyCat0qk_8aiGvNsreY05rcGSjMZpvM1FJg@mail.gmail.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Jun 23, 2020 at 08:55:38PM +0530, Naresh Kamboju wrote:
>On Thu, 18 Jun 2020 at 07:18, Sasha Levin <sashal@kernel.org> wrote:
>>
>> From: Miklos Szeredi <mszeredi@redhat.com>
>>
>> [ Upstream commit 56230d956739b9cb1cbde439d76227d77979a04d ]
>>
>> Check permission before opening a real file.
>>
>> ovl_path_open() is used by readdir and copy-up routines.
>>
>> ovl_permission() theoretically already checked copy up permissions, but it
>> doesn't hurt to re-do these checks during the actual copy-up.
>>
>> For directory reading ovl_permission() only checks access to topmost
>> underlying layer.  Readdir on a merged directory accesses layers below the
>> topmost one as well.  Permission wasn't checked for these layers.
>>
>> Note: modifying ovl_permission() to perform this check would be far more
>> complex and hence more bug prone.  The result is less precise permissions
>> returned in access(2).  If this turns out to be an issue, we can revisit
>> this bug.
>>
>> Signed-off-by: Miklos Szeredi <mszeredi@redhat.com>
>> Signed-off-by: Sasha Levin <sashal@kernel.org>
>> ---
>>  fs/overlayfs/util.c | 27 ++++++++++++++++++++++++++-
>>  1 file changed, 26 insertions(+), 1 deletion(-)
>>
>> diff --git a/fs/overlayfs/util.c b/fs/overlayfs/util.c
>> index afdc2533ce74..76d6610767f6 100644
>> --- a/fs/overlayfs/util.c
>> +++ b/fs/overlayfs/util.c
>> @@ -307,7 +307,32 @@ bool ovl_is_whiteout(struct dentry *dentry)
>>
>>  struct file *ovl_path_open(struct path *path, int flags)
>>  {
>> -       return dentry_open(path, flags | O_NOATIME, current_cred());
>> +       struct inode *inode = d_inode(path->dentry);
>> +       int err, acc_mode;
>> +
>> +       if (flags & ~(O_ACCMODE | O_LARGEFILE))
>> +               BUG();
>> +
>> +       switch (flags & O_ACCMODE) {
>> +       case O_RDONLY:
>> +               acc_mode = MAY_READ;
>> +               break;
>> +       case O_WRONLY:
>> +               acc_mode = MAY_WRITE;
>> +               break;
>> +       default:
>> +               BUG();
>
>This BUG: triggered on stable-rc 5.7, 5.4, 4.19 and 4.14.
>
>steps to reproduce:
>          - cd /opt/ltp
>          - ./runltp -s execveat03

Yup, that patch has been dropped, thanks for testing!

-- 
Thanks,
Sasha
