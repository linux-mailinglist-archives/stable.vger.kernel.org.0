Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1263C2F3442
	for <lists+stable@lfdr.de>; Tue, 12 Jan 2021 16:36:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391505AbhALPgp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 Jan 2021 10:36:45 -0500
Received: from linux.microsoft.com ([13.77.154.182]:42098 "EHLO
        linux.microsoft.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2391460AbhALPgp (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 12 Jan 2021 10:36:45 -0500
Received: from sequoia (162-237-133-238.lightspeed.rcsntx.sbcglobal.net [162.237.133.238])
        by linux.microsoft.com (Postfix) with ESMTPSA id 59A3220B6C40;
        Tue, 12 Jan 2021 07:36:03 -0800 (PST)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 59A3220B6C40
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
        s=default; t=1610465763;
        bh=McXfpx7CXiTJWz8uagaZ4YpQfZgo3sZg2yh4/x+j+Yc=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=V0Z8At8aZ8JrV6C7ViNabSX4/+P0ef/JP6xqvVGNr9XPNlLIwshd1g0xxCt4yhFbC
         Ql8o+9n/AppO4baHyIjQQACKwa5DdNFyFHNI/aqA4giXq0Qbaqjlb2Uf/ZrVWKCdx+
         u2RP1TmzzHrYc3QgsKQNMDqRQ89E/JFDQPnqNq0s=
Date:   Tue, 12 Jan 2021 09:35:34 -0600
From:   Tyler Hicks <tyhicks@linux.microsoft.com>
To:     Mimi Zohar <zohar@linux.ibm.com>
Cc:     Sasha Levin <sashal@kernel.org>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, Maurizio Drocco <maurizio.drocco@ibm.com>,
        Bruno Meneguele <bmeneg@redhat.com>,
        linux-integrity@vger.kernel.org,
        linux-security-module@vger.kernel.org
Subject: Re: [PATCH AUTOSEL 5.7 03/30] ima: extend boot_aggregate with kernel
 measurements
Message-ID: <20210112153534.GA4146@sequoia>
References: <20200708154116.3199728-1-sashal@kernel.org>
 <20200708154116.3199728-3-sashal@kernel.org>
 <1594224793.23056.251.camel@linux.ibm.com>
 <20200709012735.GX2722994@sasha-vm>
 <5b8dcdaf66fbe2a39631833b03772a11613fbbbf.camel@linux.ibm.com>
 <20201211031008.GN489768@sequoia>
 <659c09673affe9637a5d1391c12af3aa710ba78a.camel@linux.ibm.com>
 <20201214164222.GK4951@sequoia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201214164222.GK4951@sequoia>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 2020-12-14 10:42:24, Tyler Hicks wrote:
> On 2020-12-11 06:01:54, Mimi Zohar wrote:
> > On Thu, 2020-12-10 at 21:10 -0600, Tyler Hicks wrote:
> > > On 2020-11-29 08:17:38, Mimi Zohar wrote:
> > > > Hi Sasha,
> > > > 
> > > > On Wed, 2020-07-08 at 21:27 -0400, Sasha Levin wrote:
> > > > > On Wed, Jul 08, 2020 at 12:13:13PM -0400, Mimi Zohar wrote:
> > > > > >Hi Sasha,
> > > > > >
> > > > > >On Wed, 2020-07-08 at 11:40 -0400, Sasha Levin wrote:
> > > > > >> From: Maurizio Drocco <maurizio.drocco@ibm.com>
> > > > > >>
> > > > > >> [ Upstream commit 20c59ce010f84300f6c655d32db2610d3433f85c ]
> > > > > >>
> > > > > >> Registers 8-9 are used to store measurements of the kernel and its
> > > > > >> command line (e.g., grub2 bootloader with tpm module enabled). IMA
> > > > > >> should include them in the boot aggregate. Registers 8-9 should be
> > > > > >> only included in non-SHA1 digests to avoid ambiguity.
> > > > > >
> > > > > >Prior to Linux 5.8, the SHA1 template data hashes were padded before
> > > > > >being extended into the TPM.  Support for calculating and extending
> > > > > >the per TPM bank template data digests is only being upstreamed in
> > > > > >Linux 5.8.
> > > > > >
> > > > > >How will attestation servers know whether to include PCRs 8 & 9 in the
> > > > > >the boot_aggregate calculation?  Now, there is a direct relationship
> > > > > >between the template data SHA1 padded digest not including PCRs 8 & 9,
> > > > > >and the new per TPM bank template data digest including them.
> > > > > 
> > > > > Got it, I'll drop it then, thank you!
> > > > 
> > > > After re-thinking this over, I realized that the attestation server can
> > > > verify the "boot_aggregate" based on the quoted PCRs without knowing
> > > > whether padded SHA1 hashes or per TPM bank hash values were extended
> > > > into the TPM[1], but non-SHA1 boot aggregate values [2] should always
> > > > include PCRs 8 & 9.
> > > 
> > > I'm still not clear on how an attestation server would know to include
> > > PCRs 8 and 9 after this change came through a stable kernel update. It
> > > doesn't seem like something appropriate for stable since it requires
> > > code changes to attestation servers to handle the change.
> > > 
> > > I know this has already been released in some stable releases, so I'm
> > > too late, but perhaps I'm missing something.
> > 
> > The point of adding PCRs 8 & 9 only to non-SHA1 boot_aggregate values
> > was to avoid affecting existing attestation servers.  The intention was
> > when attestation servers added support for the non-sha1 boot_aggregate
> > values, they'd also include PCRs 8 & 9.  The existing SHA1
> > boot_aggregate value remains PCRs 0 - 7.
> 
> AFAIK, there's nothing that prevents the non-SHA1 TPM 2.0 PCR banks from
> being used even before v5.8, albeit with zero padded SHA1 digests.
> Existing attestation servers that already support that configuration are
> broken by this stable backport.

To wrap up this thread, I think the last thing to address is if this
commit should be reverted from stable kernels? Do you have any thoughts
about that, Mimi?

Tyler

> 
> > To prevent this or something similar from happening again, what should
> > have been the proper way of including PCRs 8 & 9?
> 
> I don't think that commits like 6f1a1d103b48 ("ima: Switch to
> ima_hash_algo for boot aggregate") and 20c59ce010f8 ("ima: extend
> boot_aggregate with kernel measurements") should be backported to
> stable.
> 
> Including PCRs 8 and 9 definitely makes sense to include in the
> boot_aggregate value but limiting such a change to "starting in 5.8",
> rather than "starting in 5.8 and 5.4.82", is the safer approach when
> attestation server modifications are required.
> 
> Tyler
> 
> > 
> > thanks,
> > 
> > Mimi
> > 
