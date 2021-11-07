Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6C8514473F0
	for <lists+stable@lfdr.de>; Sun,  7 Nov 2021 17:48:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234926AbhKGQuo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 7 Nov 2021 11:50:44 -0500
Received: from mail.kernel.org ([198.145.29.99]:47638 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230092AbhKGQun (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 7 Nov 2021 11:50:43 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 71CD96108B;
        Sun,  7 Nov 2021 16:48:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1636303680;
        bh=LuqyXW0s3iea0qghV4oS1d9eUNF23p9aYTCVd99xMvE=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=aDOMpvuDNeyasOPFzhX4nGLa6ZXwfxPX3U1Vjq77APWqRmSiUx3jLg3Xsrn/ugm9V
         bmjVCUiM/BnRwBbnG9fsQjJ0sDkCDh9lcdYdB5NARICOOfOJgApq6POIdvNC6DnE1f
         KodnVm1U7zSA23oa+866uTuZ22MbK0peyHxuPBXeU3HTtQs8F/9a2bzhkjqcdjgpCJ
         V5WyZWVWFzdPgz4Ase+QKnLouHdt6SAVPsD8w8GBbabe4Q7hnfbHl7rM87HsWT+fZB
         dfLgekhFOB1D4OJVcj6g2Jvw/nuVIRDfbVN4Z4Fdm7QIA5RbU/EKee+I28mM7QXYXH
         BTSEzySLfOo3w==
Message-ID: <2a0b84575733e4aaee13926387d997c35ac23130.camel@kernel.org>
Subject: Re: [PATCH] x86/sgx: Fix free page accounting
From:   Jarkko Sakkinen <jarkko@kernel.org>
To:     Reinette Chatre <reinette.chatre@intel.com>,
        dave.hansen@linux.intel.com, tglx@linutronix.de, bp@alien8.de,
        mingo@redhat.com, linux-sgx@vger.kernel.org, x86@kernel.org
Cc:     seanjc@google.com, tony.luck@intel.com, hpa@zytor.com,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
Date:   Sun, 07 Nov 2021 18:47:58 +0200
In-Reply-To: <6e51fdacc2c1d834258f00ad8cc268b8d782eca7.camel@kernel.org>
References: <373992d869cd356ce9e9afe43ef4934b70d604fd.1636049678.git.reinette.chatre@intel.com>
         <6e51fdacc2c1d834258f00ad8cc268b8d782eca7.camel@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.40.4-1 
MIME-Version: 1.0
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sun, 2021-11-07 at 18:45 +0200, Jarkko Sakkinen wrote:
> On Thu, 2021-11-04 at 11:28 -0700, Reinette Chatre wrote:
> > The consequence of sgx_nr_free_pages not being protected is that
> > its value may not accurately reflect the actual number of free
> > pages on the system, impacting the availability of free pages in
> > support of many flows. The problematic scenario is when the
> > reclaimer never runs because it believes there to be sufficient
> > free pages while any attempt to allocate a page fails because there
> > are no free pages available. The worst scenario observed was a
> > user space hang because of repeated page faults caused by
> > no free pages ever made available.
>=20
> Can you go in detail with the "concrete scenario" in the commit
> message? It does not have to describe all the possible scenarios
> but at least one sequence of events.

I.e. I don't have anything fundamentally against changing it to
atomic but the commit message is completely lacking the stimulus
of changing anything.

/Jarkko
