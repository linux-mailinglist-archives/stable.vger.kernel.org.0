Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8C46650B9DB
	for <lists+stable@lfdr.de>; Fri, 22 Apr 2022 16:16:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345048AbiDVOTJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 22 Apr 2022 10:19:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37750 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1448289AbiDVOTH (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 22 Apr 2022 10:19:07 -0400
Received: from phobos.denx.de (phobos.denx.de [IPv6:2a01:238:438b:c500:173d:9f52:ddab:ee01])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EED715AA61
        for <stable@vger.kernel.org>; Fri, 22 Apr 2022 07:16:12 -0700 (PDT)
Received: from [127.0.0.1] (p578adb1c.dip0.t-ipconnect.de [87.138.219.28])
        (using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: marex@denx.de)
        by phobos.denx.de (Postfix) with ESMTPSA id 721B883C54;
        Fri, 22 Apr 2022 16:16:10 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=denx.de;
        s=phobos-20191101; t=1650636971;
        bh=Z1PyET0hKcBKj2LtxgxXYI+GUs7TLXXhbyejG8dwATk=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=RvWnWwW7+wdVioRynodq7vyNhBVseuEo0LyVTwUTZg0TrmlFop7/S9QZSarRSC3FA
         iFj7LhVA7golKOB73+wq3SImh/BxlHOYirW77LoovCOSsR6JExfisHOMLp8rcqk5Ys
         +29cky/f5Dzfo3IgvwsCUzdmZHEHBc0jhENLxfOW7zP0Hn6OeImAsPrxu8aqxAN+Tk
         EQGAqyW0eUmqGUOO+XrKQlBCFTrVij9l7/pGUEMjklIRChaH1JZpwP+uiR66YKB45n
         hrU0Pfr+dGmcHc02JFfoY9cyokQ/v0L0wCjR312qGaXVCCU9ad3EstKwcBs/yMEQ1b
         dSy/KrDRlqFjA==
Message-ID: <286ad443-4bc2-d548-9b84-114ee17824cc@denx.de>
Date:   Fri, 22 Apr 2022 16:16:09 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.0
Subject: Re: net: micrel: fix KS8851_MLL Kconfig -- missing dependency in
 5.10.112
Content-Language: en-US
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     linux-stable <stable@vger.kernel.org>,
        Randy Dunlap <rdunlap@infradead.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Sasha Levin <sashal@kernel.org>
References: <7f3dedb3-7d5d-dcf3-8d7f-631251173d33@denx.de>
 <YmK1QBMkfXkNG09F@kroah.com>
From:   Marek Vasut <marex@denx.de>
In-Reply-To: <YmK1QBMkfXkNG09F@kroah.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Virus-Scanned: clamav-milter 0.103.5 at phobos.denx.de
X-Virus-Status: Clean
X-Spam-Status: No, score=-5.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 4/22/22 16:01, Greg KH wrote:
> On Fri, Apr 22, 2022 at 12:20:31PM +0200, Marek Vasut wrote:
>> Since linux-stable 5.10.112 commit:
>>
>> 1ff5359afa5e ("net: micrel: fix KS8851_MLL Kconfig")
>>
>> it is not possible to select KS8851_MLL symbol.
>>
>> This is because the commit adds dependency on Kconfig symbol
>>
>> PTP_1588_CLOCK_OPTIONAL
>>
>> which was added in Linux upstream commit:
>>
>> e5f31552674e ("ethernet: fix PTP_1588_CLOCK dependencies")
>>
>> And the aforementioned commit is not part of stable 5.10.112.
> 
> Can you send a commit to revert this?

I can, but I have one question -- should this really be reverted or 
would it be better to pick the missing dependency, commit:

e5f31552674e ("ethernet: fix PTP_1588_CLOCK dependencies")

It seems the missing dependency is also a fix.
