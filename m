Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C4189536C2E
	for <lists+stable@lfdr.de>; Sat, 28 May 2022 11:57:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233514AbiE1J5L (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 28 May 2022 05:57:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46350 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231189AbiE1J5K (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 28 May 2022 05:57:10 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B7A50220C6;
        Sat, 28 May 2022 02:57:09 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 59F0260C74;
        Sat, 28 May 2022 09:57:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CED2AC34100;
        Sat, 28 May 2022 09:57:07 +0000 (UTC)
Authentication-Results: smtp.kernel.org;
        dkim=pass (1024-bit key) header.d=zx2c4.com header.i=@zx2c4.com header.b="lLm2GUUB"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zx2c4.com; s=20210105;
        t=1653731826;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=q7RfA7PtTbBS4zXqZjj854mn3I9tYZOlp3as/KmiSyM=;
        b=lLm2GUUBz3B3s74kE3lWYjQnM5HSRYwtKdXTyoTp0IwfDVNPDmg5QWYtd12CuvykjPsXAF
        D8bEbdUqCoAUd4HQZSWRM5frngkc+92EJ/Gkp40JGM7fdNVTKoT8cI/VgMnQ2brDdd83/+
        0o4SWmvR9q8McTiP7pXczZer0JMz+4c=
Received: by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id 0a18bd6c (TLSv1.3:AEAD-AES256-GCM-SHA384:256:NO);
        Sat, 28 May 2022 09:57:05 +0000 (UTC)
Date:   Sat, 28 May 2022 11:57:01 +0200
From:   "Jason A. Donenfeld" <Jason@zx2c4.com>
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        herbert@gondor.apana.org.au, gaochao <gaochao49@huawei.com>,
        Ard Biesheuvel <ardb@kernel.org>, stable@vger.kernel.org
Subject: Re: [PATCH crypto v2] crypto: blake2s - remove shash module
Message-ID: <YpHx7arH4lLaZuhm@zx2c4.com>
References: <YpCGQvpirQWaAiRF@zx2c4.com>
 <20220527081106.63227-1-Jason@zx2c4.com>
 <YpGeIT1KHv9QwF4X@sol.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <YpGeIT1KHv9QwF4X@sol.localdomain>
X-Spam-Status: No, score=-6.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Eric,

On Fri, May 27, 2022 at 08:59:29PM -0700, Eric Biggers wrote:
> On Fri, May 27, 2022 at 10:11:06AM +0200, Jason A. Donenfeld wrote:
> > BLAKE2s has no use as an shash, with no users of it.
> 
> "no use" => "no known current use".

Ack.

> This doesn't compile on arm, since blake2s_compress_generic() isn't defined.

Grr, thanks. I'll fix that and verify before sending v3.

> Also, the wrong value is being passed for the 'inc' argument.

Are you sure? Not sure I'm seeing what you are on first glance.

> 2048 iterations is also a lot.  Doing a lot of iterations here doesn't
> meaningfully increase the test coverage.

For symmetric things like this, yeah, you're right. I'll reduce that to
a more modest 100 or something.

> And please run checkpatch; those are some very long lines :-(

Ack.

Jason
