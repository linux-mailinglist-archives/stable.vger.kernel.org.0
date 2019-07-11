Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4548465AA1
	for <lists+stable@lfdr.de>; Thu, 11 Jul 2019 17:41:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728274AbfGKPlN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 11 Jul 2019 11:41:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:39908 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725971AbfGKPlN (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 11 Jul 2019 11:41:13 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 42FD221537;
        Thu, 11 Jul 2019 15:41:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1562859672;
        bh=mWo5hCIGc4oPfm+WCi3xG/fwGJK6s8d7L7thRy0e3mg=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=cJNJerz84O9GsooyrtKxXgPZDhwuTDQLGM7goImnSkwV4po69C8kbDJQ7JALAnKvh
         peqWw4ir7W8NN34VVhNZpi+YSqeG0okiSEI6MB+yWPWnO7ot/cmQugkR6KpfcJ7wU7
         kk+JEpZ8AwsrBIvySQQvE60bYw5bFTuyYUSOFzh8=
Date:   Thu, 11 Jul 2019 17:41:10 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Amir Goldstein <amir73il@gmail.com>
Cc:     Sasha Levin <sashal@kernel.org>,
        Miklos Szeredi <mszeredi@redhat.com>,
        stable <stable@vger.kernel.org>,
        overlayfs <linux-unionfs@vger.kernel.org>,
        Vivek Goyal <vgoyal@redhat.com>
Subject: Re: overlayfs regression in master and stable trees
Message-ID: <20190711154110.GA28220@kroah.com>
References: <1560073529193139@kroah.com>
 <CAOQ4uxiTrsOs3KWOxedZicXNMJJharmWo=TDXDnxSC1XMNVKBg@mail.gmail.com>
 <CAOQ4uxiTTuOESvZ2Y5cSebqKs+qeU3q6ZMReBDro0Qv7aRBhpw@mail.gmail.com>
 <20190623010345.GJ2226@sasha-vm>
 <CAOQ4uxgv_FOLagfAMa=XLZZXnVhKoQK9oUHXiO45TZrKq5LQDw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAOQ4uxgv_FOLagfAMa=XLZZXnVhKoQK9oUHXiO45TZrKq5LQDw@mail.gmail.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Jul 11, 2019 at 05:14:48PM +0300, Amir Goldstein wrote:
> >
> > >3) Disallow bogus layer combinations.
> > >syzbot has started to produce repros that create bogus layer combinations.
> > >So far it has only been able to reproduce a WARN_ON, which has already
> > >been fixed in stable, by  acf3062a7e1c ("ovl: relax WARN_ON()..."), but
> > >other real bugs could be lurking if those setups are allowed.
> > >We decided to detect and error on these setups on mount, to stop syzbot
> > >(and attackers) from trying to attack overlayfs this way.
> > >To stop syzbot from mutating this class of repros on stable kernel you
> > >MAY apply these 3 patches, but in any case, I would wait a while to see
> > >if more bugs are reported on master.
> > >Although this solves a problem dating before 4.19, I have no plans
> > >of backporting these patches further back.
> > >
> > >146d62e5a586 ovl: detect overlapping layers
> > >9179c21dc6ed ovl: don't fail with disconnected lower NFS
> > >1dac6f5b0ed2 ovl: fix bogus -Wmaybe-unitialized warning
> >
> > I've queued these 3 for 4.19.
> >
> 
> FYI, an overlayfs regression has been reported:
> https://github.com/containers/libpod/issues/3540
> 
> Caused by commit "ovl: detect overlapping layers"
> 
> I am working on a fix.
> In retrospect, given my lengthy disclaimer above, it seems
> that this patch should not have been applied to stable (yet).
> I believe that this patch belongs to a class of fixed that
> should soak in master for a while before being considered for
> stable. On my part, I will not propose these sort of fixed in the future,
> with or without a disclaimer until they have soaked in master.

That's fair enough, send the git ids to stable@vger when you feel they
have "soaked" long enough in the future.

thanks,

greg k-h
