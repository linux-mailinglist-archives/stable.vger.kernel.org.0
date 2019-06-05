Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 20B34354E9
	for <lists+stable@lfdr.de>; Wed,  5 Jun 2019 03:10:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726715AbfFEBKw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 4 Jun 2019 21:10:52 -0400
Received: from kvm5.telegraphics.com.au ([98.124.60.144]:32864 "EHLO
        kvm5.telegraphics.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726399AbfFEBKw (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 4 Jun 2019 21:10:52 -0400
Received: from localhost (localhost.localdomain [127.0.0.1])
        by kvm5.telegraphics.com.au (Postfix) with ESMTP id E972329BDA;
        Tue,  4 Jun 2019 21:10:49 -0400 (EDT)
Date:   Wed, 5 Jun 2019 11:11:02 +1000 (AEST)
From:   Finn Thain <fthain@telegraphics.com.au>
To:     Sasha Levin <sashal@kernel.org>
cc:     "James E.J. Bottomley" <jejb@linux.ibm.com>, stable@vger.kernel.org
Subject: Re: [PATCH 2/7] scsi: NCR5380: Always re-enable reselection
 interrupt
In-Reply-To: <20190604125042.9E7FE2499F@mail.kernel.org>
Message-ID: <alpine.LNX.2.21.1906051055130.9@nippy.intranet>
References: <16486d63c31a51aa08ca79490e423569c7deaa57.1559438652.git.fthain@telegraphics.com.au> <20190604125042.9E7FE2499F@mail.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, 4 Jun 2019, Sasha Levin wrote:

> Hi,
> 
> [This is an automated email]
> 
> This commit has been processed because it contains a "Fixes:" tag,
> fixing commit: 8b00c3d5d40d ncr5380: Implement new eh_abort_handler.
> 
> The bot has tested the following trees: v5.1.6, v5.0.20, v4.19.47, v4.14.123, v4.9.180.
> 
> v5.1.6: Build OK!
> v5.0.20: Build OK!
> v4.19.47: Failed to apply! Possible dependencies:
>     6a162836997c ("scsi: NCR5380: Reduce goto statements in NCR5380_select()")
> 
> v4.14.123: Failed to apply! Possible dependencies:
>     6a162836997c ("scsi: NCR5380: Reduce goto statements in NCR5380_select()")
> 
> v4.9.180: Failed to apply! Possible dependencies:
>     6a162836997c ("scsi: NCR5380: Reduce goto statements in NCR5380_select()")
> 
> 
> How should we proceed with this patch?
> 

Please cherry-pick the dependency, as it does not alter functionality.

$ 
$ git checkout v4.9
HEAD is now at 69973b830859 Linux 4.9
$ git cherry-pick 6a162836997c
[detached HEAD 0e33d17b7b50] scsi: NCR5380: Reduce goto statements in 
NCR5380_select()
 Date: Thu Sep 27 11:17:11 2018 +1000
 1 file changed, 12 insertions(+), 9 deletions(-)
$ git cherry-pick 61f0c0f6aaf8
[detached HEAD 8ae61212c888] scsi: NCR5380: Always re-enable reselection 
interrupt
 Date: Mon Mar 25 15:45:51 2019 +1100
 1 file changed, 2 insertions(+), 10 deletions(-)
$ 

You could instead apply the patch using more fuzz...

$ 
$ git checkout v4.9
HEAD is now at 69973b830859 Linux 4.9
$ git show 61f0c0f6aaf8 | patch -p1 -F3
patching file drivers/scsi/NCR5380.c
Hunk #1 succeeded at 813 (offset 104 lines).
Hunk #2 succeeded at 1210 (offset 98 lines).
Hunk #3 succeeded at 1217 with fuzz 3 (offset 98 lines).
Hunk #4 succeeded at 1251 (offset 95 lines).
Hunk #5 succeeded at 1901 (offset 77 lines).
Hunk #6 succeeded at 1932 (offset 77 lines).
Hunk #7 succeeded at 2039 (offset 82 lines).
$ 

This also works but would seem to undermine future backporting.

Thanks.

-- 

> -- 
> Thanks,
> Sasha
> 
