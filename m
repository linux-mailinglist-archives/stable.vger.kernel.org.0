Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DBD239D0AA
	for <lists+stable@lfdr.de>; Mon, 26 Aug 2019 15:33:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730631AbfHZNdO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Aug 2019 09:33:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:35562 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726953AbfHZNdO (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 26 Aug 2019 09:33:14 -0400
Received: from localhost (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0E3AA2053B;
        Mon, 26 Aug 2019 13:33:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1566826393;
        bh=FamM+SSY+z3f75Xpd6SmuYGyZVxeXjQ1tjsE5A1mK0g=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=zWA/lYMRUhnZGc4MqKv/RxuOQdMUMesgrfB3TXIWqEiB5QkEsOlIBnv5Lyhp3+ZW/
         A/zqoZtDA9d6RN1APSiHrx1UjeqaX28mvUb7EAsA/kIzdb2hMeN+/ggBDln4eWKIl1
         tYh4Wz2GLdgO8TRqK0cF0G5f/H8OpXA3lME4kKss=
Date:   Mon, 26 Aug 2019 09:33:12 -0400
From:   Sasha Levin <sashal@kernel.org>
To:     Nikolai Kondrashov <Nikolai.Kondrashov@redhat.com>
Cc:     Greg KH <greg@kroah.com>, CKI Project <cki-project@redhat.com>,
        Linux Stable maillist <stable@vger.kernel.org>
Subject: Re: =?utf-8?B?4p2MIEZBSUw=?= =?utf-8?Q?=3A?= Stable queue: queue-5.2
Message-ID: <20190826133312.GI5281@sasha-vm>
References: <cki.FF1370FEA1.W4XGF3MDGN@redhat.com>
 <20190825144122.GA27775@kroah.com>
 <d0567d4e-6bbe-4a93-d657-0ee7f6e4625d@redhat.com>
 <20190826083309.GA32549@kroah.com>
 <1e9a3221-f044-a3a0-bbe1-34e6f8a468f0@redhat.com>
 <8badf977-5af5-d5cb-82d1-61f3596f7ec8@redhat.com>
 <a00e47ca-12a4-2792-2391-a2b599f51ecb@redhat.com>
 <53508fd1-cb2d-12e1-3d6e-12d2272efc09@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <53508fd1-cb2d-12e1-3d6e-12d2272efc09@redhat.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Aug 26, 2019 at 02:39:31PM +0300, Nikolai Kondrashov wrote:
>So, this leads me to suspect the repos *were* inconsistent. Likely not as I
>described before, but still. They should've been inconsistent for more than 5
>minutes for us to trip on this.

This is likely the case. I took my sweet time doing the release and
looking at irc logs, I have gone way above 5 minutes. However, we'd
really like to avoid having a magical number of minutes here to get it
right.

To me the issue seems that you're mixing the information provided by two
repos that may have inconsistency between them, even if merely due to
sync within the CDN. You should use information provided only by one
repo.

I myself run a (rather dumb) bot that just attempts to apply/build
-stable tagged patches, and it seems to avoid the inconsistency issue by
only working with the information provided by stable-queue:

 - For each of the active stable/LTS kernels (let's say 5.2 in this
   "loop"), we do:
 - Grab the latest released version from stable-queue:
   - $ git tag | sort -V | grep 'v5\.2' | tail -n1
     v5.2.10
 - Check it out in linux-stable:
   - $ git checkout v5.2.10
   - Bail if the above fails; this solves the "consistency" problem.
 - Apply the patches from the queue
 - Run your tests

This way, you guarantee that linux-stable is at the right position since
you're just telling it where to go to, rather than getting information
out of that repo which might conflict with something you've learned from
stable-queue.

--
Thanks,
Sasha
