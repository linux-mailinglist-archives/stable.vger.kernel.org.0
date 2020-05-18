Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4CA511D84C4
	for <lists+stable@lfdr.de>; Mon, 18 May 2020 20:14:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732976AbgERSOS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 May 2020 14:14:18 -0400
Received: from fllv0015.ext.ti.com ([198.47.19.141]:38994 "EHLO
        fllv0015.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732376AbgERSOR (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 18 May 2020 14:14:17 -0400
Received: from fllv0034.itg.ti.com ([10.64.40.246])
        by fllv0015.ext.ti.com (8.15.2/8.15.2) with ESMTP id 04IIE3BI085441;
        Mon, 18 May 2020 13:14:03 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1589825643;
        bh=krVs+kruRFwBMP7hMokQq0Nkw7/V8H8gRqCagZh3dMk=;
        h=Subject:To:CC:References:From:Date:In-Reply-To;
        b=OZFCYDYUsyAybe9//eGhtoCVs8IV8NXx3pd2a2vjw+kBWic6ilQCNWTYnzgjMrpzR
         /qCoSe1QECSHfETpYPE9xPzX+IKCxLLZ6UGOG2g2/3zFEJQr2FvocnyY22gOaUlL+g
         AFIYZrprgtGMkMNPf6RtaHZ+uCr9XYwZtCCuCFUU=
Received: from DFLE115.ent.ti.com (dfle115.ent.ti.com [10.64.6.36])
        by fllv0034.itg.ti.com (8.15.2/8.15.2) with ESMTPS id 04IIE2X3115908
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Mon, 18 May 2020 13:14:03 -0500
Received: from DFLE111.ent.ti.com (10.64.6.32) by DFLE115.ent.ti.com
 (10.64.6.36) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1979.3; Mon, 18
 May 2020 13:14:02 -0500
Received: from fllv0039.itg.ti.com (10.64.41.19) by DFLE111.ent.ti.com
 (10.64.6.32) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1979.3 via
 Frontend Transport; Mon, 18 May 2020 13:14:02 -0500
Received: from [10.250.100.73] (ileax41-snat.itg.ti.com [10.172.224.153])
        by fllv0039.itg.ti.com (8.15.2/8.15.2) with ESMTP id 04IIDx9N088498;
        Mon, 18 May 2020 13:14:00 -0500
Subject: Re: [PATCH 5.6 019/194] net: Make PTP-specific drivers depend on
 PTP_1588_CLOCK
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <linux-kernel@vger.kernel.org>
CC:     <stable@vger.kernel.org>, Arnd Bergmann <arnd@arndb.de>,
        Richard Cochran <richardcochran@gmail.com>,
        Nicolas Pitre <nico@fluxnic.net>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Clay McClure <clay@daemons.net>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
References: <20200518173531.455604187@linuxfoundation.org>
 <20200518173533.160651742@linuxfoundation.org>
From:   Grygorii Strashko <grygorii.strashko@ti.com>
Message-ID: <05fd5be4-a969-2b7f-52e4-754d9651a280@ti.com>
Date:   Mon, 18 May 2020 21:13:54 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <20200518173533.160651742@linuxfoundation.org>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Greg,

On 18/05/2020 20:35, Greg Kroah-Hartman wrote:
> From: Clay McClure <clay@daemons.net>
> 
> [ Upstream commit b6d49cab44b567b3e0a5544b3d61e516a7355fad ]
> 
> Commit d1cbfd771ce8 ("ptp_clock: Allow for it to be optional") changed
> all PTP-capable Ethernet drivers from `select PTP_1588_CLOCK` to `imply
> PTP_1588_CLOCK`, "in order to break the hard dependency between the PTP
> clock subsystem and ethernet drivers capable of being clock providers."
> As a result it is possible to build PTP-capable Ethernet drivers without
> the PTP subsystem by deselecting PTP_1588_CLOCK. Drivers are required to
> handle the missing dependency gracefully.
> 
> Some PTP-capable Ethernet drivers (e.g., TI_CPSW) factor their PTP code
> out into separate drivers (e.g., TI_CPTS_MOD). The above commit also
> changed these PTP-specific drivers to `imply PTP_1588_CLOCK`, making it
> possible to build them without the PTP subsystem. But as Grygorii
> Strashko noted in [1]:
> 
> On Wed, Apr 22, 2020 at 02:16:11PM +0300, Grygorii Strashko wrote:
> 
>> Another question is that CPTS completely nonfunctional in this case and
>> it was never expected that somebody will even try to use/run such
>> configuration (except for random build purposes).
> 
> In my view, enabling a PTP-specific driver without the PTP subsystem is
> a configuration error made possible by the above commit. Kconfig should
> not allow users to create a configuration with missing dependencies that
> results in "completely nonfunctional" drivers.
> 
> I audited all network drivers that call ptp_clock_register() but merely
> `imply PTP_1588_CLOCK` and found five PTP-specific drivers that are
> likely nonfunctional without PTP_1588_CLOCK:
> 
>      NET_DSA_MV88E6XXX_PTP
>      NET_DSA_SJA1105_PTP
>      MACB_USE_HWSTAMP
>      CAVIUM_PTP
>      TI_CPTS_MOD
> 
> Note how these symbols all reference PTP or timestamping in their name;
> this is a clue that they depend on PTP_1588_CLOCK.
> 
> Change them from `imply PTP_1588_CLOCK` [2] to `depends on PTP_1588_CLOCK`.
> I'm not using `select PTP_1588_CLOCK` here because PTP_1588_CLOCK has
> its own dependencies, which `select` would not transitively apply.
> 
> Additionally, remove the `select NET_PTP_CLASSIFY` from CPTS_TI_MOD;
> PTP_1588_CLOCK already selects that.
> 
> [1]: https://lore.kernel.org/lkml/c04458ed-29ee-1797-3a11-7f3f560553e6@ti.com/
> 
> [2]: NET_DSA_SJA1105_PTP had never declared any type of dependency on
> PTP_1588_CLOCK (`imply` or otherwise); adding a `depends on PTP_1588_CLOCK`
> here seems appropriate.
> 
> Cc: Arnd Bergmann <arnd@arndb.de>
> Cc: Richard Cochran <richardcochran@gmail.com>
> Cc: Nicolas Pitre <nico@fluxnic.net>
> Cc: Grygorii Strashko <grygorii.strashko@ti.com>
> Cc: Geert Uytterhoeven <geert@linux-m68k.org>
> Fixes: d1cbfd771ce8 ("ptp_clock: Allow for it to be optional")
> Signed-off-by: Clay McClure <clay@daemons.net>
> Signed-off-by: David S. Miller <davem@davemloft.net>
> Signed-off-by: Sasha Levin <sashal@kernel.org>
> ---

Could you drop this patch, pls?
it's not for stable and can cause build failures.

-- 
Best regards,
grygorii
