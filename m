Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CAA272A4C3A
	for <lists+stable@lfdr.de>; Tue,  3 Nov 2020 18:04:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726581AbgKCREh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Nov 2020 12:04:37 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:33862 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728066AbgKCREh (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 3 Nov 2020 12:04:37 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1604423076;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=P6Nqd/GTymSo6mkhELu0bxwV3r/gwkmZPBYT64Awjzw=;
        b=HeLwgTjMWvS9joUSbXxBccGlOhrjx6Ozo7/Fj7AFn4UpJyx0ZwBb8RTtacfdnOCrREGPkr
        ZsThG3Ff4FWNV+2iHFeNFL7D5TOVBOisAUBp/rEL6xFt6RhtV1H1Uy1q1vVdxlvH9tGDkC
        xUP/VstOqX+yJU2RGvwlut4TXlMC50c=
Received: from mail-pf1-f197.google.com (mail-pf1-f197.google.com
 [209.85.210.197]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-223-KpLTPoZWOfupDhFsdP9b-g-1; Tue, 03 Nov 2020 12:04:34 -0500
X-MC-Unique: KpLTPoZWOfupDhFsdP9b-g-1
Received: by mail-pf1-f197.google.com with SMTP id x9so1765165pff.10
        for <stable@vger.kernel.org>; Tue, 03 Nov 2020 09:04:33 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=P6Nqd/GTymSo6mkhELu0bxwV3r/gwkmZPBYT64Awjzw=;
        b=JgqH0eKVesNOrmJ/a/q2ISROHzPfoFv4zShnLHfeeJN8e7UMe/gbfT9jJ6EO5CXUrU
         076RfltGykzfkHpZvCOrTKVFrUIuN8GqcMJSNO38tFjQYeVzyy4nxW7l3A9IGFgIerO4
         kUtGSARF9TmsCtxlgOwngvGIU5Qg+qYwoZDDNVZBLTsSVHlC75YftVTLENopQg9uqG15
         mk9RgyFCvTFy1yXbJJDkftVsS/xP6saT1WcunUhdfGwRD2tUvCUT19fXkjwOBpH7Emk9
         94wOKXsVpTy7iVZ/7rJp5/YgfBUGhe54lBkKPY+d8TKZSpqa0qqomof3UbTJMieTaX00
         A2jw==
X-Gm-Message-State: AOAM530DavPano4OWY1R0W6VqENjEczu9oy8czmGepk9oIfCuDjugE6Z
        O/MFdkwPM6zAdl4qQlTvreitkVDrFUHcfc9d//UsXpsr0D5OQsnWD4yP7z6nIc/kIjw4GH9TjTx
        hNFVCxBRk8cY9qtb8
X-Received: by 2002:a17:90a:7089:: with SMTP id g9mr160163pjk.4.1604423072875;
        Tue, 03 Nov 2020 09:04:32 -0800 (PST)
X-Google-Smtp-Source: ABdhPJzKrStQIiawQJXfEFp92+BAuOv0tSVW7WzCsy3loX2ZPEWNt9Fyvdp3RWqxou54wmyvUe6r9g==
X-Received: by 2002:a17:90a:7089:: with SMTP id g9mr160141pjk.4.1604423072675;
        Tue, 03 Nov 2020 09:04:32 -0800 (PST)
Received: from xiangao.remote.csb ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id v24sm15775598pgi.91.2020.11.03.09.04.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 Nov 2020 09:04:31 -0800 (PST)
Date:   Wed, 4 Nov 2020 01:04:21 +0800
From:   Gao Xiang <hsiangkao@redhat.com>
To:     Chao Yu <chao@kernel.org>
Cc:     Chao Yu <yuchao0@huawei.com>, linux-erofs@lists.ozlabs.org,
        LKML <linux-kernel@vger.kernel.org>, nl6720 <nl6720@gmail.com>,
        stable <stable@vger.kernel.org>
Subject: Re: [PATCH] erofs: derive atime instead of leaving it empty
Message-ID: <20201103170421.GB886627@xiangao.remote.csb>
References: <20201031195102.21221-1-hsiangkao.ref@aol.com>
 <20201031195102.21221-1-hsiangkao@aol.com>
 <20201103025033.GA788000@xiangao.remote.csb>
 <275b73d7-9865-91c0-ecf2-bceed09a4dae@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <275b73d7-9865-91c0-ecf2-bceed09a4dae@kernel.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Chao,

On Tue, Nov 03, 2020 at 11:58:42PM +0800, Chao Yu wrote:
> Hi Xiang,
> 
> On 2020-11-3 10:50, Gao Xiang wrote:
> > Hi Chao,
> > 
> > On Sun, Nov 01, 2020 at 03:51:02AM +0800, Gao Xiang wrote:
> > > From: Gao Xiang <hsiangkao@redhat.com>
> > > 
> > > EROFS has _only one_ ondisk timestamp (ctime is currently
> > > documented and recorded, we might also record mtime instead
> > > with a new compat feature if needed) for each extended inode
> > > since EROFS isn't mainly for archival purposes so no need to
> > > keep all timestamps on disk especially for Android scenarios
> > > due to security concerns. Also, romfs/cramfs don't have their
> > > own on-disk timestamp, and squashfs only records mtime instead.
> > > 
> > > Let's also derive access time from ondisk timestamp rather than
> > > leaving it empty, and if mtime/atime for each file are really
> > > needed for specific scenarios as well, we can also use xattrs
> > > to record them then.
> > > 
> > > Reported-by: nl6720 <nl6720@gmail.com>
> > > [ Gao Xiang: It'd be better to backport for user-friendly concern. ]
> > > Fixes: 431339ba9042 ("staging: erofs: add inode operations")
> > > Cc: stable <stable@vger.kernel.org> # 4.19+
> > > Signed-off-by: Gao Xiang <hsiangkao@redhat.com>
> > 
> > May I ask for some extra free slots to review this patch plus
> > [PATCH 1/4] of
> > https://lore.kernel.org/r/20201022145724.27284-1-hsiangkao@aol.com
> > 
> > since it'd be also in linux-next for a while before sending out
> > to Linus. And the debugging messages may also be an annoying
> > thing for users.
> 
> Sorry for the delay review, will check the details tomorrow. :)

No problem, thanks! If we'd like to submit a -fixes pull request,
it'd be better not to be in the latter half of 5.10 rc... And
considering that it'd be stayed in linux-next for almost a week,
so yeah... (Only these 2 patches are considered for -fixes for now.)

Thanks.
Gao Xiang

> 
> Thanks,
> 
> > 
> > Thanks a lot!
> > 
> > Thanks,
> > Gao Xiang
> > 
> 

