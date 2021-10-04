Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 64243421495
	for <lists+stable@lfdr.de>; Mon,  4 Oct 2021 18:57:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237855AbhJDQ7W (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 4 Oct 2021 12:59:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56776 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237561AbhJDQ7U (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 4 Oct 2021 12:59:20 -0400
Received: from mail-pf1-x434.google.com (mail-pf1-x434.google.com [IPv6:2607:f8b0:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9784EC061745;
        Mon,  4 Oct 2021 09:57:31 -0700 (PDT)
Received: by mail-pf1-x434.google.com with SMTP id s55so13983978pfw.4;
        Mon, 04 Oct 2021 09:57:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=HEf/I/hk3U5Zpvreh8jDOQt8rMtCGugDMTgqZTR6bsc=;
        b=KBTZl0ZBXlVWC9XlsrU/j2wITUAo0PIQZ4fM0JOwdglV7xjyheU43HwGaZyyFyAzSw
         qICRLCHkiXTZ6IU+EzC0XKuFb8BX0iB84jKtmMO9buOdUrU7Oz4FZCp9Twqh8Kc0VHxB
         Cvzhwhg4oDgo+bxJfipsf1PhypV4J1pOi7B/TbcAJ8encQBK71JtygnSLXIh1Iu8snwa
         YO+lR13hVX2EhTx7+qEBzr0OG9Fq/zS8wRv12sbKserX//H8cDi9HDZk/GW0SRK5/4u1
         C31Zlp8RhOGgbvdB2a5yjGzFKe4XLdShtWP7HLiEGbJ/jCJiDXkVwvzyXfiSL+vyMPQu
         LCAA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=HEf/I/hk3U5Zpvreh8jDOQt8rMtCGugDMTgqZTR6bsc=;
        b=OKy+LmtV/8EZC4uhjOxSXO1ZWjp1h6w9vodWTf9O1ebgO/LjwxqHTB/zBRC7YRNH23
         QF8/Cznh/Bfm9zMOEtVdxFxXERxohdMCXKJOUAx164LOlY74Gqm5kao9c+YgzjwHc1x+
         EDmmJ+KDqdGh/rUAOiWT2yMXtNRe480KFHnURn0APkF+XVZHhUUi6mAEG/j8Kiq4DiEU
         bUKgPmzgruaiLoB22j9CLXyw8aPK8OG8NGoedHwVNAdfyICKJRNLfF8G/N+rnsRbMaRM
         4x3n7DULWO9Quoir0sSUikhoVgUd6G/JRcrUdp8XCJLMPuRjg1Xk4b2wQ57nIJrYTDKe
         9ssQ==
X-Gm-Message-State: AOAM5335clmmA8gvgUoLrNyMrAiUNytuRo+xsrgvt8DwvI98CXPhihSl
        0bkedDZSg0kiPpsX9wW1eSDhdlr7fIQ=
X-Google-Smtp-Source: ABdhPJxXwVUsaeGBCQzqf8eS8c0cXt3lJpG5zqMzeMai5/73q4QPOURHKtVKoIpLjmlYleiZB/rdAQ==
X-Received: by 2002:a63:a03:: with SMTP id 3mr11839165pgk.326.1633366650702;
        Mon, 04 Oct 2021 09:57:30 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id w185sm12075224pfd.113.2021.10.04.09.57.19
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 04 Oct 2021 09:57:30 -0700 (PDT)
Subject: Re: [PATCH] spi: bcm2835: do not unregister controller in shutdown
 handler
To:     Mark Brown <broonie@kernel.org>
Cc:     Jason Gunthorpe <jgg@ziepe.ca>,
        Lino Sanfilippo <LinoSanfilippo@gmx.de>, rjui@broadcom.com,
        sbranden@broadcom.com, bcm-kernel-feedback-list@broadcom.com,
        nsaenz@kernel.org, linux-spi@vger.kernel.org,
        linux-rpi-kernel@lists.infradead.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        p.rosenberger@kunbus.com, linux-integrity@vger.kernel.org,
        stable@vger.kernel.org
References: <20210928195657.5573-1-LinoSanfilippo@gmx.de>
 <20211001175422.GA53652@sirena.org.uk>
 <2c4d7115-7a02-f79e-c91b-3c2dd54051b2@gmx.de>
 <YVr4USeiIoQJ0Pqh@sirena.org.uk> <20211004131756.GW3544071@ziepe.ca>
 <YVsLxHMCdXf4vS+i@sirena.org.uk> <20211004154436.GY3544071@ziepe.ca>
 <YVssWYaxuQDi8jI5@sirena.org.uk>
 <e68b04ab-831b-0ed5-074a-0879194569f9@gmail.com>
 <YVsxNiyZ3CuZTXqE@sirena.org.uk>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <72d8920c-ccf2-50bf-36fd-1585f3932fd6@gmail.com>
Date:   Mon, 4 Oct 2021 09:57:15 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <YVsxNiyZ3CuZTXqE@sirena.org.uk>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 10/4/21 9:52 AM, Mark Brown wrote:
> On Mon, Oct 04, 2021 at 09:36:37AM -0700, Florian Fainelli wrote:
>> On 10/4/21 9:31 AM, Mark Brown wrote:
> 
>>> an issue, someone could press a button or whatever.  Frankly for SPI the
>>> quiescing part doesn't seem like logic that should be implemented in
>>> drivers, it's a subsystem level thing since there's nothing driver
>>> specific about it.
> 
>> Surely the SPI subsystem can help avoid queuing new transfers towards
>> the SPI controller while the controller can shut down the resources that
>> only it knows about.
> 
> Yes, that's what I was saying.
> 
>>> In the case of this specific driver I'm still not clear that the best
>>> thing isn't just to delete the shutdown callback and let any ongoing
>>> transfers complete, though I guess there'd be issues in kexec cases with
>>> long enough tansfers.
> 
>> No please don't, I should have arguably justified the reasons why
>> better, but the main reason is that one of the platforms on which this
>> driver is used has received extensive power management analysis and
>> changes, and shutting down every bit of hardware, including something as
>> small as a SPI controller, and its clock (and its PLL) helped meet
>> stringent power targets.
> 
> OK, so it's similar to a lot of the other embedded cases where it's for
> a power down that doesn't cut as much power as would be desirable -
> that's reasonable.  Like you say you didn't mention it at all in the
> changelog.  Ideally the hardware would just cut all power to the SoC in
> shutdown but then IIRC those boards don't have a PMIC so...  

Yes, that's is what we do on other types of SoCs, this particular one
however only has a single power domain and so software must come to the
rescue to shut down as much as it can. Newer boards do have a PMIC that
can help us with that, but not with everything, still.

> 
>> TBH, I still wonder why we have .shutdown() and we simply don't use
>> .remove() which would reduce the amount of work that people have to do
>> validate that the hardware is put in a low power state and would also
>> reduce the amount of burden on the various subsystems.
> 
> Yeah, it does seem a bit odd - I'd figured it was for speed reasons.
> 


-- 
Florian
