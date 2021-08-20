Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8073B3F3730
	for <lists+stable@lfdr.de>; Sat, 21 Aug 2021 01:07:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231576AbhHTXHp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 20 Aug 2021 19:07:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:50106 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230303AbhHTXHp (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 20 Aug 2021 19:07:45 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9B88E6023B;
        Fri, 20 Aug 2021 23:07:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1629500826;
        bh=sqegKiu5bEQr/nPEr9byZWUabdR/OKECY/NCUWkPVko=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Ch8eJ+wAvTak8/coZWXFBkrFS0UbbmWkb74eAT6vF3d9mVVBAgATJ0wLuA5HwMULD
         MZTgXGFJ//n+Ir4Bbmbyvvbj1YHjxsQ+Lnc6OPPbZlSfQFbdWMtaAfZ/IGEW0vE0cm
         dqKWF0jyqVkLg9vKVUJURZpRLoeYk1JmQd54HgITfFWWT4rpn3gaZwsLCE7vzTJEHF
         QVsQFv3ZZh9zo4TBmpxpCqwYUqyj+Vrt/hHj0x3HZR8H4i3vnFOwEtmvChBHz0uJVm
         t2a7bQr3yAeVg4mVKdEwt+KPXbOIILuQsC8gClNnq47B9aN7qieeUYi9dm/OBpl40w
         OPalzZsiQw0Kw==
Received: by pali.im (Postfix)
        id 37071B8A; Sat, 21 Aug 2021 01:07:04 +0200 (CEST)
Date:   Sat, 21 Aug 2021 01:07:04 +0200
From:   Pali =?utf-8?B?Um9ow6Fy?= <pali@kernel.org>
To:     Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
Cc:     Sasha Levin <sashal@kernel.org>,
        Greg KH <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Kalle Valo <kvalo@codeaurora.org>,
        linux-wireless@vger.kernel.org
Subject: Re: Backporting CVE-2020-3702 ath9k patches to stable
Message-ID: <20210820230704.sckgjngjpj3dvsae@pali>
References: <20210818084859.vcs4vs3yd6zetmyt@pali>
 <YRzMt53Ca/5irXc0@kroah.com>
 <20210818091027.2mhqrhg5pcq2bagt@pali>
 <YRzQZZIp/LfMy/xG@kroah.com>
 <20210820113505.dgcsurognowp6xqp@pali>
 <YSAdPJFhmTztd+0Z@sashalap>
 <87y28vycox.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <87y28vycox.fsf@toke.dk>
User-Agent: NeoMutt/20180716
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Saturday 21 August 2021 00:27:10 Toke Høiland-Jørgensen wrote:
> Sasha Levin <sashal@kernel.org> writes:
> 
> > On Fri, Aug 20, 2021 at 01:35:05PM +0200, Pali Rohár wrote:
> >>On Wednesday 18 August 2021 11:18:29 Greg KH wrote:
> >>> On Wed, Aug 18, 2021 at 11:10:27AM +0200, Pali Rohár wrote:
> >>> > On Wednesday 18 August 2021 11:02:47 Greg KH wrote:
> >>> > > On Wed, Aug 18, 2021 at 10:48:59AM +0200, Pali Rohár wrote:
> >>> > > > Hello! I would like to request for backporting following ath9k commits
> >>> > > > which are fixing CVE-2020-3702 issue.
> >>> > > >
> >>> > > > 56c5485c9e44 ("ath: Use safer key clearing with key cache entries")
> >>> > > > 73488cb2fa3b ("ath9k: Clear key cache explicitly on disabling hardware")
> >>> > > > d2d3e36498dd ("ath: Export ath_hw_keysetmac()")
> >>> > > > 144cd24dbc36 ("ath: Modify ath_key_delete() to not need full key entry")
> >>> > > > ca2848022c12 ("ath9k: Postpone key cache entry deletion for TXQ frames reference it")
> >>> > > >
> >>> > > > See also:
> >>> > > > https://lore.kernel.org/linux-wireless/87o8hvlx5g.fsf@codeaurora.org/
> >>> > > >
> >>> > > > This CVE-2020-3702 issue affects ath9k driver in stable kernel versions.
> >>> > > > And due to this issue Qualcomm suggests to not use open source ath9k
> >>> > > > driver and instead to use their proprietary driver which do not have
> >>> > > > this issue.
> >>> > > >
> >>> > > > Details about CVE-2020-3702 are described on the ESET blog post:
> >>> > > > https://www.welivesecurity.com/2020/08/06/beyond-kr00k-even-more-wifi-chips-vulnerable-eavesdropping/
> >>> > > >
> >>> > > > Two months ago ESET tested above mentioned commits applied on top of
> >>> > > > 4.14 stable tree and confirmed that issue cannot be reproduced anymore
> >>> > > > with those patches. Commits were applied cleanly on top of 4.14 stable
> >>> > > > tree without need to do any modification.
> >>> > >
> >>> > > What stable tree(s) do you want to see these go into?
> >>> >
> >>> > Commits were introduced in 5.12, so it should go to all stable trees << 5.12
> >>> >
> >>> > > And what order are the above commits to be applied in, top-to-bottom or
> >>> > > bottom-to-top?
> >>> >
> >>> > Same order in which were applied in 5.12. So first commit to apply is
> >>> > 56c5485c9e44, then 73488cb2fa3b and so on... (from top of the email to
> >>> > the bottom of email).
> >>>
> >>> Great, all now queued up.  Sad that qcom didn't want to do this
> >>> themselves :(
> >>>
> >>> greg k-h
> >>
> >>It is sad, but Qualcomm support said that they have fixed it in their
> >>proprietary driver in July 2020 (so more than year ago) and that open
> >>source drivers like ath9k are unsupported and customers should not use
> >>them :( And similar answer is from vendors who put these chips into
> >>their cards / products.
> >
> > Is there a public statement that says that? Right now the MAINTAINERS
> > file says it's "supported" and if it's not the case we should at least
> > fix that and consider deprecating it if it's really orphaned.
> 
> FWIW there's still quite a few OpenWrt devices that are using ath9k and
> ticking away happily. And we are some that do still care about ath9k,
> even if QCA doesn't... As the email that started this thread also shows,
> I suppose?

For sure, there are lot of people who are using cards with this driver.
These cards are still popular for scenarios where 802.11N is enough as
these chips are relatively stable and have good hw design. In these
chips there is no CPU, no DSP, everything is done directly in HW or on
host CPU (in kernel driver or userspace). So therefore there is no
firmware/microcode like in new cards single point of failure or cause
instability. And card vendors are still putting these chips also into
new cards.

Simple issues (like kernel crash, API change, ... ) in ath9k driver can
be relatively easily fixed by (any) kernel developer. But issues like
fixing some cryptography part used in hw chip does not have to be simple
for people who do not have HW documentation or are not skilled in how
chip is working. (IIRC there is no public HW documentation)

So due to popularity basic maintenance is and would be still there (even
without Qualcomm support), but security related issues are problematic.

And I think that these older wifi cards would be still under attack by
security researchers. So we can expect that in future there can be
another attack which would need some driver modification for correct
mitigation...
