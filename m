Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 150A953F869
	for <lists+stable@lfdr.de>; Tue,  7 Jun 2022 10:43:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238391AbiFGIne (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 04:43:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50026 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238383AbiFGIna (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 04:43:30 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8A4A5D029F;
        Tue,  7 Jun 2022 01:43:28 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 266846171D;
        Tue,  7 Jun 2022 08:43:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 36951C34115;
        Tue,  7 Jun 2022 08:43:27 +0000 (UTC)
Authentication-Results: smtp.kernel.org;
        dkim=pass (1024-bit key) header.d=zx2c4.com header.i=@zx2c4.com header.b="FNTLJmqd"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zx2c4.com; s=20210105;
        t=1654591405;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=VZ4F390wwgyLtG+L0iznIIemwDHW51GnqRnFSuFUrrk=;
        b=FNTLJmqdT1awE4b4uJ+UuumQtcdlfCS5DhaEl4nraqGKJwI0I5Ibqm1MC0+PwrYbt/WXqI
        edw2mty2xN5tko8gTyA55xilIwvOtmCqK4EuAyUFeBjciA+6yic6Aw4FJaF42m7LdoxtQc
        m0vQHJHIDXsydEtq0aWl+OGCg1473P0=
Received: by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id 03e1e244 (TLSv1.3:AEAD-AES256-GCM-SHA384:256:NO);
        Tue, 7 Jun 2022 08:43:25 +0000 (UTC)
Received: by mail-yw1-f180.google.com with SMTP id 00721157ae682-300628e76f3so167419887b3.12;
        Tue, 07 Jun 2022 01:43:24 -0700 (PDT)
X-Gm-Message-State: AOAM533TtU+5OZA0vptZziOIowv8z4I4/wFIR/J1J91rQuumQ1G6VoLG
        HDUCro4vVp6wfXKvgkVvqNPZUpcL/B1QZvStsZg=
X-Google-Smtp-Source: ABdhPJyWTewz9Z7+XYW4cyrP2wsCWmGDoNBMtTnBsoWJike0+n9TU9TFY4Q7rnB4TEb9e40R805vSPnPblB2OnnQpxQ=
X-Received: by 2002:a81:6c89:0:b0:30c:4c36:f9c7 with SMTP id
 h131-20020a816c89000000b0030c4c36f9c7mr30236343ywc.485.1654591403328; Tue, 07
 Jun 2022 01:43:23 -0700 (PDT)
MIME-Version: 1.0
References: <8cc7ebe4-442b-a24b-9bb0-fce6e0425ee6@raspberrypi.com>
In-Reply-To: <8cc7ebe4-442b-a24b-9bb0-fce6e0425ee6@raspberrypi.com>
From:   "Jason A. Donenfeld" <Jason@zx2c4.com>
Date:   Tue, 7 Jun 2022 10:43:12 +0200
X-Gmail-Original-Message-ID: <CAHmME9o6R2RRdwzB9f+464xH+Aw-9wx2dm=ZsQYFbTk_-66yJw@mail.gmail.com>
Message-ID: <CAHmME9o6R2RRdwzB9f+464xH+Aw-9wx2dm=ZsQYFbTk_-66yJw@mail.gmail.com>
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

On Tue, Jun 7, 2022 at 10:29 AM Phil Elwell <phil@raspberrypi.com> wrote:
>
> This patch is fatal for me in the downstream Raspberry Pi kernel - it locks up
> on boot even before the earlycon output is available. Hacking jump_label_init to
> skip the jump_entry for "crng_is_ready" allows it to boot, but is likely to have
> consequences further down the line.

Also, reading this a few times, I'm not 100% sure I understand what
you did to hack around this and why that works. Think you could paste
your hackpatch just out of interest to the discussion (but obviously
not to be applied)?

Jason
