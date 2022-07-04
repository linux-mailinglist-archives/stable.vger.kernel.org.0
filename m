Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C02E956539E
	for <lists+stable@lfdr.de>; Mon,  4 Jul 2022 13:34:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233761AbiGDLeg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 4 Jul 2022 07:34:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45766 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230026AbiGDLef (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 4 Jul 2022 07:34:35 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ED240E88
        for <stable@vger.kernel.org>; Mon,  4 Jul 2022 04:34:34 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8DB9D614C8
        for <stable@vger.kernel.org>; Mon,  4 Jul 2022 11:34:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5459BC3411E;
        Mon,  4 Jul 2022 11:34:33 +0000 (UTC)
Authentication-Results: smtp.kernel.org;
        dkim=pass (1024-bit key) header.d=zx2c4.com header.i=@zx2c4.com header.b="TWB6GCLz"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zx2c4.com; s=20210105;
        t=1656934471;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=vHntRFwipq72a8KSy9j7yxIpOZ+D7/HXHEnMPcV3cuM=;
        b=TWB6GCLzv5mEacyen/1txgSWaXkVQc4cF4hOpnOk6tTc1Apy87yZqJbifkEP2ZbOpBKy8V
        oQQ3rm+r+ME2WBqJDC+TSNVJRHWE2sZ5E+BVeXtRuMezPW7l97r495W7RjWxAvcHtcl/gu
        EPWeoOv89q+wPzmKssEJdDxp2oPRUgc=
Received: by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id 704fd48c (TLSv1.3:AEAD-AES256-GCM-SHA384:256:NO);
        Mon, 4 Jul 2022 11:34:31 +0000 (UTC)
Date:   Mon, 4 Jul 2022 13:34:22 +0200
From:   "Jason A. Donenfeld" <Jason@zx2c4.com>
To:     Michael Ellerman <michael@ellerman.id.au>
Cc:     Sachin Sant <sachinp@linux.ibm.com>, benh@kernel.crashing.org,
        paulus@samba.org, linuxppc-dev@lists.ozlabs.org,
        stable@vger.kernel.org
Subject: Re: [PATCH] powerpc/powernv: delay rng of node creation until later
 in boot
Message-ID: <YsLQPpAY6ZZHCOAI@zx2c4.com>
References: <Yr2PQSZWVtr+Y7a2@zx2c4.com>
 <20220630121654.1939181-1-Jason@zx2c4.com>
 <8A9A296D-D7BD-42BE-AB32-C951C29E4C40@linux.ibm.com>
 <YsAg/hixHvdxnWNL@zx2c4.com>
 <2B9FC5ED-D6B8-4632-ACA4-7CF508EE9C46@ellerman.id.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <2B9FC5ED-D6B8-4632-ACA4-7CF508EE9C46@ellerman.id.au>
X-Spam-Status: No, score=-6.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Michael,

On Mon, Jul 04, 2022 at 09:14:32PM +1000, Michael Ellerman wrote:
> 
> 
> On 2 July 2022 8:42:06 pm AEST, "Jason A. Donenfeld" <Jason@zx2c4.com> wrote:
> >Hi Benjamin, Paul,
> >
> >On Thu, Jun 30, 2022 at 07:24:05PM +0530, Sachin Sant wrote:
> >> > On 30-Jun-2022, at 5:46 PM, Jason A. Donenfeld <Jason@zx2c4.com> wrote:
> >> > 
> >> > The of node for the rng must be created much later in boot. Otherwise it
> >> > tries to connect to a parent that doesn't yet exist, resulting on this
> >> > splat:
> >> > 
> >> > [    0.000478] kobject: '(null)' ((____ptrval____)): is not initialized, yet kobject_get() is being called.
> >> > [    0.002925] [c000000002a0fb30] [c00000000073b0bc] kobject_get+0x8c/0x100 (unreliable)
> >> > [    0.003071] [c000000002a0fba0] [c00000000087e464] device_add+0xf4/0xb00
> >> > [    0.003194] [c000000002a0fc80] [c000000000a7f6e4] of_device_add+0x64/0x80
> >> > [    0.003321] [c000000002a0fcb0] [c000000000a800d0] of_platform_device_create_pdata+0xd0/0x1b0
> >> > [    0.003476] [c000000002a0fd00] [c00000000201fa44] pnv_get_random_long_early+0x240/0x2e4
> >> > [    0.003623] [c000000002a0fe20] [c000000002060c38] random_init+0xc0/0x214
> >> > 
> >> > This patch fixes the issue by doing the of node creation inside of
> >> > machine_subsys_initcall.
> >> > 
> >> > Fixes: f3eac426657d ("powerpc/powernv: wire up rng during setup_arch")
> >> > Cc: stable@vger.kernel.org
> >> > Cc: Michael Ellerman <mpe@ellerman.id.au>
> >> > Reported-by: Sachin Sant <sachinp@linux.ibm.com>
> >> > Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
> >> > ---
> >> 
> >> Thanks Jason for the patch. This fixes the reported problem for me.
> >> 
> >> Tested-by: Sachin Sant <sachinp@linux.ibm.com>
> >> 
> >> - Sachin
> >
> >It sounds like Michael is on vacation for a few weeks. Think you could
> >queue this up so we can get POWER8 booting again?
> 
> It doesn't break booting for me, but it is an ugly splat.
> 
> I'll pick it up into fixes.
> 
> I think it's more correct to say the "platform device creation" causes the problem, so I'll update the change log to say that.

Sounds good. Thank you!

Jason
