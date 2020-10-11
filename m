Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A3D0128A9F7
	for <lists+stable@lfdr.de>; Sun, 11 Oct 2020 21:47:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726068AbgJKTrf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 11 Oct 2020 15:47:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35378 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726456AbgJKTrd (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 11 Oct 2020 15:47:33 -0400
Received: from gate2.alliedtelesis.co.nz (gate2.alliedtelesis.co.nz [IPv6:2001:df5:b000:5::4])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A3EDFC0613CE
        for <stable@vger.kernel.org>; Sun, 11 Oct 2020 12:47:33 -0700 (PDT)
Received: from mmarshal3.atlnz.lc (mmarshal3.atlnz.lc [10.32.18.43])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (Client did not present a certificate)
        by gate2.alliedtelesis.co.nz (Postfix) with ESMTPS id 28FE4891B0;
        Mon, 12 Oct 2020 08:47:28 +1300 (NZDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alliedtelesis.co.nz;
        s=mail181024; t=1602445648;
        bh=yzuM1AbYaSkislsBsctNJQYk00rOwZXZwalvzT3mozk=;
        h=From:To:CC:Subject:Date:References:In-Reply-To;
        b=jiCrZKdAJqwubTld1g+3Onr8HdibTa7Gq+LVvwVAR2veDV0bWbBK4T7pe2bYkPDXf
         glMvnJyb8bq4AGG0CF2QwYnHy2WDT3MTxpZG+Q+Xvg4YGQJPVfYRiDZWGMwJJ0k8km
         Ee+jMeJejDreUhBJWxuBtOmbrHR9lmvbEJgeKwKknEqa68nPPpP6oUwEXC+uwT4SOy
         rAGZPWuPQgkrwFG0me5Vu+Yuju6g8Jgdr6MfP7KmpMRUpJdLnzVkFwzgFC4Uq1/HqO
         Fd4XIKOVDxHGPdkFR8VXa/UUsNYN9OhndEYjx3yVKh4kDTqS6ZBAhOnew2XzIWjLor
         Rz7UGYyceOAwg==
Received: from svr-chch-ex1.atlnz.lc (Not Verified[10.32.16.77]) by mmarshal3.atlnz.lc with Trustwave SEG (v7,5,8,10121)
        id <B5f83614f0000>; Mon, 12 Oct 2020 08:47:27 +1300
Received: from svr-chch-ex1.atlnz.lc (2001:df5:b000:bc8::77) by
 svr-chch-ex1.atlnz.lc (2001:df5:b000:bc8::77) with Microsoft SMTP Server
 (TLS) id 15.0.1497.2; Mon, 12 Oct 2020 08:47:26 +1300
Received: from svr-chch-ex1.atlnz.lc ([fe80::409d:36f5:8899:92e8]) by
 svr-chch-ex1.atlnz.lc ([fe80::409d:36f5:8899:92e8%12]) with mapi id
 15.00.1497.006; Mon, 12 Oct 2020 08:47:26 +1300
From:   Chris Packham <Chris.Packham@alliedtelesis.co.nz>
To:     Pavel Machek <pavel@denx.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 4.19 21/38] spi: fsl-espi: Only process interrupts for
 expected events
Thread-Topic: [PATCH 4.19 21/38] spi: fsl-espi: Only process interrupts for
 expected events
Thread-Index: AQHWmywHvuJcZBywGkuaEhHbg7KTCKmKH7kAgAfesQA=
Date:   Sun, 11 Oct 2020 19:47:26 +0000
Message-ID: <e96519d3-8b58-4715-1ada-6139749e6da3@alliedtelesis.co.nz>
References: <20201005142108.650363140@linuxfoundation.org>
 <20201005142109.694666032@linuxfoundation.org>
 <20201006193634.GB8771@duo.ucw.cz>
In-Reply-To: <20201006193634.GB8771@duo.ucw.cz>
Accept-Language: en-NZ, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-exchange-transport-fromentityheader: Hosted
x-originating-ip: [10.32.1.11]
Content-Type: text/plain; charset="Windows-1252"
Content-ID: <671A07B30930C44EAA974C62F10976BB@atlnz.lc>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


On 7/10/20 8:36 am, Pavel Machek wrote:
> Hi!
>
>> [ Upstream commit b867eef4cf548cd9541225aadcdcee644669b9e1 ]
>>
>> The SPIE register contains counts for the TX FIFO so any time the irq
>> handler was invoked we would attempt to process the RX/TX fifos. Use the
>> SPIM value to mask the events so that we only process interrupts that
>> were expected.
>>
>> This was a latent issue exposed by commit 3282a3da25bd ("powerpc/64:
>> Implement soft interrupt replay in C").
> We don't seem to have commit 3282... in 4.19, so we don't need this
> one in 4.19-stable according to the changelog.
Technically 3282... exposed the issue by making it more likely to happen=20
so 4.19 might just have a really low probability of seeing the issue (I=20
think I did try reproducing it on kernels of that vintage). Personally=20
I'm not too fussed the kernel versions I care about have the fix. Maybe=20
someone from NXP cares enough to pursue it.=
