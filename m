Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3E136D6A25
	for <lists+stable@lfdr.de>; Mon, 14 Oct 2019 21:30:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388873AbfJNT37 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Oct 2019 15:29:59 -0400
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:45364 "EHLO
        bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1730405AbfJNT37 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 14 Oct 2019 15:29:59 -0400
Received: from localhost (localhost [127.0.0.1])
        by bedivere.hansenpartnership.com (Postfix) with ESMTP id D7B238EE0F8;
        Mon, 14 Oct 2019 12:29:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=hansenpartnership.com;
        s=20151216; t=1571081398;
        bh=6+zVmnXVRSW3VefS05Bdkv0D9Q5z93dRC6W+RmfclTk=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=nQ1GyZfPwpiIDjMS6VL+s814j9py+atSMF7mkEzVgJi1yieVXKP/AVWhFsFKwTsyM
         vXGbwFHBw6eHku8aWG7E/A44hzTnSxtYVy4Wf3tLlBzkXHYx8XW5aJ8kbLjT25hsTg
         wkOfTXhRUXg+guMhRuryHuyga8RDZvJ8IvMYSA+8=
Received: from bedivere.hansenpartnership.com ([127.0.0.1])
        by localhost (bedivere.hansenpartnership.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id 9j7g9LG10Gpt; Mon, 14 Oct 2019 12:29:58 -0700 (PDT)
Received: from [172.16.1.194] (unknown [63.64.162.234])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by bedivere.hansenpartnership.com (Postfix) with ESMTPSA id 2D6F58EE0F5;
        Mon, 14 Oct 2019 12:29:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=hansenpartnership.com;
        s=20151216; t=1571081398;
        bh=6+zVmnXVRSW3VefS05Bdkv0D9Q5z93dRC6W+RmfclTk=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=nQ1GyZfPwpiIDjMS6VL+s814j9py+atSMF7mkEzVgJi1yieVXKP/AVWhFsFKwTsyM
         vXGbwFHBw6eHku8aWG7E/A44hzTnSxtYVy4Wf3tLlBzkXHYx8XW5aJ8kbLjT25hsTg
         wkOfTXhRUXg+guMhRuryHuyga8RDZvJ8IvMYSA+8=
Message-ID: <1571081397.3728.9.camel@HansenPartnership.com>
Subject: Re: [PATCH] KEYS: asym_tpm: Switch to get_random_bytes()
From:   James Bottomley <James.Bottomley@HansenPartnership.com>
To:     Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>,
        "Safford, David (GE Global Research, US)" <david.safford@ge.com>
Cc:     Ken Goldman <kgold@linux.ibm.com>,
        Mimi Zohar <zohar@linux.ibm.com>,
        "linux-integrity@vger.kernel.org" <linux-integrity@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "open list:ASYMMETRIC KEYS" <keyrings@vger.kernel.org>,
        "open list:CRYPTO API" <linux-crypto@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
Date:   Mon, 14 Oct 2019 12:29:57 -0700
In-Reply-To: <20191014190033.GA15552@linux.intel.com>
References: <20191003175854.GB19679@linux.intel.com>
         <1570128827.5046.19.camel@linux.ibm.com>
         <BCA04D5D9A3B764C9B7405BBA4D4A3C035F2A22E@ALPMBAPA12.e2k.ad.ge.com>
         <20191004182711.GC6945@linux.intel.com>
         <BCA04D5D9A3B764C9B7405BBA4D4A3C035F2A38B@ALPMBAPA12.e2k.ad.ge.com>
         <20191007000520.GA17116@linux.intel.com>
         <59b88042-9c56-c891-f75e-7c0719eb5ff9@linux.ibm.com>
         <20191008234935.GA13926@linux.intel.com>
         <20191008235339.GB13926@linux.intel.com>
         <BCA04D5D9A3B764C9B7405BBA4D4A3C035F2B995@ALPMBAPA12.e2k.ad.ge.com>
         <20191014190033.GA15552@linux.intel.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.26.6 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, 2019-10-14 at 22:00 +0300, Jarkko Sakkinen wrote:
> On Wed, Oct 09, 2019 at 12:11:06PM +0000, Safford, David (GE Global
> Research, US) wrote:
> > 
> > > From: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
> > > Sent: Tuesday, October 8, 2019 7:54 PM
> > > To: Ken Goldman <kgold@linux.ibm.com>
> > > Cc: Safford, David (GE Global Research, US) <david.safford@ge.com
> > > >; Mimi
> > > Zohar <zohar@linux.ibm.com>; linux-integrity@vger.kernel.org;
> > > stable@vger.kernel.org; open list:ASYMMETRIC KEYS
> > > <keyrings@vger.kernel.org>; open list:CRYPTO API <linux-
> > > crypto@vger.kernel.org>; open list <linux-kernel@vger.kernel.org>
> > > Subject: EXT: Re: [PATCH] KEYS: asym_tpm: Switch to
> > > get_random_bytes()
> > > 
> > > On Wed, Oct 09, 2019 at 02:49:35AM +0300, Jarkko Sakkinen wrote:
> > > > On Mon, Oct 07, 2019 at 06:13:01PM -0400, Ken Goldman wrote:
> > > > > The TPM library specification states that the TPM must comply
> > > > > with NIST SP800-90 A.
> > > > > 
> > > > > https://trustedcomputinggroup.org/membership/certification/tp
> > > > > m-certified-products/
> > > > > 
> > > > > shows that the TPMs get third party certification, Common
> > > > > Criteria EAL 4+.
> > > > > 
> > > > > While it's theoretically possible that an attacker could
> > > > > compromise both the TPM vendors and the evaluation agencies,
> > > > > we do have EAL 4+ assurance against both 1 and 2.
> > > > 
> > > > Certifications do not equal to trust.
> > > 
> > > And for trusted keys the least trust solution is to do generation
> > > with the kernel assets and sealing with TPM. With TEE the least
> > > trust solution is equivalent.
> > > 
> > > Are you proposing that the kernel random number generation should
> > > be removed? That would be my conclusion of this discussion if I
> > > would agree any of this (I don't).
> > > 
> > > /Jarkko
> > 
> > No one is suggesting that.
> > 
> > You are suggesting changing the documented behavior of trusted
> > keys, and that would cause problems for some of our use cases.
> > While certification may not in your mind be equal to trust, it is
> > equal to compliance with mandatory regulations.
> > 
> > Perhaps rather than arguing past each other, we should look into 
> > providing users the ability to choose, as an argument to keyctl?
> > 
> > dave
> 
> I'm taking my words back in the regression part as regression would
> need really a failing system. Definitely the fixes tag should be
> removed from my patch.
> 
> What is anyway the role of the kernel rng? Why does it exist and when
> exactly it should be used? This exactly where the whole review
> process throughout the "chain of command" failed misserably with
> tpm_asym.c.
> 
> The commit message for tpm_asym.c does not document the design choice
> in any possible way and still was merged to the mainline.
> 
> Before knowning the answer to the "existential" question we are
> somewhat paralyzed on moving forward with trusted keys (e.g.
> paralyzed to merge TEE backend).
> 
> Your proposal might make sense but I don't really want to say
> anything since I'm completely cluesless of the role of the kernel
> rng. Looks like everyone who participated to the review process of
> tpm_asym.c, is too.

The job of the in-kernel rng is simply to produce a mixed entropy pool
from which we can draw random numbers.  The idea is that quite a few
attackers have identified the rng as being a weak point in the security
architecture of the kernel, so if we mix entropy from all the sources
we have, you have to compromise most of them to gain some predictive
power over the rng sequence.

The point is not how certified the TPM RNG is, the point is that it's a
single source and if we rely on it solely for some applications, like
trusted keys, then it gives the attackers a single known point to go
after.  This may be impossible for script kiddies, but it won't be for
nation states ... are you going to exclusively trust the random number
you got from your chinese certified TPM?

Remember also that the attack doesn't have to be to the TPM only, it
could be the pathway by which we get the random number, which involves
components outside of the TPM certification.

James

