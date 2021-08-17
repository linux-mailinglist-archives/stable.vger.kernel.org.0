Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 05D083EF258
	for <lists+stable@lfdr.de>; Tue, 17 Aug 2021 20:57:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231616AbhHQS6V (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 17 Aug 2021 14:58:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:40454 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230040AbhHQS6V (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 17 Aug 2021 14:58:21 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6D6EE60F58;
        Tue, 17 Aug 2021 18:57:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1629226667;
        bh=2XcXNJckxVKqAUkQr3OnLHOMlEXeXg+rMqgZHIzsIwQ=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=ZM19eiaP830Jjnq7WpgBd757cueDeUTKGXydS3fRcMzp35BHWeA1kbaTfHQntpUKg
         aBJBvPvUYSoLD7drxmoiyEqyQAUlakf/ToVSnsJLrO+XBdkzVmBZQdCEZYYZK/2dpl
         ITkP1rQYvN+ddd5YSddzCS4hHinnnovMXQGVQe9/C+VPzsdbYBFfrXixrd+qkGA/wS
         hQ4yxQTfmnpI9MO6e1AmDv7dwk34YBa1uxj3S3I+WmUWHOgWA6sjb1mhPGK4Mgj7or
         Vf6M2m1tkPuW5Jgsy4ClIceTF4N6Xjq+Qvqt1fSUnEWqEM7Kac8PNg3IgLHQvTl/GU
         hOjJWx0rbekdA==
Date:   Tue, 17 Aug 2021 11:57:46 -0700
From:   Jaegeuk Kim <jaegeuk@kernel.org>
To:     Christoph Hellwig <hch@infradead.org>
Cc:     Eric Biggers <ebiggers@kernel.org>, Chao Yu <chao@kernel.org>,
        Theodore Ts'o <tytso@mit.edu>,
        linux-f2fs-devel@lists.sourceforge.net,
        linux-fsdevel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH] f2fs: remove broken support for allocating DIO writes
Message-ID: <YRwGqsLgyKqdbkGX@google.com>
References: <20210728015154.171507-1-ebiggers@kernel.org>
 <YQRQRh1zUHSIzcC/@gmail.com>
 <YQS5eBljtztWwOFE@mit.edu>
 <YQd3Hbid/mFm0o24@sol.localdomain>
 <a3cdd7cb-50a7-1b37-fe58-dced586712a2@kernel.org>
 <YQg4Lukc2dXX3aJc@google.com>
 <b88328b4-db3e-0097-d8cc-f250ee678e5b@kernel.org>
 <YQidOD/zNB17fd9v@google.com>
 <YRsY6dyHyaChkQ6n@gmail.com>
 <YRtMOqzZU4c1Vjje@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YRtMOqzZU4c1Vjje@infradead.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 08/17, Christoph Hellwig wrote:
> On Mon, Aug 16, 2021 at 07:03:21PM -0700, Eric Biggers wrote:
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
> Btw, this is generally a problem for buffered I/O as well, although the
> window for exposing uninitialized blocks on a crash tends to be smaller.

How about adding a warning message when we meet an error with preallocated
unwritten blocks? In the meantime, can we get the Eric's patches for iomap
support? I feel that we only need to modify the preallocation and error
handling parts?
