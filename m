Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3CFB66A514E
	for <lists+stable@lfdr.de>; Tue, 28 Feb 2023 03:40:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229549AbjB1CkF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Feb 2023 21:40:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56694 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229501AbjB1CkE (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 27 Feb 2023 21:40:04 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 04ED31715D;
        Mon, 27 Feb 2023 18:40:03 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8403C60FBA;
        Tue, 28 Feb 2023 02:40:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6BB3BC433EF;
        Tue, 28 Feb 2023 02:40:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1677552001;
        bh=g0eDzrfjNbTCob099SJw7KqJqdR7cRW3Cv0jdqmvURI=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Unc8lvTLqfqQsVK2Ik0XO2/GceM1wwBd8oQXYW6s43ONw6M4Hc8g0ZGBukF+MA/zY
         +0u7ZwwPJftm+RyEfuW/Dhvln1DD0qoyfx+mE2DOgOb6h3KwrlXPmfoyPQOZyqqD0b
         uLUMgx2gujCBwjzO0vCHm8rgoHZEeLJUblZ5NKN9ob1IpxnCteMRqd4+poylTmQ01b
         qqeKp583t0CxWhoNfV0bx/Dt0RPB3uz5+FFyemsFeT/t2zEj0mUBi5UzHKn1HaFbrN
         /siWSFPwLoGhO4K2C6sxXfP7jnF8CQKnDmDjclNv0lZUVw/jLccsxu3ioG/XuuuMkI
         XVq2aL2NWPz4A==
Date:   Tue, 28 Feb 2023 04:39:58 +0200
From:   Jarkko Sakkinen <jarkko@kernel.org>
To:     Mario Limonciello <mario.limonciello@amd.com>
Cc:     Guenter Roeck <linux@roeck-us.net>,
        Peter Huewe <peterhuewe@gmx.de>,
        Jason Gunthorpe <jgg@ziepe.ca>,
        Dominik Brodowski <linux@dominikbrodowski.net>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        stable@vger.kernel.org,
        Thorsten Leemhuis <regressions@leemhuis.info>,
        James Bottomley <James.Bottomley@hansenpartnership.com>,
        "Jason A . Donenfeld" <Jason@zx2c4.com>,
        linux-integrity@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] tpm: disable hwrng for fTPM on some AMD designs
Message-ID: <Y/1pfpA2o6GRUIDZ@kernel.org>
References: <20230220180729.23862-1-mario.limonciello@amd.com>
 <20230227145554.GA3714281@roeck-us.net>
 <7f5bd6a2-2eed-a27e-8655-181bb37a7c1c@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7f5bd6a2-2eed-a27e-8655-181bb37a7c1c@amd.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Feb 27, 2023 at 08:58:37AM -0600, Mario Limonciello wrote:
