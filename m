Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C4678659C9F
	for <lists+stable@lfdr.de>; Fri, 30 Dec 2022 23:01:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231174AbiL3WBK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 30 Dec 2022 17:01:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46354 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235391AbiL3WBI (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 30 Dec 2022 17:01:08 -0500
Received: from mail-pj1-x102d.google.com (mail-pj1-x102d.google.com [IPv6:2607:f8b0:4864:20::102d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D58F317E2C
        for <stable@vger.kernel.org>; Fri, 30 Dec 2022 14:01:06 -0800 (PST)
Received: by mail-pj1-x102d.google.com with SMTP id v23so23569981pju.3
        for <stable@vger.kernel.org>; Fri, 30 Dec 2022 14:01:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:message-id:in-reply-to:subject:cc:to:from
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=DQYLGAH0uGXo3xlMz5nVls5ASt4VNqU9CWQhF48EYvw=;
        b=jOFraJc2+le2FfTl9+hl81vOAbgJL9wX3Ldrv9YY+Gu/AxmtD+bQtclTHwnTGgH27A
         BVgmvTTbPItZ5UYgTIKhy5tzqyLIBe5JtpltE5LFgZr8kwMR28Mj8I8kEcPJC/vvtnLb
         ohnaHo1wEWqxF/beEMnmqoUoVT8oHOP73zM6s1VE/TUIYTqbG5k/Vn7cJIJC3jmdG5M+
         IQP4ojENssjjADyCnE40YNMpAIZQVU+6IGsNiZVKUVyv3nOsgB+u3UUg7okJzREaaB6s
         uYmVb5ffLAbJl/HtlLZj7TCY+kTUVU9+SEK+5gmpEznsAaSXXeA7hDJhlsEbSkbGVdD4
         4xcQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=mime-version:references:message-id:in-reply-to:subject:cc:to:from
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=DQYLGAH0uGXo3xlMz5nVls5ASt4VNqU9CWQhF48EYvw=;
        b=OT6oa7ESA0EvPIOsAusaCNR3CP2rthinCxmyrg+JKa/qKet4rFooPQ4L1XgT6mqQo/
         VRAFoBj8MvvJwSWrM2KeDV8v8CgvfbtypDwISbwnb3y2tbTEM8y3WegX2Il6Go5Z5CGs
         L6G/SbyJXB/Q6jPYMmINoLLrNCj4tHG7oRVc85xNEqCY4l1qehnNt9T3J1PUfSbGEIDs
         Fy+Nw/+WzaVrsuGJbWZOpVIjD4klXXHwZ0OCkAPmCmo8Ggop6XprLgEPr7fcBV0vAg6J
         Tq8VFUAeo79lOSutQwH4Fo5m621eb4ZvpP5Y3N7BIY0x16INonmvoeHsmWRUai45Rm0Z
         NDfw==
X-Gm-Message-State: AFqh2kolbH5CnHQ3AcHod/NpnUCI/eu4l2X06ZnrRi6BGNJe712uN8mN
        Iq25fNqdB3QsB6fbKtykr8Wu8w==
X-Google-Smtp-Source: AMrXdXv4oXVZT5rM0N5imJkkR+zQ6Brwur97rGFFx35dL6Lhe4dDs6060zOcH2NrU1vXy9LrW/DdbQ==
X-Received: by 2002:a17:902:d4d1:b0:189:3a04:4466 with SMTP id o17-20020a170902d4d100b001893a044466mr3420177plg.2.1672437666185;
        Fri, 30 Dec 2022 14:01:06 -0800 (PST)
Received: from [2620:15c:29:203:8954:8b68:67ce:a964] ([2620:15c:29:203:8954:8b68:67ce:a964])
        by smtp.gmail.com with ESMTPSA id g19-20020a635213000000b0044ed37dbca8sm9241470pgb.2.2022.12.30.14.01.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 30 Dec 2022 14:01:05 -0800 (PST)
Date:   Fri, 30 Dec 2022 14:01:04 -0800 (PST)
From:   David Rientjes <rientjes@google.com>
To:     Herbert Xu <herbert@gondor.apana.org.au>
cc:     Peter Gonda <pgonda@google.com>, Andy Nguyen <theflow@google.com>,
        stable@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-crypto@vger.kernel.org, John Allen <john.allen@amd.com>,
        "Thomas . Lendacky" <thomas.lendacky@amd.com>
Subject: Re: [PATCH] crypto: ccp - Limit memory allocation in SEV_GET_ID2
 ioctl
In-Reply-To: <Y6wDJd3hfztLoCp1@gondor.apana.org.au>
Message-ID: <826b3dda-5b48-2d42-96b8-c49ccebfdfed@google.com>
References: <20221214202046.719598-1-pgonda@google.com> <Y5rxd6ZVBqFCBOUT@gondor.apana.org.au> <762d33dc-b5fd-d1ef-848c-7de3a6695557@google.com> <Y6wDJd3hfztLoCp1@gondor.apana.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, 28 Dec 2022, Herbert Xu wrote:

> On Tue, Dec 27, 2022 at 05:42:31PM -0800, David Rientjes wrote:
> >
> > The goal was to be more explicit about that, but setting __GFP_NOWARN 
> > would result in the same functional behavior.  If we're to go that route, 
> > it would likely be best to add a comment about the limitation.
> > 
> > That said, if AMD would prefer this to be an EINVAL instead of a ENOMEM by 
> > introducing a more formal limitation on the length that can be used, that 
> > would be preferred so that we don't need to rely on the page allocator's 
> > max length to enforce this arbitrarily.
> 
> Ideally the limit should be set according to the object that
> you're trying to allocate.  But if that is truly unlimited,
> and you don't want to see a warning, then GFP_NOWARN seems to
> fit the bill.
> 

AMD would be able to speak authoritatively on it, but I think the length 
of the ID isn't to be assumed by software because it will likely change 
later.

I don't think there's an active vulnerability with the currnet code so we 
can likely drop stable@vger.kernel.org for this.  The kzalloc() will fail 
if you try to allocate over 2MB.  If you try to allocate >32KB, the page 
allocator will attempt to reclaim but won't oom kill.  If you try to 
allocate <=32KB, there's the potential for oom kill if nothing is 
reclaimable, but if memory is that scarce I think we have bigger problems.

So __GFP_NOWARN will work, but I also think it's subtle enough that it 
warrants being coupled with a comment.
