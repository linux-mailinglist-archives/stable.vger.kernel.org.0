Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D383933D53D
	for <lists+stable@lfdr.de>; Tue, 16 Mar 2021 14:54:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235571AbhCPNyO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 16 Mar 2021 09:54:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:56846 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235569AbhCPNyC (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 16 Mar 2021 09:54:02 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id ED1E664FED;
        Tue, 16 Mar 2021 13:54:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1615902842;
        bh=DSp4ZyCdLVrD/515PijNSWVY8esTcirqwL+R08qKkD0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=kepDP69Ry/ngCbQbuVnK5sTa8HmjWObQRpY7jKZ/9Hdv2iZjgSp5SHDIReCV41yZ9
         rlszJk7PyvsUW4DYxuhv/CmMZUFFJpisL35DeJnnbcVWxtl7bLLZMB46dKXWmL6g2/
         DmSHwku234UB91qYKSL8SGXWRQMfObJB0TanU91Ffh0lRiTl2g3nyixzDT6Q5TYp3k
         XYr3ZnxDouOsdg759LsDTpkNijYEmApECpUjePgms6NYr3+I5FCPCKs0459YFW5SWF
         7r10Z3kwUY9YGDVkqEiTxXl33Q7Qi8YANQuFN0JaCuRhlhiI19DDaU8fLVEyBJNmgu
         iwHD+LAO2CE3g==
Date:   Tue, 16 Mar 2021 09:54:01 -0400
From:   Sasha Levin <sashal@kernel.org>
To:     "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>
Cc:     Vladimir Oltean <vladimir.oltean@nxp.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        Jakub Kicinski <kuba@kernel.org>,
        Christian Eggers <ceggers@arri.de>
Subject: Re: [PATCH 5.10 113/290] net: dsa: implement a central TX
 reallocation procedure
Message-ID: <YFC4eVripXbAw2cG@sashalap>
References: <20210315135541.921894249@linuxfoundation.org>
 <20210315135545.737069480@linuxfoundation.org>
 <20210315195601.auhfy5uafjafgczs@skbuf>
 <YFBGIt2jRQLmjtln@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <YFBGIt2jRQLmjtln@kroah.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Mar 16, 2021 at 06:46:10AM +0100, gregkh@linuxfoundation.org wrote:
>On Mon, Mar 15, 2021 at 07:56:02PM +0000, Vladimir Oltean wrote:
>> +Andrew, Vivien,
>>
>> On Mon, Mar 15, 2021 at 02:53:26PM +0100, gregkh@linuxfoundation.org wrote:
>> > From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
>> >
>> > From: Vladimir Oltean <vladimir.oltean@nxp.com>
>> >
>> > [ Upstream commit a3b0b6479700a5b0af2c631cb2ec0fb7a0d978f2 ]
>> >
>> > At the moment, taggers are left with the task of ensuring that the skb
>> > headers are writable (which they aren't, if the frames were cloned for
>> > TX timestamping, for flooding by the bridge, etc), and that there is
>> > enough space in the skb data area for the DSA tag to be pushed.
>> >
>> > Moreover, the life of tail taggers is even harder, because they need to
>> > ensure that short frames have enough padding, a problem that normal
>> > taggers don't have.
>> >
>> > The principle of the DSA framework is that everything except for the
>> > most intimate hardware specifics (like in this case, the actual packing
>> > of the DSA tag bits) should be done inside the core, to avoid having
>> > code paths that are very rarely tested.
>> >
>> > So provide a TX reallocation procedure that should cover the known needs
>> > of DSA today.
>> >
>> > Note that this patch also gives the network stack a good hint about the
>> > headroom/tailroom it's going to need. Up till now it wasn't doing that.
>> > So the reallocation procedure should really be there only for the
>> > exceptional cases, and for cloned packets which need to be unshared.
>> >
>> > Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
>> > Tested-by: Christian Eggers <ceggers@arri.de> # For tail taggers only
>> > Tested-by: Kurt Kanzenbach <kurt@linutronix.de>
>> > Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
>> > Signed-off-by: Jakub Kicinski <kuba@kernel.org>
>> > Signed-off-by: Sasha Levin <sashal@kernel.org>
>> > ---
>>
>> For context, Sasha explains here:
>> https://www.spinics.net/lists/stable-commits/msg190151.html
>> (the conversation is somewhat truncated, unfortunately, because
>> stable-commits@vger.kernel.org ate my replies)
>> that 13 patches were backported to get the unrelated commit 9200f515c41f
>> ("net: dsa: tag_mtk: fix 802.1ad VLAN egress") to apply cleanly with git-am.
>>
>> I am not strictly against this, even though I would have liked to know
>> that the maintainers were explicitly informed about it.
>>
>> Greg, could you make your stable backporting emails include the output
>> of ./get_maintainer.pl into the list of recipients? Thanks.
>
>I cc: everyone on the signed-off-by list on the patch, why would we need
>to add more?  A maintainer should always be on that list automatically.

Oh, hm, could this be an issue with subsystems that have a shared
maintainership model? In that scenario not all maintainers will sign-off
on a commit.

-- 
Thanks,
Sasha
