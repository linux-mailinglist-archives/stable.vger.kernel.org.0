Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2072F12F248
	for <lists+stable@lfdr.de>; Fri,  3 Jan 2020 01:40:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725900AbgACAk0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 2 Jan 2020 19:40:26 -0500
Received: from mail.kernel.org ([198.145.29.99]:59984 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725872AbgACAk0 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 2 Jan 2020 19:40:26 -0500
Received: from localhost (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C69D021734;
        Fri,  3 Jan 2020 00:40:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1578012026;
        bh=NaK3/6XMrcVpbwCyhTAxrVBQ85hjklBvqmJGGDgRAsk=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=GbTdghOQ5GBGP5JTaO4VlWGrmifg4vBevZ9yMhNmMMb48iqgeGn176q/k6MsWAwhR
         5nJZaCvJ1xBFDqMdS0Za4VTY4cOIYbRbKO1vl4b+AIEhZru8TqgL+U8hIAxzUTwOQc
         K91VrZ4iXhz89JzCX1V0GbVMdZ9zm+Rh2o/Wkc8Q=
Date:   Thu, 2 Jan 2020 19:40:24 -0500
From:   Sasha Levin <sashal@kernel.org>
To:     Guenter Roeck <linux@roeck-us.net>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable <stable@vger.kernel.org>, Stephen Boyd <sboyd@kernel.org>
Subject: Re: Clock related crashes in v5.4.y-queue
Message-ID: <20200103004024.GM16372@sasha-vm>
References: <029dab5a-22f5-c4e9-0797-54cdba0f3539@roeck-us.net>
 <20200102210119.GA250861@kroah.com>
 <20200102212837.GA9400@roeck-us.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20200102212837.GA9400@roeck-us.net>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Jan 02, 2020 at 01:28:37PM -0800, Guenter Roeck wrote:
>On Thu, Jan 02, 2020 at 10:01:19PM +0100, Greg Kroah-Hartman wrote:
>> On Wed, Jan 01, 2020 at 06:44:08PM -0800, Guenter Roeck wrote:
>> > Hi,
>> >
>> > I see a number of crashes in the latest v5.4.y-queue; please see below
>> > for details. The problem bisects to commit 54a311c5d3988d ("clk: Fix memory
>> > leak in clk_unregister()").
>> >
>> > The context suggests recovery from a failed driver probe, and it appears
>> > that the memory is released twice. Interestingly, I don't see the problem
>> > in mainline.
>> >
>> > I would suggest to drop that patch from the stable queue.
>>
>> That does not look right, as you point out, so I will go drop it now.
>>
>> The logic of the clk structure lifetimes seems crazy, messing with krefs
>> and just "knowing" the lifecycle of the other structures seems like a
>> problem just waiting to happen...
>>
>
>I agree. While the patch itself seems to be ok per Stephen's feedback,
>we have to assume that there will be more secondary failures in addition
>to the one I have discovered. Given that clocks are not normally
>unregistered, I don't think fixing the memory leak is important enough
>to risk the stability of stable releases.
>
>With all that in mind, I'd rather have this in mainline for a prolonged
>period of time before considering it for stable release (if at all).

I would very much like to circle back and add both this patch and it's
fix to the stable trees at some point in the future.

If the code is good enough for mainline it should be good enough for
stable as well. If it's broken - let's fix it now instead of deferring
this to when people try to upgrade their major kernel versions.

-- 
Thanks,
Sasha
