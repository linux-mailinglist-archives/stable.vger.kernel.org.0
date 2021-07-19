Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 405EC3CEB99
	for <lists+stable@lfdr.de>; Mon, 19 Jul 2021 22:06:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356234AbhGSRV5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Jul 2021 13:21:57 -0400
Received: from mail.kernel.org ([198.145.29.99]:58950 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1377554AbhGSRQi (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 19 Jul 2021 13:16:38 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8676F60FF3;
        Mon, 19 Jul 2021 17:57:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1626717437;
        bh=KbDdGnhC2frkP9u/h0M77QXr/SNK+dA7wAXsuKjWBfE=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=rxjDPS5yqgWfhNXTOh7Z6Bv1ZPRpE516CQiwHt2HE5rhBXzTaypZb+eCchVgUf2jy
         T6l/dD/zJFKpnkwRg5t0GHoAcuNJtYp8AW6ZG91ZjZ6KCfVfEV6xpajCIGQXYZVf0r
         xYaXBGu1PadkuO7TgbuusPf+chkFcAhpp0GvnfCWoJLTUSWBj7618YUR/QUBcr2Vok
         nPi/BoyJ78QeeRp91Al1GXka4iCOwsVEws8MnWCwZw8kPnTpdHPvEcqqb+XcWFftTm
         jjETQ7zjJnGpl+3b86KPDVZts0/ucFDz+UBCJUOgo9GhQNuiL2IGY2r54R/KcGurm8
         74JJ3hlddff7g==
Date:   Mon, 19 Jul 2021 13:57:16 -0400
From:   Sasha Levin <sashal@kernel.org>
To:     Naresh Kamboju <naresh.kamboju@linaro.org>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kishon Vijay Abraham I <kishon@ti.com>,
        open list <linux-kernel@vger.kernel.org>,
        linux-stable <stable@vger.kernel.org>,
        Aswath Govindraju <a-govindraju@ti.com>,
        Nishanth Menon <nm@ti.com>, lkft-triage@lists.linaro.org
Subject: Re: [PATCH 5.10 216/243] arm64: dts: ti: k3-j721e-common-proc-board:
 Use external clock for SERDES
Message-ID: <YPW8/AZQe4x6i9DY@sashalap>
References: <20210719144940.904087935@linuxfoundation.org>
 <20210719144947.891096868@linuxfoundation.org>
 <CA+G9fYt3-5vb_1rjdW3=4nASPGMe3gRrXzdCu10bSgR+Zeo-Hw@mail.gmail.com>
 <CA+G9fYvHj9w1ZYk7UCCh2raCybeb0QeFFic-cuCgj8s_Ffwtbw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <CA+G9fYvHj9w1ZYk7UCCh2raCybeb0QeFFic-cuCgj8s_Ffwtbw@mail.gmail.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Jul 19, 2021 at 10:59:14PM +0530, Naresh Kamboju wrote:
>On Mon, 19 Jul 2021 at 22:01, Naresh Kamboju <naresh.kamboju@linaro.org> wrote:
>>
>> On Mon, 19 Jul 2021 at 21:42, Greg Kroah-Hartman
>> <gregkh@linuxfoundation.org> wrote:
>> >
>> > From: Kishon Vijay Abraham I <kishon@ti.com>
>> >
>> > [ Upstream commit f2a7657ad7a821de9cc77d071a5587b243144cd5 ]
>> >
>> > Use external clock for all the SERDES used by PCIe controller. This will
>> > make the same clock used by the local SERDES as well as the clock
>> > provided to the PCIe connector.
>> >
>> > Signed-off-by: Kishon Vijay Abraham I <kishon@ti.com>
>> > Reviewed-by: Aswath Govindraju <a-govindraju@ti.com>
>> > Signed-off-by: Nishanth Menon <nm@ti.com>
>> > Link: https://lore.kernel.org/r/20210603143427.28735-4-kishon@ti.com
>> > Signed-off-by: Sasha Levin <sashal@kernel.org>
>> > ---
>> >  .../dts/ti/k3-j721e-common-proc-board.dts     | 40 +++++++++++++++++++
>> >  1 file changed, 40 insertions(+)
>> >
>> > diff --git a/arch/arm64/boot/dts/ti/k3-j721e-common-proc-board.dts b/arch/arm64/boot/dts/ti/k3-j721e-common-proc-board.dts
>> > index 7cd31ac67f88..56a92f59c3a1 100644
>> > --- a/arch/arm64/boot/dts/ti/k3-j721e-common-proc-board.dts
>> > +++ b/arch/arm64/boot/dts/ti/k3-j721e-common-proc-board.dts
>> > @@ -9,6 +9,7 @@
>> >  #include <dt-bindings/gpio/gpio.h>
>> >  #include <dt-bindings/input/input.h>
>> >  #include <dt-bindings/net/ti-dp83867.h>
>> > +#include <dt-bindings/phy/phy-cadence.h>
>>
>> Following build errors noticed on arm64 architecture on 5.10 branch.
>
>also noticed on stable-rc 5.12.

Dropped from both, thanks!

-- 
Thanks,
Sasha
