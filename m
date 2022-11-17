Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7F4B462CFA6
	for <lists+stable@lfdr.de>; Thu, 17 Nov 2022 01:31:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232664AbiKQAbk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 16 Nov 2022 19:31:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60046 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233438AbiKQAba (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 16 Nov 2022 19:31:30 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 606AF57B66;
        Wed, 16 Nov 2022 16:31:29 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id A6E10CE1D41;
        Thu, 17 Nov 2022 00:31:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 257E8C433D6;
        Thu, 17 Nov 2022 00:31:25 +0000 (UTC)
Authentication-Results: smtp.kernel.org;
        dkim=pass (1024-bit key) header.d=zx2c4.com header.i=@zx2c4.com header.b="OsPtVHcl"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zx2c4.com; s=20210105;
        t=1668645083;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=1kowHhgLHtQV/Mbbv3Y03475q28N42puJJFWSh7Q+0Y=;
        b=OsPtVHcl+Ttf7qcvdbQRy54Q7krssaPwEj4CAacIL0gkKPOEjLSt3GMj34IqYUXtAVF3S7
        DH8beOWC4jkynj6FSH7yZUmQGs5Fw42usgY0ZiXX6MjHw4OClUogNdiwSvMKwctnPP08vY
        ZYiV21Z12dudVkPxBjr8VzhDcsnCBG8=
Received: by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id 08511a45 (TLSv1.3:TLS_AES_256_GCM_SHA384:256:NO);
        Thu, 17 Nov 2022 00:31:23 +0000 (UTC)
Date:   Thu, 17 Nov 2022 01:31:20 +0100
From:   "Jason A. Donenfeld" <Jason@zx2c4.com>
To:     Ard Biesheuvel <ardb@kernel.org>
Cc:     linux-efi@vger.kernel.org, stable@vger.kernel.org,
        Ilias Apalodimas <ilias.apalodimas@linaro.org>
Subject: Re: [PATCH] efi: random: zero out secret after use and do not take
 minimum
Message-ID: <Y3WA2BU0vtsOu6pJ@zx2c4.com>
References: <20221116200555.2046552-1-Jason@zx2c4.com>
 <CAMj1kXHJ4vQ=2dnJCAR1eOaM9FPvokYb_DODu+3MAR7XMMQ7fw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CAMj1kXHJ4vQ=2dnJCAR1eOaM9FPvokYb_DODu+3MAR7XMMQ7fw@mail.gmail.com>
X-Spam-Status: No, score=-6.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Nov 16, 2022 at 10:44:20PM +0100, Ard Biesheuvel wrote:
> On Wed, 16 Nov 2022 at 21:06, Jason A. Donenfeld <Jason@zx2c4.com> wrote:
> >
> > Taking the minimum is wrong, if the bootloader or EFI stub is actually
> > passing on a bunch of bytes that it expects the kernel to hash itself.
> 
> We still need some kind of limit, just so things don't explode if
> seed->size is bogus.

Alright, let's just say 1k then. Will send a v2.

Jason
