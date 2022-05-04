Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4C0DA51B1A3
	for <lists+stable@lfdr.de>; Thu,  5 May 2022 00:10:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241397AbiEDWNh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 May 2022 18:13:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35286 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238209AbiEDWNg (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 4 May 2022 18:13:36 -0400
Received: from mout02.posteo.de (mout02.posteo.de [185.67.36.66])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 411C91A3AF
        for <stable@vger.kernel.org>; Wed,  4 May 2022 15:09:59 -0700 (PDT)
Received: from submission (posteo.de [185.67.36.169]) 
        by mout02.posteo.de (Postfix) with ESMTPS id E81F3240107
        for <stable@vger.kernel.org>; Thu,  5 May 2022 00:09:57 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=posteo.de; s=2017;
        t=1651702197; bh=Vky15gD8jullIDai+eZgZhQbvam0639JS90uBzaxgfI=;
        h=From:To:Cc:Subject:Date:From;
        b=A5sXvdtLbmjojXwqrPwBjKpRJzK1X1zQowUYosF04Wk6EihXy1ZT2zP5/u7EqTOJF
         IQ2KxI0ydTAlQWadiN3Skyl2p+U8LTvfL+D8hFcDu2GegjOXAOJxLQPIKOL9E4jndq
         vZIFT2PNB059O5iA7h9NUtoL9GAOY6hhcfNW3IxmM1HmJ9WkDyNzDd0B4PmnlC+4BA
         gBfnPCzmKKEv/Szfg1ArjAHFEr51hMFUtSGTR6d6vssFkHuZtREdxXHXPEMsJ2uMJ4
         5yCpqNJw7NtQOsmTyyZ82K4XTPmctZEbl+Ou+3suZVafXf4gNWC0Dnv67MBVhQpK9J
         6RTkMbVyyCUTA==
Received: from customer (localhost [127.0.0.1])
        by submission (posteo.de) with ESMTPSA id 4Ktrbn02H7z6tn7;
        Thu,  5 May 2022 00:09:56 +0200 (CEST)
From:   Manuel Ullmann <labre@posteo.de>
To:     Holger =?utf-8?Q?Hoffst=C3=A4tte?= <holger@applied-asynchrony.com>
Cc:     Manuel Ullmann <labre@posteo.de>,
        Jordan Leppert <jordanleppert@protonmail.com>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "regressions@lists.linux.dev" <regressions@lists.linux.dev>,
        "davem@davemloft.net" <davem@davemloft.net>
Subject: Re: Crash on resume after suspend (5.17.5 and 5.15.36)
References: <refZ3y2HAXztrRkMMmFbBaF7Dz1CctWgjchSdBtcSNlpk-TL0fqLepVVHfw9qXtIQF9uFzBvFdjQiiX9Jv2zW9oaWej952s1IYwu61d1REo=@protonmail.com>
        <9-Ehc_xXSwdXcvZqKD5aSqsqeNj5Izco4MYEwnx5cySXVEc9-x_WC4C3kAoCqNTi-H38frroUK17iobNVnkLtW36V6VWGSQEOHXhmVMm5iQ=@protonmail.com>
        <87levhnlqu.fsf@posteo.de>
        <18466b6a-b040-c72c-e33d-fe37c5ff6a9d@applied-asynchrony.com>
Date:   Wed, 04 May 2022 22:10:13 +0000
In-Reply-To: <18466b6a-b040-c72c-e33d-fe37c5ff6a9d@applied-asynchrony.com>
        ("Holger =?utf-8?Q?Hoffst=C3=A4tte=22's?= message of "Wed, 4 May 2022
 22:58:29 +0200")
Message-ID: <878rrh2blm.fsf@posteo.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Holger Hoffst=C3=A4tte <holger@applied-asynchrony.com> writes:
> On 2022-05-04 21:25, Manuel Ullmann wrote:
>>> https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git/commit=
/?h=3Dlinux-5.17.y&id=3Dcbe6c3a8f8f4315b96e46e1a1c70393c06d95a4c
>> Yup, that=E2=80=99s my fault and I reproduced this myself yesterday. I a=
ctually
>> expected this to happen and attempted to test suspend with the patch,
>> but must have screwed up by kexec-rebooting into an unpatched kernel
>> version or something like that. I=E2=80=99ll disable the kexec service i=
n the
>> future, if I ever need to prepare a patch again.
>>> 05:00.0 Ethernet controller: Aquantia Corp. AQC107 NBase-T/IEEE 802.3bz=
 Ethernet Controller [AQtion] (rev 02)
>> Yes, I have the same one.
>>=20
>>> Please let me know if there is any more info I can give that will help.
>> Can you confirm, that hibernation works with the patch, but not without
>> it? The patch was an attempt to fix it, because I had the same behaviour
>
> Cannot test hibernation, but..

That=E2=80=99s unfortunate.

>> with hibernation. I tried to make sense of the deep parameter in
>> atl_resume_common pm function calls, but apparently it=E2=80=99s always =
required
>> to be true and thus obsolete.
>
> ..I patched 5.15.38 to pass true as deep arg everywhere, and now resume
> seems to work again reliably, 5 out of 5. \o/

Thanks for confirming that my patch should work. For some reason I had
the same idea. ;)

>> I=E2=80=99ll leave the cleanup of that parameter to the maintainers for =
mainline
>> and prepare a patch. Last time I sent it against mainline. If this fixup
>> of a stable patch regression should be posted differently, it would be
>> nice, if someone could give me a pointer.
>
> Send fix to mainline first, with Fixes: <mainline commit id> tag and
> Cc: stable mentioning the affected versions.
Thanks for the hint. I did that.

> cheers
> Holger

