Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6E7F254731A
	for <lists+stable@lfdr.de>; Sat, 11 Jun 2022 11:20:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230191AbiFKJUP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 11 Jun 2022 05:20:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50662 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229616AbiFKJUO (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 11 Jun 2022 05:20:14 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C00BD6443;
        Sat, 11 Jun 2022 02:20:12 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id DB3BFCE3357;
        Sat, 11 Jun 2022 09:20:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 57F3DC34116;
        Sat, 11 Jun 2022 09:20:08 +0000 (UTC)
Authentication-Results: smtp.kernel.org;
        dkim=pass (1024-bit key) header.d=zx2c4.com header.i=@zx2c4.com header.b="SWySVg6d"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zx2c4.com; s=20210105;
        t=1654939206;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=d1nu/8OrD5lJ8ZJkrInQDHzhV+PXmqlwAeVMBiKufIU=;
        b=SWySVg6d9micIJRfHNSibZVmlDb6uPBkrfeQSdJ+hOzYAyGjsUJysA7fRpz/b2z1dbn3ID
        37ESovt/x+4UHZpQJM4EEHim+HuvggQyP1K/UFhIQymd0J7JH3x3ll6kabpCuleEwIPtbi
        EgfNsSx2cNfbQkC89CL5tJuEWuOBmqA=
Received: by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id 1cef741a (TLSv1.3:AEAD-AES256-GCM-SHA384:256:NO);
        Sat, 11 Jun 2022 09:20:06 +0000 (UTC)
Date:   Sat, 11 Jun 2022 11:20:01 +0200
From:   "Jason A. Donenfeld" <Jason@zx2c4.com>
To:     Christophe Leroy <christophe.leroy@csgroup.eu>
Cc:     "linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: Re: [PATCH] powerpc/rng: wire up during setup_arch
Message-ID: <YqReQbGQ3G5JxSgP@zx2c4.com>
References: <20220611081114.449165-1-Jason@zx2c4.com>
 <956d2faa-4dae-fc75-2c03-387c77806f2b@csgroup.eu>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <956d2faa-4dae-fc75-2c03-387c77806f2b@csgroup.eu>
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

On Sat, Jun 11, 2022 at 09:16:24AM +0000, Christophe Leroy wrote:
> Le 11/06/2022 à 10:11, Jason A. Donenfeld a écrit :
> > The platform's RNG must be available before random_init() in order to be
> > useful for initial seeding, which in turn means that it needs to be
> > called from setup_arch(), rather than from an init call. Fortunately,
> > each platform already has a setup_arch function pointer, which means
> > it's easy to wire this up for each of the three platforms that have an
> > RNG. This commit also removes some noisy log messages that don't add
> > much.
> 
> Can't we use one of the machine initcalls for that ?
> Like machine_early_initcall() or machine_arch_initcall() ?

No, unfortunately. I tried this, and it's still too late. This must be
done in setup_arch().

> Today it is using  machine_subsys_initcall() and you didn't remove it. 
> It means rng_init() will be called twice. Is that ok ?

I did remove the calls to machine_subsys_initcall(). I just double
checked:

zx2c4@thinkpad ~/Projects/random-linux/arch/powerpc $ rg machine_subsys_initcall platforms/*/rng.c
zx2c4@thinkpad ~/Projects/random-linux/arch/powerpc $

Jason
