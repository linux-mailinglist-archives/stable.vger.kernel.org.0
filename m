Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 81B5F248CB0
	for <lists+stable@lfdr.de>; Tue, 18 Aug 2020 19:16:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727118AbgHRRQY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 18 Aug 2020 13:16:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:49248 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727098AbgHRRQX (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 18 Aug 2020 13:16:23 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6932620658;
        Tue, 18 Aug 2020 17:16:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597770982;
        bh=siPmZLqDC3R3VHF+A9YadJIvistgqmc6Gt7i93OIppo=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=U05EpxYDYwQ8kAQy9IogbG8w8/bePM5Qftj5zhiL8MYUoQq5KtzzvQQpvAp1SKnhG
         ToERJ5DzoWRP7um0Q5aFeCJGI5JK9ktFLebd0RoFp60u1dEH5UJlWFSEwVvxOC47El
         kr1Vu397bbo11MxEb8bPWz3KwhlH48qRSxu9aKgM=
Date:   Tue, 18 Aug 2020 19:16:46 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Mike Marshall <hubcap@omnibond.com>
Cc:     stable@vger.kernel.org
Subject: Re: submission for 5.4 LTS
Message-ID: <20200818171646.GA744123@kroah.com>
References: <CAOg9mSR=rOCGhxuR+L8YXzvwTrg4KyO285vx2TTm20fh9EdtMA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAOg9mSR=rOCGhxuR+L8YXzvwTrg4KyO285vx2TTm20fh9EdtMA@mail.gmail.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Aug 18, 2020 at 11:49:29AM -0400, Mike Marshall wrote:
> upstream commit id: ec95f1dedc9c64ac5a8b0bdb7c276936c70fdedd
> 
> I verified that ec95f1de "orangefs: get rid of knob code..."
> will apply to 5.4 and I compiled and ran a patched 5.4 kernel
> against my normal xfstests...  I wish that ec95f1de could be
> in the 5.4 long term stable kernel.
> 
> ec95f1de went upstream in 5.7. When I sent up the patch it was
> just a theoretical race condition to me: I accepted what Christoph
> said about it. We now have experienced in-the-real-world how
> important the patch is...
> 
> Someone was trying to read a whole large (more than 100 meg)
> file from orangefs into some kind of cloud bucket. The
> resulting read failed with a "Bad address" error. I
> immediately thought of this patch. I reproduced the
> "Bad address" error with dd in kernel versions that
> lack ec95f1de. The "Bad address" error does not occur
> in kernels that include ec95f1de:
> 
> 5.7.11-100.fc31.x86_64:
> 
> $ ./wr.sh 10000000 > /pvfsmnt/wr.10000000
> $ dd if=/pvfsmnt/wr.10000000 of=/tmp/wr.10000000 count=10 bs=419430400
> $ ls -l /pvfsmnt/wr.10000000 /tmp/wr.10000000
> -rw-rw-r--. 1 hubcap hubcap 498888897 Aug 14 15:41 /pvfsmnt/wr.10000000
> -rw-rw-r--. 1 hubcap hubcap 498888897 Aug 14 16:51 /tmp/wr.10000000
> $ md5sum /pvfsmnt/wr.10000000 /tmp/wr.10000000
> 669daa04f91f561f5fb2851fb30e4ffe  /pvfsmnt/wr.10000000
> 669daa04f91f561f5fb2851fb30e4ffe  /tmp/wr.10000000
> 
> 5.6.0hubcap:
> 
> $ ./wr.sh 10000000 > /pvfsmnt/wr.10000000
> $ dd if=/pvfsmnt/wr.10000000 of=/tmp/wr.10000000 count=10 bs=419430400
> dd: error reading '/pvfsmnt/wr.10000000': Bad address
> 0+0 records in
> 0+0 records out
> 0 bytes copied, 10.3365 s, 0.0 kB/s

Sounds reasonable, I'll queue this up after this next round of releases
in the next few days, thanks!

greg k-h
