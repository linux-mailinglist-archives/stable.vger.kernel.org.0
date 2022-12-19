Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ED246650C21
	for <lists+stable@lfdr.de>; Mon, 19 Dec 2022 13:48:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231896AbiLSMs4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Dec 2022 07:48:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55544 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230283AbiLSMsz (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 19 Dec 2022 07:48:55 -0500
Received: from fanzine2.igalia.com (fanzine2.igalia.com [213.97.179.56])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 98AFBE089;
        Mon, 19 Dec 2022 04:48:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=igalia.com;
        s=20170329; h=Content-Transfer-Encoding:Content-Type:In-Reply-To:From:
        References:Cc:To:Subject:MIME-Version:Date:Message-ID:Sender:Reply-To:
        Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
        Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
        List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=qb34MAU0ZEKzBpLKg0adOlW9E7RFwMB3/UYEgFSDOn8=; b=UqSA0EsQxeAV6MF38ZT2DQ+DK4
        cfZeCzYx+t3G1PSUTVKnC3o8nb1EdyExg17toHM9oEsBzv5FddcNlG1xC+038DT7GhQfdwyVmCNy6
        VfKUGD3oWOr3eGMTwWfqreS21NDDbnyaQuDFAvhqHKcs36uAfbslJckOQJVtCTdj5sQuF1WQWu/R0
        byufzpfTk0x/oIcUNNcaT7jtDQoQloqZEpLM//hPhjs8QTbylSggKdLP7T3PeRfm1umGjz1afgLky
        1l6HRRDIFY7zsN2JKmjOuUZ+OBsRFjK6KhUR+JJ2VMzY+bi1oMbeY4ugiW1pgEhMrJtBJWcBhF/vx
        SoOflzuQ==;
Received: from 200-158-226-94.dsl.telesp.net.br ([200.158.226.94] helo=[192.168.1.60])
        by fanzine2.igalia.com with esmtpsa 
        (Cipher TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_128_GCM:128) (Exim)
        id 1p7FZI-006Ikw-6P; Mon, 19 Dec 2022 13:48:32 +0100
Message-ID: <3ff9f56c-479b-2dbd-9ee6-c7d00c7bd285@igalia.com>
Date:   Mon, 19 Dec 2022 09:48:18 -0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.0
Subject: Re: [PATCH 6.0.y / 6.1.y] x86/split_lock: Add sysctl to control the
 misery mode
To:     Peter Zijlstra <peterz@infradead.org>, Greg KH <greg@kroah.com>
Cc:     stable@vger.kernel.org, x86@kernel.org,
        linux-kernel@vger.kernel.org, corbet@lwn.net,
        kernel-dev@igalia.com, kernel@gpiccoli.net, fenghua.yu@intel.com,
        joshua@froggi.es, pgofman@codeweavers.com, pavel@denx.de,
        pgriffais@valvesoftware.com, zfigura@codeweavers.com,
        cristian.ciocaltea@collabora.com,
        Thomas Gleixner <tglx@linutronix.de>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Tony Luck <tony.luck@intel.com>,
        Andre Almeida <andrealmeid@igalia.com>
References: <20221218234400.795055-1-gpiccoli@igalia.com>
 <Y6A6Q57/qz7w7cxM@kroah.com>
 <Y6BD9W7hk4CjhSdh@hirez.programming.kicks-ass.net>
Content-Language: en-US
From:   "Guilherme G. Piccoli" <gpiccoli@igalia.com>
In-Reply-To: <Y6BD9W7hk4CjhSdh@hirez.programming.kicks-ass.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 19/12/2022 07:59, Peter Zijlstra wrote:
> On Mon, Dec 19, 2022 at 11:17:39AM +0100, Greg KH wrote:
> 
>> What specific programs have this problem and what are the exact results
>> of it?
> 
> IIRC it was God of War (2018) that triggered this initially. But it's
> possible more games were found to tickle this specific thing. Since it's
> binary only gunk that is unlikely to ever get fixed we need something to
> allow for it.
> 
> (slow motion Kratos yelling B...o...y...)
> 
>> Also, this is really a new feature and not really a "fix", but one could
>> argue a lot that this is a "resolve a performance problem" if you want
>> to and have the numbers to back it up  {hint}
> 
> Right, there were some, they should indeed have been included.

Thanks Peter, that's exactly it - the current report is linked on commit
message.

About performance numbers, the only "numbers" I have is: game is
unplayable, according to the report "When I launch God of War through
Steam or Lutris I get around 25 fps, on lowest settings and at 10%
resolution scaling", FPS for for games is double of that usually.

I understand this is not a regular fix in which something is completely
broken, but it does fix a behavior introduced on kernel that prevent
some userspace binaries to properly run, in practice. Ofc some will
argue that we already have the kernel parameter, but it's different -
requires reboot and bootloader understanding.

If 6.0.y is too much, I'd ask we have it at least for 6.1, which is
long-term, that will help a lot of people for sure.
Thanks,


Guilherme
