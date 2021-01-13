Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 93E262F40BB
	for <lists+stable@lfdr.de>; Wed, 13 Jan 2021 01:57:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392258AbhAMAnF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 Jan 2021 19:43:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54660 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2392391AbhAMAcY (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 12 Jan 2021 19:32:24 -0500
Received: from mail-pj1-x1032.google.com (mail-pj1-x1032.google.com [IPv6:2607:f8b0:4864:20::1032])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 08A3EC061575
        for <stable@vger.kernel.org>; Tue, 12 Jan 2021 16:31:44 -0800 (PST)
Received: by mail-pj1-x1032.google.com with SMTP id cq1so46581pjb.4
        for <stable@vger.kernel.org>; Tue, 12 Jan 2021 16:31:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=amacapital-net.20150623.gappssmtp.com; s=20150623;
        h=content-transfer-encoding:from:mime-version:subject:date:message-id
         :references:cc:in-reply-to:to;
        bh=ExLznwThawuTbJyTIm5Arp9VEpqF0RS06oUV/Yikwmk=;
        b=H5KRgSNPwE1C8dCIrYHz4KtK0VDnitGlIiJ5wkmflzfdAWNYBWrjI+x0lE0zO2SNoA
         FXlp6wgVDUsVJQRm3vvVn3Shs9HVLKgdwJNlBF0dNbKnzo1+BuCvl34LTSL9ZzmiYsLl
         F3nQJXVhKj5lG+Mgv+zKysbXn4t4oRHQJFQRKgfVQlrxlI8XN575A4gBpNiAoD6I9NQP
         5tewyt0Jmput92WVXpSlMwal47KHRr8phA5wL8rRRZ5VGLR0kaOlkMchU5uxhGxd70q5
         6Pk6WBhRao7xFx9VDFX+btxBzDOb75c7fyf1OiD4On7J7qPFe6GGhrvWZeFHO4zWw9se
         IzNQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:content-transfer-encoding:from:mime-version
         :subject:date:message-id:references:cc:in-reply-to:to;
        bh=ExLznwThawuTbJyTIm5Arp9VEpqF0RS06oUV/Yikwmk=;
        b=XU8eg4xXwI1VlOeOI57HoL1XIY53IeyEwU/8+iGvtcm1eca4XZwyikL/HmYUgt/c62
         qY/vYoyqhmPSGBJBI4Fw1OmYfi+9OwB3AlZDGEcYxuDkFVcqrSRSQhjIuHsLdvDqx0CR
         EV+8SxOZ7KcFNAJLnGbhIQQwUGqjB09JuFrpTS2VCAlQh8ZmR/0EVXg0dGmxoPYx4cFJ
         5S1AWvVfvqScND35VawVgcQyEtA1jUQnzScgqZKbOI/wa0X6VqTMDc2/tK7/t1MVm3Sb
         3TUAcIMEhCCCKmntZ5fZUi0zCsiChh96hNQLAY4JNsC7NlLOs1imd1UK8m96W2ObvHq9
         tfaQ==
X-Gm-Message-State: AOAM532XjANJUuT1wKDWIwp80g/aQ+4xr0xI2UWl4YZYoPQPM+omwfEN
        EIk60sUViLCTJboK3844IxW2Hg==
X-Google-Smtp-Source: ABdhPJxKjI1QJE3Zr82VBGjhwlRDU5OYeWqJ0iNY8jIT5kAoV1QMdVIdo6Opm2h/41rbYVBjjab6Sw==
X-Received: by 2002:a17:90a:5405:: with SMTP id z5mr306369pjh.13.1610497903418;
        Tue, 12 Jan 2021 16:31:43 -0800 (PST)
Received: from ?IPv6:2600:1010:b015:9bd0:bda1:66ef:aea3:7e99? ([2600:1010:b015:9bd0:bda1:66ef:aea3:7e99])
        by smtp.gmail.com with ESMTPSA id 73sm152935pga.26.2021.01.12.16.31.42
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 12 Jan 2021 16:31:42 -0800 (PST)
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
From:   Andy Lutomirski <luto@amacapital.net>
Mime-Version: 1.0 (1.0)
Subject: Re: [PATCH] mm/userfaultfd: fix memory corruption due to writeprotect
Date:   Tue, 12 Jan 2021 16:31:41 -0800
Message-Id: <68095DFB-7D72-480E-BDF3-3C88B8428867@amacapital.net>
References: <F33D2DD9-97D5-44A0-890B-35FE686E36DC@gmail.com>
Cc:     Will Deacon <will@kernel.org>, Yu Zhao <yuzhao@google.com>,
        Laurent Dufour <ldufour@linux.vnet.ibm.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Vinayak Menon <vinmenon@codeaurora.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andy Lutomirski <luto@kernel.org>,
        Peter Xu <peterx@redhat.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        linux-mm <linux-mm@kvack.org>,
        lkml <linux-kernel@vger.kernel.org>,
        Pavel Emelyanov <xemul@openvz.org>,
        Mike Kravetz <mike.kravetz@oracle.com>,
        Mike Rapoport <rppt@linux.vnet.ibm.com>,
        stable <stable@vger.kernel.org>,
        Minchan Kim <minchan@kernel.org>, surenb@google.com
In-Reply-To: <F33D2DD9-97D5-44A0-890B-35FE686E36DC@gmail.com>
To:     Nadav Amit <nadav.amit@gmail.com>
X-Mailer: iPhone Mail (18C66)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



> On Jan 12, 2021, at 2:29 PM, Nadav Amit <nadav.amit@gmail.com> wrote:
>=20
> =EF=BB=BF
>>=20
>> On Jan 12, 2021, at 1:43 PM, Will Deacon <will@kernel.org> wrote:
>>=20
>> On Tue, Jan 12, 2021 at 12:38:34PM -0800, Nadav Amit wrote:
>>>> On Jan 12, 2021, at 11:56 AM, Yu Zhao <yuzhao@google.com> wrote:
>>>>> On Tue, Jan 12, 2021 at 11:15:43AM -0800, Nadav Amit wrote:
>>>>>> I will send an RFC soon for per-table deferred TLB flushes tracking.
>>>>>> The basic idea is to save a generation in the page-struct that tracks=

>>>>>> when deferred PTE change took place, and track whenever a TLB flush
>>>>>> completed. In addition, other users - such as mprotect - would use
>>>>>> the tlb_gather interface.
>>>>>>=20
>>>>>> Unfortunately, due to limited space in page-struct this would only
>>>>>> be possible for 64-bit (and my implementation is only for x86-64).
>>>>>=20
>>>>> I don't want to discourage you but I don't think this would end up
>>>>> well. PPC doesn't necessarily follow one-page-struct-per-table rule,
>>>>> and I've run into problems with this before while trying to do
>>>>> something similar.
>>>=20
>>> Discourage, discourage. Better now than later.
>>>=20
>>> It will be relatively easy to extend the scheme to be per-VMA instead of=

>>> per-table for architectures that prefer it this way. It does require
>>> TLB-generation tracking though, which Andy only implemented for x86, so I=

>>> will focus on x86-64 right now.
>>=20
>> Can you remind me of what we're missing on arm64 in this area, please? I'=
m
>> happy to help get this up and running once you have something I can build=

>> on.
>=20
> Let me first finish making something that we can use as a basis for a
> discussion. I do not waste your time before I have something ready.

If you want a hand, let me know.  I suspect you understand the x86 code as w=
ell as I do at this point, though :)


