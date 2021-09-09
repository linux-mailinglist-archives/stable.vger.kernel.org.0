Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B8D8C4044FA
	for <lists+stable@lfdr.de>; Thu,  9 Sep 2021 07:28:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350724AbhIIF3s (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 9 Sep 2021 01:29:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:45816 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230449AbhIIF3s (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 9 Sep 2021 01:29:48 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5F4D86103E;
        Thu,  9 Sep 2021 05:28:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631165319;
        bh=JBYEvUU/jP+Gm4/gW+xvo3rz5yQoWysX7uaXBTr4pOU=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=DvYIK5rnPz6Lk122E3ki56xeVkn56Gl7J8l3A0L+RTlke7pB0xQqudMDpkffCip1F
         4ssZhxrjsqKATZ9bM1/IgdaU2Mlg41EDV+bVlGop0l8gP3zPplrru/k3dJjRlEt1SW
         /Qq1kyVI6HfLegXQSyI2a9RvPidzj5Tx1mcBngb4Rb+dQhdXTruDKlohZc3b3TH5bM
         40mqTcRnixZ9wdXn7mDOZvdy1l2aANpqxcHTjYZxaXVlbjf6mSBH3qUwtihwaVAOul
         qsYKk/C4dkRVCtxP0B82mEL7jvXA8klbpva8PicE319KRyCXc1DDLzZsB7Rxgy+Uz7
         jfdhjhduYfCTQ==
Date:   Wed, 8 Sep 2021 22:28:37 -0700
From:   Jaegeuk Kim <jaegeuk@kernel.org>
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     stable@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net,
        Chao Yu <chao@kernel.org>
Subject: Re: [PATCH] f2fs: guarantee to write dirty data when enabling
 checkpoint back
Message-ID: <YTmbhc7J5ZdVp3vI@google.com>
References: <20210908220020.599899-1-jaegeuk@google.com>
 <YTmaPCd3/cpMyNEe@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YTmaPCd3/cpMyNEe@kroah.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 09/09, Greg KH wrote:
> On Wed, Sep 08, 2021 at 03:00:20PM -0700, Jaegeuk Kim wrote:
> > From: Jaegeuk Kim <jaegeuk@kernel.org>
> > 
> > commit dddd3d65293a52c2c3850c19b1e5115712e534d8 upstream.
> > 
> > We must flush all the dirty data when enabling checkpoint back. Let's guarantee
> > that first by adding a retry logic on sync_inodes_sb(). In addition to that,
> > this patch adds to flush data in fsync when checkpoint is disabled, which can
> > mitigate the sync_inodes_sb() failures in advance.
> > 
> > Reviewed-by: Chao Yu <chao@kernel.org>
> > Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
> > ---
> >  fs/f2fs/file.c  |  5 ++---
> >  fs/f2fs/super.c | 11 ++++++++++-
> >  2 files changed, 12 insertions(+), 4 deletions(-)
> 
> What stable kernel(s) are you wanting to have this backported to?

5.10 please.

> 
> thanks,
> 
> greg k-h
