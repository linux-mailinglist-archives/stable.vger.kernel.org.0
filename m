Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 516EC5AD239
	for <lists+stable@lfdr.de>; Mon,  5 Sep 2022 14:17:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236756AbiIEMQ6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Sep 2022 08:16:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48554 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236216AbiIEMQ4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 5 Sep 2022 08:16:56 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C0F355E668;
        Mon,  5 Sep 2022 05:16:55 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 61B38B81145;
        Mon,  5 Sep 2022 12:16:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B4607C433D7;
        Mon,  5 Sep 2022 12:16:52 +0000 (UTC)
Authentication-Results: smtp.kernel.org;
        dkim=pass (1024-bit key) header.d=zx2c4.com header.i=@zx2c4.com header.b="CwV2vJGy"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zx2c4.com; s=20210105;
        t=1662380211;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=Cr1IcXeHldFzxffzu/QlzSBZS0u7fgjwCYCcOJCssx4=;
        b=CwV2vJGy8mCc88L4hEfJaJxZjl6MNE+EkYCQcn5mnte3BPuW4v8jztHt3VHCVqWegUT+Rc
        Sz3gxLtB4OlTZ31MIWwSx8ZX8nPKTvFZ2MJMF3SaChZC+uwXl941Skfen2aqT+kXbZADpK
        MCqR0kq/m4rGmgOQKJRNX8pGJnnzlgQ=
Received: by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id 4a432477 (TLSv1.3:TLS_AES_256_GCM_SHA384:256:NO);
        Mon, 5 Sep 2022 12:16:51 +0000 (UTC)
Received: by mail-yb1-f179.google.com with SMTP id t184so12549868yba.4;
        Mon, 05 Sep 2022 05:16:50 -0700 (PDT)
X-Gm-Message-State: ACgBeo0uGuxF5BwB0g7jr7ZVyfp8F7zrn9Mx6kapYKoQC5K8daaSBFQ6
        bJT4Txl7/FcIUYvddXH9ppB7NG9+0EwijzsMtfs=
X-Google-Smtp-Source: AA6agR40YDbjCBMD8pN4NCXW0CVx2QQgBqWwvWtpwyBDPcmXuzTa4eE+iPHNNQ3+6JEkZXUvnbb50POAMQdpmxGhgw8=
X-Received: by 2002:a25:1c5:0:b0:6a9:3222:72e6 with SMTP id
 188-20020a2501c5000000b006a9322272e6mr3013991ybb.351.1662380210011; Mon, 05
 Sep 2022 05:16:50 -0700 (PDT)
MIME-Version: 1.0
References: <20220905101403.1435037-1-Jason@zx2c4.com> <87sfl6jbb3.wl-tiwai@suse.de>
In-Reply-To: <87sfl6jbb3.wl-tiwai@suse.de>
From:   "Jason A. Donenfeld" <Jason@zx2c4.com>
Date:   Mon, 5 Sep 2022 14:16:39 +0200
X-Gmail-Original-Message-ID: <CAHmME9oUtVgwtUY5afG5Yed1j6OVKwvLH=keCp63gDSOQRgDSA@mail.gmail.com>
Message-ID: <CAHmME9oUtVgwtUY5afG5Yed1j6OVKwvLH=keCp63gDSOQRgDSA@mail.gmail.com>
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
> When you load snd-usb-audio with dyndbg=+p option, does it show the
> new error message "Mismatched sample rate xxx"?

No.
