Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7A84B185318
	for <lists+stable@lfdr.de>; Sat, 14 Mar 2020 01:01:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727687AbgCNAA5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 13 Mar 2020 20:00:57 -0400
Received: from mail.kernel.org ([198.145.29.99]:32922 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726853AbgCNAA5 (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 13 Mar 2020 20:00:57 -0400
Received: from localhost (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 87539206E7;
        Sat, 14 Mar 2020 00:00:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1584144056;
        bh=khmpfQn21NRDaavNqLxLReiUOyXirfo2Gw5bHnAFDmI=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=ZTFgMIbmGBKPA7/ms7szy+s1oKsuHD4F5kUI6NZsCS56f7sFLBBKFw6Rcyf8L0bx1
         Y3cH1ojKhJPXq4EN4qCzhSG1X+pRa5Wl82J1fqyDRW46f+UCTeKZoklnhs/wljgvnb
         D/40SQNbovvGeBU/vXXVlHRuIzUGzSj5uUosqQvI=
Date:   Fri, 13 Mar 2020 20:00:55 -0400
From:   Sasha Levin <sashal@kernel.org>
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     Petr Malat <oss@malat.biz>,
        Trond Myklebust <trond.myklebust@hammerspace.com>,
        Benjamin Coddington <bcodding@redhat.com>,
        Anna Schumaker <Anna.Schumaker@netapp.com>,
        stable <stable@vger.kernel.org>,
        Security Officers <security@kernel.org>
Subject: Re: [PATCH] NFS: Remove superfluous kmap in nfs_readdir_xdr_to_array
Message-ID: <20200314000055.GG1349@sasha-vm>
References: <20200313202443.2539-1-oss@malat.biz>
 <CAHk-=wgbhYWxprGr1puAabZZFp4O3myBv-W9dJCVYt8r=dxZNQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <CAHk-=wgbhYWxprGr1puAabZZFp4O3myBv-W9dJCVYt8r=dxZNQ@mail.gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Mar 13, 2020 at 02:05:27PM -0700, Linus Torvalds wrote:
>Adding more people.
>
>The old stable trees seem to have rather different code.
>
>[ Goes off and looks at the stable trees ]
>
>Petr seems entirely correct - the stable tree backport appears broken.
>
>Because looking at that commit 67a56e9743171 in the stable tree, it
>doesn't seem to match commit 4b310319c6a8 ("NFS: Fix memory leaks and
>corruption in readdir") in mainline.
>
>That stable backport looks bogus. It added that
>
>        array = kmap(page);
>
>line from somewhere else, probably because the stable tree didn't have
>the line at all, and it was there in the context.

I botched up that backport, sorry.

>Because while mainline has that line to initialize array with kmap(),
>in those stable trees, we have
>
>        array = nfs_readdir_get_array(page);
>
>and as Petr says, the kmap has been done there already, and it will be
>kunmap'ed by nfs_readdir_release_array().
>
>And looking closer, this same bug seems to have happened twice: it
>also exists in 0b0223f9c3a8.
>
>But somebody else should double-check me - somebody who actually knows the code.
>
>As to how I found the other case, do this in the stable git repo with
>all the stable tags:
>
>    git log -p --no-merges --all \
>        --grep="NFS: Fix memory leaks and corruption in readdir"
>
>to see all the copies of that commit backport.
>
>Add a
>
>    -S'kmap(page)'
>
>to that line to see the cases that added that line. Or to just get the commits:
>
>    git log --oneline --no-merges --all \
>        --grep="NFS: Fix memory leaks and corruption in readdir" \
>        -S'kmap(page)'
>
>and the result is
>
>    67a56e974317 NFS: Fix memory leaks and corruption in readdir
>    0b0223f9c3a8 NFS: Fix memory leaks and corruption in readdir

I've applied to fix to the 4.9 and 4.4 trees, thank you!

-- 
Thanks,
Sasha
