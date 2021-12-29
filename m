Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8420E480EB1
	for <lists+stable@lfdr.de>; Wed, 29 Dec 2021 02:46:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238253AbhL2Bqk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Dec 2021 20:46:40 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:34840 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232932AbhL2Bqj (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 28 Dec 2021 20:46:39 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0FC67611F9;
        Wed, 29 Dec 2021 01:46:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E446EC36AEB;
        Wed, 29 Dec 2021 01:46:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1640742398;
        bh=odbudRf4eHEAawzmzgl9/rAq7pa+Rq1g0KOQSRLyuno=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=eQ0xQZ1CWeZ6dnNnBKF79u8dFsp/jVgMmoBevVZZOpO5QXhLtsdGJ2eG7g48UAHgV
         vglTxBixVfm92+sENXLHj48Jd7xl+DVFp78hUEuU/S+VTZCCizyMMWmUf38368noAt
         KP/Ay1HNIEgK3ORKiNxVYO/upX9NqMN3PjdlanV2wtYfSihtu0GF29NPNoManR2YSA
         Z+RhikRzJ2m6K8P4zDEX2CjG+zGCoNmNeovUFb0ACaUdPncOiX2BWx/ra50joqW1kh
         gZGmPQC6vcVeLvjMiLcpSryQ7YDkjFVmHULn0mPr5AebFmd6J6ymYXRzHCI5SkMtiB
         ivBgedPJuhtBw==
Date:   Wed, 29 Dec 2021 03:46:36 +0200
From:   Jarkko Sakkinen <jarkko@kernel.org>
To:     Lino Sanfilippo <LinoSanfilippo@gmx.de>
Cc:     peterhuewe@gmx.de, jgg@ziepe.ca, p.rosenberger@kunbus.com,
        linux-integrity@vger.kernel.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Subject: Re: [PATCH v2] tpm: fix potential NULL pointer access in
 tpm_del_char_device
Message-ID: <Ycu9/C1IKQveozL6@iki.fi>
References: <20211220150635.8545-1-LinoSanfilippo@gmx.de>
 <YcuoMVn3eWm1fcLp@iki.fi>
 <185a096b-96f1-cc99-52e8-08a35151e347@gmx.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <185a096b-96f1-cc99-52e8-08a35151e347@gmx.de>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Dec 29, 2021 at 02:41:52AM +0100, Lino Sanfilippo wrote:
> Hi,
> 
> On 29.12.21 at 01:13, Jarkko Sakkinen wrote:
> > On Mon, Dec 20, 2021 at 04:06:35PM +0100, Lino Sanfilippo wrote:
> >> Some SPI controller drivers unregister the controller in the shutdown
> >> handler (e.g. BCM2835). If such a controller is used with a TPM 2 slave
> >> chip->ops may be accessed when it is already NULL:
> >>
> >> At system shutdown the pre-shutdown handler tpm_class_shutdown() shuts down
> >> TPM 2 and sets chip->ops to NULL. Then at SPI controller unregistration
> >> tpm_tis_spi_remove() is called and eventually calls tpm_del_char_device()
> >> which tries to shut down TPM 2 again. Thereby it accesses chip->ops again:
> >> (tpm_del_char_device calls tpm_chip_start which calls tpm_clk_enable which
> >> calls chip->ops->clk_enable).
> >>
> >> Avoid the NULL pointer access by testing if chip->ops is valid and skipping
> >> the TPM 2 shutdown procedure in case it is NULL.
> >>
> >> Fixes: dcbeab1946454 ("tpm: fix crash in tpm_tis deinitialization")
> >> Cc: stable@vger.kernel.org
> >> Signed-off-by: Lino Sanfilippo <LinoSanfilippo@gmx.de>
> >
> > Thank you.
> >
> > Reviewed-by: Jarkko Sakkinen <jarkko@kernel.org>
> >
> > BR,
> > Jarkko
> >
> 
> Thanks a lot for the review. Please note that the latest version is v3 which
> contains one more Fixes tag and also a tag for the review by Stefan. I also
> adjusted the source code comment in that version which I somehow messed up in v2.

Since there is no functional difference, I rather do not swap it.

I fixed a glitch:

+
+       /*

A multi-line commit needs to have this as the very first line.
You can check if the all tags were pulled by b4.

/Jarkko
