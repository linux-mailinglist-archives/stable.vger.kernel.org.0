Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EECD85803B2
	for <lists+stable@lfdr.de>; Mon, 25 Jul 2022 19:57:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229805AbiGYR5F (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 25 Jul 2022 13:57:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54498 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231725AbiGYR5F (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 25 Jul 2022 13:57:05 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id D4F7F1A054
        for <stable@vger.kernel.org>; Mon, 25 Jul 2022 10:57:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1658771822;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=fA6SAYs3HQMRxuDqGt+OVpRTV8U/b/smqSLdilsh9jU=;
        b=fHFaFEuVCsEW+lawbC60/ZuWXx2CN7SV4R8tZ4pdgoKnrn+keoGCwsik9GvdlBmRvUfk3h
        ptnk7B++V6GI17rxV448r+ivWcyoJ3w71Sw9LYKoTaxytr2D8Qe114G9Pwwto8xG9fyA3P
        YmPoUWGtePXPRIFEjX3aIk8EqiGiEnA=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-606-ew9zq5jHPLiCdvxrXnqBWQ-1; Mon, 25 Jul 2022 13:57:01 -0400
X-MC-Unique: ew9zq5jHPLiCdvxrXnqBWQ-1
Received: by mail-wm1-f72.google.com with SMTP id p36-20020a05600c1da400b003a33a8c14f2so5388953wms.7
        for <stable@vger.kernel.org>; Mon, 25 Jul 2022 10:57:01 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=fA6SAYs3HQMRxuDqGt+OVpRTV8U/b/smqSLdilsh9jU=;
        b=LNScUjUjGfAb5IQYI3hXhxr8yV8CQSRJcN4QeBdREHYCM+arQSGWFlwug/faxY/iVZ
         RCcmRKyQqCHXu+ryeduL0WLTSJuWSsXO2m6YHCGUMUkWshnIAnykovm0tpFJ32XCQGlF
         V0Ey/s0ealHAQS3AE3kQpNQaHTzk3c6DctbkgV7KWc25e67c3hKb+F6wK5uojYF8WD2A
         /3G60WbAoW/JpqMo58itgjCxAnH6yVdfJ9oHy2tMpRP1LWAbObK6y8D9RlLv6L4WJlTc
         boNKkaCJBe4HYszKw4h4JmEvTah2K9cGOc6MFQLm4ouyF4kzYuQzwP8WRc16lPH8SDfV
         Zk2w==
X-Gm-Message-State: AJIora8vzjdrZDqGHEXAMxZUHP1T7R421wvD+eSvfsKbDT1Sfxh6tnxc
        wiGa/VbtP3RXCqpUCcIsYCcTiGP3vO9iQsN/OqGBjei7Z0+WwV5wzGxza6zz1jR1Uo6RNychm1s
        AFTHD3ZQy+FwTUsSi
X-Received: by 2002:adf:f5cf:0:b0:21e:2ebc:4126 with SMTP id k15-20020adff5cf000000b0021e2ebc4126mr8533025wrp.195.1658771820298;
        Mon, 25 Jul 2022 10:57:00 -0700 (PDT)
X-Google-Smtp-Source: AGRyM1sPkSR7bYNOk3OOfpeBsfJxWBm4brv8/S5AimTmcqqZBb0nX2g0dTB8dpgQO01EOX4S8XZS2A==
X-Received: by 2002:adf:f5cf:0:b0:21e:2ebc:4126 with SMTP id k15-20020adff5cf000000b0021e2ebc4126mr8533014wrp.195.1658771820061;
        Mon, 25 Jul 2022 10:57:00 -0700 (PDT)
Received: from vschneid.remote.csb ([185.11.37.247])
        by smtp.gmail.com with ESMTPSA id c23-20020a05600c4a1700b003a3170a7af9sm14159853wmp.4.2022.07.25.10.56.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 25 Jul 2022 10:56:59 -0700 (PDT)
From:   Valentin Schneider <vschneid@redhat.com>
To:     "Jason A. Donenfeld" <Jason@zx2c4.com>
Cc:     linux-wireless <linux-wireless@vger.kernel.org>,
        Kalle Valo <kvalo@kernel.org>,
        Rui Salvaterra <rsalvaterra@gmail.com>,
        "Eric W . Biederman" <ebiederm@xmission.com>,
        stable <stable@vger.kernel.org>,
        Gregory Erwin <gregerwin256@gmail.com>,
        Toke =?utf-8?Q?H=C3=B8iland-J?= =?utf-8?Q?=C3=B8rgensen?= 
        <toke@toke.dk>, Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH v10] ath9k: let sleep be interrupted when unregistering
 hwrng
In-Reply-To: <CAHmME9rp0kCLKvXWfmRHi=p2PLYRszqQqQWZLHyofJ=9xZCtMA@mail.gmail.com>
References: <CAHmME9qrd25vfRYYvCWtPg+wVC5joEzzJiihCN+L4rqMfTL4Rg@mail.gmail.com>
 <20220719201108.264322-1-Jason@zx2c4.com>
 <xhsmhfsisgbam.mognet@vschneid.remote.csb>
 <CAHmME9pEvr_F2C9cG4qNSCc91a7YAAquW7Jqczcgn2fr_vA4Ow@mail.gmail.com>
 <xhsmhbktdfqrp.mognet@vschneid.remote.csb>
 <CAHmME9rp0kCLKvXWfmRHi=p2PLYRszqQqQWZLHyofJ=9xZCtMA@mail.gmail.com>
Date:   Mon, 25 Jul 2022 18:56:58 +0100
Message-ID: <xhsmhv8rldqj9.mognet@vschneid.remote.csb>
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-2.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 25/07/22 13:41, Jason A. Donenfeld wrote:
> Hi Valentin,
>
> On Mon, Jul 25, 2022 at 12:09 PM Valentin Schneider <vschneid@redhat.com> wrote:
>> > maybe at some point I'll look into overhauling all of this so that
>> > none of this will be required anyway. So I think v10 is my final
>> > submission on this.
>>
>> I think that's fair, I hope I didn't discourage you too much from
>> contributing in that area.
>
> While not strictly necessary because of Eric's ack, since you continue
> to grow this thread that addresses an active bug people are suffering
> from, it might be some very useful signaling if you too would provide
> your Acked-by, so that Kalle picks this up and people's laptops work
> again.
>

I don't think the __set_notify_signal() approach is functionally wrong, but
I also believe it isn't the proper tool for the job (for reasons I wrote
previously).

I won't ack it, but I won't nack it either if others find it satisfactory.

