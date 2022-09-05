Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BB9CF5AD213
	for <lists+stable@lfdr.de>; Mon,  5 Sep 2022 14:07:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236412AbiIEMHD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Sep 2022 08:07:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34450 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235420AbiIEMHC (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 5 Sep 2022 08:07:02 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DF7C2402D1;
        Mon,  5 Sep 2022 05:07:01 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8352D6120A;
        Mon,  5 Sep 2022 12:07:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 90DA6C433B5;
        Mon,  5 Sep 2022 12:07:00 +0000 (UTC)
Authentication-Results: smtp.kernel.org;
        dkim=pass (1024-bit key) header.d=zx2c4.com header.i=@zx2c4.com header.b="AwQI3zXh"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zx2c4.com; s=20210105;
        t=1662379617;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=ZDAdVMlFCiNAiNt/gDe4bwmhdOf+6WpnVaQhoNtIX9w=;
        b=AwQI3zXhAs84MI5DuY4E5HTbVfYtRxaPXrwSWMmMg4TYqlHSg6H73uVNE139sPoXBYVvJO
        dGU/LyhApx5Uk74WWQd+3cMZB4iUsNiqEZm6frbsTfAO6jCC2AHqr7igGE6CO4A5Om8mxd
        N2Tqiw5N2z+ob4UZobo70nN47kcXzRk=
Received: by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id 3107f0bf (TLSv1.3:TLS_AES_256_GCM_SHA384:256:NO);
        Mon, 5 Sep 2022 12:06:57 +0000 (UTC)
Received: by mail-yw1-f176.google.com with SMTP id 00721157ae682-3450a7358baso40502307b3.13;
        Mon, 05 Sep 2022 05:06:57 -0700 (PDT)
X-Gm-Message-State: ACgBeo1l+D8Ek6ad/OiCsFYJxxsBpk+M8eXo4DGB00hj85qnkqwspYHU
        LVB02DUJnCv5ELvsi3lh/r13w6T6rq1Q7UyE0kQ=
X-Google-Smtp-Source: AA6agR5X7dDkj/wLtvhnwZ797YyJChFFYEUZ25C9PbeN9mtjjfKPaq7Gnpog0gNLR7uO8ZVcW/8GIpuSdK/emysn2YU=
X-Received: by 2002:a0d:f082:0:b0:31f:1d1d:118d with SMTP id
 z124-20020a0df082000000b0031f1d1d118dmr38595397ywe.124.1662379616260; Mon, 05
 Sep 2022 05:06:56 -0700 (PDT)
MIME-Version: 1.0
References: <20220905101403.1435037-1-Jason@zx2c4.com> <87sfl6jbb3.wl-tiwai@suse.de>
In-Reply-To: <87sfl6jbb3.wl-tiwai@suse.de>
From:   "Jason A. Donenfeld" <Jason@zx2c4.com>
Date:   Mon, 5 Sep 2022 14:06:45 +0200
X-Gmail-Original-Message-ID: <CAHmME9rbqT=dAGU_oybHYH87qkwNNFizHsSyptZU1vKQMo9dgw@mail.gmail.com>
Message-ID: <CAHmME9rbqT=dAGU_oybHYH87qkwNNFizHsSyptZU1vKQMo9dgw@mail.gmail.com>
Subject: Re: [PATCH] ALSA: usb-audio: Don't refcount multiple accesses on the
 single clock
To:     Takashi Iwai <tiwai@suse.de>
Cc:     alsa-devel@alsa-project.org, LKML <linux-kernel@vger.kernel.org>,
        stable <stable@vger.kernel.org>,
        =?UTF-8?B?TmlrbMSBdnMgS2/EvGVzxYZpa292cw==?= 
        <89q1r14hd@relay.firefox.com>, Wim Taymans <wtaymans@redhat.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-6.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Sep 5, 2022 at 1:44 PM Takashi Iwai <tiwai@suse.de> wrote:
>
> On Mon, 05 Sep 2022 12:14:03 +0200,
> Jason A. Donenfeld wrote:
> >
> > This reverts commit 03a8b0df757f1beb21ba1626e23ca7412e48b525.
> > This reverts commit c11117b634f4f832c4420d3cf41c44227f140ce1.
> >
> > Pipewire and PulseAudio start devices with 44.1khz before changing them
> > to 48khz (or something different). By locking the rate, daemons are
> > unable to enumerate possible rates, and so they never change them to a
> > more optimal rate. This revert patch should allow 48khz audio again.
>
> Well, in that case, the revert is no right solution, IMO.
> If the patch caused a problem, it means that the application tries to
> change the rate while it's being still running by another.  If it
> worked, it worked just casually without noticing the bad behavior.

Not sure this is really what's happening. I think the issue is that
alsa reports that the device only supports a limited set of rates.
Pipewire then doesn't see 48khz, so it doesn't try to
stop,reclock,start.

Maybe Wim or Niklavs can provide more info about this.

Jason
