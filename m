Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E5BDB65F6CD
	for <lists+stable@lfdr.de>; Thu,  5 Jan 2023 23:30:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235430AbjAEWa1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 5 Jan 2023 17:30:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59388 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236046AbjAEWaD (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 5 Jan 2023 17:30:03 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3D57910D6;
        Thu,  5 Jan 2023 14:29:54 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E4976B81C0A;
        Thu,  5 Jan 2023 22:29:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2B0FDC433EF;
        Thu,  5 Jan 2023 22:29:50 +0000 (UTC)
Authentication-Results: smtp.kernel.org;
        dkim=pass (1024-bit key) header.d=zx2c4.com header.i=@zx2c4.com header.b="QpBB4pwU"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zx2c4.com; s=20210105;
        t=1672957786;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=mMldSeIA7qWoDB1sx6P/v3uvnTNOCNV9Im/Ue9FmzFU=;
        b=QpBB4pwU2wEZ2yl5XVSF8mYLnd3NmfAVe/m2DxszOjivDyR1t+oAmAjfXb9/LnZft8M8Sm
        tfyMpwX8w1ub8ByD/S+prDNIPhgnJLkTf3MoS+QWRKds0cASzWvEhSX/Bk+RZunpaPP8+3
        zaDdmKSp9EPrhaXg2F5QU1PKN05ae+s=
Received: by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id 843725ac (TLSv1.3:TLS_AES_256_GCM_SHA384:256:NO);
        Thu, 5 Jan 2023 22:29:46 +0000 (UTC)
Date:   Thu, 5 Jan 2023 23:29:43 +0100
From:   "Jason A. Donenfeld" <Jason@zx2c4.com>
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     Thorsten Leemhuis <regressions@leemhuis.info>,
        James Bottomley <James.Bottomley@hansenpartnership.com>,
        Peter Huewe <peterhuewe@gmx.de>,
        Jarkko Sakkinen <jarkko@kernel.org>,
        Jason Gunthorpe <jgg@ziepe.ca>, Jan Dabros <jsd@semihalf.com>,
        regressions@lists.linux.dev, LKML <linux-kernel@vger.kernel.org>,
        linux-integrity@vger.kernel.org,
        Dominik Brodowski <linux@dominikbrodowski.net>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Johannes Altmanninger <aclopte@gmail.com>,
        stable@vger.kernel.org
Subject: Re: [PATCH] tpm: Disable hwrng for TPM 1 if PM_SLEEP is enabled
Message-ID: <Y7dPV5BK6jk1KvX+@zx2c4.com>
References: <370a2808-a19b-b512-4cd3-72dc69dfe8b0@suse.cz>
 <20230105144742.3219571-1-Jason@zx2c4.com>
 <CAHk-=whxaSHcHeo10JGz3EMJZBfC1LarcrerLos7uHbE1URhtQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CAHk-=whxaSHcHeo10JGz3EMJZBfC1LarcrerLos7uHbE1URhtQ@mail.gmail.com>
X-Spam-Status: No, score=-6.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Jan 05, 2023 at 01:58:48PM -0800, Linus Torvalds wrote:
> On Thu, Jan 5, 2023 at 6:48 AM Jason A. Donenfeld <Jason@zx2c4.com> wrote:
> >
> > TPM 1's support for its hardware RNG is broken across system suspends,
> > due to races or locking issues or something else that haven't been
> > diagnosed or fixed yet. These issues prevent the system from actually
> > suspending. So disable the driver in this case. Later, when this is
> > fixed properly, we can remove this.
> 
> How about just keeping it enabled, but not making it a fatal error if
> the TPM saving doesn't work? IOW, just print the warning, and then
> "return 0" from the suspend function.

You're right that returning 0 from the pm notifier would make the
problem that users actually care about -- laptop doesn't sleep when you
close the lid -- go away.

From a random.c perspective, the RNG is already initialized when the
driver loads, which will be before suspend bricks the driver. So even if
the behavior afterwards is a buggy driver handing all zeros to random.c,
it won't really matter much; random.c can deal with that
cryptographically. I have no idea if this is actually the case with the
driver's error condition. But if it is, it's good that it doesn't
matter.

So okay, I'll roll a patch to do that when I get home. I'm writing on my
phone now, but from memory it's just changing a 'return rc;' into
'return 0;'.

Then the TPM folks can fix the underlying issue at their leisure
whenever.

Jason
