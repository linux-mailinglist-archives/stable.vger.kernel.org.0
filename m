Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ED18965DDA5
	for <lists+stable@lfdr.de>; Wed,  4 Jan 2023 21:24:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235397AbjADUY3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 Jan 2023 15:24:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39698 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239818AbjADUY2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 4 Jan 2023 15:24:28 -0500
Received: from mail-il1-x133.google.com (mail-il1-x133.google.com [IPv6:2607:f8b0:4864:20::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7CB4033D78
        for <stable@vger.kernel.org>; Wed,  4 Jan 2023 12:24:26 -0800 (PST)
Received: by mail-il1-x133.google.com with SMTP id o13so20056434ilc.7
        for <stable@vger.kernel.org>; Wed, 04 Jan 2023 12:24:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=JDUv0ehipiNpUZwAXBSE1kfsXw89mo0OLpQneB/m1FA=;
        b=Nc2IJL0p5ZD7pmp0ZcYr0kHHDOiNckSWgXTTwpBKek2b5TDvr/viZv96KlxOyiYwO4
         o2bnfScykAJU4zx5lDBzkf5+EtXvkrV36yjfkDDPssYbma1ceGPMkQrNo9CIxtsJXGAZ
         5pICXexxeoMgSUaef2uqV80C7E8ECjz69nBm549CY++VYxu01LYZfolZFRXZQNMyOaUE
         aKAIETtg+7mx+PpBCAQzgaaSEpY2nj6HVCu1dtJH4zXtUv0k1f4HUkog80oMOw9cMtVA
         f2tA7k5ewxKQSKbjZWMyuq1hH9eJY7zOu3duxkyAQPi23E1WBzHhR8279bIcGe84prNY
         Pqfg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=JDUv0ehipiNpUZwAXBSE1kfsXw89mo0OLpQneB/m1FA=;
        b=5kJLuAc+1Ftyd/PfLeVhsb1HsccPuNTFX/HqJe9Ovf7KeYMC06DGYCV9LW4V2DPuFg
         ySXxNlLcdZNkzwug59D0F1dJ5ujFhgjG75EyLWIyvp/bRkjgoUceu4kZuXWGlO7ofgvd
         fIDimIy7p4MIXKBh0pJLSOUOBPQx+b2ERLuXLbcdmHiwc9VGlLmAikVV2sXVDCJi0dXg
         eq81D/bgDfbDTkA89eTegLDZz2aqCjl7dnLhmYdhs7Z/Gw8VWq309QNeuuyIzpz48ll8
         OvyKwnn5Bk/J4b7zj6tQvgtV6IBWtMQYZIYIcZz+mdIDf361zClo3pRF34Z/+1bB48/7
         JiKw==
X-Gm-Message-State: AFqh2kose6yf+52/pPxqgPtCkHkJyF/OFAuAixXADldSTfSyYid2HJW7
        pbqVbGp51Y8xHIAq8ZZ6fDT7bg==
X-Google-Smtp-Source: AMrXdXscJ2EwBb8tL25NJFMazXNbN/OjVtgdzyrAti+SDyKzy+v4rQpUPr4IypyjNOumu8prjgA1Jg==
X-Received: by 2002:a05:6e02:d0d:b0:303:d8:f309 with SMTP id g13-20020a056e020d0d00b0030300d8f309mr6102637ilj.2.1672863865800;
        Wed, 04 Jan 2023 12:24:25 -0800 (PST)
Received: from [192.168.1.94] ([207.135.234.126])
        by smtp.gmail.com with ESMTPSA id d15-20020a02604f000000b0038ab4a09610sm10762266jaf.112.2023.01.04.12.24.24
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 04 Jan 2023 12:24:25 -0800 (PST)
Message-ID: <e2fbce81-3b2c-72ff-c7e5-07d2e7e69bc6@kernel.dk>
Date:   Wed, 4 Jan 2023 13:24:24 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.0
Subject: Re: [PATCH 2/2] block: don't allow splitting of a REQ_NOWAIT bio
To:     Keith Busch <kbusch@kernel.org>
Cc:     linux-block@vger.kernel.org, mikelley@microsoft.com,
        stable@vger.kernel.org
References: <20230104160938.62636-1-axboe@kernel.dk>
 <20230104160938.62636-3-axboe@kernel.dk>
 <Y7XP5w9cTyHJHwta@kbusch-mbp.dhcp.thefacebook.com>
Content-Language: en-US
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <Y7XP5w9cTyHJHwta@kbusch-mbp.dhcp.thefacebook.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 1/4/23 12:13?PM, Keith Busch wrote:
> On Wed, Jan 04, 2023 at 09:09:38AM -0700, Jens Axboe wrote:
>> If we split a bio marked with REQ_NOWAIT, then we can trigger spurious
>> EAGAIN if constituent parts of that split bio end up failing request
>> allocations. Parts will complete just fine, but just a single failure
>> in one of the chained bios will yield an EAGAIN final result for the
>> parent bio.
>>
>> Return EAGAIN early if we end up needing to split such a bio, which
>> allows for saner recovery handling.
> 
> We're losing some performance here for large-ish single depth IO with
> nvme. We can get a little back by forcing to use the async worker
> earlier in the dispatch instead of getting all the way to the bio
> splitting, but the overhead to check for the condition (which is
> arbitrary decision anyway since we don't know the queue limits at
> io_uring prep time) mostly negates the gain.

Yes, it's not perfect - for perfection, we'd need to be able to either
arbitrarily retry parts of the split bio if we can't get a tag. Or
reserve tags for this request when doing the splits. Either one of those
would require extensive surgery to achieve. In my testing, the cost is
low enough that I think we can live with this for now.

> It's probably fine, though, since you can still hit peak b/w with just a
> little higher qdepth. This patch is a simple way to handle the problem,
> so looks good to me.
> 
> Reviewed-by: Keith Busch <kbusch@kernel.org>

Thanks!

-- 
Jens Axboe

