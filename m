Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CA631DADA6
	for <lists+stable@lfdr.de>; Thu, 17 Oct 2019 14:59:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729460AbfJQM67 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 17 Oct 2019 08:58:59 -0400
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:50652 "EHLO
        bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726534AbfJQM67 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 17 Oct 2019 08:58:59 -0400
Received: from localhost (localhost [127.0.0.1])
        by bedivere.hansenpartnership.com (Postfix) with ESMTP id 387398EE224;
        Thu, 17 Oct 2019 05:58:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=hansenpartnership.com;
        s=20151216; t=1571317138;
        bh=b4kNWDqfZtxkbfL5dcugd/YKOrGXYCMtEtj7eyi1VmY=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=WmW72JHd4Wd4TcyP9jiSmpW6rsQYk8NSN7664rbyTnkva4l87WSbJ+vfuk1RZptyp
         rUPUuYZCGZflLMKIfI1d2Vqk5faqZ41STgKX41nHlbxDMu5UClwVarGpM3J62B9eIi
         VHFbmJN82nVaStqMLiPDRoncX/W3j1cd/+Xi2JD8=
Received: from bedivere.hansenpartnership.com ([127.0.0.1])
        by localhost (bedivere.hansenpartnership.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id 9zWOI_RLXHTt; Thu, 17 Oct 2019 05:58:57 -0700 (PDT)
Received: from [192.168.100.84] (unknown [24.246.103.29])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by bedivere.hansenpartnership.com (Postfix) with ESMTPSA id 929B38EE0EF;
        Thu, 17 Oct 2019 05:58:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=hansenpartnership.com;
        s=20151216; t=1571317137;
        bh=b4kNWDqfZtxkbfL5dcugd/YKOrGXYCMtEtj7eyi1VmY=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=StPYKgDLYbhmsgk0E4jm5IETgPreDB3vbpSX3D/QV05zozc26H4z1Om1XLIK837IW
         NJpMP+bLJqMGW8ddPTUP3RZjP8fnmsx6mQmbi747btopGiqHjUnjxLgYEVUcQ6C93D
         G93AGCALWtAa4Ih4W6q06soqvalhzlCA5UtRqO5o=
Message-ID: <1571317135.3728.3.camel@HansenPartnership.com>
Subject: Re: [PATCH] KEYS: asym_tpm: Switch to get_random_bytes()
From:   James Bottomley <James.Bottomley@HansenPartnership.com>
To:     Sumit Garg <sumit.garg@linaro.org>
Cc:     Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>,
        "Safford, David (GE Global Research, US)" <david.safford@ge.com>,
        Ken Goldman <kgold@linux.ibm.com>,
        Mimi Zohar <zohar@linux.ibm.com>,
        "linux-integrity@vger.kernel.org" <linux-integrity@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "open list:ASYMMETRIC KEYS" <keyrings@vger.kernel.org>,
        "open list:CRYPTO API" <linux-crypto@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
Date:   Thu, 17 Oct 2019 08:58:55 -0400
In-Reply-To: <CAFA6WYNNNTWXDrp_R3M60srGJYjJdRoaNpSnP54V_BinYYXTMA@mail.gmail.com>
References: <BCA04D5D9A3B764C9B7405BBA4D4A3C035F2A38B@ALPMBAPA12.e2k.ad.ge.com>
         <20191007000520.GA17116@linux.intel.com>
         <59b88042-9c56-c891-f75e-7c0719eb5ff9@linux.ibm.com>
         <20191008234935.GA13926@linux.intel.com>
         <20191008235339.GB13926@linux.intel.com>
         <BCA04D5D9A3B764C9B7405BBA4D4A3C035F2B995@ALPMBAPA12.e2k.ad.ge.com>
         <20191014190033.GA15552@linux.intel.com>
         <1571081397.3728.9.camel@HansenPartnership.com>
         <20191016110031.GE10184@linux.intel.com>
         <1571229252.3477.7.camel@HansenPartnership.com>
         <20191016162543.GB6279@linux.intel.com>
         <1571253029.17520.5.camel@HansenPartnership.com>
         <CAFA6WYNNNTWXDrp_R3M60srGJYjJdRoaNpSnP54V_BinYYXTMA@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.26.6 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, 2019-10-17 at 18:22 +0530, Sumit Garg wrote:
> On Thu, 17 Oct 2019 at 00:40, James Bottomley
> <James.Bottomley@hansenpartnership.com> wrote:
> > 
> > On Wed, 2019-10-16 at 19:25 +0300, Jarkko Sakkinen wrote:
> > > On Wed, Oct 16, 2019 at 08:34:12AM -0400, James Bottomley wrote:
> > > > reversible ciphers are generally frowned upon in random number
> > > > generation, that's why the krng uses chacha20.  In general I
> > > > think we shouldn't try to code our own mixing and instead
> > > > should get the krng to do it for us using whatever the
> > > > algorithm du jour that the crypto guys have blessed is.  That's
> > > > why I proposed adding the TPM output to the krng as entropy
> > > > input and then taking the output of the krng.
> > > 
> > > It is already registered as hwrng. What else?
> > 
> > It only contributes entropy once at start of OS.
> > 
> 
> Why not just configure quality parameter of TPM hwrng as follows? It
> would automatically initiate a kthread during hwrng_init() to feed
> entropy from TPM to kernel random numbers pool (see:
> drivers/char/hw_random/core.c +142).

The question was asked before by Jerry.  The main reason is we still
can't guarantee that at 1024 the hwrng will choose the TPM as the best
source (the problem being it only chooses one) and the mixing is done
periodically in a timer thread so it's still vulnerable to an entropy
exhaustion attack.  I think it's better to source the random number in
the TPM when asked but mix it with whatever entropy we have in the pool
using the crypto people's mixing algorithm.  This definitely avoids
exhaustion and provides some protection against single source rng
compromises.

James


> diff --git a/drivers/char/tpm/tpm-chip.c b/drivers/char/tpm/tpm-
> chip.c
> index 3d6d394..fcc3817 100644
> --- a/drivers/char/tpm/tpm-chip.c
> +++ b/drivers/char/tpm/tpm-chip.c
> @@ -548,6 +548,7 @@ static int tpm_add_hwrng(struct tpm_chip *chip)
>                  "tpm-rng-%d", chip->dev_num);
>         chip->hwrng.name = chip->hwrng_name;
>         chip->hwrng.read = tpm_hwrng_read;
> +       chip->hwrng.quality = 1024; /* Here we assume TPM provides
> full entropy */
>         return hwrng_register(&chip->hwrng);
> 
>  }
> 
> > >  Was the issue that it is only used as seed when the rng is
> > > init'd
> > > first? I haven't at this point gone to the internals of krng.
> > 
> > Basically it was similar to your xor patch except I got the kernel
> > rng
> > to do the mixing, so it would use the chacha20 cipher at the moment
> > until they decide that's unsafe and change it to something else:
> > 
> > https://lore.kernel.org/linux-crypto/1570227068.17537.4.camel@Hanse
> > nPartnership.com/
> > 
> > It uses add_hwgenerator_randomness() to do the mixing.  It also has
> > an
> > unmixed source so that read of the TPM hwrng device works as
> > expected.
> 
> Above suggestion is something similar to yours but utilizing the
> framework already provided via hwrng core.
> 
> -Sumit
> 
> > 
> > James
> > 
> > 
> > 
> > 
> > 
> 
> 

