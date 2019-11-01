Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B0B1AEC8A1
	for <lists+stable@lfdr.de>; Fri,  1 Nov 2019 19:48:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727184AbfKASsV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 1 Nov 2019 14:48:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:33810 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726671AbfKASsV (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 1 Nov 2019 14:48:21 -0400
Received: from localhost (100.50.158.77.rev.sfr.net [77.158.50.100])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3F244217D9;
        Fri,  1 Nov 2019 18:48:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1572634099;
        bh=j0rlK8l1pSBgzERyaLEvJNCfYUmwAaz1IVhv9iLIVLo=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=0tBpL9yKKSgZy88R8V96yHLnFYK4svlh1B/CPDmhG+qoigVO9ZtUAfaEsrmdtK1ZP
         fPOIMhjSL4hG/C4+UxrYEkOs+mb2laUDMRGaeBkWm2AmzTAgAtqwP3AMJNqPl91PwO
         gScGtL9BJyQzTpMUmVWNa3Zd3OmeMkNQhAPK+Py8=
Date:   Fri, 1 Nov 2019 14:48:17 -0400
From:   Sasha Levin <sashal@kernel.org>
To:     Xin Long <lucien.xin@gmail.com>
Cc:     "Rantala, Tommi T. (Nokia - FI/Espoo)" <tommi.t.rantala@nokia.com>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "syzbot+d44f7bbebdea49dbc84a@syzkaller.appspotmail.com" 
        <syzbot+d44f7bbebdea49dbc84a@syzkaller.appspotmail.com>,
        "marcelo.leitner@gmail.com" <marcelo.leitner@gmail.com>
Subject: Re: [PATCH 4.14 024/119] sctp: change sctp_prot .no_autobind with
 true
Message-ID: <20191101184817.GU1554@sasha-vm>
References: <20191027203259.948006506@linuxfoundation.org>
 <20191027203307.303661015@linuxfoundation.org>
 <3e9de35dda19c0ac207d49d24c2735655b1d8d64.camel@nokia.com>
 <CADvbK_dx=dT6j-XMA=p9QgJJp5YgA2zRCLuY08u4pz0v=vXorw@mail.gmail.com>
 <20191031120958.GP1554@sasha-vm>
 <CADvbK_eRDP=zK7cTFDBmOe1_+-Q57Daet7V1OUY9FPaENDY3VA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <CADvbK_eRDP=zK7cTFDBmOe1_+-Q57Daet7V1OUY9FPaENDY3VA@mail.gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sat, Nov 02, 2019 at 01:58:33AM +0800, Xin Long wrote:
>On Thu, Oct 31, 2019 at 8:10 PM Sasha Levin <sashal@kernel.org> wrote:
>>
>> On Thu, Oct 31, 2019 at 05:14:15PM +0800, Xin Long wrote:
>> >On Thu, Oct 31, 2019 at 3:54 PM Rantala, Tommi T. (Nokia - FI/Espoo)
>> ><tommi.t.rantala@nokia.com> wrote:
>> >>
>> >> On Sun, 2019-10-27 at 22:00 +0100, Greg Kroah-Hartman wrote:
>> >> > From: Xin Long <lucien.xin@gmail.com>
>> >> >
>> >> > [ Upstream commit 63dfb7938b13fa2c2fbcb45f34d065769eb09414 ]
>> >> >
>> >> > syzbot reported a memory leak:
>> >> >
>> >> >   BUG: memory leak, unreferenced object 0xffff888120b3d380 (size 64):
>> >> >   backtrace:
>> >> >
>> >> >     [...] slab_alloc mm/slab.c:3319 [inline]
>> >> >     [...] kmem_cache_alloc+0x13f/0x2c0 mm/slab.c:3483
>> >> >     [...] sctp_bucket_create net/sctp/socket.c:8523 [inline]
>> >> >     [...] sctp_get_port_local+0x189/0x5a0 net/sctp/socket.c:8270
>> >> >     [...] sctp_do_bind+0xcc/0x200 net/sctp/socket.c:402
>> >> >     [...] sctp_bindx_add+0x4b/0xd0 net/sctp/socket.c:497
>> >> >     [...] sctp_setsockopt_bindx+0x156/0x1b0 net/sctp/socket.c:1022
>> >> >     [...] sctp_setsockopt net/sctp/socket.c:4641 [inline]
>> >> >     [...] sctp_setsockopt+0xaea/0x2dc0 net/sctp/socket.c:4611
>> >> >     [...] sock_common_setsockopt+0x38/0x50 net/core/sock.c:3147
>> >> >     [...] __sys_setsockopt+0x10f/0x220 net/socket.c:2084
>> >> >     [...] __do_sys_setsockopt net/socket.c:2100 [inline]
>> >> >
>> >> > It was caused by when sending msgs without binding a port, in the path:
>> >> > inet_sendmsg() -> inet_send_prepare() -> inet_autobind() ->
>> >> > .get_port/sctp_get_port(), sp->bind_hash will be set while bp->port is
>> >> > not. Later when binding another port by sctp_setsockopt_bindx(), a new
>> >> > bucket will be created as bp->port is not set.
>> >> >
>> >> > sctp's autobind is supposed to call sctp_autobind() where it does all
>> >> > things including setting bp->port. Since sctp_autobind() is called in
>> >> > sctp_sendmsg() if the sk is not yet bound, it should have skipped the
>> >> > auto bind.
>> >> >
>> >> > THis patch is to avoid calling inet_autobind() in inet_send_prepare()
>> >> > by changing sctp_prot .no_autobind with true, also remove the unused
>> >> > .get_port.
>> >>
>> >> Hi,
>> >>
>> >> I'm seeing SCTP oops in 4.14.151, reproducible easily with iperf:
>> >>
>> >> # iperf3 -s -1 &
>> >> # iperf3 -c localhost --sctp
>> >>
>> >> This patch was also included in 4.19.81, but there it seems to be working
>> >> fine.
>> >>
>> >> Any ideas if this patch is valid for 4.14, or what's missing in 4.14 to
>> >> make this work?
>> >pls get this commit into 4.14, which has been in 4.19:
>> >
>> >commit 644fbdeacf1d3edd366e44b8ba214de9d1dd66a9
>> >Author: Xin Long <lucien.xin@gmail.com>
>> >Date:   Sun May 20 16:39:10 2018 +0800
>> >
>> >    sctp: fix the issue that flags are ignored when using kernel_connect
>>
>> Care to send a backport?
>Sure, I haven't yet sent a backport for 4.14.y
>After I do the cherry-pick, what's the next step? Post it upstream
>with CCing someone ?

Just make sure stable@vger.kernel.org is Cc'ed.

-- 
Thanks,
Sasha
