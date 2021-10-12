Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 60BAF429DE3
	for <lists+stable@lfdr.de>; Tue, 12 Oct 2021 08:42:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232690AbhJLGo0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 Oct 2021 02:44:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:60030 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232931AbhJLGoX (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 12 Oct 2021 02:44:23 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id DEE2A60F21;
        Tue, 12 Oct 2021 06:42:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1634020942;
        bh=TZofqd5FCz2brY/O/c6Q4V3uBUR/wzIyfsmqHOHu9ig=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=lVk9a8/hl4MzcABvawLAdg0c0R3O1GdFbLivScQaMQReVsfksmADnBezYwiPfaMDs
         EFrjQSNRtR0+6DiRK4i6BiZZPV0KTqtO1nBLF2n3UC/bfaVEP2fN2NTc6HSvZ2O6KC
         4C4I9YZ1AdGM3e7b9nbed/R6CwmCDAmb9cbuYgzg=
Date:   Tue, 12 Oct 2021 08:42:19 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Sasha Levin <sashal@kernel.org>
Cc:     Christophe Leroy <christophe.leroy@csgroup.eu>,
        Naresh Kamboju <naresh.kamboju@linaro.org>,
        open list <linux-kernel@vger.kernel.org>,
        linux-stable <stable@vger.kernel.org>,
        "Naveen N. Rao" <naveen.n.rao@linux.vnet.ibm.com>,
        Johan Almbladh <johan.almbladh@anyfinetworks.com>,
        Song Liu <songliubraving@fb.com>,
        Michael Ellerman <mpe@ellerman.id.au>
Subject: Re: [PATCH 5.4 49/52] powerpc/bpf: Fix BPF_MOD when imm == 1
Message-ID: <YWUuSxGRyqIaqETE@kroah.com>
References: <20211011134503.715740503@linuxfoundation.org>
 <20211011134505.420785540@linuxfoundation.org>
 <CA+G9fYtUcnJioz4rPonLvjhwwNFmXYfiqE+0uUDO5aZcuoa0MQ@mail.gmail.com>
 <21099a2e-b1d3-a1dd-be79-3e491afe20cc@csgroup.eu>
 <YWTcfEigynJLoEa/@sashalap>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <YWTcfEigynJLoEa/@sashalap>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Oct 11, 2021 at 08:53:16PM -0400, Sasha Levin wrote:
> On Mon, Oct 11, 2021 at 08:24:30PM +0200, Christophe Leroy wrote:
> > 
> > 
> > Le 11/10/2021 à 19:33, Naresh Kamboju a écrit :
> > > stable-rc 5.4 build failed due this patch.
> > >  - powerpc gcc-10-defconfig - FAILED
> > >  - powerpc gcc-11-defconfig - FAILED
> > >  - powerpc gcc-8-defconfig - FAILED
> > >  - powerpc gcc-9-defconfig - FAILED
> > > 
> > > 
> > > On Mon, 11 Oct 2021 at 19:28, Greg Kroah-Hartman
> > > <gregkh@linuxfoundation.org> wrote:
> > > > 
> > > > From: Naveen N. Rao <naveen.n.rao@linux.vnet.ibm.com>
> > > > 
> > > > [ Upstream commit 8bbc9d822421d9ac8ff9ed26a3713c9afc69d6c8 ]
> > > > 
> > > > Only ignore the operation if dividing by 1.
> > > 
> > > <trim>
> > > 
> > > In file included from arch/powerpc/net/bpf_jit64.h:11,
> > >                  from arch/powerpc/net/bpf_jit_comp64.c:19:
> > > arch/powerpc/net/bpf_jit_comp64.c: In function 'bpf_jit_build_body':
> > > arch/powerpc/net/bpf_jit_comp64.c:415:46: error: implicit declaration
> > > of function 'PPC_RAW_LI'; did you mean 'PPC_RLWIMI'?
> > 
> > PPC_RAW_LI() was added by commit 3a1812379163 ("powerpc/ppc-opcode:
> > Consolidate powerpc instructions from bpf_jit.h")
> > 
> > Priori to that you have to use PPC_LI() instead, with the same arguments.
> 
> I think that I forgot to reply: I've pushed a fixed patch resolved as
> proposed above.

Thanks, I'll go push out new -rc for 4.19 and 5.4 now.

greg k-h
