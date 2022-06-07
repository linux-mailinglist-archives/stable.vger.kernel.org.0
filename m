Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BEDEB53FAD2
	for <lists+stable@lfdr.de>; Tue,  7 Jun 2022 12:07:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240069AbiFGKHF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 06:07:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44888 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233877AbiFGKHE (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 06:07:04 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 69218EACD7;
        Tue,  7 Jun 2022 03:07:03 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 04495611E8;
        Tue,  7 Jun 2022 10:07:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 84B2EC385A5;
        Tue,  7 Jun 2022 10:07:00 +0000 (UTC)
Date:   Tue, 7 Jun 2022 11:06:56 +0100
From:   Catalin Marinas <catalin.marinas@arm.com>
To:     "Jason A. Donenfeld" <Jason@zx2c4.com>
Cc:     Phil Elwell <phil@raspberrypi.com>,
        Russell King - ARM Linux <linux@armlinux.org.uk>,
        Russell King <rmk+kernel@armlinux.org.uk>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Stephen Boyd <swboyd@chromium.org>,
        Ard Biesheuvel <ardb@kernel.org>,
        stable <stable@vger.kernel.org>
Subject: Re: [PATCH v2] ARM: initialize jump labels before setup_machine_fdt()
Message-ID: <Yp8jQG30OWOG9C4j@arm.com>
References: <8cc7ebe4-442b-a24b-9bb0-fce6e0425ee6@raspberrypi.com>
 <CAHmME9pL=g7Gz9-QOHnTosLHAL9YSPsW+CnE=9=u3iTQaFzomg@mail.gmail.com>
 <0f6458d7-037a-fa4d-8387-7de833288fb9@raspberrypi.com>
 <CAHmME9rJif3ydZuFJcSjPxkGMofZkbu2PXcHBF23OWVgGQ4c+A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHmME9rJif3ydZuFJcSjPxkGMofZkbu2PXcHBF23OWVgGQ4c+A@mail.gmail.com>
X-Spam-Status: No, score=-6.7 required=5.0 tests=BAYES_00,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Jason,

On Tue, Jun 07, 2022 at 10:51:41AM +0200, Jason A. Donenfeld wrote:
> On Tue, Jun 7, 2022 at 10:47 AM Phil Elwell <phil@raspberrypi.com> wrote:
> > Thanks for the quick response, but that doesn't work for me either. Let me say
> > again that I'm on a downstream kernel (rpi-5.15.y) so this may not be a
> > universal problem, but merging either of these fixing patches would be fatal for us.
> 
> Alright, thanks. And I'm guessing you don't currently have a problem
> *without* either of the fixing patches, because your device tree
> doesn't use rng-seed. Is that right?
> 
> In anycase, I sent in a revert to get all the static branch stuff out
> of stable -- https://lore.kernel.org/stable/20220607084005.666059-1-Jason@zx2c4.com/
> -- so the "urgency" of this should decrease and we can fix this as
> normal during the 5.19 cycle.

Since the above revert got queued in -stable, I assume you don't need
commit 73e2d827a501 ("arm64: Initialize jump labels before
setup_machine_fdt()") in stable either.

Do you plan to fix the crng_ready() static branch differently? If you
do, I'd like to revert the corresponding arm64 commit as well. It seems
to be harmless but I'd rather not keep it if no longer needed. So please
keep me updated whatever you decide.

Thanks.

-- 
Catalin
