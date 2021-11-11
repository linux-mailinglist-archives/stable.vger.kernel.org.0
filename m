Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F151F44D02D
	for <lists+stable@lfdr.de>; Thu, 11 Nov 2021 03:56:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230027AbhKKC7f (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 10 Nov 2021 21:59:35 -0500
Received: from mail.kernel.org ([198.145.29.99]:60708 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229699AbhKKC7e (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 10 Nov 2021 21:59:34 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6789F60F46;
        Thu, 11 Nov 2021 02:56:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1636599405;
        bh=H6tHr5NfLSh87fUojoQq+mnI4oI93uWaeta7PBQYnnU=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=lSMuEbwpVcY1ImM3xTmDkuEh1C2lbjENZgUTqlQEhd2SvefbM1I6W4BkwcHO4ghot
         aDvcC0wmjC+w85GI0+1nQ4WNYh/ViQeTjP4EXyVomnS5t/K+5irYhK8MOhTFdWqb7a
         XQENvnAt7lYzsmi0C4nXZadzLdgRdOC6CRPLVAp4T7Mcnw9gUEnkPpl9IHxaxDOnx2
         k4HR0gTbQehDrgltzN9h55WnXKrYV9H5QUiRit7iX5puqK/SLhuynaP+h9gwEuHtlj
         b+kn9OvdnyLj+RCBEUB0ftU3scyDZjTPiOESgvDcAPFxFHa9pabBoa/bNhjtB5TbeB
         XTnU6vgj/BWog==
Message-ID: <e5bc04905eccbd0ac9fbcf20d363ab90371f6e1c.camel@kernel.org>
Subject: Re: [PATCH V2] x86/sgx: Fix free page accounting
From:   Jarkko Sakkinen <jarkko@kernel.org>
To:     "Luck, Tony" <tony.luck@intel.com>,
        "Chatre, Reinette" <reinette.chatre@intel.com>,
        "dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "bp@alien8.de" <bp@alien8.de>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "linux-sgx@vger.kernel.org" <linux-sgx@vger.kernel.org>,
        "x86@kernel.org" <x86@kernel.org>
Cc:     "seanjc@google.com" <seanjc@google.com>,
        "hpa@zytor.com" <hpa@zytor.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Date:   Thu, 11 Nov 2021 04:56:43 +0200
In-Reply-To: <bcc3a465dde24f8dab469b4260753e40@intel.com>
References: <b2e69e9febcae5d98d331de094d9cc7ce3217e66.1636487172.git.reinette.chatre@intel.com>
         <8e0bb87f05b79317a06ed2d8ab5e2f5cf6132b6a.camel@kernel.org>
         <794a7034-f6a7-4aff-7958-b1bd959ced24@intel.com>
         <bcc3a465dde24f8dab469b4260753e40@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.40.4-1 
MIME-Version: 1.0
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, 2021-11-10 at 19:16 +0000, Luck, Tony wrote:
> > > > The consequence of sgx_nr_free_pages not being protected is that
> > > > its value may not accurately reflect the actual number of free
> > > > pages on the system, impacting the availability of free pages in
> > > > support of many flows. The problematic scenario isu when the
> > >=20
> > > In non-atomicity is not a problem, when it is not a problem :-)
>=20
> This is most definitely a problem.
>=20
> start with sgx_nr_free_pages =3D=3D 100
>=20
> Now have a cpu on node0 allocate a page at the same time as another
> cpu on node1 allcoates a page. Each holds the relevent per-node lock,
> but that doesn't stop both CPUs from accessing the global together:
>=20
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0CPU on node0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0CPU on node1
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0sgx_nr_free_pages--;=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0sgx_nr=
_free_pages--;
>=20
> What is the value of sgx_nr_free_pages now? We want it to be 98,
> but it could be 99.
>=20
> Rinse, repeat thousands of times. Eventually the value of sgx_nr_free_pag=
es
> has not even a close connection to the number of free pages.
>=20
> -Tony

Yeah, so I figured this (see my follow-up response to Reinette) but
such description is lacking from the commit message.

/Jarkko

