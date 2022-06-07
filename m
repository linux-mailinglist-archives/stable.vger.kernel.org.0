Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 06D8D53F8A3
	for <lists+stable@lfdr.de>; Tue,  7 Jun 2022 10:52:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238453AbiFGIv7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 04:51:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51230 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237656AbiFGIv6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 04:51:58 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C6D10D6819;
        Tue,  7 Jun 2022 01:51:57 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1BC7961751;
        Tue,  7 Jun 2022 08:51:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 44206C34119;
        Tue,  7 Jun 2022 08:51:56 +0000 (UTC)
Authentication-Results: smtp.kernel.org;
        dkim=pass (1024-bit key) header.d=zx2c4.com header.i=@zx2c4.com header.b="VaEEqfo2"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zx2c4.com; s=20210105;
        t=1654591913;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=6g6+8Ruy1eC3mY4X+0ZwjQnZhj0RCq9Li4nXIU0hk1E=;
        b=VaEEqfo2ryZDpLOYbqy03slCBPDcz+0rV3RXndesPN9s133iYXEBbuZG6G22jKllrX68RS
        Hn8qcMr/btCR15OmOz09lxyUMVQ0WLkJ9sHGQc5OF8LbJLlwvAKNXLKZOR48V5TRKgXAZQ
        6A6PDYfMgLaDdzL1JPXii7ynGbTrVrg=
Received: by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id d04700b3 (TLSv1.3:AEAD-AES256-GCM-SHA384:256:NO);
        Tue, 7 Jun 2022 08:51:53 +0000 (UTC)
Received: by mail-yb1-f169.google.com with SMTP id r1so1421643ybd.4;
        Tue, 07 Jun 2022 01:51:52 -0700 (PDT)
X-Gm-Message-State: AOAM533+Nbm74GpmtU39dl2MA0BoOKc5vJbBrXcZrTFiwgnC+/qi1To1
        FQjTxVdMn2sW0Kuear8ra+GEjtZDW2FjUiAiujY=
X-Google-Smtp-Source: ABdhPJx/0jo73YmT00K9s4V5Uk8ug6NH5MZS357wEqwyV7CIL0wSWjYgDJqdLxWPuXQtriXQZzWf2IbxBjDYFlTZULI=
X-Received: by 2002:a25:83c2:0:b0:65c:bc75:800b with SMTP id
 v2-20020a2583c2000000b0065cbc75800bmr28996456ybm.373.1654591912021; Tue, 07
 Jun 2022 01:51:52 -0700 (PDT)
MIME-Version: 1.0
References: <8cc7ebe4-442b-a24b-9bb0-fce6e0425ee6@raspberrypi.com>
 <CAHmME9pL=g7Gz9-QOHnTosLHAL9YSPsW+CnE=9=u3iTQaFzomg@mail.gmail.com> <0f6458d7-037a-fa4d-8387-7de833288fb9@raspberrypi.com>
In-Reply-To: <0f6458d7-037a-fa4d-8387-7de833288fb9@raspberrypi.com>
From:   "Jason A. Donenfeld" <Jason@zx2c4.com>
Date:   Tue, 7 Jun 2022 10:51:41 +0200
X-Gmail-Original-Message-ID: <CAHmME9rJif3ydZuFJcSjPxkGMofZkbu2PXcHBF23OWVgGQ4c+A@mail.gmail.com>
Message-ID: <CAHmME9rJif3ydZuFJcSjPxkGMofZkbu2PXcHBF23OWVgGQ4c+A@mail.gmail.com>
Subject: Re: [PATCH v2] ARM: initialize jump labels before setup_machine_fdt()
To:     Phil Elwell <phil@raspberrypi.com>
Cc:     Russell King - ARM Linux <linux@armlinux.org.uk>,
        Russell King <rmk+kernel@armlinux.org.uk>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Stephen Boyd <swboyd@chromium.org>,
        Ard Biesheuvel <ardb@kernel.org>,
        stable <stable@vger.kernel.org>
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

Hi Phil,

On Tue, Jun 7, 2022 at 10:47 AM Phil Elwell <phil@raspberrypi.com> wrote:
> Thanks for the quick response, but that doesn't work for me either. Let me say
> again that I'm on a downstream kernel (rpi-5.15.y) so this may not be a
> universal problem, but merging either of these fixing patches would be fatal for us.

Alright, thanks. And I'm guessing you don't currently have a problem
*without* either of the fixing patches, because your device tree
doesn't use rng-seed. Is that right?

In anycase, I sent in a revert to get all the static branch stuff out
of stable -- https://lore.kernel.org/stable/20220607084005.666059-1-Jason@zx2c4.com/
-- so the "urgency" of this should decrease and we can fix this as
normal during the 5.19 cycle. But with that said, I do want to get
this fixed as soon as possible still. I'll be back at my desk tonight
and will finally have access to real hardware again. Are you hitting
this by loading a 32bit kernel on a raspi4? Or running a 32bit kernel
on the raspi1? Or some other combo?

Jason
