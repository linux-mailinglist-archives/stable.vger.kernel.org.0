Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CD9A14F96B
	for <lists+stable@lfdr.de>; Sun, 23 Jun 2019 03:03:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726423AbfFWBDr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 22 Jun 2019 21:03:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:34738 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725844AbfFWBDr (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 22 Jun 2019 21:03:47 -0400
Received: from localhost (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 53A472084E;
        Sun, 23 Jun 2019 01:03:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1561251826;
        bh=cuwbYT8yBxuJ7pc8Ea2TdAptwyRjgPT1ZamHNhYYwwY=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=L24R2DEIfBcLEreg0U/G/Lx1iIAeodxZVKSaG8Buhh+Tw5gs6J2YYM+/Qpg3Wzzpr
         KDlru/GoMdrz2sKvUXqDatA4IDugkDGxvbPXltjeDO+jZD5kVgdMwdNiUmrHdzeuhr
         gt+yMvMrV7DMEsw3iDbYPE4UQ714s2dnp9IlNeH4=
Date:   Sat, 22 Jun 2019 21:03:45 -0400
From:   Sasha Levin <sashal@kernel.org>
To:     Amir Goldstein <amir73il@gmail.com>
Cc:     Greg KH <gregkh@linuxfoundation.org>,
        Miklos Szeredi <mszeredi@redhat.com>,
        stable <stable@vger.kernel.org>,
        overlayfs <linux-unionfs@vger.kernel.org>
Subject: Re: FAILED: patch "[PATCH] ovl: support the FS_IOC_FS[SG]ETXATTR
 ioctls" failed to apply to 5.1-stable tree
Message-ID: <20190623010345.GJ2226@sasha-vm>
References: <1560073529193139@kroah.com>
 <CAOQ4uxiTrsOs3KWOxedZicXNMJJharmWo=TDXDnxSC1XMNVKBg@mail.gmail.com>
 <CAOQ4uxiTTuOESvZ2Y5cSebqKs+qeU3q6ZMReBDro0Qv7aRBhpw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <CAOQ4uxiTTuOESvZ2Y5cSebqKs+qeU3q6ZMReBDro0Qv7aRBhpw@mail.gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Jun 21, 2019 at 11:15:47AM +0300, Amir Goldstein wrote:
>On Thu, Jun 13, 2019 at 11:49 AM Amir Goldstein <amir73il@gmail.com> wrote:
>>
>> On Sun, Jun 9, 2019 at 12:45 PM <gregkh@linuxfoundation.org> wrote:
>> >
>> >
>> > The patch below does not apply to the 5.1-stable tree.
>> > If someone wants it applied there, or to any other stable or longterm
>> > tree, then please email the backport, including the original git commit
>> > id to <stable@vger.kernel.org>.
>> >
>> > thanks,
>> >
>> > greg k-h
>> >
>>
>> FYI, the failure to apply this patch would be resolved after you
>> picked up "ovl: check the capability before cred overridden" for
>> stable, please hold off from taking this patch just yet, because
>> it has a bug, whose fix wasn't picked upstream yet.
>>
>
>Greg,
>
>Please apply these patches to stable 4.19.
>They fix a docker regression (project quotas feature).
>
>b21d9c435f93 ovl: support the FS_IOC_FS[SG]ETXATTR ioctls
>941d935ac763 ovl: fix wrong flags check in FS_IOC_FS[SG]ETXATTR ioctls
>
>They apply cleanly and tested on v4.19.53.

I've queued these for 4.19.

>While at it, I also tested that the following patches apply cleanly and solve
>relevant issues on v4.19.53, but they are not clear stable candidates.
>
>1) /proc/locks shows incorrect ino. Only reported by xfstests (so far):
>6dde1e42f497 ovl: make i_ino consistent with st_ino in more cases

And this.

>2) Fix output of `modinfo overlay`:
>253e74833911 ovl: fix typo in MODULE_PARM_DESC

But not this one. Maybe we should be including these in stable trees
since the risk factor is low and it fixes something user-visible, but
our current rules object this this kind of patches so I've left it out.

>3) Disallow bogus layer combinations.
>syzbot has started to produce repros that create bogus layer combinations.
>So far it has only been able to reproduce a WARN_ON, which has already
>been fixed in stable, by  acf3062a7e1c ("ovl: relax WARN_ON()..."), but
>other real bugs could be lurking if those setups are allowed.
>We decided to detect and error on these setups on mount, to stop syzbot
>(and attackers) from trying to attack overlayfs this way.
>To stop syzbot from mutating this class of repros on stable kernel you
>MAY apply these 3 patches, but in any case, I would wait a while to see
>if more bugs are reported on master.
>Although this solves a problem dating before 4.19, I have no plans
>of backporting these patches further back.
>
>146d62e5a586 ovl: detect overlapping layers
>9179c21dc6ed ovl: don't fail with disconnected lower NFS
>1dac6f5b0ed2 ovl: fix bogus -Wmaybe-unitialized warning

I've queued these 3 for 4.19.

--
Thanks,
Sasha
