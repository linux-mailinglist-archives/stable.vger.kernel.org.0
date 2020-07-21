Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 41CC92280EE
	for <lists+stable@lfdr.de>; Tue, 21 Jul 2020 15:30:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726473AbgGUNat (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 21 Jul 2020 09:30:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:35314 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726192AbgGUNas (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 21 Jul 2020 09:30:48 -0400
Received: from localhost (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EE6AA206E9;
        Tue, 21 Jul 2020 13:30:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1595338248;
        bh=Go7Erws6q/gKx6g2x/csh/nTGhFSxFw+jEwevVsjsFQ=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=UvyWWntm3hXrmys/RYKfkTX11+K4hWCRNW+sbnXkJT+HzF7dGbVcyAB2414VghMO7
         4g/gsBb+ZxJLBhA5HuOUzsPsHUDoJvmX6tirPvcUE75L+68lP0RfRZFDluBGBDsQcH
         SaUaGhlhOxp8mmWKye3Apg2NLNzg/5kRc++2Fi88=
Date:   Tue, 21 Jul 2020 09:30:46 -0400
From:   Sasha Levin <sashal@kernel.org>
To:     Pavel Machek <pavel@denx.de>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH 4.19 041/133] Revert "usb/ohci-platform: Fix a warning
 when hibernating"
Message-ID: <20200721133046.GB406581@sasha-vm>
References: <20200720152803.732195882@linuxfoundation.org>
 <20200720152805.704517976@linuxfoundation.org>
 <20200720210722.GA11552@amd>
 <20200721012943.GA406581@sasha-vm>
 <20200721112908.GA17950@duo.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20200721112908.GA17950@duo.ucw.cz>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Jul 21, 2020 at 01:29:08PM +0200, Pavel Machek wrote:
>Hi!
>
>> > > >After some investigations, we concluded the following:
>> > > > - the issue does not exist in vanilla v5.8-rc4+
>> > > > - [bisecting shows that] the panic on v4.14.186 is caused by the lack
>> > > >   of v5.6-rc1 commit 987351e1ea7772 ("phy: core: Add consumer device
>> > > >   link support"). Getting evidence for that is easy. Reverting
>> > > >   987351e1ea7772 in vanilla leads to a similar backtrace [2].
>> > > >
>> > > >Questions:
>> > > > - Backporting 987351e1ea7772 ("phy: core: Add consumer device
>> > > >   link support") to v4.14.187 looks challenging enough, so probably not
>> > > >   worth it. Anybody to contradict this?
>> >
>> > I'm not sure about v4.14.187, but backport to v4.19 is quite simple
>> > (just ignore single non-existing file) and passes basic testing.
>> >
>> > Would that be better solution for 4.19 and newer?
>>
>> If Eugeniu could confirm that doing so on 4.19+ works for him, sure.
>
>He did:
>
>Message-ID: <20200721065054.GA8290@lxhi-065.adit-jv.com>
>Technically yes. Backporting 987351e1ea7772 to v4.19.x avoids the panic.
>...
>FWIW I confirm that:
>* setup [A] leads to the issue reported in [C]
>* setup [B] resolves the issue reported in [C]
>
>[A] v4.19 + 16bdc04cc98 + 1cb3b0095c3 + 79112cc3c29f
>[B] v4.19 + 16bdc04cc98 + 1cb3b0095c3 + 79112cc3c29f + 987351e1ea7
>[C] https://lore.kernel.org/linux-usb/20200709070023.GA18414@lxhi-065.adit-jv.com/

Awesome, I can queue it back for the next release.

-- 
Thanks,
Sasha
