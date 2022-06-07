Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 541A153FA73
	for <lists+stable@lfdr.de>; Tue,  7 Jun 2022 11:55:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239483AbiFGJz2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 05:55:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36994 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240488AbiFGJwg (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 05:52:36 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 57E0928E2C
        for <stable@vger.kernel.org>; Tue,  7 Jun 2022 02:52:10 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 1B171B81E78
        for <stable@vger.kernel.org>; Tue,  7 Jun 2022 09:52:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BBA9AC385A5;
        Tue,  7 Jun 2022 09:52:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654595527;
        bh=st9d+ews4SipjOs7MHEvjEbFqfp+XQeFZgIor1p4zp0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=pbKt2p3QDUwWUSFbDpSDXwJDcCohQV2YZJ5QfY2mztLNRul8N9zSWLSWtGapTiPYe
         K1+XZJ3RIgGdWYneh8xsbzcPLnwLsg1YnuUDSp0DNGqiTv/9WzDs7fQuUINGChoQgf
         44Bg8KXyj02sBPGjn4MrrTOk/kfo2otNqiR1ahq8=
Date:   Tue, 7 Jun 2022 11:52:02 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     "Maciej W. Rozycki" <macro@orcam.me.uk>
Cc:     stable@vger.kernel.org
Subject: Re: [PATCH 5.17] MIPS: IP30: Remove incorrect `cpu_has_fpu' override
Message-ID: <Yp8fwoLg+s0VXxgX@kroah.com>
References: <alpine.DEB.2.21.2206070237210.19680@angie.orcam.me.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.21.2206070237210.19680@angie.orcam.me.uk>
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Jun 07, 2022 at 02:42:00AM +0100, Maciej W. Rozycki wrote:
> Remove unsupported forcing of `cpu_has_fpu' to 1, which makes the `nofpu' 
> kernel parameter non-functional, and also causes a link error:
> 
> ld: arch/mips/kernel/traps.o: in function `trap_init':
> ./arch/mips/include/asm/msa.h:(.init.text+0x348): undefined reference to `handle_fpe'
> ld: ./arch/mips/include/asm/msa.h:(.init.text+0x354): undefined reference to `handle_fpe'
> ld: ./arch/mips/include/asm/msa.h:(.init.text+0x360): undefined reference to `handle_fpe'
> 
> where the CONFIG_MIPS_FP_SUPPORT configuration option has been disabled.
> 
> Signed-off-by: Maciej W. Rozycki <macro@orcam.me.uk>
> Reported-by: Stephen Zhang <starzhangzsd@gmail.com>
> Fixes: 7505576d1c1a ("MIPS: add support for SGI Octane (IP30)")
> Cc: stable@vger.kernel.org # v5.5+
> ---
> Hi,
> 
>  This is a version of commit f44b3e74c33f for 5.17-stable and before 
> (where the preceding `#define cpu_has_tx39_cache 0' line has not been 
> removed yet and hence the merge conflict).
> 
>  No functional change, just a mechanical update.  Please apply.

Now queued up, thanks.

greg k-h