> On 2/27/23 08:55, Guenter Roeck wrote:
> > On Mon, Feb 20, 2023 at 12:07:28PM -0600, Mario Limonciello wrote:
> > > AMD has issued an advisory indicating that having fTPM enabled in
> > > BIOS can cause "stuttering" in the OS.  This issue has been fixed
> > > in newer versions of the fTPM firmware, but it's up to system
> > > designers to decide whether to distribute it.
> > > 
> > > This issue has existed for a while, but is more prevalent starting
> > > with kernel 6.1 because commit b006c439d58db ("hwrng: core - start
> > > hwrng kthread also for untrusted sources") started to use the fTPM
> > > for hwrng by default. However, all uses of /dev/hwrng result in
> > > unacceptable stuttering.
> > > 
> > > So, simply disable registration of the defective hwrng when detecting
> > > these faulty fTPM versions.  As this is caused by faulty firmware, it
> > > is plausible that such a problem could also be reproduced by other TPM
> > > interactions, but this hasn't been shown by any user's testing or reports.
> > > 
> > > It is hypothesized to be triggered more frequently by the use of the RNG
> > > because userspace software will fetch random numbers regularly.
> > > 
> > > Intentionally continue to register other TPM functionality so that users
> > > that rely upon PCR measurements or any storage of data will still have
> > > access to it.  If it's found later that another TPM functionality is
> > > exacerbating this problem a module parameter it can be turned off entirely
> > > and a module parameter can be introduced to allow users who rely upon
> > > fTPM functionality to turn it on even though this problem is present.
> > > 
> > > Link: https://www.amd.com/en/support/kb/faq/pa-410
> > > Link: https://bugzilla.kernel.org/show_bug.cgi?id=216989
> > > Link: https://lore.kernel.org/all/20230209153120.261904-1-Jason@zx2c4.com/
> > > Fixes: b006c439d58d ("hwrng: core - start hwrng kthread also for untrusted sources")
> > > Cc: stable@vger.kernel.org
> > > Cc: Jarkko Sakkinen <jarkko@kernel.org>
> > > Cc: Thorsten Leemhuis <regressions@leemhuis.info>
> > > Cc: James Bottomley <James.Bottomley@hansenpartnership.com>
> > > Co-developed-by: Jason A. Donenfeld <Jason@zx2c4.com>
> > > Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
> > > Signed-off-by: Mario Limonciello <mario.limonciello@amd.com>
> > > ---
> > > v1->v2:
> > >   * Minor style from Jarkko's feedback
> > >   * Move comment above function
> > >   * Explain further in commit message
> > > ---
> > >   drivers/char/tpm/tpm-chip.c | 61 ++++++++++++++++++++++++++++++-
> > >   drivers/char/tpm/tpm.h      | 73 +++++++++++++++++++++++++++++++++++++
> > >   2 files changed, 133 insertions(+), 1 deletion(-)
> > > 
> > > diff --git a/drivers/char/tpm/tpm-chip.c b/drivers/char/tpm/tpm-chip.c
> > > index 741d8f3e8fb3..1b066d7a6e21 100644
> > > --- a/drivers/char/tpm/tpm-chip.c
> > > +++ b/drivers/char/tpm/tpm-chip.c
> > > @@ -512,6 +512,64 @@ static int tpm_add_legacy_sysfs(struct tpm_chip *chip)
> > >   	return 0;
> > >   }
> > > +/*
> > > + * Some AMD fTPM versions may cause stutter
> > > + * https://www.amd.com/en/support/kb/faq/pa-410
> > > + *
> > > + * Fixes are available in two series of fTPM firmware:
> > > + * 6.x.y.z series: 6.0.18.6 +
> > > + * 3.x.y.z series: 3.57.y.5 +
> > > + */
> > > +static bool tpm_amd_is_rng_defective(struct tpm_chip *chip)
> > > +{
> > > +	u32 val1, val2;
> > > +	u64 version;
> > > +	int ret;
> > > +
> > > +	if (!(chip->flags & TPM_CHIP_FLAG_TPM2))
> > > +		return false;
> > > +
> > > +	ret = tpm_request_locality(chip);
> > > +	if (ret)
> > > +		return false;
> > > +
> > > +	ret = tpm2_get_tpm_pt(chip, TPM2_PT_MANUFACTURER, &val1, NULL);
> > > +	if (ret)
> > > +		goto release;
> > > +	if (val1 != 0x414D4400U /* AMD */) {
> > > +		ret = -ENODEV;
> > > +		goto release;
> > > +	}
> > > +	ret = tpm2_get_tpm_pt(chip, TPM2_PT_FIRMWARE_VERSION_1, &val1, NULL);
> > > +	if (ret)
> > > +		goto release;
> > > +	ret = tpm2_get_tpm_pt(chip, TPM2_PT_FIRMWARE_VERSION_2, &val2, NULL);
> > > +	if (ret)
> > > +		goto release;
> > 
> > This goto is unnecessary.
> > 
> > > +
> > > +release:
> > > +	tpm_relinquish_locality(chip);
> > > +
> > > +	if (ret)
> > > +		return false;
> > > +
> > > +	version = ((u64)val1 << 32) | val2;
> > > +	if ((version >> 48) == 6) {
> > > +		if (version >= 0x0006000000180006ULL)
> > > +			return false;
> > > +	} else if ((version >> 48) == 3) {
> > > +		if (version >= 0x0003005700000005ULL)
> > > +			return false;
> > > +	} else
> > > +		return false;
> > 
> > checkpatch:
> > 
> > CHECK: braces {} should be used on all arms of this statement
> > #200: FILE: drivers/char/tpm/tpm-chip.c:557:
> > +	if ((version >> 48) == 6) {
> > [...]
> > +	} else if ((version >> 48) == 3) {
> > [...]
> > +	} else
> > [...]
> 
> It was requested by Jarko explicitly in v1 to do it this way.
> 
> https://lore.kernel.org/lkml/Y+%2F6G+UlTI7GpW6o@kernel.org/

OK, you're right, it is my bad, I'm sorry about that. Send v3 with that feedback reverted.

BR, Jarkko
