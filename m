Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 72106319D28
	for <lists+stable@lfdr.de>; Fri, 12 Feb 2021 12:17:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229839AbhBLLRZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 12 Feb 2021 06:17:25 -0500
Received: from mail.kernel.org ([198.145.29.99]:36550 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229718AbhBLLRY (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 12 Feb 2021 06:17:24 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 035AB60C41;
        Fri, 12 Feb 2021 11:16:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1613128603;
        bh=3cBFgSXoPKtGmZ39QTAsBzgIxi9rHYwIcUPbJHWDSvA=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Z1c5KuWmeNAsE0v455SwagTiWRv6dcQYqpQH0ZEMdip5vz2k1HUhbGChnLuEdDHrv
         wEnadPY6ZiJlQkk7Wf55dpnB289oOo9AcsaYD5d46AuU1iu+PeT34hp711kSy2Gf5l
         T1g9RrkGsCgLWRZaNy2Uq8Aw2GnLGsClvE+/9vsk=
Date:   Fri, 12 Feb 2021 12:16:41 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Lukasz Majczak <lma@semihalf.com>
Cc:     Guenter Roeck <linux@roeck-us.net>,
        Jarkko Sakkinen <jarkko@kernel.org>,
        James Bottomley <James.Bottomley@hansenpartnership.com>,
        Tj <ml.linux@elloe.vision>, Dirk Gouders <dirk@gouders.net>,
        Peter Huewe <peterhuewe@gmx.de>,
        Jason Gunthorpe <jgg@ziepe.ca>,
        linux-integrity@vger.kernel.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, Radoslaw Biernacki <rad@semihalf.com>,
        Marcin Wojtas <mw@semihalf.com>,
        Alex Levin <levinale@google.com>, upstream@semihalf.com
Subject: Re: [PATCH v5] tpm_tis: Add missing
 tpm_request/relinquish_locality() calls
Message-ID: <YCZjmf4ZLMnlvu9r@kroah.com>
References: <20210212110600.19216-1-lma@semihalf.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210212110600.19216-1-lma@semihalf.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Feb 12, 2021 at 12:06:00PM +0100, Lukasz Majczak wrote:
> There are missing calls to tpm_request_locality() before the calls to
> the tpm_get_timeouts() and tpm_tis_probe_irq_single() - both functions
> internally send commands to the tpm using tpm_tis_send_data()
> which in turn, at the very beginning, calls the tpm_tis_status().
> This one tries to read TPM_STS register, what fails and propagates
> this error upward. The read fails due to lack of acquired locality,
> as it is described in
> TCG PC Client Platform TPM Profile (PTP) Specification,
> paragraph 6.1 FIFO Interface Locality Usage per Register,
> Table 39 Register Behavior Based on Locality Setting for FIFO
> - a read attempt to TPM_STS_x Registers returns 0xFF in case of lack
> of locality. The described situation manifests itself with
> the following warning trace:
> 
> [    4.324298] TPM returned invalid status
> [    4.324806] WARNING: CPU: 2 PID: 1 at drivers/char/tpm/tpm_tis_core.c:275 tpm_tis_status+0x86/0x8f
> 
> Tested on Samsung Chromebook Pro (Caroline), TPM 1.2 (SLB 9670)
> Fixes: a3fbfae82b4c ("tpm: take TPM chip power gating out of tpm_transmit()")
> 
> Signed-off-by: Lukasz Majczak <lma@semihalf.com>
> Reviewed-by: Guenter Roeck <linux@roeck-us.net>
> ---
<formletter>

This is not the correct way to submit patches for inclusion in the
stable kernel tree.  Please read:
    https://www.kernel.org/doc/html/latest/process/stable-kernel-rules.html
for how to do this properly.

</formletter>
