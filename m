Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3B550CC3FF
	for <lists+stable@lfdr.de>; Fri,  4 Oct 2019 22:11:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731402AbfJDULi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 4 Oct 2019 16:11:38 -0400
Received: from mx1.redhat.com ([209.132.183.28]:51306 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731140AbfJDULi (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 4 Oct 2019 16:11:38 -0400
Received: from mail-io1-f69.google.com (mail-io1-f69.google.com [209.85.166.69])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 85CF22CD7E5
        for <stable@vger.kernel.org>; Fri,  4 Oct 2019 20:11:37 +0000 (UTC)
Received: by mail-io1-f69.google.com with SMTP id g15so14029435ioc.0
        for <stable@vger.kernel.org>; Fri, 04 Oct 2019 13:11:37 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:subject:message-id:reply-to
         :mail-followup-to:references:mime-version:content-disposition
         :in-reply-to:user-agent;
        bh=oefRLRHPUFRhefeZoPfYtoKI/frpILJv/HMoF+sATsw=;
        b=ie0zPkb/+sGbkBUhvx4XjaDZopLQLqQcEwfk8sporMUB4igN2BgN9zxmkHZesHGzAs
         gFGUXXYAVbPaWKt61Z9zeLV+D+XDt+OECjJy5VQeTxR3i5Dn/lPl5qajs7m7P6bDhbnL
         M2gzpGdvKXqR6gKe92RzQhqSfrdCg4BJ/pRdZh/MkT1C/AeBJCONGwEHOS0mVwr/eSfJ
         unalDYMUIWkbEtOBdkFjsTce9zlGvM+I25zhQPgSIgRR0jg/To/A6j5pluGVSMeQ+JdL
         W04ZD3kpuniw+MvuPcFOxnqShtzsnIUrmqYGHrF3r5+N8RYbw2Lu+UqxMkdrAleXV/kW
         gQEA==
X-Gm-Message-State: APjAAAUU2JuSyku0KlrocDV6oujL+ot2fyELzw6CXZ5aQCkJupv4GpJR
        T7JCgXT44U9bH0tzyknZ6aJSdQF4v/YYusAZhCLJeEAPXREQSqLbE4bIr6RCrGfeHfS7+iRAT+l
        fZFy9yOPQ0nup7ynf
X-Received: by 2002:a92:3bca:: with SMTP id n71mr18292787ilh.104.1570219896771;
        Fri, 04 Oct 2019 13:11:36 -0700 (PDT)
X-Google-Smtp-Source: APXvYqy1qh//E7zUDQGLacjK8MB0QFfBwC6v81r/DwCPI28EUzHD5yO7QqL9crRHlqdxwAyYXmoNPg==
X-Received: by 2002:a92:3bca:: with SMTP id n71mr18292760ilh.104.1570219896550;
        Fri, 04 Oct 2019 13:11:36 -0700 (PDT)
Received: from localhost (ip70-163-223-149.ph.ph.cox.net. [70.163.223.149])
        by smtp.gmail.com with ESMTPSA id f12sm2530228iob.58.2019.10.04.13.11.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 04 Oct 2019 13:11:35 -0700 (PDT)
Date:   Fri, 4 Oct 2019 13:11:34 -0700
From:   Jerry Snitselaar <jsnitsel@redhat.com>
To:     James Bottomley <James.Bottomley@HansenPartnership.com>,
        Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>,
        Mimi Zohar <zohar@linux.ibm.com>,
        David Safford <david.safford@ge.com>,
        linux-integrity@vger.kernel.org, stable@vger.kernel.org,
        David Howells <dhowells@redhat.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        "open list:ASYMMETRIC KEYS" <keyrings@vger.kernel.org>,
        "open list:CRYPTO API" <linux-crypto@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] KEYS: asym_tpm: Switch to get_random_bytes()
Message-ID: <20191004201134.nuesk6hxtxajnxh2@cantor>
Reply-To: Jerry Snitselaar <jsnitsel@redhat.com>
Mail-Followup-To: James Bottomley <James.Bottomley@HansenPartnership.com>,
        Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>,
        Mimi Zohar <zohar@linux.ibm.com>,
        David Safford <david.safford@ge.com>,
        linux-integrity@vger.kernel.org, stable@vger.kernel.org,
        David Howells <dhowells@redhat.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        "open list:ASYMMETRIC KEYS" <keyrings@vger.kernel.org>,
        "open list:CRYPTO API" <linux-crypto@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
References: <1570128827.5046.19.camel@linux.ibm.com>
 <20191003215125.GA30511@linux.intel.com>
 <20191003215743.GB30511@linux.intel.com>
 <1570140491.5046.33.camel@linux.ibm.com>
 <1570147177.10818.11.camel@HansenPartnership.com>
 <20191004182216.GB6945@linux.intel.com>
 <1570213491.3563.27.camel@HansenPartnership.com>
 <20191004183342.y63qdvspojyf3m55@cantor>
 <1570214574.3563.32.camel@HansenPartnership.com>
 <20191004200728.xoj6jlgbhv57gepc@cantor>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20191004200728.xoj6jlgbhv57gepc@cantor>
User-Agent: NeoMutt/20180716
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri Oct 04 19, Jerry Snitselaar wrote:
>On Fri Oct 04 19, James Bottomley wrote:
>>On Fri, 2019-10-04 at 11:33 -0700, Jerry Snitselaar wrote:
>>>On Fri Oct 04 19, James Bottomley wrote:
>>>> On Fri, 2019-10-04 at 21:22 +0300, Jarkko Sakkinen wrote:
>>>> > On Thu, Oct 03, 2019 at 04:59:37PM -0700, James Bottomley wrote:
>>>> > > I think the principle of using multiple RNG sources for strong
>>>> > > keys is a sound one, so could I propose a compromise:  We have
>>>> > > a tpm subsystem random number generator that, when asked for
>>>> > > <n> random bytes first extracts <n> bytes from the TPM RNG and
>>>> > > places it into the kernel entropy pool and then asks for <n>
>>>> > > random bytes from the kernel RNG? That way, it will always have
>>>> > > the entropy to satisfy the request and in the worst case, where
>>>> > > the kernel has picked up no other entropy sources at all it
>>>> > > will be equivalent to what we have now (single entropy source)
>>>> > > but usually it will be a much better mixed entropy source.
>>>> >
>>>> > I think we should rely the existing architecture where TPM is
>>>> > contributing to the entropy pool as hwrng.
>>>>
>>>> That doesn't seem to work: when I trace what happens I see us
>>>> inject 32 bytes of entropy at boot time, but never again.  I think
>>>> the problem is the kernel entropy pool is push not pull and we have
>>>> no triggering event in the TPM to get us to push.  I suppose we
>>>> could set a timer to do this or perhaps there is a pull hook and we
>>>> haven't wired it up correctly?
>>>>
>>>> James
>>>>
>>>
>>>Shouldn't hwrng_fillfn be pulling from it?
>>
>>It should, but the problem seems to be it only polls the "current" hw
>>rng ... it doesn't seem to have a concept that there may be more than
>>one.  What happens, according to a brief reading of the code, is when
>>multiple are registered, it determines what the "best" one is and then
>>only pulls from that.  What I think it should be doing is filling from
>>all of them using the entropy quality to adjust how many bits we get.
>>
>>James
>>
>
>Most of them don't even set quality, including the tpm, so they end up
>at the end of the list. For the ones that do I'm not sure how they determined
>the value. For example virtio-rng sets quality to 1000.

I should have added that I like that idea though.
