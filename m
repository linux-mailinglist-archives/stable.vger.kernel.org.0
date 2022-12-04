Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2AA80641F30
	for <lists+stable@lfdr.de>; Sun,  4 Dec 2022 20:14:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230371AbiLDTOo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 4 Dec 2022 14:14:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36668 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230297AbiLDTOn (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 4 Dec 2022 14:14:43 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1D571DDB;
        Sun,  4 Dec 2022 11:14:42 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0FF1E60EE2;
        Sun,  4 Dec 2022 19:14:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 95BD1C433D6;
        Sun,  4 Dec 2022 19:14:38 +0000 (UTC)
Authentication-Results: smtp.kernel.org;
        dkim=pass (1024-bit key) header.d=zx2c4.com header.i=@zx2c4.com header.b="AVlqJxBZ"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zx2c4.com; s=20210105;
        t=1670181276;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=c8/OiJnXeAAW5RqxKEnU+8MYk+oKnoN126NTwylqEOY=;
        b=AVlqJxBZck/d09jS3B5UpI2Cmq3WNR3sPRLYsHKUEKEYsphHmwNUkWG+y4tFoly504I6E4
        4CQErqsqR9TZgqsZ7TNB98QdAimM/SBYbGFGDCNyNHzS65w8vLT+DvPVuHPQ1LU7wyQYFO
        sND2duUyxwu2yrP9aleXVOxflJRCwvs=
Received: by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id a74ea920 (TLSv1.3:TLS_AES_256_GCM_SHA384:256:NO);
        Sun, 4 Dec 2022 19:14:35 +0000 (UTC)
Date:   Sun, 4 Dec 2022 20:14:31 +0100
From:   "Jason A. Donenfeld" <Jason@zx2c4.com>
To:     Jarkko Sakkinen <jarkko@kernel.org>
Cc:     Vlastimil Babka <vbabka@suse.cz>,
        Jan =?utf-8?B?RMSFYnJvxZs=?= <jsd@semihalf.com>,
        linux-integrity@vger.kernel.org, peterhuewe@gmx.de, jgg@ziepe.ca,
        gregkh@linuxfoundation.org, arnd@arndb.de, rrangel@chromium.org,
        timvp@google.com, apronin@google.com, mw@semihalf.com,
        upstream@semihalf.com, linux-kernel@vger.kernel.org,
        linux-crypto@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH v3] char: tpm: Protect tpm_pm_suspend with locks
Message-ID: <Y4zxly0XABDg1OhU@zx2c4.com>
References: <20221128195651.322822-1-Jason@zx2c4.com>
 <Y4zTnhgunXuwVXHe@kernel.org>
 <Y4zUotH0UeHlRBGP@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <Y4zUotH0UeHlRBGP@kernel.org>
X-Spam-Status: No, score=-6.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sun, Dec 04, 2022 at 05:10:58PM +0000, Jarkko Sakkinen wrote:
> On Sun, Dec 04, 2022 at 05:06:41PM +0000, Jarkko Sakkinen wrote:
> > On Mon, Nov 28, 2022 at 08:56:51PM +0100, Jason A. Donenfeld wrote:
> > > From: Jan Dabros <jsd@semihalf.com>
> > > 
> > > Currently tpm transactions are executed unconditionally in
> > > tpm_pm_suspend() function, which may lead to races with other tpm
> > > accessors in the system. Specifically, the hw_random tpm driver makes
> > > use of tpm_get_random(), and this function is called in a loop from a
> > > kthread, which means it's not frozen alongside userspace, and so can
> > > race with the work done during system suspend:
> > > 
> > > [    3.277834] tpm tpm0: tpm_transmit: tpm_recv: error -52
> > > [    3.278437] tpm tpm0: invalid TPM_STS.x 0xff, dumping stack for forensics
> > > [    3.278445] CPU: 0 PID: 1 Comm: init Not tainted 6.1.0-rc5+ #135
> > > [    3.278450] Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.0-20220807_005459-localhost 04/01/2014
> > > [    3.278453] Call Trace:
> > > [    3.278458]  <TASK>
> > > [    3.278460]  dump_stack_lvl+0x34/0x44
> > > [    3.278471]  tpm_tis_status.cold+0x19/0x20
> > > [    3.278479]  tpm_transmit+0x13b/0x390
> > > [    3.278489]  tpm_transmit_cmd+0x20/0x80
> > > [    3.278496]  tpm1_pm_suspend+0xa6/0x110
> > > [    3.278503]  tpm_pm_suspend+0x53/0x80
> > > [    3.278510]  __pnp_bus_suspend+0x35/0xe0
> > > [    3.278515]  ? pnp_bus_freeze+0x10/0x10
> > > [    3.278519]  __device_suspend+0x10f/0x350
> > > 
> > > Fix this by calling tpm_try_get_ops(), which itself is a wrapper around
> > > tpm_chip_start(), but takes the appropriate mutex.
> > > 
> > > Signed-off-by: Jan Dabros <jsd@semihalf.com>
> > > Reported-by: Vlastimil Babka <vbabka@suse.cz>
> > > Tested-by: Jason A. Donenfeld <Jason@zx2c4.com>
> > > Tested-by: Vlastimil Babka <vbabka@suse.cz>
> > > Link: https://lore.kernel.org/all/c5ba47ef-393f-1fba-30bd-1230d1b4b592@suse.cz/
> > > Cc: stable@vger.kernel.org
> > > Fixes: e891db1a18bf ("tpm: turn on TPM on suspend for TPM 1.x")
> > > [Jason: reworked commit message, added metadata]
> > > Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
> > > ---
> > >  drivers/char/tpm/tpm-interface.c | 5 +++--
> > >  1 file changed, 3 insertions(+), 2 deletions(-)
> > > 
> > > diff --git a/drivers/char/tpm/tpm-interface.c b/drivers/char/tpm/tpm-interface.c
> > > index 1621ce818705..d69905233aff 100644
> > > --- a/drivers/char/tpm/tpm-interface.c
> > > +++ b/drivers/char/tpm/tpm-interface.c
> > > @@ -401,13 +401,14 @@ int tpm_pm_suspend(struct device *dev)
> > >  	    !pm_suspend_via_firmware())
> > >  		goto suspended;
> > >  
> > > -	if (!tpm_chip_start(chip)) {
> > > +	rc = tpm_try_get_ops(chip);
> > > +	if (!rc) {
> > >  		if (chip->flags & TPM_CHIP_FLAG_TPM2)
> > >  			tpm2_shutdown(chip, TPM2_SU_STATE);
> > >  		else
> > >  			rc = tpm1_pm_suspend(chip, tpm_suspend_pcr);
> > >  
> > > -		tpm_chip_stop(chip);
> > > +		tpm_put_ops(chip);
> > >  	}
> > >  
> > >  suspended:
> > > -- 
> > > 2.38.1
> > > 
> > 
> > Hi, sorry for the latency.
> > 
> > Reviewed-by: Jarkko Sakkinen <jarkko@kernel.org>
> 
> Applied to  git://git.kernel.org/pub/scm/linux/kernel/git/jarkko/linux-tpmdd.git

Oh thank goodness. You'll send this in for rc8 today?

Jason
