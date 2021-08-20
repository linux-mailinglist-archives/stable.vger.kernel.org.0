Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 804C03F35FE
	for <lists+stable@lfdr.de>; Fri, 20 Aug 2021 23:23:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231761AbhHTVXs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 20 Aug 2021 17:23:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:59012 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231200AbhHTVXs (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 20 Aug 2021 17:23:48 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id AB8926108B;
        Fri, 20 Aug 2021 21:23:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1629494590;
        bh=fLgBCmuTS4P3zp1jdfgwAGz5rrUB0maIASN2bUovQHg=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=anmUv4Xt4BBNtFaoa+B1nUnzAKbBsH2Xny7MlTj0KVkLaM/dWk8UBVeOJe+66CyoC
         U7C0HChGU3fpubVT/Lq2+IPIceNxJH+Z7UsbLYXZESSW8hjAZB39xCo6EmjU6dfVvn
         yxeDwvzQBRhfJRoc3hDuZQ1b6XUO3aXJn9BjQyaaKXK8AyYP3fuauNk/c6LQxCpDfQ
         qVDHre2tdHw0pOHk0vM7cZDWLLo/giIESfM6PMh2kR6exnRBZ1mW6u6lG3f5ep1ZCW
         rYcfTL0b36hnwtme+N5qD8I492skWULAdw6ZKJjwSqayItMvlZeoGR7SxO8lJCExKY
         mzF8ERMMEEYBQ==
Date:   Fri, 20 Aug 2021 17:23:08 -0400
From:   Sasha Levin <sashal@kernel.org>
To:     Pali =?iso-8859-1?Q?Roh=E1r?= <pali@kernel.org>
Cc:     Greg KH <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Kalle Valo <kvalo@codeaurora.org>,
        linux-wireless@vger.kernel.org
Subject: Re: Backporting CVE-2020-3702 ath9k patches to stable
Message-ID: <YSAdPJFhmTztd+0Z@sashalap>
References: <20210818084859.vcs4vs3yd6zetmyt@pali>
 <YRzMt53Ca/5irXc0@kroah.com>
 <20210818091027.2mhqrhg5pcq2bagt@pali>
 <YRzQZZIp/LfMy/xG@kroah.com>
 <20210820113505.dgcsurognowp6xqp@pali>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1; format=flowed
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20210820113505.dgcsurognowp6xqp@pali>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Aug 20, 2021 at 01:35:05PM +0200, Pali Rohár wrote:
>On Wednesday 18 August 2021 11:18:29 Greg KH wrote:
>> On Wed, Aug 18, 2021 at 11:10:27AM +0200, Pali Rohár wrote:
>> > On Wednesday 18 August 2021 11:02:47 Greg KH wrote:
>> > > On Wed, Aug 18, 2021 at 10:48:59AM +0200, Pali Rohár wrote:
>> > > > Hello! I would like to request for backporting following ath9k commits
>> > > > which are fixing CVE-2020-3702 issue.
>> > > >
>> > > > 56c5485c9e44 ("ath: Use safer key clearing with key cache entries")
>> > > > 73488cb2fa3b ("ath9k: Clear key cache explicitly on disabling hardware")
>> > > > d2d3e36498dd ("ath: Export ath_hw_keysetmac()")
>> > > > 144cd24dbc36 ("ath: Modify ath_key_delete() to not need full key entry")
>> > > > ca2848022c12 ("ath9k: Postpone key cache entry deletion for TXQ frames reference it")
>> > > >
>> > > > See also:
>> > > > https://lore.kernel.org/linux-wireless/87o8hvlx5g.fsf@codeaurora.org/
>> > > >
>> > > > This CVE-2020-3702 issue affects ath9k driver in stable kernel versions.
>> > > > And due to this issue Qualcomm suggests to not use open source ath9k
>> > > > driver and instead to use their proprietary driver which do not have
>> > > > this issue.
>> > > >
>> > > > Details about CVE-2020-3702 are described on the ESET blog post:
>> > > > https://www.welivesecurity.com/2020/08/06/beyond-kr00k-even-more-wifi-chips-vulnerable-eavesdropping/
>> > > >
>> > > > Two months ago ESET tested above mentioned commits applied on top of
>> > > > 4.14 stable tree and confirmed that issue cannot be reproduced anymore
>> > > > with those patches. Commits were applied cleanly on top of 4.14 stable
>> > > > tree without need to do any modification.
>> > >
>> > > What stable tree(s) do you want to see these go into?
>> >
>> > Commits were introduced in 5.12, so it should go to all stable trees << 5.12
>> >
>> > > And what order are the above commits to be applied in, top-to-bottom or
>> > > bottom-to-top?
>> >
>> > Same order in which were applied in 5.12. So first commit to apply is
>> > 56c5485c9e44, then 73488cb2fa3b and so on... (from top of the email to
>> > the bottom of email).
>>
>> Great, all now queued up.  Sad that qcom didn't want to do this
>> themselves :(
>>
>> greg k-h
>
>It is sad, but Qualcomm support said that they have fixed it in their
>proprietary driver in July 2020 (so more than year ago) and that open
>source drivers like ath9k are unsupported and customers should not use
>them :( And similar answer is from vendors who put these chips into
>their cards / products.

Is there a public statement that says that? Right now the MAINTAINERS
file says it's "supported" and if it's not the case we should at least
fix that and consider deprecating it if it's really orphaned.

-- 
Thanks,
Sasha
