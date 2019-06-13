Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 791B84433D
	for <lists+stable@lfdr.de>; Thu, 13 Jun 2019 18:30:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727627AbfFMQ2G (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 13 Jun 2019 12:28:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:48964 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727271AbfFMQ2G (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 13 Jun 2019 12:28:06 -0400
Received: from localhost (unknown [131.107.160.220])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9EE1F21743;
        Thu, 13 Jun 2019 16:28:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1560443285;
        bh=pTWfd28rxTsC36j5nVi4lXHdrxsHMLFah47TRp8/Hl0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=jH+hYGmLO1NFzZnYcUN5UZLEqmsoQQ3AoV3p5xisj858SDLvyW9Nh3RakQJBRYq4g
         oBxFnQEyHGkFv/4dw+UJxCsMrHHu5+M315FphN83xvW4/NOf+v9mP2WcwFdyfr8Zdk
         pJD1fokgt1FQHAtnRbEeOUG/eM3pCje3IPwso66A=
Date:   Thu, 13 Jun 2019 12:28:05 -0400
From:   Sasha Levin <sashal@kernel.org>
To:     Takashi Iwai <tiwai@suse.de>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        syzbot+e4c8abb920efa77bace9@syzkaller.appspotmail.com
Subject: Re: [PATCH 4.14 61/81] ALSA: seq: Protect in-kernel ioctl calls with
 mutex
Message-ID: <20190613162805.GI1513@sasha-vm>
References: <20190613075649.074682929@linuxfoundation.org>
 <20190613075653.581995283@linuxfoundation.org>
 <s5hzhmlluwx.wl-tiwai@suse.de>
 <20190613091122.GA31122@kroah.com>
 <s5hv9x9luek.wl-tiwai@suse.de>
 <20190613153946.GG1513@sasha-vm>
 <s5hwohpjxrk.wl-tiwai@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <s5hwohpjxrk.wl-tiwai@suse.de>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Jun 13, 2019 at 05:44:15PM +0200, Takashi Iwai wrote:
>On Thu, 13 Jun 2019 17:39:46 +0200,
>Sasha Levin wrote:
>>
>> On Thu, Jun 13, 2019 at 11:13:55AM +0200, Takashi Iwai wrote:
>> >On Thu, 13 Jun 2019 11:11:22 +0200,
>> >Greg Kroah-Hartman wrote:
>> >>
>> >> On Thu, Jun 13, 2019 at 11:02:54AM +0200, Takashi Iwai wrote:
>> >> > On Thu, 13 Jun 2019 10:33:44 +0200,
>> >> > Greg Kroah-Hartman wrote:
>> >> > >
>> >> > > [ Upstream commit feb689025fbb6f0aa6297d3ddf97de945ea4ad32 ]
>> >> > >
>> >> > > ALSA OSS sequencer calls the ioctl function indirectly via
>> >> > > snd_seq_kernel_client_ctl().  While we already applied the protection
>> >> > > against races between the normal ioctls and writes via the client's
>> >> > > ioctl_mutex, this code path was left untouched.  And this seems to be
>> >> > > the cause of still remaining some rare UAF as spontaneously triggered
>> >> > > by syzkaller.
>> >> > >
>> >> > > For the sake of robustness, wrap the ioctl_mutex also for the call via
>> >> > > snd_seq_kernel_client_ctl(), too.
>> >> > >
>> >> > > Reported-by: syzbot+e4c8abb920efa77bace9@syzkaller.appspotmail.com
>> >> > > Signed-off-by: Takashi Iwai <tiwai@suse.de>
>> >> > > Signed-off-by: Sasha Levin <sashal@kernel.org>
>> >> >
>> >> > This commit is reverted later by commit f0654ba94e33.
>> >> > So please drop this.  The proper fix is done later by commit
>> >> > 7c32ae35fbf9 ("ALSA: seq: Cover unsubscribe_port() in list_mutex")
>> >> >
>> >> > Ditto for 4.19.y and 5.1.y.
>> >>
>> >> Now dropped everywhere, and I added 7c32ae35fbf9 ("ALSA: seq: Cover
>> >> unsubscribe_port() in list_mutex") everywhere instead.
>> >
>> >Thanks!
>> >
>> >BTW, do we have a systematic check whether the selected stable commit
>> >is reverted in a later commit?  At least, you can track it as long as
>> >Fixes tag is properly set.
>>
>> I have that scripting in place, and I usually check it once before I
>> send the initial reviews and then once Greg does the -rc release.
>
>OK, good to hear.  So this time must be some exceptional error.

I still run these manually (I guess it's time to automate that too), so
it happens sometimes that folks notice these faster :)

--
Thanks,
Sasha
