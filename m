Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9A8029E8B3
	for <lists+stable@lfdr.de>; Tue, 27 Aug 2019 15:10:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726170AbfH0NKX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Aug 2019 09:10:23 -0400
Received: from mx1.redhat.com ([209.132.183.28]:39180 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726250AbfH0NKX (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Aug 2019 09:10:23 -0400
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 4F5637FDCA;
        Tue, 27 Aug 2019 13:10:23 +0000 (UTC)
Received: from [10.36.117.101] (ovpn-117-101.ams2.redhat.com [10.36.117.101])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id A04705D9E1;
        Tue, 27 Aug 2019 13:10:18 +0000 (UTC)
Subject: =?UTF-8?Q?Re=3a_=e2=9d=8c_FAIL=3a_Stable_queue=3a_queue-5=2e2?=
To:     Sasha Levin <sashal@kernel.org>
Cc:     Greg KH <greg@kroah.com>, CKI Project <cki-project@redhat.com>,
        Linux Stable maillist <stable@vger.kernel.org>
References: <cki.FF1370FEA1.W4XGF3MDGN@redhat.com>
 <20190825144122.GA27775@kroah.com>
 <d0567d4e-6bbe-4a93-d657-0ee7f6e4625d@redhat.com>
 <20190826083309.GA32549@kroah.com>
 <1e9a3221-f044-a3a0-bbe1-34e6f8a468f0@redhat.com>
 <8badf977-5af5-d5cb-82d1-61f3596f7ec8@redhat.com>
 <a00e47ca-12a4-2792-2391-a2b599f51ecb@redhat.com>
 <53508fd1-cb2d-12e1-3d6e-12d2272efc09@redhat.com>
 <20190826133312.GI5281@sasha-vm>
From:   Nikolai Kondrashov <Nikolai.Kondrashov@redhat.com>
Message-ID: <e1b5fad9-b896-cfad-0e76-26405de2abc5@redhat.com>
Date:   Tue, 27 Aug 2019 16:10:17 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <20190826133312.GI5281@sasha-vm>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.27]); Tue, 27 Aug 2019 13:10:23 +0000 (UTC)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 8/26/19 4:33 PM, Sasha Levin wrote:
> On Mon, Aug 26, 2019 at 02:39:31PM +0300, Nikolai Kondrashov wrote:
>> So, this leads me to suspect the repos *were* inconsistent. Likely not as I
>> described before, but still. They should've been inconsistent for more than 5
>> minutes for us to trip on this.
> 
> This is likely the case. I took my sweet time doing the release and
> looking at irc logs, I have gone way above 5 minutes. However, we'd
> really like to avoid having a magical number of minutes here to get it
> right.
> 
> To me the issue seems that you're mixing the information provided by two
> repos that may have inconsistency between them, even if merely due to
> sync within the CDN. You should use information provided only by one
> repo.
> 
> I myself run a (rather dumb) bot that just attempts to apply/build
> -stable tagged patches, and it seems to avoid the inconsistency issue by
> only working with the information provided by stable-queue:
> 
> - For each of the active stable/LTS kernels (let's say 5.2 in this
>    "loop"), we do:
> - Grab the latest released version from stable-queue:
>    - $ git tag | sort -V | grep 'v5\.2' | tail -n1
>      v5.2.10
> - Check it out in linux-stable:
>    - $ git checkout v5.2.10
>    - Bail if the above fails; this solves the "consistency" problem.
> - Apply the patches from the queue
> - Run your tests
> 
> This way, you guarantee that linux-stable is at the right position since
> you're just telling it where to go to, rather than getting information
> out of that repo which might conflict with something you've learned from
> stable-queue.

Thank you, Sasha. This makes sense. You using this approach in your bot gives
us the guarantee it will work :) We'll change our trigger to this (I posted an
internal ticket and everything), likely next week.

Nick
