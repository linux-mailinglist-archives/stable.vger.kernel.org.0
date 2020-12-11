Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CB1932D7D3B
	for <lists+stable@lfdr.de>; Fri, 11 Dec 2020 18:48:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405622AbgLKRry (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 11 Dec 2020 12:47:54 -0500
Received: from bedivere.hansenpartnership.com ([96.44.175.130]:59906 "EHLO
        bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2405633AbgLKRrS (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 11 Dec 2020 12:47:18 -0500
Received: from localhost (localhost [127.0.0.1])
        by bedivere.hansenpartnership.com (Postfix) with ESMTP id A4A201280195;
        Fri, 11 Dec 2020 09:46:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
        d=hansenpartnership.com; s=20151216; t=1607708796;
        bh=eES7dkAWAETGlrB/U5ZcYdxiZYF5ERyWxz5zpk5XS54=;
        h=Message-ID:Subject:From:To:Date:In-Reply-To:References:From;
        b=aSCTaU08AIo2KulFz0YKW5uDbOoeqsKWNO8rT5OQkooKfvQgZoFprGW9Hij4XfqTn
         U6PBJKECnnVooKjlRbbwv/O+OMIQxkgFYOrYx4KGngF+2bMuaHYc7bQbSrXlhucPGg
         1E0wiTJzYVG7ZyXVanYziUzjN9e8C++KrjAVm4iI=
Received: from bedivere.hansenpartnership.com ([127.0.0.1])
        by localhost (bedivere.hansenpartnership.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id wC4SYAMM1k4E; Fri, 11 Dec 2020 09:46:36 -0800 (PST)
Received: from jarvis.int.hansenpartnership.com (unknown [IPv6:2601:600:8280:66d1::527])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by bedivere.hansenpartnership.com (Postfix) with ESMTPSA id 114BA1280193;
        Fri, 11 Dec 2020 09:46:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
        d=hansenpartnership.com; s=20151216; t=1607708796;
        bh=eES7dkAWAETGlrB/U5ZcYdxiZYF5ERyWxz5zpk5XS54=;
        h=Message-ID:Subject:From:To:Date:In-Reply-To:References:From;
        b=aSCTaU08AIo2KulFz0YKW5uDbOoeqsKWNO8rT5OQkooKfvQgZoFprGW9Hij4XfqTn
         U6PBJKECnnVooKjlRbbwv/O+OMIQxkgFYOrYx4KGngF+2bMuaHYc7bQbSrXlhucPGg
         1E0wiTJzYVG7ZyXVanYziUzjN9e8C++KrjAVm4iI=
Message-ID: <76710d8ec58c440ed7a7b446696b8659f694d0db.camel@HansenPartnership.com>
Subject: Re: [PATCH AUTOSEL 5.7 03/30] ima: extend boot_aggregate with
 kernel measurements
From:   James Bottomley <James.Bottomley@HansenPartnership.com>
To:     Mimi Zohar <zohar@linux.ibm.com>,
        Tyler Hicks <tyhicks@linux.microsoft.com>
Cc:     Sasha Levin <sashal@kernel.org>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, Maurizio Drocco <maurizio.drocco@ibm.com>,
        Bruno Meneguele <bmeneg@redhat.com>,
        linux-integrity@vger.kernel.org,
        linux-security-module@vger.kernel.org
Date:   Fri, 11 Dec 2020 09:46:35 -0800
In-Reply-To: <659c09673affe9637a5d1391c12af3aa710ba78a.camel@linux.ibm.com>
References: <20200708154116.3199728-1-sashal@kernel.org>
         <20200708154116.3199728-3-sashal@kernel.org>
         <1594224793.23056.251.camel@linux.ibm.com>
         <20200709012735.GX2722994@sasha-vm>
         <5b8dcdaf66fbe2a39631833b03772a11613fbbbf.camel@linux.ibm.com>
         <20201211031008.GN489768@sequoia>
         <659c09673affe9637a5d1391c12af3aa710ba78a.camel@linux.ibm.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.34.4 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, 2020-12-11 at 06:01 -0500, Mimi Zohar wrote:
> On Thu, 2020-12-10 at 21:10 -0600, Tyler Hicks wrote:
> > On 2020-11-29 08:17:38, Mimi Zohar wrote:
> > > Hi Sasha,
> > > 
> > > On Wed, 2020-07-08 at 21:27 -0400, Sasha Levin wrote:
> > > > On Wed, Jul 08, 2020 at 12:13:13PM -0400, Mimi Zohar wrote:
> > > > > Hi Sasha,
> > > > > 
> > > > > On Wed, 2020-07-08 at 11:40 -0400, Sasha Levin wrote:
> > > > > > From: Maurizio Drocco <maurizio.drocco@ibm.com>
> > > > > > 
> > > > > > [ Upstream commit 20c59ce010f84300f6c655d32db2610d3433f85c
> > > > > > ]
> > > > > > 
> > > > > > Registers 8-9 are used to store measurements of the kernel
> > > > > > and its command line (e.g., grub2 bootloader with tpm
> > > > > > module enabled). IMA should include them in the boot
> > > > > > aggregate. Registers 8-9 should be only included in non-
> > > > > > SHA1 digests to avoid ambiguity.
> > > > > 
> > > > > Prior to Linux 5.8, the SHA1 template data hashes were padded
> > > > > before being extended into the TPM.  Support for calculating
> > > > > and extending the per TPM bank template data digests is only
> > > > > being upstreamed in Linux 5.8.
> > > > > 
> > > > > How will attestation servers know whether to include PCRs 8 &
> > > > > 9 in the the boot_aggregate calculation?  Now, there is a
> > > > > direct relationship between the template data SHA1 padded
> > > > > digest not including PCRs 8 & 9, and the new per TPM bank
> > > > > template data digest including them.
> > > > 
> > > > Got it, I'll drop it then, thank you!
> > > 
> > > After re-thinking this over, I realized that the attestation
> > > server can verify the "boot_aggregate" based on the quoted PCRs
> > > without knowing whether padded SHA1 hashes or per TPM bank hash
> > > values were extended into the TPM[1], but non-SHA1 boot aggregate
> > > values [2] should always include PCRs 8 & 9.
> > 
> > I'm still not clear on how an attestation server would know to
> > include PCRs 8 and 9 after this change came through a stable kernel
> > update. It doesn't seem like something appropriate for stable since
> > it requires code changes to attestation servers to handle the
> > change.
> > 
> > I know this has already been released in some stable releases, so
> > I'm too late, but perhaps I'm missing something.
> 
> The point of adding PCRs 8 & 9 only to non-SHA1 boot_aggregate values
> was to avoid affecting existing attestation servers.  The intention
> was when attestation servers added support for the non-sha1
> boot_aggregate values, they'd also include PCRs 8 & 9.  The existing
> SHA1 boot_aggregate value remains PCRs 0 - 7.
> 
> To prevent this or something similar from happening again, what
> should have been the proper way of including PCRs 8 & 9?

Just to be pragmatic: this is going to happen again.  Shim is already
measuring the Mok variables through PCR 14, so if we want an accurate
boot aggregate, we're going to have to include PCR 14 as well (or
persuade shim to measure through a PCR we're already including, which
isn't impossible since I think shim should be measuring the Mok
variables using the EV_EFI_VARIABLE_DRIVER_CONFIG event and, since it
affects secure boot policy, that does argue it should be measured
through PCR 7).

James


