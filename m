Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BE5256A5156
	for <lists+stable@lfdr.de>; Tue, 28 Feb 2023 03:41:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229819AbjB1ClY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Feb 2023 21:41:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58068 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229486AbjB1ClX (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 27 Feb 2023 21:41:23 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C36932749A;
        Mon, 27 Feb 2023 18:41:08 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7408660FBA;
        Tue, 28 Feb 2023 02:41:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 45D83C433D2;
        Tue, 28 Feb 2023 02:41:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1677552066;
        bh=k+5EFHB2St+NxQ4m2feRTrEsoE8xrhizYjRDOSwTdXI=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=U7zA8jIG3g25AQaltN5JWSVoug59qlyIb1JT6NwDbB/gHYEmeLqFCqE92kkE6KmVM
         pc2OSBJl3BSHn1TsCVUAOO35oPZHGKiQab5isEX7RYN4lGjwLWc7hVsQMzd7DuHvtY
         gNJF5TQuEMahHTXbQUAVOQMN9aaXT2sjlD3+XMwERlCl5FL3OC6If6LQduGTdm6qXm
         OBmTvGXTFfwhDr0og2RZmdqMZjWb/oA6aYTludwPo2+P0hksXSP909LUrotT699j3v
         7o+r+VCpj82jqxzDeNhDC91baqwV7+1HCJc2s3BOGALdSL1sHU5o/Ns2bIgMtWlfUQ
         aU5iL73RuXIUQ==
Date:   Tue, 28 Feb 2023 04:41:03 +0200
From:   Jarkko Sakkinen <jarkko@kernel.org>
To:     "Limonciello, Mario" <Mario.Limonciello@amd.com>
Cc:     Peter Huewe <peterhuewe@gmx.de>, Jason Gunthorpe <jgg@ziepe.ca>,
        Dominik Brodowski <linux@dominikbrodowski.net>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        Thorsten Leemhuis <regressions@leemhuis.info>,
        James Bottomley <James.Bottomley@hansenpartnership.com>,
        "Jason A . Donenfeld" <Jason@zx2c4.com>,
        "linux-integrity@vger.kernel.org" <linux-integrity@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2] tpm: disable hwrng for fTPM on some AMD designs
Message-ID: <Y/1pvzXqaZew20WD@kernel.org>
References: <20230220180729.23862-1-mario.limonciello@amd.com>
 <915571f8-d055-90b9-3048-f629befd9a13@amd.com>
 <DS7PR12MB60953294CDD3F198ACD3E567E2AC9@DS7PR12MB6095.namprd12.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <DS7PR12MB60953294CDD3F198ACD3E567E2AC9@DS7PR12MB6095.namprd12.prod.outlook.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Feb 28, 2023 at 02:37:59AM +0000, Limonciello, Mario wrote:
> [Public]
> 
> 
> 
> > -----Original Message-----
> > From: Limonciello, Mario
> > Sent: Monday, February 27, 2023 08:53
> > To: Peter Huewe <peterhuewe@gmx.de>; Jarkko Sakkinen
> > <jarkko@kernel.org>; Jason Gunthorpe <jgg@ziepe.ca>; Dominik Brodowski
> > <linux@dominikbrodowski.net>; Herbert Xu
> > <herbert@gondor.apana.org.au>
> > Cc: stable@vger.kernel.org; Thorsten Leemhuis
> > <regressions@leemhuis.info>; James Bottomley
> > <James.Bottomley@hansenpartnership.com>; Jason A . Donenfeld
> > <Jason@zx2c4.com>; linux-integrity@vger.kernel.org; linux-
> > kernel@vger.kernel.org
> > Subject: Re: [PATCH v2] tpm: disable hwrng for fTPM on some AMD designs
> > 
> > On 2/20/23 12:07, Mario Limonciello wrote:
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
> > > Link: https://lore.kernel.org/all/20230209153120.261904-1-
> > Jason@zx2c4.com/
> > > Fixes: b006c439d58d ("hwrng: core - start hwrng kthread also for untrusted
> > sources")
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
> > 
> > One of the reporters on the kernel bugzilla did confirm the v2 patch,
> > forwarding their tag.
> > 
> > Tested-by: Bell <1138267643@qq.com>
> 
> Here's another tag.
> 
> Tested-by: reach622@mailcuk.com 

Thanks this tested-by can be in v3 because curly braces does not affect
semantics. I can ack that then and pick it up.

BR, Jarkko
