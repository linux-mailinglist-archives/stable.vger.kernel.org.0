Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CFC0258F066
	for <lists+stable@lfdr.de>; Wed, 10 Aug 2022 18:27:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232405AbiHJQ1u (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 10 Aug 2022 12:27:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56500 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232705AbiHJQ1t (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 10 Aug 2022 12:27:49 -0400
Received: from mail-yb1-xb2d.google.com (mail-yb1-xb2d.google.com [IPv6:2607:f8b0:4864:20::b2d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F248E8274F
        for <stable@vger.kernel.org>; Wed, 10 Aug 2022 09:27:48 -0700 (PDT)
Received: by mail-yb1-xb2d.google.com with SMTP id 199so24092033ybl.9
        for <stable@vger.kernel.org>; Wed, 10 Aug 2022 09:27:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc;
        bh=AqWTLOdt9Aiqhe7XvTQEnY7vtsmM8FsS3bAtm1mmGe8=;
        b=ZdhkmcOFLCTCCOZ6zTiytv6XOWOi1bawCeHK99xlaOlN5WevAmkYa9MsjeTMTz/Y1N
         FOkaINdeTlXiAe1RXXLvy2YmU8T2sDo6B2cmsf8n/MPgTZnC9RqRezaG9/GwlvFrGEAS
         JzMDPnUNY+VZUxYqvKD/1B2YvP3ScQNS4ZVn81LwPeDBE47YmPjrEMjoo/llnbt/C71r
         aT9ol4zS2y/9M/mW97R7rGHIybyEW1HDB19U5xJF5aUQCWYw+qOA/xRLfrA8fNV4Wzzc
         KySUjH9awMf9/ngBcKJhSz3DJVTll36NHkuMQZSsSeQp1NiGfI12ISfMqvNvrKhU4Agi
         cC8A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc;
        bh=AqWTLOdt9Aiqhe7XvTQEnY7vtsmM8FsS3bAtm1mmGe8=;
        b=B3sU2Cq335nWY7tIkfNf32VFZdIgIhtwAVVTeAIyc7gc6BKGmx5bN0gMAaW0dRfLTq
         WkM/bxtotoKXRJ/rZ0fNoGBrB+ZuxYVFSh9x3VLD5J96YHPxkiQUf1GwL/kqDlvXsweI
         2gCXf5uo72OeeBxqamWB2zBG0TldbSvJ2DW2PTt+PHR142yzew9MVGsY4lyvvLw83Ue8
         CP5pq2DkeX9CurIJ7kSVxQMKGCpnQzgYKCmgIyqZZF2PG7yqAbAirephdVERYWwhwU3n
         qOsC6YDl0ay2kl1QIiEu6/o3ewcZKTYnoBj/pZhGAsOKwbrPSajpsEqVUmn/5UKq7fvF
         iHlw==
X-Gm-Message-State: ACgBeo1kWLtdF1QcYs4LGBUX0hrnFU/Xo+GnuWLavNCjpHqgKBa8FRaJ
        kRxhFmnyffdQRPqqLWtEbGHjGj8kHsahBkwXFigSL8Wpht6ho9qt
X-Google-Smtp-Source: AA6agR6hNC9iPGwG6c8X8sonhLzDsOqWu6VWu6M7h3pfL3h/tbfBLu1EfCCheAS7sEdoZaYmiwVaSwMJ+msmu4Fl7AY=
X-Received: by 2002:a25:bc1:0:b0:67b:bf16:663e with SMTP id
 184-20020a250bc1000000b0067bbf16663emr17324745ybl.302.1660148868024; Wed, 10
 Aug 2022 09:27:48 -0700 (PDT)
MIME-Version: 1.0
References: <CAE7E4gmX=L8y26DJOkUbYtP59RJDRzob5K5oi0ZLGO-EfcQMjA@mail.gmail.com>
 <YvPcLoR4ebjvDboo@kroah.com>
In-Reply-To: <YvPcLoR4ebjvDboo@kroah.com>
From:   Jeongik Cha <jeongik@google.com>
Date:   Thu, 11 Aug 2022 01:27:36 +0900
Message-ID: <CAE7E4g=mFyi6wCDTjpAbZFtyudr5C2ewLFtpwWouRdJJ33vgug@mail.gmail.com>
Subject: Re: wifi: mac80211_hwsim: fix race condition in pending packet
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     stable@vger.kernel.org, kernel-team@android.com,
        Alistair Delva <adelva@google.com>,
        JaeMan Park <jaeman@google.com>,
        Johannes Berg <johannes@sipsolutions.net>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Aug 11, 2022 at 1:26 AM Greg KH <gregkh@linuxfoundation.org> wrote:
>
> On Thu, Aug 11, 2022 at 12:53:58AM +0900, Jeongik Cha wrote:
> > Hello everyone,
> >
> > I'd like to request a review to merge these patches into stable releases.
> >
> > These patches fix race conditions in pending packets from
> > mac80211_hwsim which cause kernel panic after a device is running for
> > a few hours. It makes test cases in Android(which uses mac80211_hwsim
> > for test purposes) flaky, and also, makes Android emulator unstable.
> >
> > It would be great if these patches could be merged after version 4.19.
> >
> > If you have further questions, please let me know!
> >
> > commit cc5250cdb43d444061412df7fae72d2b4acbdf97 wifi: mac80211_hwsim:
> > use 32-bit skb cookie
> > commit 58b6259d820d63c2adf1c7541b54cce5a2ae6073 wifi: mac80211_hwsim:
> > add back erroneously removed cast
> > commit 4ee186fa7e40ae06ebbfbad77e249e3746e14114 wifi: mac80211_hwsim:
> > fix race condition in pending packet
>
> This is listed in reverse order, correct?
>
> thanks,
>
> greg k-h

Yes, that is correct. The commit at the bottom is the first one.

Thanks
Jeongik
