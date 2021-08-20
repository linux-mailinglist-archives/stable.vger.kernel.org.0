Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 212543F3695
	for <lists+stable@lfdr.de>; Sat, 21 Aug 2021 00:41:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239542AbhHTWmV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 20 Aug 2021 18:42:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:46132 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233567AbhHTWmV (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 20 Aug 2021 18:42:21 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B47D86115B;
        Fri, 20 Aug 2021 22:41:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1629499303;
        bh=BOTW8Mks0s0GIIpV4u8SO9KrAV5VLNg6mhoNs46Tdig=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=lGO1sdrWgaFd9A00Tuipl/3oYHTycQsiaXz82w6fWwptIWFYzMytTcBPW8Rgw+CpB
         ETbPWg5vFMxE+oDr2uLT4CMGvupqK9lpgqV4DxtcFB+RiMbYC+rtn+wxo7dYWrx6kc
         u5S5XAkc8LQflZKtAenQ9Qr7HhzCscaQFhHsL8Lf7B9kptn3T0uxBfUNZoVRE0Wq9r
         0Vrcnxrsk1mQB3JQhDijfmogASjoGZdtYkFejzERBzOYNVQA1PXZO/1GyP+qW201G1
         Od3flfduIHutftfa1PcOehIwGKRVqzXIW4kRmc1PBhZivCLtqB9WqdiFDBKuoDbD4r
         on8ksncvxQQIg==
Received: by pali.im (Postfix)
        id 9B625B8A; Sat, 21 Aug 2021 00:41:40 +0200 (CEST)
Date:   Sat, 21 Aug 2021 00:41:40 +0200
From:   Pali =?utf-8?B?Um9ow6Fy?= <pali@kernel.org>
To:     Sasha Levin <sashal@kernel.org>
Cc:     Greg KH <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Kalle Valo <kvalo@codeaurora.org>,
        linux-wireless@vger.kernel.org
Subject: Re: Backporting CVE-2020-3702 ath9k patches to stable
Message-ID: <20210820224140.3ynhvfnyasod3wdj@pali>
References: <20210818084859.vcs4vs3yd6zetmyt@pali>
 <YRzMt53Ca/5irXc0@kroah.com>
 <20210818091027.2mhqrhg5pcq2bagt@pali>
 <YRzQZZIp/LfMy/xG@kroah.com>
 <20210820113505.dgcsurognowp6xqp@pali>
 <YSAdPJFhmTztd+0Z@sashalap>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <YSAdPJFhmTztd+0Z@sashalap>
User-Agent: NeoMutt/20180716
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Friday 20 August 2021 17:23:08 Sasha Levin wrote:
> On Fri, Aug 20, 2021 at 01:35:05PM +0200, Pali Rohár wrote:
> > On Wednesday 18 August 2021 11:18:29 Greg KH wrote:
> > > On Wed, Aug 18, 2021 at 11:10:27AM +0200, Pali Rohár wrote:
> > > > On Wednesday 18 August 2021 11:02:47 Greg KH wrote:
> > > > > On Wed, Aug 18, 2021 at 10:48:59AM +0200, Pali Rohár wrote:
> > > > > > Hello! I would like to request for backporting following ath9k commits
> > > > > > which are fixing CVE-2020-3702 issue.
> > > > > >
> > > > > > 56c5485c9e44 ("ath: Use safer key clearing with key cache entries")
> > > > > > 73488cb2fa3b ("ath9k: Clear key cache explicitly on disabling hardware")
> > > > > > d2d3e36498dd ("ath: Export ath_hw_keysetmac()")
> > > > > > 144cd24dbc36 ("ath: Modify ath_key_delete() to not need full key entry")
> > > > > > ca2848022c12 ("ath9k: Postpone key cache entry deletion for TXQ frames reference it")
> > > > > >
> > > > > > See also:
> > > > > > https://lore.kernel.org/linux-wireless/87o8hvlx5g.fsf@codeaurora.org/
> > > > > >
> > > > > > This CVE-2020-3702 issue affects ath9k driver in stable kernel versions.
> > > > > > And due to this issue Qualcomm suggests to not use open source ath9k
> > > > > > driver and instead to use their proprietary driver which do not have
> > > > > > this issue.
> > > > > >
> > > > > > Details about CVE-2020-3702 are described on the ESET blog post:
> > > > > > https://www.welivesecurity.com/2020/08/06/beyond-kr00k-even-more-wifi-chips-vulnerable-eavesdropping/
> > > > > >
> > > > > > Two months ago ESET tested above mentioned commits applied on top of
> > > > > > 4.14 stable tree and confirmed that issue cannot be reproduced anymore
> > > > > > with those patches. Commits were applied cleanly on top of 4.14 stable
> > > > > > tree without need to do any modification.
> > > > >
> > > > > What stable tree(s) do you want to see these go into?
> > > >
> > > > Commits were introduced in 5.12, so it should go to all stable trees << 5.12
> > > >
> > > > > And what order are the above commits to be applied in, top-to-bottom or
> > > > > bottom-to-top?
> > > >
> > > > Same order in which were applied in 5.12. So first commit to apply is
> > > > 56c5485c9e44, then 73488cb2fa3b and so on... (from top of the email to
> > > > the bottom of email).
> > > 
> > > Great, all now queued up.  Sad that qcom didn't want to do this
> > > themselves :(
> > > 
> > > greg k-h
> > 
> > It is sad, but Qualcomm support said that they have fixed it in their
> > proprietary driver in July 2020 (so more than year ago) and that open
> > source drivers like ath9k are unsupported and customers should not use
> > them :( And similar answer is from vendors who put these chips into
> > their cards / products.
> 
> Is there a public statement that says that? Right now the MAINTAINERS
> file says it's "supported" and if it's not the case we should at least
> fix that and consider deprecating it if it's really orphaned.

No, there is no public statement. This is just (private) response from
official Qualcomm support contact...

And from card vendors were similar replies, that they received only fix
from Qualcomm (for proprietary driver) and for open source ath9k support
I need to ask open source kernel community. They suggested me to wait
until open source kernel community fix it.

I really do not know what is the support state of ath9k, but the fact is
that this security issue was fixed in July 2020 (in Qualcomm driver) and
some vendors received fix even earlier.

So something is really wrong if in LTS kernels this issue was not fixed
for more than year and in vendor driver was it basically immediately.

I agree that some clarification or public statement about ath9k driver
support would be very useful...

> -- 
> Thanks,
> Sasha
