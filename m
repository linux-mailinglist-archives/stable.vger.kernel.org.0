Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 70956355574
	for <lists+stable@lfdr.de>; Tue,  6 Apr 2021 15:42:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239093AbhDFNmI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 6 Apr 2021 09:42:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:33420 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229911AbhDFNmH (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 6 Apr 2021 09:42:07 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6435A613C7;
        Tue,  6 Apr 2021 13:41:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1617716519;
        bh=b1ThPDuwmdA5W2MfjKGQeqHfVHiU0Eh1TspdbnlE2sg=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=sHPM1UQZS4hn2dl5kIKhIPIfhxk0ID8Z9Zjzxo+Bhgrp8uQzRkAkCxFS+m1p2Mgut
         ndEcguSeiETeDElax3HkXcK9C8tfD3qsNrNMsrFUCkkyLJqcQltHG51m0zaJ7ySt7g
         4Ii5L72Dqil52fieKMirRFPlkezah4OavQ2WzNww=
Date:   Tue, 6 Apr 2021 15:41:57 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Salvatore Bonaccorso <carnil@debian.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Shyam Prasad N <sprasad@microsoft.com>,
        Aurelien Aptel <aaptel@suse.com>,
        Steve French <stfrench@microsoft.com>,
        Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 4.19 013/247] cifs: Set CIFS_MOUNT_USE_PREFIX_PATH flag
 on setting cifs_sb->prepath.
Message-ID: <YGxlJXv/+IPaErUr@kroah.com>
References: <20210301161031.684018251@linuxfoundation.org>
 <20210301161032.337414143@linuxfoundation.org>
 <YGxIMCsclG4E1/ck@eldamar.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YGxIMCsclG4E1/ck@eldamar.lan>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Apr 06, 2021 at 01:38:24PM +0200, Salvatore Bonaccorso wrote:
> Hi,
> 
> On Mon, Mar 01, 2021 at 05:10:33PM +0100, Greg Kroah-Hartman wrote:
> > From: Shyam Prasad N <sprasad@microsoft.com>
> > 
> > [ Upstream commit a738c93fb1c17e386a09304b517b1c6b2a6a5a8b ]
> > 
> > While debugging another issue today, Steve and I noticed that if a
> > subdir for a file share is already mounted on the client, any new
> > mount of any other subdir (or the file share root) of the same share
> > results in sharing the cifs superblock, which e.g. can result in
> > incorrect device name.
> > 
> > While setting prefix path for the root of a cifs_sb,
> > CIFS_MOUNT_USE_PREFIX_PATH flag should also be set.
> > Without it, prepath is not even considered in some places,
> > and output of "mount" and various /proc/<>/*mount* related
> > options can be missing part of the device name.
> > 
> > Signed-off-by: Shyam Prasad N <sprasad@microsoft.com>
> > Reviewed-by: Aurelien Aptel <aaptel@suse.com>
> > Signed-off-by: Steve French <stfrench@microsoft.com>
> > Signed-off-by: Sasha Levin <sashal@kernel.org>
> > ---
> >  fs/cifs/connect.c | 1 +
> >  1 file changed, 1 insertion(+)
> > 
> > diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
> > index 6285085195c15..632249ce61eba 100644
> > --- a/fs/cifs/connect.c
> > +++ b/fs/cifs/connect.c
> > @@ -3882,6 +3882,7 @@ int cifs_setup_cifs_sb(struct smb_vol *pvolume_info,
> >  		cifs_sb->prepath = kstrdup(pvolume_info->prepath, GFP_KERNEL);
> >  		if (cifs_sb->prepath == NULL)
> >  			return -ENOMEM;
> > +		cifs_sb->mnt_cifs_flags |= CIFS_MOUNT_USE_PREFIX_PATH;
> >  	}
> >  
> >  	return 0;
> 
> A user in Debian reported an issue with mounts of DFS shares after an
> update in Debian from 4.19.177 to 4.181:
> 
> https://lists.debian.org/debian-user/2021/04/msg00062.html
> 
> In a test setup i was able to reproduce the issue with 4.19.184 itself
> (but interestingly not withing the 5.10.y series, checked 5.10.26)
> which both contain the above commit.
> 
> 4.19.184 with a738c93fb1c1 ("cifs: Set CIFS_MOUNT_USE_PREFIX_PATH flag
> on setting cifs_sb->prepath.") reverted fixes the issue.
> 
> Is there probably some missing prerequisites missing in the 4.19.y
> brach? I could not test othr versions, but maybe other versions are
> affected as well as before 4.19.y, as the commit was backported to
> 4.14.223 as well.

If there is a missing patch, we will be glad to take it, does 5.4 also
have this problem?

thanks,

greg k-h
