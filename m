Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4E8BB540233
	for <lists+stable@lfdr.de>; Tue,  7 Jun 2022 17:15:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245030AbiFGPPP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 11:15:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41830 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343980AbiFGPPL (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 11:15:11 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1F47419F90;
        Tue,  7 Jun 2022 08:15:10 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id CA99BB82028;
        Tue,  7 Jun 2022 15:15:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9A88EC385A5;
        Tue,  7 Jun 2022 15:15:06 +0000 (UTC)
Authentication-Results: smtp.kernel.org;
        dkim=pass (1024-bit key) header.d=zx2c4.com header.i=@zx2c4.com header.b="neC6mfEh"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zx2c4.com; s=20210105;
        t=1654614905;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=DZuHJPQiHP4rHVjD/qdEgYv2Fzx196BxBOjguVbVCcE=;
        b=neC6mfEhGijcPrsAFaEp7MT1Tqxd3gNX3tzHAmZ72pv84FWPUjYU3mUlIn9f8lsZYtHLFU
        DWnnl9jlkH8w8ueGWLB2r4jyfeNhTqWS0wUaq0JdCCJ+U0WpvzLnFjyxcqi4+0g0q3xS2T
        rALUtAyqQT+0KDMitJ6ob08afivWcKE=
Received: by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id 6746b553 (TLSv1.3:AEAD-AES256-GCM-SHA384:256:NO);
        Tue, 7 Jun 2022 15:15:04 +0000 (UTC)
Date:   Tue, 7 Jun 2022 17:14:59 +0200
From:   "Jason A. Donenfeld" <Jason@zx2c4.com>
To:     Phil Elwell <phil@raspberrypi.com>
Cc:     Russell King - ARM Linux <linux@armlinux.org.uk>,
        Russell King <rmk+kernel@armlinux.org.uk>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Stephen Boyd <swboyd@chromium.org>,
        Ard Biesheuvel <ardb@kernel.org>,
        stable <stable@vger.kernel.org>
Subject: Re: [PATCH v2] ARM: initialize jump labels before setup_machine_fdt()
Message-ID: <Yp9rc1G6xfTSSUjF@zx2c4.com>
References: <8cc7ebe4-442b-a24b-9bb0-fce6e0425ee6@raspberrypi.com>
 <CAHmME9o6R2RRdwzB9f+464xH+Aw-9wx2dm=ZsQYFbTk_-66yJw@mail.gmail.com>
 <8c3fe744-0181-043a-3af9-dd00165a6356@raspberrypi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <8c3fe744-0181-043a-3af9-dd00165a6356@raspberrypi.com>
X-Spam-Status: No, score=-6.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hey again,

On Tue, Jun 07, 2022 at 10:15:27AM +0100, Phil Elwell wrote:
> On 07/06/2022 09:43, Jason A. Donenfeld wrote:
> > Hi Phil,
> > 
> > On Tue, Jun 7, 2022 at 10:29 AM Phil Elwell <phil@raspberrypi.com> wrote:
> >>
> >> This patch is fatal for me in the downstream Raspberry Pi kernel - it locks up
> >> on boot even before the earlycon output is available. Hacking jump_label_init to
> >> skip the jump_entry for "crng_is_ready" allows it to boot, but is likely to have
> >> consequences further down the line.
> > 
> > Also, reading this a few times, I'm not 100% sure I understand what
> > you did to hack around this and why that works. Think you could paste
> > your hackpatch just out of interest to the discussion (but obviously
> > not to be applied)?
> 
> This is the minimal version of my workaround patch that at least allows the 
> board to boot. Bear in mind that it was written with no previous knowledge of 
> jump labels and was arrived at by iteratively bisecting the list of jump_labels 
> until the first dangerous one was found, then later working out that there was 
> only one.

Looks like this patch fails due to CONFIG_STRICT_KERNEL_RWX.
Investigating deeper now, but that for starters seems to be the
differentiating factor between my prior test rig and one that reproduces
the error. I assume your raspi also sets CONFIG_STRICT_KERNEL_RWX.

Jason
