Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3534CEB8A9
	for <lists+stable@lfdr.de>; Thu, 31 Oct 2019 22:03:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729830AbfJaVDg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 31 Oct 2019 17:03:36 -0400
Received: from mga02.intel.com ([134.134.136.20]:34915 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727742AbfJaVDg (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 31 Oct 2019 17:03:36 -0400
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga101.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 31 Oct 2019 14:03:35 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.68,253,1569308400"; 
   d="scan'208";a="194457177"
Received: from epobrien-mobl1.ger.corp.intel.com (HELO localhost) ([10.252.10.103])
  by orsmga008.jf.intel.com with ESMTP; 31 Oct 2019 14:03:31 -0700
Date:   Thu, 31 Oct 2019 23:03:30 +0200
From:   Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
To:     James Bottomley <James.Bottomley@HansenPartnership.com>
Cc:     "Safford, David (GE Global Research, US)" <david.safford@ge.com>,
        Ken Goldman <kgold@linux.ibm.com>,
        Mimi Zohar <zohar@linux.ibm.com>,
        "linux-integrity@vger.kernel.org" <linux-integrity@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "open list:ASYMMETRIC KEYS" <keyrings@vger.kernel.org>,
        "open list:CRYPTO API" <linux-crypto@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] KEYS: asym_tpm: Switch to get_random_bytes()
Message-ID: <20191031210330.GA10507@linux.intel.com>
References: <20191014190033.GA15552@linux.intel.com>
 <1571081397.3728.9.camel@HansenPartnership.com>
 <20191016110031.GE10184@linux.intel.com>
 <1571229252.3477.7.camel@HansenPartnership.com>
 <20191016162543.GB6279@linux.intel.com>
 <1571253029.17520.5.camel@HansenPartnership.com>
 <20191017180440.GG6667@linux.intel.com>
 <20191021113939.GA11649@linux.intel.com>
 <20191029084258.GA5649@linux.intel.com>
 <1572361096.4812.3.camel@HansenPartnership.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1572361096.4812.3.camel@HansenPartnership.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Oct 29, 2019 at 07:58:16AM -0700, James Bottomley wrote:
> On Tue, 2019-10-29 at 10:42 +0200, Jarkko Sakkinen wrote:
> > On Mon, Oct 21, 2019 at 02:39:39PM +0300, Jarkko Sakkinen wrote:
> > > On Thu, Oct 17, 2019 at 09:04:40PM +0300, Jarkko Sakkinen wrote:
> > > > On Wed, Oct 16, 2019 at 03:10:29PM -0400, James Bottomley wrote:
> > > > > On Wed, 2019-10-16 at 19:25 +0300, Jarkko Sakkinen wrote:
> > > > > > On Wed, Oct 16, 2019 at 08:34:12AM -0400, James Bottomley
> > > > > > wrote:
> > > > > > > reversible ciphers are generally frowned upon in random
> > > > > > > number
> > > > > > > generation, that's why the krng uses chacha20.  In general
> > > > > > > I think
> > > > > > > we shouldn't try to code our own mixing and instead should
> > > > > > > get the
> > > > > > > krng to do it for us using whatever the algorithm du jour
> > > > > > > that the
> > > > > > > crypto guys have blessed is.  That's why I proposed adding
> > > > > > > the TPM
> > > > > > > output to the krng as entropy input and then taking the
> > > > > > > output of
> > > > > > > the krng.
> > > > > > 
> > > > > > It is already registered as hwrng. What else?
> > > > > 
> > > > > It only contributes entropy once at start of OS.
> > > > 
> > > > Ok.
> > > > 
> > > > > >  Was the issue that it is only used as seed when the rng is
> > > > > > init'd
> > > > > > first? I haven't at this point gone to the internals of krng.
> > > > > 
> > > > > Basically it was similar to your xor patch except I got the
> > > > > kernel rng
> > > > > to do the mixing, so it would use the chacha20 cipher at the
> > > > > moment
> > > > > until they decide that's unsafe and change it to something
> > > > > else:
> > > > > 
> > > > > https://lore.kernel.org/linux-crypto/1570227068.17537.4.camel@H
> > > > > ansenPartnership.com/
> > > > > 
> > > > > It uses add_hwgenerator_randomness() to do the mixing.  It also
> > > > > has an
> > > > > unmixed source so that read of the TPM hwrng device works as
> > > > > expected.
> > > > 
> > > > Thinking that could this potentially racy? I.e. between the calls
> > > > something else could eat the entropy added?
> > > 
> > > Also, what is wrong just taking one value from krng and mixing
> > > it with a value from TPM RNG where needed? That would be non-racy
> > > too.
> > 
> > I guess we can move forward with this?
> 
> Sure I suppose; can we can figure out how to get the mixing function du
> jour exposed?

Maybe it is best to reflect the whole issue in the context of the
Sumit's 2nd patch set, which adds ARM TEE support in order to move
forward.

/Jarkko
