Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A0C274E8369
	for <lists+stable@lfdr.de>; Sat, 26 Mar 2022 19:41:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232900AbiCZSnO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 26 Mar 2022 14:43:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52990 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231200AbiCZSnN (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 26 Mar 2022 14:43:13 -0400
Received: from mail-lf1-x129.google.com (mail-lf1-x129.google.com [IPv6:2a00:1450:4864:20::129])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D3BA058391
        for <stable@vger.kernel.org>; Sat, 26 Mar 2022 11:41:36 -0700 (PDT)
Received: by mail-lf1-x129.google.com with SMTP id bu29so18527650lfb.0
        for <stable@vger.kernel.org>; Sat, 26 Mar 2022 11:41:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=je98ykY3vsH8qDn25IW7eQYaUsod4iWZw+6FMsszdYQ=;
        b=cY/i8NkOXIGpbugW/kXT/lHU/6KoHURxtydz8kA95dAKXv2dKSirRf5cna3Zz4aQE+
         3zUrMCb8X6oIozpmPaWm2GuBQkB5p7v5BNoSLeNAqcrF06WOFYpSLhQLT9RJ7kcNoToA
         /byaS8f5DiCBA3c9IENt3HgD+FLD9/VL6yCSc=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=je98ykY3vsH8qDn25IW7eQYaUsod4iWZw+6FMsszdYQ=;
        b=M9B98QLrACDPgAYHey2jD/vkGMwehuILCgVceDwxIDwz+gtxvy00wAu+jXvUhwP3Mh
         05kMS84RSTre2Oc1rslL/oYQscLFxU5ayzsrowKEHhdcziiGOE0kFSBiso5iL43r3yxP
         G+4onPbIKwYLjiB0NpcAvMeducuEjPKqkvJHyowts6Q+opPQZUjoBw3V8drgLgg7NuOy
         MAemHIUpGUra4ADgvwHHVfJACy6z72O/1c0X3SbJtuREiUJ3dXMpq/KPVQBovNQtKz5h
         hY6SCsguuLwNqXICOMNJLoNCkAjOxfcWf6Q/RpEuI8Xw6aym8GxxXHNHm5MqnC3qfckf
         UDlw==
X-Gm-Message-State: AOAM531OSPFnWYr6G5iVTU1ZfrE6FK2/K98eeEGHQc6LxPVEkLloCIp7
        T14QvFvYjoOPjXbCy5HVd2aDww9mBSKUycO7k74=
X-Google-Smtp-Source: ABdhPJwZwtZoRYrSu6ssxVh+QJg6gXzjajN63E3c3/Y10ePG6aDM/IVb6D7Y7SJId2HMRgQ5z9XgrQ==
X-Received: by 2002:a05:6512:1585:b0:445:908b:ad71 with SMTP id bp5-20020a056512158500b00445908bad71mr12554696lfb.200.1648320094834;
        Sat, 26 Mar 2022 11:41:34 -0700 (PDT)
Received: from mail-lf1-f46.google.com (mail-lf1-f46.google.com. [209.85.167.46])
        by smtp.gmail.com with ESMTPSA id y23-20020a2e95d7000000b00247e4e386aasm1103771ljh.121.2022.03.26.11.41.33
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 26 Mar 2022 11:41:34 -0700 (PDT)
Received: by mail-lf1-f46.google.com with SMTP id t25so18431945lfg.7
        for <stable@vger.kernel.org>; Sat, 26 Mar 2022 11:41:33 -0700 (PDT)
X-Received: by 2002:a19:e048:0:b0:448:2caa:7ed2 with SMTP id
 g8-20020a19e048000000b004482caa7ed2mr13185867lfj.449.1648320093080; Sat, 26
 Mar 2022 11:41:33 -0700 (PDT)
MIME-Version: 1.0
References: <20220325150419.757836392@linuxfoundation.org> <20220325150420.085364078@linuxfoundation.org>
 <CAHk-=wiaeZKiEk87Sms1sy53m8tT3UCLOoeUBnX1c_1dZ78WjQ@mail.gmail.com> <Yj7oXgoCdhWAwFQt@kroah.com>
In-Reply-To: <Yj7oXgoCdhWAwFQt@kroah.com>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Sat, 26 Mar 2022 11:41:17 -0700
X-Gmail-Original-Message-ID: <CAHk-=wgeOrhN_Gznm80==STG1pEbqLMCaZZoeQzZu=NN9GOTgw@mail.gmail.com>
Message-ID: <CAHk-=wgeOrhN_Gznm80==STG1pEbqLMCaZZoeQzZu=NN9GOTgw@mail.gmail.com>
Subject: Re: [PATCH 5.10 11/38] swiotlb: rework "fix info leak with DMA_FROM_DEVICE"
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        stable <stable@vger.kernel.org>,
        Halil Pasic <pasic@linux.ibm.com>,
        Christoph Hellwig <hch@lst.de>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-1.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sat, Mar 26, 2022 at 3:18 AM Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:"
>
> Yes, I've been watching that thread.  This change is already in 5.15 and
> 5.16 kernels, and does solve one known security issue, so it's a tough
> call.

If you're following that thread, you'll have seen that I've reverted
it, and I actually think the security argument was bogus - the whole
commit was due to a misunderstanding of the actual direction of the
data transfer.

But hey, maybe I'm wrong. The only truly uncontested fact is that it
broke the ath9k driver.

           Linus
