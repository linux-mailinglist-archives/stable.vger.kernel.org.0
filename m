Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D118F2D6E5D
	for <lists+stable@lfdr.de>; Fri, 11 Dec 2020 04:13:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392106AbgLKDLC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 10 Dec 2020 22:11:02 -0500
Received: from linux.microsoft.com ([13.77.154.182]:38126 "EHLO
        linux.microsoft.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729331AbgLKDKv (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 10 Dec 2020 22:10:51 -0500
Received: from sequoia (162-237-133-238.lightspeed.rcsntx.sbcglobal.net [162.237.133.238])
        by linux.microsoft.com (Postfix) with ESMTPSA id 1AA7920B717A;
        Thu, 10 Dec 2020 19:10:10 -0800 (PST)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 1AA7920B717A
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
        s=default; t=1607656210;
        bh=UjXdwP2ZHKFxPJkmlk76kE+9RzmPBF3Xf8HNjv05RPE=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=iZFK29ut36BwHBbKNBpcvUPr32umM+0qxOCVISeIxhi6k7fwPq+62tCU8Gwl5W5pm
         4YhdwUVPbyrQP39Wq9uhsPJcZsLYwJASDupHYEkW6gywDAJqD0U67kwwkSt1aysqwc
         lWL6VcuecrDcXM5Um1L7FU/qizWs6Gg5YQteOUMI=
Date:   Thu, 10 Dec 2020 21:10:08 -0600
From:   Tyler Hicks <tyhicks@linux.microsoft.com>
To:     Mimi Zohar <zohar@linux.ibm.com>
Cc:     Sasha Levin <sashal@kernel.org>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, Maurizio Drocco <maurizio.drocco@ibm.com>,
        Bruno Meneguele <bmeneg@redhat.com>,
        linux-integrity@vger.kernel.org,
        linux-security-module@vger.kernel.org
Subject: Re: [PATCH AUTOSEL 5.7 03/30] ima: extend boot_aggregate with kernel
 measurements
Message-ID: <20201211031008.GN489768@sequoia>
References: <20200708154116.3199728-1-sashal@kernel.org>
 <20200708154116.3199728-3-sashal@kernel.org>
 <1594224793.23056.251.camel@linux.ibm.com>
 <20200709012735.GX2722994@sasha-vm>
 <5b8dcdaf66fbe2a39631833b03772a11613fbbbf.camel@linux.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5b8dcdaf66fbe2a39631833b03772a11613fbbbf.camel@linux.ibm.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 2020-11-29 08:17:38, Mimi Zohar wrote:
> Hi Sasha,
> 
> On Wed, 2020-07-08 at 21:27 -0400, Sasha Levin wrote:
> > On Wed, Jul 08, 2020 at 12:13:13PM -0400, Mimi Zohar wrote:
> > >Hi Sasha,
> > >
> > >On Wed, 2020-07-08 at 11:40 -0400, Sasha Levin wrote:
> > >> From: Maurizio Drocco <maurizio.drocco@ibm.com>
> > >>
> > >> [ Upstream commit 20c59ce010f84300f6c655d32db2610d3433f85c ]
> > >>
> > >> Registers 8-9 are used to store measurements of the kernel and its
> > >> command line (e.g., grub2 bootloader with tpm module enabled). IMA
> > >> should include them in the boot aggregate. Registers 8-9 should be
> > >> only included in non-SHA1 digests to avoid ambiguity.
> > >
> > >Prior to Linux 5.8, the SHA1 template data hashes were padded before
> > >being extended into the TPM.  Support for calculating and extending
> > >the per TPM bank template data digests is only being upstreamed in
> > >Linux 5.8.
> > >
> > >How will attestation servers know whether to include PCRs 8 & 9 in the
> > >the boot_aggregate calculation?  Now, there is a direct relationship
> > >between the template data SHA1 padded digest not including PCRs 8 & 9,
> > >and the new per TPM bank template data digest including them.
> > 
> > Got it, I'll drop it then, thank you!
> 
> After re-thinking this over, I realized that the attestation server can
> verify the "boot_aggregate" based on the quoted PCRs without knowing
> whether padded SHA1 hashes or per TPM bank hash values were extended
> into the TPM[1], but non-SHA1 boot aggregate values [2] should always
> include PCRs 8 & 9.

I'm still not clear on how an attestation server would know to include
PCRs 8 and 9 after this change came through a stable kernel update. It
doesn't seem like something appropriate for stable since it requires
code changes to attestation servers to handle the change.

I know this has already been released in some stable releases, so I'm
too late, but perhaps I'm missing something.

Tyler

> 
> Any place commit 6f1a1d103b48 was backported [2], this commit
> 20c59ce010f8 ("ima: extend boot_aggregate with kernel measurements")
> should be backported as well.
> 
> thanks,
> 
> Mimi
> 
> [1] commit 1ea973df6e21 ("ima: Calculate and extend PCR with digests in ima_template_entry")
> [2] commit 6f1a1d103b48 ("ima: Switch to ima_hash_algo for boot aggregate")
> 
