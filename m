Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3B5AE5539B2
	for <lists+stable@lfdr.de>; Tue, 21 Jun 2022 20:48:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351385AbiFUSsF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 21 Jun 2022 14:48:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46524 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229877AbiFUSsB (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 21 Jun 2022 14:48:01 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 059E1D134;
        Tue, 21 Jun 2022 11:47:58 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 93C85616F7;
        Tue, 21 Jun 2022 18:47:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 60DAEC341C4;
        Tue, 21 Jun 2022 18:47:56 +0000 (UTC)
Authentication-Results: smtp.kernel.org;
        dkim=pass (1024-bit key) header.d=zx2c4.com header.i=@zx2c4.com header.b="ezJM0ZjI"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zx2c4.com; s=20210105;
        t=1655837274;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=GlYZcKElYGV2iK1XBEvZIDxk1bR0rIwRS2M0K6D36VU=;
        b=ezJM0ZjIbTQHLkvi2SKGBexDkAX+8Tho6UJYFkD/LP5yOWR8DsK1Dbk/0lKbikmiUNXzt+
        G73pxPS2hFbiO+xHT3ApWGGZ92oD+DqLcuJINJtYbSgru5ANj20iy+6CuVVwBfq8Of/RjH
        5A70B1EJYD7o3KbIFH8mqJiuzRSTcQY=
Received: by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id 415ea671 (TLSv1.3:AEAD-AES256-GCM-SHA384:256:NO);
        Tue, 21 Jun 2022 18:47:54 +0000 (UTC)
Date:   Tue, 21 Jun 2022 20:47:52 +0200
From:   "Jason A. Donenfeld" <Jason@zx2c4.com>
To:     Christophe Leroy <christophe.leroy@csgroup.eu>
Cc:     Michael Ellerman <mpe@ellerman.id.au>,
        "linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>,
        LKML <linux-kernel@vger.kernel.org>,
        stable <stable@vger.kernel.org>
Subject: Re: [PATCH v5] powerpc/powernv: wire up rng during setup_arch
Message-ID: <YrISWLwm8m7OPFom@zx2c4.com>
References: <20220620124531.78075-1-Jason@zx2c4.com>
 <20220621140849.127227-1-Jason@zx2c4.com>
 <246d8bf0-2bee-7e1b-e0af-408920ece309@csgroup.eu>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <246d8bf0-2bee-7e1b-e0af-408920ece309@csgroup.eu>
X-Spam-Status: No, score=-6.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Christophe,

On Tue, Jun 21, 2022 at 06:33:11PM +0000, Christophe Leroy wrote:
> Le 21/06/2022 à 16:08, Jason A. Donenfeld a écrit :
> > The platform's RNG must be available before random_init() in order to be
> > useful for initial seeding, which in turn means that it needs to be
> > called from setup_arch(), rather than from an init call. Fortunately,
> > each platform already has a setup_arch function pointer, which means we
> > can wire it up that way. Complicating things, however, is that POWER8
> > systems need some per-cpu state and kmalloc, which isn't available at
> > this stage. So we split things up into an early phase and a later
> > opportunistic phase. This commit also removes some noisy log messages
> > that don't add much.
> 
> Regarding the kmalloc(), I have not looked at it in details, but usually 
> you can use memblock_alloc() when kmalloc is not available yet.

That seems a bit excessive, especially as those allocations are long
lived. And we don't even *need* it that early, but just before
random_init(). Michael is running this v5 on the test rig overnight, so
we'll learn in the Australian morning whether this finally did the trick
(I hope).

Jason
