Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B00CA9B3C3
	for <lists+stable@lfdr.de>; Fri, 23 Aug 2019 17:46:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2436512AbfHWPpC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 23 Aug 2019 11:45:02 -0400
Received: from mail-pl1-f195.google.com ([209.85.214.195]:45233 "EHLO
        mail-pl1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387803AbfHWPpC (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 23 Aug 2019 11:45:02 -0400
Received: by mail-pl1-f195.google.com with SMTP id y8so5789331plr.12;
        Fri, 23 Aug 2019 08:45:01 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=d13wUvTcGWm9qSA2DfjkIYqexwd152oPkAxpgbt/a/I=;
        b=tDSDgmSyi6YM9EItP+kOQqNgXFZo0vBq8/cdixyj8xNQLRzo6tD5QnxiJqPGiNaKdA
         7mc74NXbtSd/0bfxsfqMNQR40a+ZxvOB8FSqIWgbThQ12AgbUSF8xFgVh7ilBCQrd/8O
         bqKhxX8Xky7kJS4vX/D32G8oPcGRPRva8jtr/jSRa3A5PpwqRHNq/KXks79qTPx5m79u
         MqG7s0huwOvdSqkwe+x+0nM5DWFfzVFQqBRKEmxOe+XHJyLTtWZmCRxzcKU/LXsAVaS3
         3EJVgjYJzwC4y/bULzKOQgawKvMj4YW/dkWswQFTRzHOT7q0yh1CLDLf+mRCx5iZ6wP4
         gx9w==
X-Gm-Message-State: APjAAAUruNWKIsQLTZwwfR317OUVX0T6ciHRVml+wByB5Vw4HVWTAL4o
        8863b9TeR7iC0L5d+acmW7w=
X-Google-Smtp-Source: APXvYqzAgJ2AiT/6zWW+CtjuC3MArI9xkF4kBmeHNBX25UKeZChWozqkKMIWPCp8GYzSK9JZS2e2vg==
X-Received: by 2002:a17:902:543:: with SMTP id 61mr5585600plf.20.1566575101259;
        Fri, 23 Aug 2019 08:45:01 -0700 (PDT)
Received: from 42.do-not-panic.com (42.do-not-panic.com. [157.230.128.187])
        by smtp.gmail.com with ESMTPSA id x128sm6465741pfd.52.2019.08.23.08.44.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 23 Aug 2019 08:45:00 -0700 (PDT)
Received: by 42.do-not-panic.com (Postfix, from userid 1000)
        id 56568404D5; Fri, 23 Aug 2019 15:44:59 +0000 (UTC)
Date:   Fri, 23 Aug 2019 15:44:59 +0000
From:   Luis Chamberlain <mcgrof@kernel.org>
To:     linux-xfs@vger.kernel.org, Alexander.Levin@microsoft.com
Cc:     gregkh@linuxfoundation.org, stable@vger.kernel.org,
        amir73il@gmail.com
Subject: Re: [PATCH 0/6] xfs: stable fixes for v4.19.y - circa v4.19.60
Message-ID: <20190823154459.GU16384@42.do-not-panic.com>
References: <20190724063451.26190-1-mcgrof@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190724063451.26190-1-mcgrof@kernel.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Jul 24, 2019 at 06:34:45AM +0000, Luis Chamberlain wrote:
> Sasha,
> 
> you merged my last set of XFS fixes. I asked for one patch to not be
> merged yet as one issue was not yet properly fixed. After some further
> review I have identified commits which do fix the kernel crash reported
> on kz#204223 [0] with generic/388, this patch set applies on top of the
> last one I sent you.
> 
> These commits do quite a bit of code refactoring, and the actual fix
> lies hidden in the last commit by Darrick. Due to the amount of changes
> trying to extract the fix is riskier than just carring the code
> refactoring. If we're OK with the code refactor for stable, its my
> recommendation we keep the changes to match more with upstream and
> benefit from other fixes. The code refactoring was merged on v4.20 and
> Darrick's fix is the only fix upstream since the code was merged.
> 
> If others disagree with this approach please speak up.
> 
> I've run a full set of fstests against the following sections 12 times and
> have found no regressions against the baseline:
> 
> xfs
> xfs_logdev
> xfs_nocrc_512
> xfs_nocrc
> xfs_realtimedev
> xfs_reflink_1024
> xfs_reflink_dev
> 
> Review from others is appreciated.
> 
> [0] https://bugzilla.kernel.org/show_bug.cgi?id=204223
> 
> Allison Henderson (4):
>   xfs: Move fs/xfs/xfs_attr.h to fs/xfs/libxfs/xfs_attr.h
>   xfs: Add helper function xfs_attr_try_sf_addname
>   xfs: Add attibute set and helper functions
>   xfs: Add attibute remove and helper functions
> 
> Brian Foster (1):
>   xfs: don't trip over uninitialized buffer on extent read of corrupted
>     inode
> 
> Darrick J. Wong (1):
>   xfs: always rejoin held resources during defer roll
> 
>  fs/xfs/libxfs/xfs_attr.c       | 231 ++++++++++++++++++---------------
>  fs/xfs/{ => libxfs}/xfs_attr.h |   2 +
>  fs/xfs/libxfs/xfs_bmap.c       |  54 +++++---
>  fs/xfs/libxfs/xfs_bmap.h       |   1 +
>  fs/xfs/libxfs/xfs_defer.c      |  14 +-
>  fs/xfs/xfs_dquot.c             |  17 +--
>  6 files changed, 183 insertions(+), 136 deletions(-)
>  rename fs/xfs/{ => libxfs}/xfs_attr.h (98%)

*poke*

BTW I'm off on vacation for a while after today.

  Luis
