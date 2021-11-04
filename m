Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 16802445649
	for <lists+stable@lfdr.de>; Thu,  4 Nov 2021 16:25:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231441AbhKDP1o (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 4 Nov 2021 11:27:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:40780 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231305AbhKDP1o (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 4 Nov 2021 11:27:44 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6F0B460F70;
        Thu,  4 Nov 2021 15:25:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1636039505;
        bh=vrVc5faDOhH1k8/I7w8i9951zMZhVdsvnZ8o+77I/8A=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=VR7+8CVqsCy8IHFocaHStPga0zmjMW2R2k1js8R+jLM84yGjw/l9RQelEr0TYnnAr
         Yvpdgd/QMB0PipNM/Y7ZA2Kxm7XjiQVwFv3r7+bebHzNs4/ad4wYCWfZlQvbZxFEq+
         cicBLq12oNzqwChIs+8++nBXi0fBOu+/K9b0qQmyTZ9vsE6d4YtblphyYc+tKipTKJ
         3GP9YtiU2v2wjRTHYeMuDQZURR4yLjajSjtDAiSxLdgwp6U1Qgn/vnR4vD1FvAIkd5
         r4GLb7SCt7q6e7VcrwEn1RLKHNjrukq7cPERvhy1fQOKIRrt6EFrmSCCl44L7EGCGo
         dwZM6wm84VYFA==
Message-ID: <55eb8f3649590289a0f2b1ebe7583b6da3ff70ee.camel@kernel.org>
Subject: Re: [PATCH] x86/sgx: Free backing memory after faulting the enclave
 page
From:   Jarkko Sakkinen <jarkko@kernel.org>
To:     Dave Hansen <dave.hansen@intel.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        Jethro Beekman <jethro@fortanix.com>,
        Sean Christopherson <seanjc@google.com>
Cc:     reinette.chatre@intel.com, tony.luck@intel.com,
        nathaniel@profian.com, stable@vger.kernel.org,
        Borislav Petkov <bp@suse.de>, linux-sgx@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date:   Thu, 04 Nov 2021 17:25:03 +0200
In-Reply-To: <d2191571-30a5-c2aa-e8ed-0a380e9daeac@intel.com>
References: <20211103232238.110557-1-jarkko@kernel.org>
         <6831ed3c-c5b1-64f7-2ad7-f2d686224b7e@intel.com>
         <e88d6d580354aadaa8eaa5ee6fa703f021786afb.camel@kernel.org>
         <d2191571-30a5-c2aa-e8ed-0a380e9daeac@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.40.4-1 
MIME-Version: 1.0
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, 2021-11-04 at 08:13 -0700, Dave Hansen wrote:
> On 11/4/21 8:04 AM, Jarkko Sakkinen wrote:
> > > Do we also need to deal with truncating the PCMD?=C2=A0 (For those wa=
tching
> > > along at home, there are two things SGX swaps to RAM: the actual page
> > > data and also some metadata that ensures page integrity and helps
> > > prevent things like rolling back to old versions of swapped pages)
> > Yes.
> >=20
> > This can be achieved by iterating through all of the enclave pages,
> > which share the same shmem page for storing their PCMD's, as the one
> > being faulted back. If none of those pages is swapped, the PCMD page ca=
n
> > safely truncated.
>=20
> I was thinking we could just read the page.=C2=A0 If it's all 0's, trunca=
te it.

Hmm... did ELDU zero PCMD as a side-effect?

It should be fairly effecient just to check the pages by using
encl->page_tree.

/Jarkko
