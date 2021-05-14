Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E6C16380F14
	for <lists+stable@lfdr.de>; Fri, 14 May 2021 19:36:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232313AbhENRhc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 14 May 2021 13:37:32 -0400
Received: from terminus.zytor.com ([198.137.202.136]:56311 "EHLO
        mail.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231849AbhENRhc (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 14 May 2021 13:37:32 -0400
Received: from tazenda.hos.anvin.org ([IPv6:2601:646:8602:8be0:7285:c2ff:fefb:fd4])
        (authenticated bits=0)
        by mail.zytor.com (8.16.1/8.15.2) with ESMTPSA id 14EHa2me3150421
        (version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NO);
        Fri, 14 May 2021 10:36:02 -0700
DKIM-Filter: OpenDKIM Filter v2.11.0 mail.zytor.com 14EHa2me3150421
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zytor.com;
        s=2021042801; t=1621013763;
        bh=sz5jkjvMgb5V+JAn9gd2Tb1fSB3vWOyxs+Bvq6ZrCvE=;
        h=Subject:To:Cc:References:From:Date:In-Reply-To:From;
        b=kTSrLr1+lF7XDQSL31hJsRtYDkJWw2YU6shJw0j9SaSDZIuUeFKMsgxBC5jC1cYId
         y6IdnDXkuVnhmgqWYWtFNMMJv94s6ZzUd1y4zIenuOh2d0AOz0OgtachRtwJXu9qn6
         UdXWa2LCJGcTEJSpBVZ/YAJNGfpN0o4XjvnlP65TOeKALa4XHUGgEI+vD8pexNksw8
         Ka6iudGeCDMT3Gb9uwO6wabYVUUZAtrJjXFnPhcztcWhQelO2DiL6O+B+k6sO/1Yma
         t15M29Qxyl1c6fxMoLGHO+6IPDOP4oUN5cpqt0ihng/2SsfpJidLHwy/mU83EW4tn/
         Zk+YkegxPwhFg==
Subject: Re: [PATCH] x86/i8259: Work around buggy legacy PIC
To:     Thomas Gleixner <tglx@linutronix.de>,
        Maximilian Luz <luzmaximilian@gmail.com>,
        Sachi King <nakato@nakato.io>, Ingo Molnar <mingo@redhat.com>,
        Borislav Petkov <bp@alien8.de>,
        David Laight <David.Laight@aculab.com>
Cc:     "x86@kernel.org" <x86@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
References: <20210512210459.1983026-1-luzmaximilian@gmail.com>
 <e7dbd4d1-f23f-42f0-e912-032ba32f9ec8@gmail.com>
 <e43d9a823c9e44bab0cdbf32a000c373@AcuMS.aculab.com> <3034083.sOBWI1P7ec@yuki>
 <5c08541a-2615-f075-a189-0462f1005007@gmail.com>
 <87im3l43w9.ffs@nanos.tec.linutronix.de>
From:   "H. Peter Anvin" <hpa@zytor.com>
Message-ID: <c26954e1-bb2f-086a-9c7f-68382978efe7@zytor.com>
Date:   Fri, 14 May 2021 10:35:57 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <87im3l43w9.ffs@nanos.tec.linutronix.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 5/14/21 10:32 AM, Thomas Gleixner wrote:
> 
> That's a valid assumption. As I said, we can make IOAPIC work even w/o
> PIC. I'll have a look how much PIC assumptions are still around.
> 

As far as I read, the problem isn't actually the absence of a PIC (we 
definitely boot systems without PICs all the time now), but rather that 
the PIC is advertised in ACPI but is buggy or absent; a similar platform 
with different firmware doesn't have problem.

If my understanding of the thread is correct, it's quirk fodder.

	-hpa

