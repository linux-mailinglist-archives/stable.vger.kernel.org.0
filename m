Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 098391C5B4A
	for <lists+stable@lfdr.de>; Tue,  5 May 2020 17:32:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729864AbgEEPcg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 May 2020 11:32:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:32910 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730110AbgEEPc3 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 5 May 2020 11:32:29 -0400
Received: from localhost (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 916B92083B;
        Tue,  5 May 2020 15:32:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588692748;
        bh=NR80z2yPjqgO14WXQRPXI+q6gF+1S53iofV6VuLwBac=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=JkMfcC55zIFvs6+OSV4SiX2FtfTw0QIvi20Axw9EpOzMh5R1ceS8HDj73hIA5jtpR
         MNC6119kGguNpko2xuC5B4eGdJueQJNXg4VIt8q/vNXhhUSvpm9QSOE9ryaZR63Kq6
         d3gagdQdwxFajtWcNHeSKNPLpF4ShuOAp2ltZpyM=
Date:   Tue, 5 May 2020 11:32:27 -0400
From:   Sasha Levin <sashal@kernel.org>
To:     Andy Shevchenko <andy.shevchenko@gmail.com>
Cc:     Pavel Machek <pavel@denx.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Stable <stable@vger.kernel.org>,
        Dan Williams <dan.j.williams@intel.com>,
        Nicolas Ferre <nicolas.ferre@microchip.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Vinod Koul <vkoul@kernel.org>
Subject: Re: [PATCH 4.19 28/37] dmaengine: dmatest: Fix iteration non-stop
 logic
Message-ID: <20200505153227.GI13035@sasha-vm>
References: <20200504165448.264746645@linuxfoundation.org>
 <20200504165451.307643203@linuxfoundation.org>
 <20200505123159.GC28722@amd>
 <CAHp75VeM+qwh5rHL7RDdacru0jPSB9me2aTs__jdy749dTKRng@mail.gmail.com>
 <20200505125818.GA31126@amd>
 <CAHp75VcKreeQpjROdL23XGqgVu+F_0eL5DsJ=5APEQUO9V69EQ@mail.gmail.com>
 <20200505133700.GA31753@amd>
 <CAHp75Ve+pzhamZXiKxHF+VD8yfsjRF2coattHyiD+0aa7Fy2DA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <CAHp75Ve+pzhamZXiKxHF+VD8yfsjRF2coattHyiD+0aa7Fy2DA@mail.gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, May 05, 2020 at 05:05:37PM +0300, Andy Shevchenko wrote:
>On Tue, May 5, 2020 at 4:37 PM Pavel Machek <pavel@denx.de> wrote:
>> On Tue 2020-05-05 16:19:11, Andy Shevchenko wrote:
>> > On Tue, May 5, 2020 at 3:58 PM Pavel Machek <pavel@denx.de> wrote:
>> > > On Tue 2020-05-05 15:51:16, Andy Shevchenko wrote:
>> > > > On Tue, May 5, 2020 at 3:37 PM Pavel Machek <pavel@denx.de> wrote:
>> > > Yeah, I pointed that out above. Both && and || permit short
>> > > execution. But that does not matter, as neither "params->iterations"
>> > > nor "total_tests >= params->iterations" have side effects.
>> > >
>> > > Where is the runtime difference?
>> >
>> > We have to check *both* conditions. If we don't check iterations, we
>> > just wait indefinitely until somebody tells us to stop.
>> > Everything in the commit message and mentioned there commit IDs which
>> > you may check.
>>
>> No.
>
>Yes. Please, read carefully the commit message (for your convenience I
>emphasized above). I don't want to spend time on this basics stuff
>anymore.

I'm a bit confused about this too. Maybe it's too early in the morning,
so I wrote this little test program:

#include <stdio.h>
#include <stdlib.h>

int main(int argc, char *argv[])
{
        int a = atoi(argv[1]);
        int b = atoi(argv[2]);

        if (!a && !b)
                printf("A");
        else
                printf("B");

        if (!(a || b))
                printf("A");
        else
                printf("B");

        printf("\n");

        return 0;
}

Andy, could you give an example of two values which will print something
other than "AA" or "BB"?

Heck, gcc even compiles these two conditions the same way:

        if (!a && !b)
    11a8:       83 7d f8 00             cmpl   $0x0,-0x8(%rbp)
    11ac:       75 12                   jne    11c0 <main+0x57>
    11ae:       83 7d fc 00             cmpl   $0x0,-0x4(%rbp)
    11b2:       75 0c                   jne    11c0 <main+0x57>
                printf("A");
    11b4:       bf 41 00 00 00          mov    $0x41,%edi
    11b9:       e8 a2 fe ff ff          callq  1060 <putchar@plt>
    11be:       eb 0a                   jmp    11ca <main+0x61>
        else
                printf("B");
    11c0:       bf 42 00 00 00          mov    $0x42,%edi
    11c5:       e8 96 fe ff ff          callq  1060 <putchar@plt>

        if (!(a || b))
    11ca:       83 7d f8 00             cmpl   $0x0,-0x8(%rbp)
    11ce:       75 12                   jne    11e2 <main+0x79>
    11d0:       83 7d fc 00             cmpl   $0x0,-0x4(%rbp)
    11d4:       75 0c                   jne    11e2 <main+0x79>
                printf("A");
    11d6:       bf 41 00 00 00          mov    $0x41,%edi
    11db:       e8 80 fe ff ff          callq  1060 <putchar@plt>
    11e0:       eb 0a                   jmp    11ec <main+0x83>
        else
                printf("B");
    11e2:       bf 42 00 00 00          mov    $0x42,%edi
    11e7:       e8 74 fe ff ff          callq  1060 <putchar@plt>

-- 
Thanks,
Sasha
