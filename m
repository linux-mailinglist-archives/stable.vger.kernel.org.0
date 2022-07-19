Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2293657A8AD
	for <lists+stable@lfdr.de>; Tue, 19 Jul 2022 22:55:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238045AbiGSUz4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 Jul 2022 16:55:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44152 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234727AbiGSUzz (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 19 Jul 2022 16:55:55 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 777C145F75;
        Tue, 19 Jul 2022 13:55:54 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0DD0A61957;
        Tue, 19 Jul 2022 20:55:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 113ACC341C6;
        Tue, 19 Jul 2022 20:55:52 +0000 (UTC)
Authentication-Results: smtp.kernel.org;
        dkim=pass (1024-bit key) header.d=zx2c4.com header.i=@zx2c4.com header.b="fRtf0smj"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zx2c4.com; s=20210105;
        t=1658264151;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=vAVARSc49C86zWIrCd3K8jFisxO1etfqUr16Ti/OMVw=;
        b=fRtf0smjzr6ZSdudbo5yUmHz5+csQM3HrsuOITMbyX3uQbMp5GoSdruVVQTnH8NDcPhO/f
        6QOK8CIBCnBs+lG6MmDd3yteR1pGN00o5pzWL2G8nWMplwHkwDilSOTIgikZIAQ4s9rifX
        Xr3GihNMq42WvAvg2h14lP3IeGbVl4w=
Received: by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id 9e52cc3f (TLSv1.3:AEAD-AES256-GCM-SHA384:256:NO);
        Tue, 19 Jul 2022 20:55:51 +0000 (UTC)
Received: by mail-qt1-f178.google.com with SMTP id g24so9317696qtu.2;
        Tue, 19 Jul 2022 13:55:50 -0700 (PDT)
X-Gm-Message-State: AJIora+/Xv/tw82OwmNnCOrlU6UUuif6Vt6NXldabeGf8EQdx0AEffIm
        psuH+PKRIRFjWYhoollX0iyNARIRrnq6xDziq1I=
X-Google-Smtp-Source: AGRyM1vzv9s1eS+pfO8WNlWcBgPiQEOtbrCKCO4Jy0sOvMrdQOv7HFXY6fMTpC3ji4oW9pDJEgAANGDXVjxoNe+m36o=
X-Received: by 2002:ac8:7c48:0:b0:31f:83:85d9 with SMTP id o8-20020ac87c48000000b0031f008385d9mr3301852qtv.105.1658264149671;
 Tue, 19 Jul 2022 13:55:49 -0700 (PDT)
MIME-Version: 1.0
References: <CAHmME9qrd25vfRYYvCWtPg+wVC5joEzzJiihCN+L4rqMfTL4Rg@mail.gmail.com>
 <20220719201108.264322-1-Jason@zx2c4.com> <87sfmwsu5l.fsf@email.froward.int.ebiederm.org>
In-Reply-To: <87sfmwsu5l.fsf@email.froward.int.ebiederm.org>
From:   "Jason A. Donenfeld" <Jason@zx2c4.com>
Date:   Tue, 19 Jul 2022 22:55:38 +0200
X-Gmail-Original-Message-ID: <CAHmME9r5B30Ts=DmME7A2NG31rXo77iAhSgufbxq2dY8WNJhgw@mail.gmail.com>
Message-ID: <CAHmME9r5B30Ts=DmME7A2NG31rXo77iAhSgufbxq2dY8WNJhgw@mail.gmail.com>
Subject: Re: [PATCH v10] ath9k: let sleep be interrupted when unregistering hwrng
To:     "Eric W. Biederman" <ebiederm@xmission.com>
Cc:     linux-wireless@vger.kernel.org, Kalle Valo <kvalo@kernel.org>,
        Rui Salvaterra <rsalvaterra@gmail.com>,
        Valentin Schneider <vschneid@redhat.com>,
        stable@vger.kernel.org, Gregory Erwin <gregerwin256@gmail.com>,
        =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@toke.dk>,
        Herbert Xu <herbert@gondor.apana.org.au>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-6.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Eric,

On Tue, Jul 19, 2022 at 10:51 PM Eric W. Biederman
<ebiederm@xmission.com> wrote:
> Acked-by: "Eric W. Biederman" <ebiederm@xmission.com>

Thank you.

> The whole design seems very strange to me.  I would think instead of
> having a current hardware random number generator the kernel would
> pull from every hardware random generator available.  Further that
> we can get a userspace read all of the way into driver code for
> a hardware random generator seems weird.    I would think in
> practice we would want all of this filtered through /dev/random,
> /dev/urandom, and the get_entropy syscall.

Yes indeed. In general, the hwrng interface is kind of badly designed
and a bit of a nuisance. I've spent the last few months reworking
random.c and that's finally nearing okay enough shape. Possibly after
I'll turn my attention to a real overhaul of hwrng too (assuming
Herbert gives me lattitude to do that, I guess; I don't maintain that
code). The main goal anyhow ought be to just non-invasively shephard
bits into random.c, with additional frills being merely additional.

Jason
