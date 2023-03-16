Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7F3C36BD90C
	for <lists+stable@lfdr.de>; Thu, 16 Mar 2023 20:25:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230274AbjCPTZZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Mar 2023 15:25:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51714 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230255AbjCPTZY (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 16 Mar 2023 15:25:24 -0400
Received: from mail-io1-xd32.google.com (mail-io1-xd32.google.com [IPv6:2607:f8b0:4864:20::d32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3DB55AF68E
        for <stable@vger.kernel.org>; Thu, 16 Mar 2023 12:25:22 -0700 (PDT)
Received: by mail-io1-xd32.google.com with SMTP id o12so1282717iow.6
        for <stable@vger.kernel.org>; Thu, 16 Mar 2023 12:25:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112; t=1678994721;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=QO+PaSrCDUmhEeRGRCLwJJ6+iMUfs2kw6XORqJOF2FU=;
        b=tyyJB2rGfgTXdkY5uxPUUl6UJXFp2KjzHndbE7GxrqZKeayLn/2IXD7Wk1YXoupIWG
         TrHWD898fZDuj2WAP1y1RQEnynuoCotxkBF+3UtC5CWb3eJnDQvC+WRHPVUFa9Ltj1E7
         /xm595/Hxgof25hhAa9NMpCQqRJU2lEThj9anI/hGGm/W4dnfnZDe6fIQ9kGR50nPPGr
         Da4T8Jjq9ifCGRREKnPAlVfOcaglTzRJaKW1ZEJznUsY88wFmJV5JuXxulx0LzVqv4JT
         ofQLFJv2V8dfwkUdelAIvHMQ+BGz3Doobt7+fTQNps5Ik0aL911clHwSgXD5rsGlZn39
         hlQw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678994721;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=QO+PaSrCDUmhEeRGRCLwJJ6+iMUfs2kw6XORqJOF2FU=;
        b=he8bNsiLd8NeRySpl/FLvDPP8/pUO6OTLKeVN63RmIIZEL858885CRKlLyoal/HNio
         73RAd9gP0STPqVts711qOsKrzThgvysR0luS9HTZJvpSCBAe+/vG81cwV31CiWLetkfF
         lEVdXOs396ZARhN+fO7pG1Cpz4MSGWywVq4mkCm8gFs92c5ZKpO1KSCVj8zTqSmksDEY
         het3lI2BsC7WxgrfY4pwfefq1HbvPotjzqecsWPJFFYFVYgh9cgUkg8aLIQpxZlQCZlG
         CRfBl8IGoMpvgasyiLyhi8t4wvuIbLJGTXVl1FdM7ZvZId8eZ1fTG6jh2rojXO7PPaSE
         VExA==
X-Gm-Message-State: AO0yUKW/UY6ZOgvDPP0QbWz1QMtgvy2FahEDEZkRAqtBviJRimZelnJV
        /0nEK/TKpoB3BXmOKl6AJIQw2A==
X-Google-Smtp-Source: AK7set8Fk3p1ZOQ7IU2K/KIsEubzYn7lQGwI7Tgn2VaTpDxrPEljVCjZCSjE1DXclHvS/ubKYnlCaQ==
X-Received: by 2002:a5e:c204:0:b0:740:7d21:d96f with SMTP id v4-20020a5ec204000000b007407d21d96fmr2022484iop.1.1678994721545;
        Thu, 16 Mar 2023 12:25:21 -0700 (PDT)
Received: from [192.168.1.94] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id p5-20020a02b005000000b004063510ba0esm23563jah.142.2023.03.16.12.25.20
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 16 Mar 2023 12:25:20 -0700 (PDT)
Message-ID: <ef445202-400b-ec2e-727a-306d5fd9350d@kernel.dk>
Date:   Thu, 16 Mar 2023 13:25:19 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
Subject: Re: [PATCH 5.10/5.15] io_uring: avoid null-ptr-deref in
 io_arm_poll_handler
Content-Language: en-US
To:     Fedor Pchelkin <pchelkin@ispras.ru>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     stable@vger.kernel.org, linux-kernel@vger.kernel.org,
        Alexey Khoroshilov <khoroshilov@ispras.ru>,
        lvc-project@linuxtesting.org
References: <20230316185616.271024-1-pchelkin@ispras.ru>
 <ZBNoOE0tMiJZd6r8@kroah.com> <20230316192259.ec46rcfw52ubqxrp@fpc>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <20230316192259.ec46rcfw52ubqxrp@fpc>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 3/16/23 1:22 PM, Fedor Pchelkin wrote:
> On Thu, Mar 16, 2023 at 08:04:24PM +0100, Greg Kroah-Hartman wrote:
>>
>> How can you trigger a GFP_ATOMIC memory failure?  If you do, worse
>> things are about to happen to your system, right?
>>
>> thanks,
>>
>> greg k-h
> 
> Well, Syzkaller triggers them with fail slab, and that is more for
> debugging purposes to detect improper handling of error paths.
> 
> I agree that if GFP_ATOMIC memory allocation fails then the system is in
> more trouble. Do you mean this is the point not to backport it? Now I'm
> actually not quite sure about this... It's not clear to me whether such
> things should be backported: on one hand, it is a bug which can actually
> occur (yes, in very bad situation), on the other - the whole system is not
> good anyway.

I agree with both of you - the likelihood of this happening outside of
synthetic error injection is very small, and if it does, the system has
probably gone to shit anyway.

On the other hand, this does bring the code in line with what upstream
is doing, and I think it's worth adding for that reason alone.

-- 
Jens Axboe


