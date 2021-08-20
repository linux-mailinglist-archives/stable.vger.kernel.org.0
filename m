Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7600F3F32D9
	for <lists+stable@lfdr.de>; Fri, 20 Aug 2021 20:12:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235519AbhHTSMi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 20 Aug 2021 14:12:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:44966 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231757AbhHTSMh (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 20 Aug 2021 14:12:37 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4CCD0608FE;
        Fri, 20 Aug 2021 18:11:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1629483119;
        bh=Ug/nWYFe3aKoUQ5ituPguHYC0Y4myQql1SYX/rV6X0I=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Iw/pdnyA1ONdK54eU3zepv0FOEWjZfqHh/RkIXhlPBxtuC4OmDr9Kk2O1pfyJ4C9M
         3h6MZ9qQYAKU97s+TaFb/HaVE95J5ceCxEz7ZqHZhuSHC7CoQauuvQxrufQMZ34JSd
         jYcc9/nS1IX0yUszV5lG4L8UPYx2BXAgGucNqeQ00P6YdkNfKs9eJOYpoKMW2ARgoN
         m2ClveBPVxKXayI/GIMjgKYm/m4hn4rxgWaiMDX726PO1vZJunLmoEGljqXGzTbWaq
         fEqJHXaAA1sCy7qpwRTnSPNiUGQ7y5CXZiWIyMWUmW9AQv7IVRz2iRLKoAXZQAWJZS
         nKbPOK5SQHcMA==
Date:   Fri, 20 Aug 2021 11:11:57 -0700
From:   Eric Biggers <ebiggers@kernel.org>
To:     Chao Yu <chao@kernel.org>
Cc:     Jaegeuk Kim <jaegeuk@kernel.org>, Theodore Ts'o <tytso@mit.edu>,
        linux-f2fs-devel@lists.sourceforge.net,
        linux-fsdevel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH] f2fs: remove broken support for allocating DIO writes
Message-ID: <YR/wbenc0d3eMAjz@sol.localdomain>
References: <20210728015154.171507-1-ebiggers@kernel.org>
 <YQRQRh1zUHSIzcC/@gmail.com>
 <YQS5eBljtztWwOFE@mit.edu>
 <YQd3Hbid/mFm0o24@sol.localdomain>
 <a3cdd7cb-50a7-1b37-fe58-dced586712a2@kernel.org>
 <YQg4Lukc2dXX3aJc@google.com>
 <b88328b4-db3e-0097-d8cc-f250ee678e5b@kernel.org>
 <YQidOD/zNB17fd9v@google.com>
 <YRsY6dyHyaChkQ6n@gmail.com>
 <c4e5c71d-1652-7174-fa36-674fab4e61df@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c4e5c71d-1652-7174-fa36-674fab4e61df@kernel.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Aug 20, 2021 at 05:35:21PM +0800, Chao Yu wrote:
> > > > > 
> > > > > Hmm, I'm still trying to deal with this as a corner case where the writes
> > > > > haven't completed due to an error. How about keeping the preallocated block
> > > > > offsets and releasing them if we get an error? Do we need to handle EIO right?
> > > > 
> > > > What about the case that CP + SPO following DIO preallocation? User will
> > > > encounter uninitialized block after recovery.
> > > 
> > > I think buffered writes as a workaround can expose the last unwritten block as
> > > well, if SPO happens right after block allocation. We may need to compromise
> > > at certain level?
> > > 
> > 
> > Freeing preallocated blocks on error would be better than nothing, although note
> > that the preallocated blocks may have filled an arbitrary sequence of holes --
> > so simply truncating past EOF would *not* be sufficient.
> > 
> > But really filesystems need to be designed to never expose uninitialized data,
> > even if I/O errors or a sudden power failure occurs.  It is unfortunate that
> > f2fs apparently wasn't designed with that goal in mind.
> > 
> > In any case, I don't think we can proceed with any other f2fs direct I/O
> > improvements until this data leakage bug can be solved one way or another.  If
> > my patch to remove support for allocating writes isn't acceptable and the
> > desired solution is going to require some more invasive f2fs surgery, are you or
> > Chao going to work on it?  I'm not sure there's much I can do here.
> 
> I may have time to take look into the implementation as I proposed above, maybe
> just enabling this in FSYNC_MODE_STRICT mode if user concerns unwritten data?
> thoughts?
> 

What does this have to do with fsync?

- Eric
