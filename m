Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0BCE913023E
	for <lists+stable@lfdr.de>; Sat,  4 Jan 2020 12:53:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725827AbgADLxN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 4 Jan 2020 06:53:13 -0500
Received: from mail.kernel.org ([198.145.29.99]:44532 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725796AbgADLxM (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 4 Jan 2020 06:53:12 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0149A24649;
        Sat,  4 Jan 2020 11:53:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1578138790;
        bh=/zeTUOLPTnr8cd2pSmtDmYm5FZFtcaNSMd3zUfMLuZM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=s+7E9Yp0eTdm44eKkGtBoeqw6sqgYg8JOj9PgeNZ9OGjrdWq+WCgPTu0y7EGV8zvI
         Tol8GWIkZkFLgZH6fCTuWO0jxpFBnlTw7y6dbm9SaBAOPc35dCD6DzUFAX2rRpEtdW
         wtUyfwMRn4lr6ykgjL03wt4RYJjJC+qxYaTgqR6Q=
Date:   Sat, 4 Jan 2020 12:53:08 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Chengguang Xu <cgxu519@mykernel.net>
Cc:     Pavel Machek <pavel@denx.de>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        stable <stable@vger.kernel.org>, Chao Yu <yuchao0@huawei.com>,
        Jaegeuk Kim <jaegeuk@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 4.19 062/114] f2fs: choose hardlimit when softlimit is
 larger than hardlimit in f2fs_statfs_project()
Message-ID: <20200104115308.GA1296856@kroah.com>
References: <20200102220029.183913184@linuxfoundation.org>
 <20200102220035.294585461@linuxfoundation.org>
 <20200103171213.GC14328@amd>
 <16f6e3f5bbe.d291a05d38838.5222280714928609391@mykernel.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <16f6e3f5bbe.d291a05d38838.5222280714928609391@mykernel.net>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sat, Jan 04, 2020 at 09:50:43AM +0800, Chengguang Xu wrote:
>  ---- 在 星期六, 2020-01-04 01:12:13 Pavel Machek <pavel@denx.de> 撰写 ----
>  > Hi!
>  > 
>  > > From: Chengguang Xu <cgxu519@mykernel.net>
>  > > 
>  > > [ Upstream commit 909110c060f22e65756659ec6fa957ae75777e00 ]
>  > > 
>  > > Setting softlimit larger than hardlimit seems meaningless
>  > > for disk quota but currently it is allowed. In this case,
>  > > there may be a bit of comfusion for users when they run
>  > > df comamnd to directory which has project quota.
>  > > 
>  > > For example, we set 20M softlimit and 10M hardlimit of
>  > > block usage limit for project quota of test_dir(project id 123).
>  > 
>  > > Signed-off-by: Chengguang Xu <cgxu519@mykernel.net>
>  > > Reviewed-by: Chao Yu <yuchao0@huawei.com>
>  > > Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
>  > > Signed-off-by: Sasha Levin <sashal@kernel.org>
>  > > ---
>  > >  fs/f2fs/super.c | 20 ++++++++++++++------
>  > >  1 file changed, 14 insertions(+), 6 deletions(-)
>  > > 
>  > > diff --git a/fs/f2fs/super.c b/fs/f2fs/super.c
>  > > index 7a9cc64f5ca3..662c7de58b99 100644
>  > > --- a/fs/f2fs/super.c
>  > > +++ b/fs/f2fs/super.c
>  > > @@ -1148,9 +1148,13 @@ static int f2fs_statfs_project(struct super_block *sb,
>  > >          return PTR_ERR(dquot);
>  > >      spin_lock(&dquot->dq_dqb_lock);
>  > >  
>  > > -    limit = (dquot->dq_dqb.dqb_bsoftlimit ?
>  > > -         dquot->dq_dqb.dqb_bsoftlimit :
>  > > -         dquot->dq_dqb.dqb_bhardlimit) >> sb->s_blocksize_bits;
>  > > +    limit = 0;
>  > > +    if (dquot->dq_dqb.dqb_bsoftlimit)
>  > > +        limit = dquot->dq_dqb.dqb_bsoftlimit;
>  > > +    if (dquot->dq_dqb.dqb_bhardlimit &&
>  > > +            (!limit || dquot->dq_dqb.dqb_bhardlimit < limit))
>  > > +        limit = dquot->dq_dqb.dqb_bhardlimit;
>  > > +
>  > >      if (limit && buf->f_blocks > limit) {
>  > 
>  > >> blocksize disappeared here. That can't be right.
>  > 
>  > Plus, is this just obfuscated way of saying
>  > 
>  > limit = min_not_zero(dquot->dq_dqb.dqb_bsoftlimit, dquot->dq_dqb.dqb_bhardlimit)?
>  > 
> 
> Please  skip this patch from  stable list,  I'll send  a revised patch to upstream.

This patch is already in Linus's tree, so you can't send a "revised"
version, only one that applies on top of this one :)

That being said, I'll go drop this from the stable queues, thanks.
Please let us know when the fixed patch is in Linus's tree and we will
be glad to take both of them.

greg k-h
