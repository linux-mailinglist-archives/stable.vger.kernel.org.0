Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D1701F04FD
	for <lists+stable@lfdr.de>; Tue,  5 Nov 2019 19:22:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390741AbfKESWe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Nov 2019 13:22:34 -0500
Received: from mail.kernel.org ([198.145.29.99]:55406 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390482AbfKESWe (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 5 Nov 2019 13:22:34 -0500
Received: from willie-the-truck (236.31.169.217.in-addr.arpa [217.169.31.236])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B5B0F20656;
        Tue,  5 Nov 2019 18:22:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1572978153;
        bh=2PpdqCgtXuVnsFpdkcLkVmqLIbzVGdR/tiI6Ud/y9SQ=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=oA659C/SaDyW4wKF4dDC7UmaM5b4VqXmNQwJdpBlvFX1FygyLep/7X3ECuYAk8+aj
         Vtt+25WG3La5pHDmsxj16olIEjKbIdq0jtBh1AzNOOemuRsGW66+EKRw2+TgG1G3gM
         RWL5HVL4uvsYPSscbChRFCA3fkj8IYDYKBCIzXVE=
Date:   Tue, 5 Nov 2019 18:22:29 +0000
From:   Will Deacon <will@kernel.org>
To:     John Stultz <john.stultz@linaro.org>
Cc:     Catalin Marinas <catalin.marinas@arm.com>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        stable <stable@vger.kernel.org>,
        Alistair Delva <adelva@google.com>,
        Sandeep Patil <sspatil@google.com>
Subject: Re: [PATCH] arm64: Ensure VM_WRITE|VM_SHARED ptes are clean by
 default
Message-ID: <20191105182228.GA388@willie-the-truck>
References: <20191029153051.24367-1-catalin.marinas@arm.com>
 <CALAqxLXuxZVg0kqNQXF_dH17NzH9m14-Ci_rzruHzmms0V7pvg@mail.gmail.com>
 <20191105102902.GB29852@willie-the-truck>
 <CALAqxLVT-SK0-nNUmbDWa3kkZED2z+pcryzuue9c=n42shu3kA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CALAqxLVT-SK0-nNUmbDWa3kkZED2z+pcryzuue9c=n42shu3kA@mail.gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Nov 05, 2019 at 09:06:43AM -0800, John Stultz wrote:
> On Tue, Nov 5, 2019 at 2:29 AM Will Deacon <will@kernel.org> wrote:
> > On Mon, Nov 04, 2019 at 05:16:42PM -0800, John Stultz wrote:
> > >   So I'm not yet sure why, but I've just validated that this patch is
> > > causing trouble with booting AOSP on HiKey960 with 5.4-rc6 (-rc5 works
> > > fine).

[...]

> > As an experiment, can you try reverting just the part of the patch that
> > removes PTE_DIRTY from the PROT_* definitions? (see below)
> 
> I'll give this a try! Feel free to let me know if there's anything
> else I should test.

Thanks. Also worth trying to revert 747a70e60b72 instead of this patch, as
Catalin suggested.

Will
