Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 326214C1911
	for <lists+stable@lfdr.de>; Wed, 23 Feb 2022 17:52:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237711AbiBWQxX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 23 Feb 2022 11:53:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38616 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231601AbiBWQxX (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 23 Feb 2022 11:53:23 -0500
Received: from phobos.denx.de (phobos.denx.de [IPv6:2a01:238:438b:c500:173d:9f52:ddab:ee01])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AF62913D29
        for <stable@vger.kernel.org>; Wed, 23 Feb 2022 08:52:54 -0800 (PST)
Received: from [127.0.0.1] (p578adb1c.dip0.t-ipconnect.de [87.138.219.28])
        (using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: marex@denx.de)
        by phobos.denx.de (Postfix) with ESMTPSA id 5D39B83CA0;
        Wed, 23 Feb 2022 17:52:52 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=denx.de;
        s=phobos-20191101; t=1645635172;
        bh=cRIgNh9h8o+UmyeNDtBUfbZCSnTjMdwKAWQ0BzoO9Fc=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=ubHtlYPL9rWe7Fls33JL6w4o0vwn5dJ3tgbEkM/FF3qrDjFRBVvidv+LZnzg2tECo
         SqK2E08urWFHXXhBYYtEtwEIxMO3vS7ZnVZ4kEOVN95HIH+r9U6AJnYYiA/iElQh6y
         anaa8S5kZOFI+dXGxz3817QyGtX91pqwIZ9AVlSWp5KW+myyyFgCwwqsA8nBcixm2r
         QKs0wp08HhTjbOeYuFxqkpIn2HTVUpPfjtq9cKk3qy5PejntWbKKNe9eVXIs+Y8Th+
         0vz07RNv1RgiL+XxC3oGU8wS53GPGTpH4I4MvCv+eaxmQnPyXv7+mq2cH9Y5WgkGxs
         KLDwp0WeWkehg==
Message-ID: <ee74ed25-cd10-1047-9700-7546c7ee7052@denx.de>
Date:   Wed, 23 Feb 2022 17:52:51 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.6.0
Subject: Re: [PATCH] ASoC: ops: Shift tested values in snd_soc_put_volsw() by
 +min
Content-Language: en-US
To:     Mark Brown <broonie@kernel.org>, Takashi Iwai <tiwai@suse.de>
Cc:     alsa-devel@alsa-project.org, stable@vger.kernel.org,
        Alexandre TORGUE <alexandre.torgue@st.com>
References: <20220215130645.164025-1-marex@denx.de>
 <s5hy221y6md.wl-tiwai@suse.de> <YhZhkz6gQYsK3Fwd@sirena.org.uk>
From:   Marek Vasut <marex@denx.de>
In-Reply-To: <YhZhkz6gQYsK3Fwd@sirena.org.uk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Virus-Scanned: clamav-milter 0.103.5 at phobos.denx.de
X-Virus-Status: Clean
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 2/23/22 17:32, Mark Brown wrote:
> On Wed, Feb 23, 2022 at 03:55:54PM +0100, Takashi Iwai wrote:
>>
>> But, more reading the code, I suspect whether the function does work
>> correctly at all...  How is the mask calculation done in that way?
>>    unsigned int mask = (1U << (fls(min + max) - 1)) - 1;
>> What's the difference of this function with snd_soc_put_volsw()?
> 
> Yeah, I'm not clear either - Marek mentioned _SX when he was doing the
> patch but I didn't get the bandwidth to figure out what it's doing
> properly yet.  At this point I'm not clear what _SX is supposed to do,
> I'm hoping it works well for the devices that use it but I don't have
> any of them.

Right, I wasn't sure about the remaining two -- volsw_sx and xr_sx -- 
that's why I only did this one I could at least test.

But CS42L51 is on STM32MP1 DKx devkit, CCing Alex , ST might be able to 
look at that one and test.

>> Furthermore, the mask calculation and usage in snd_soc_put_volsw()
>> isn't right, either, I'm afraid; if the range is [-10, 0], max=0, then
>> mask will 0, which will omit all values...
> 
> Indeed, if anyone did that.  Fortunately I don't *think* that's an
> issue.  The whole way that code handles signed bitfields by remapping
> them into unsigned user visible controls is a landmine, it's not even
> obvious that they handle signed bitfields in the first place.

[...]
