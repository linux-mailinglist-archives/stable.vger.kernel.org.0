Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BDFC812153
	for <lists+stable@lfdr.de>; Thu,  2 May 2019 19:56:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726220AbfEBR4C (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 2 May 2019 13:56:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:47324 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725962AbfEBR4C (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 2 May 2019 13:56:02 -0400
Received: from localhost (adsl-173-228-226-134.prtc.net [173.228.226.134])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2CDD620652;
        Thu,  2 May 2019 17:56:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1556819761;
        bh=yyOfE5WOPuEC+HAmQynDKOs8Hj8lVMs0jDuisL88W7w=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=zZcQdJDw1HSHnMkiltPrEPXtM7EWy1aE8XN3GzKqKUlTuU7r9mTIItkCsqNGyDUtp
         m4nvpr654pmlPZlpjWraFbtCF/DEXj19tzifA7i99k+LM6/qaOKwqLZ3TbRaiyt44t
         XN8PgDVHTd40liBAQZU5x9zF+8yVU9mZz2VVD3wI=
Date:   Thu, 2 May 2019 13:55:59 -0400
From:   Sasha Levin <sashal@kernel.org>
To:     Andre Noll <maan@tuebingen.mpg.de>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Dave Chinner <david@fromorbit.com>,
        "Darrick J. Wong" <darrick.wong@oracle.com>,
        linux-xfs@vger.kernel.org, stable@vger.kernel.org
Subject: Re: xfs: Assertion failed in xfs_ag_resv_init()
Message-ID: <20190502175559.GB3048@sasha-vm>
References: <20190501171529.GB28949@kroah.com>
 <20190501175129.GH2780@tuebingen.mpg.de>
 <20190501192822.GM5207@magnolia>
 <20190501221107.GI29573@dread.disaster.area>
 <20190502114440.GB21563@kroah.com>
 <20190502132027.GF11584@sasha-vm>
 <20190502141025.GB13141@kroah.com>
 <20190502152736.GW2780@tuebingen.mpg.de>
 <20190502165244.GB14995@kroah.com>
 <20190502174516.GY2780@tuebingen.mpg.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20190502174516.GY2780@tuebingen.mpg.de>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, May 02, 2019 at 07:45:16PM +0200, Andre Noll wrote:
>On Thu, May 02, 18:52, Greg Kroah-Hartman wrote
>> On Thu, May 02, 2019 at 05:27:36PM +0200, Andre Noll wrote:
>> > On Thu, May 02, 16:10, Greg Kroah-Hartman wrote
>> > > Ok, then how about we hold off on this patch for 4.9.y then.  "no one"
>> > > should be using 4.9.y in a "server system" anymore, unless you happen to
>> > > have an enterprise kernel based on it.  So we should be fine as the
>> > > users of the older kernels don't run xfs.
>> >
>> > Well, we do run xfs on top of bcache on vanilla 4.9 kernels on a few
>> > dozen production servers here. Mainly because we ran into all sorts
>> > of issues with newer kernels (not necessary related to xfs). 4.9,
>> > OTOH, appears to be rock solid for our workload.
>>
>> Great, but what is wrong with 4.14.y or better yet, 4.19.y?  Do those
>> also work for your workload?  If not, we should fix that, and soon :)
>
>Some months ago we tried 4.14 and it was a real disaster: random
>crashes with nothing in the logs on the file servers and unkillable
>hung processes on the compute machines. The thing is, I can't afford
>an extended downtime of these production systems, or test patches, or
>enable debugging options which slow down the systems too much. Also,
>10 of the compute nodes load the nvidia module, so all bets are off
>anyway. But we've seen the hung processes also on the non-gpu nodes
>where the nvidia module is not loaded.
>
>As for 4.19, xfs on bcache was broken until a couple of weeks
>ago. Meanwhile the fix (e578f90d8a9c) went in, so I benchmarked 4.19.x
>on one system briefly. To my surprise the results were *worse* than
>with 4.9. This seems to be another cache bypass issue, but I need to
>have a closer look, and more reliable numbers.

Is this something you can reproduce outside of those 10 magical
machines?

--
Thanks,
Sasha
