Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 42AFA32727C
	for <lists+stable@lfdr.de>; Sun, 28 Feb 2021 14:40:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230049AbhB1Nkb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 28 Feb 2021 08:40:31 -0500
Received: from angie.orcam.me.uk ([157.25.102.26]:37100 "EHLO
        angie.orcam.me.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229715AbhB1Nkb (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 28 Feb 2021 08:40:31 -0500
X-Greylist: delayed 3027 seconds by postgrey-1.27 at vger.kernel.org; Sun, 28 Feb 2021 08:40:30 EST
Received: by angie.orcam.me.uk (Postfix, from userid 500)
        id 0C10392009C; Sun, 28 Feb 2021 14:39:48 +0100 (CET)
Received: from localhost (localhost [127.0.0.1])
        by angie.orcam.me.uk (Postfix) with ESMTP id F208092009B;
        Sun, 28 Feb 2021 14:39:48 +0100 (CET)
Date:   Sun, 28 Feb 2021 14:39:48 +0100 (CET)
From:   "Maciej W. Rozycki" <macro@orcam.me.uk>
To:     yunqiang.su@cipunited.com
cc:     'YunQiang Su' <wzssyqa@gmail.com>,
        'Thomas Bogendoerfer' <tsbogend@alpha.franken.de>,
        'Jiaxun Yang' <jiaxun.yang@flygoat.com>,
        'linux-mips' <linux-mips@vger.kernel.org>, stable@vger.kernel.org
Subject: =?UTF-8?Q?Re=3A_=E5=9B=9E=E5=A4=8D=3A_=5BPATCH_v4=5D_MIPS=3A_in?=
 =?UTF-8?Q?troduce_config_option_to_force_use_FR=3D0_for_F?=
 =?UTF-8?Q?PXX_binary?=
In-Reply-To: <000501d70da5$0ffd6a70$2ff83f50$@cipunited.com>
Message-ID: <alpine.DEB.2.21.2102281407590.44210@angie.orcam.me.uk>
References: <20210222034342.13136-1-yunqiang.su@cipunited.com> <CAKcpw6UgEUUCG2=9E9KFpTYF23fWshdcFtmB_O+YT0xEoS3swA@mail.gmail.com> <alpine.DEB.2.21.2102280217220.44210@angie.orcam.me.uk> <000501d70da5$0ffd6a70$2ff83f50$@cipunited.com>
User-Agent: Alpine 2.21 (DEB 202 2017-01-01)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sun, 28 Feb 2021, yunqiang.su@cipunited.com wrote:

> >  This is also the correct interpretation for objects produced by Golang, which I
> > have concluded are actually just fine according to the traditional psABI
> > definition.  It looks to me like the bug is solely in the linker, due to this weird
> > interpretation quoted above and unforeseen consequences for FPXX links
> > invented much later.
> > 
> 
> Yes. This a bug of linker, and we should fix it.
> While for pre-existing binaries, we need a solution to make it workable, especially for the
> generic Linux distributions, just like Debian.
> 
> https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=962485

 Thanks for the pointer.

 After a bit of thinking and having fully understood what the issue 
actually is I conclude a change like your original one (with no 
configuration option; we've got too many of them already) will be OK so 
long as it keeps the current arrangement for R6, which has the FR mode 
hardwired, because, as you say, for genuine FPXX binaries the actual FR 
setting does not matter, so the change in the fixed form won't break what 
hasn't been broken already.

 Please keep the history of changes in the comment section rather that the 
change description though.  Also I think the change description needs to 
be more elaborate on the motivation, so that someone who looks at it say 
10 years from now can figure out what is going on here.  You can reuse 
bits of our discussion for that purpose.

 Sadly I can see many changes going in where the description hardly says 
anything, and while the matter may seem obvious right now, it surely won't 
be for someone trying to unbreak things years from now while keeping the 
intent of the original change where it did the right thing.  Especially as 
secondary sources of information may not be easily available (anymore) and 
the test environment may not be easily reproducible.  Notice how often I 
need to refer to changes that were made many years ago and were not always 
correct.

 NB the real problem are not programs included with the distribution 
(which as I say can and ought to be fixed up with a script automatically; 
a distribution needs to have provisions for such workarounds as problems 
with the toolchain inevitably do happen from time to time), but programs 
built by users of the distribution who we cannot reasonably expect to be 
aware of every single quirk out there.

 Observe however that this does not solve the issue of a link-time or 
load-time incompatibility between FP32 modules incorrectly marked FPXX and 
FP64 or FP64A modules.  These will be let through and depending on usage 
likely eventually fail.

 You might be able to come up with a wrapper script in place of whatever 
the Golang invocation command is to postprocess modules produced in user 
compilations as well, and have it distributed until the linker issue has 
been fixed upstream and the changes propagated back to the distribution.

  Maciej
