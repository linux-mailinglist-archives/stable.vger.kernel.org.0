Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 96FB46D6730
	for <lists+stable@lfdr.de>; Tue,  4 Apr 2023 17:24:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235320AbjDDPYK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 4 Apr 2023 11:24:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42520 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233767AbjDDPYJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 4 Apr 2023 11:24:09 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D60EF4491
        for <stable@vger.kernel.org>; Tue,  4 Apr 2023 08:24:08 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 72F0A635D2
        for <stable@vger.kernel.org>; Tue,  4 Apr 2023 15:24:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AD9AEC433D2;
        Tue,  4 Apr 2023 15:24:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1680621847;
        bh=bv9sygn2HLy3yHTqEOJi6mXpzfPPW8uG8OQ6tRdO7H0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=ldNhfu/p2517oQHIWGt8kWF9JUE1qGbm2quarSyLUVnB2KtTT9hICpYz17w++Gm5O
         H0jG3TXdJW3RzHIYYck5MZdT86LfQvz60cm1zu0toziI7AZ8rNW+1W4raQBc0+124X
         zKtZeCYCIbvZf5gImmYOHrEbnfRLkYTt32OMpKbJJWAVkTMq0s+sNGM4aNRhQNZYuT
         AD49RpOjZIoHwpJ4/vfWwIAKVWgLWVmhXawWhY1fbARXXr8S/z2qzW31MAI0NEtjDF
         xeaGc5ek4UwaqmWcw1qUn3U1U71PZwY+UDx1x0vp3E2RmoUOniZMwCOPLzPxNl6Gm6
         piX5s4xCjiz2g==
Date:   Tue, 4 Apr 2023 11:24:06 -0400
From:   Sasha Levin <sashal@kernel.org>
To:     Pavel Machek <pavel@denx.de>
Cc:     =?utf-8?B?QXLEsW7DpyDDnE5BTA==?= <arinc.unal@arinc9.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, patches@lists.linux.dev,
        Jakub Kicinski <kuba@kernel.org>
Subject: Re: [PATCH 5.10 051/173] net: dsa: mt7530: move setting ssc_delta to
 PHY_INTERFACE_MODE_TRGMII case
Message-ID: <ZCxBFgch4aN1GKqR@sashalap>
References: <20230403140414.174516815@linuxfoundation.org>
 <20230403140416.096716862@linuxfoundation.org>
 <ZCwJhAfrTIPorVTw@duo.ucw.cz>
 <f08afb70-2278-b6aa-7f48-e407b9af447c@arinc9.com>
 <ZCwNZEoySWUWoKpR@duo.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <ZCwNZEoySWUWoKpR@duo.ucw.cz>
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Apr 04, 2023 at 01:43:32PM +0200, Pavel Machek wrote:
>Hi!
>
>> > > [ Upstream commit 407b508bdd70b6848993843d96ed49ac4108fb52 ]
>> > >
>> > > Move setting the ssc_delta variable to under the PHY_INTERFACE_MODE_TRGMII
>> > > case as it's only needed when trgmii is used.
>> >
>> > This one is very wrong for 5.10. ssc_delta is unconditionally used
>> > below, and it will not use uninitialized variable.
>> >
>> > (In mainline, that code is protected by if (trgint), so it does not
>> > have this problem).
>>
>> This patch is not stable material in the first place. As a newbie I
>> incorrectly sent it to net tree instead of net-next. This patch can just be
>> ignored for 5.10, if that takes the least amount of effort for you folks.
>>
>> Sorry about that and thanks for pointing this out Pavel.
>
>I believe you did the right thing, but as it had Fixes header stable
>people picked it up.

Right. I'll drop it.

-- 
Thanks,
Sasha
