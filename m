Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F3F341F1B79
	for <lists+stable@lfdr.de>; Mon,  8 Jun 2020 16:52:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730135AbgFHOv7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Jun 2020 10:51:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:55018 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725975AbgFHOv5 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 8 Jun 2020 10:51:57 -0400
Received: from willie-the-truck (236.31.169.217.in-addr.arpa [217.169.31.236])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 13A7F206C3;
        Mon,  8 Jun 2020 14:51:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1591627917;
        bh=1puOhgt4Uwf+poNYxoCheW9wNrOBAmiWsqq8Yg7kpT0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=m1kfouFwxncpCcEUNSdwbfYPisRKvhk/SAz5yBJSKNX6jTYHy4QU21ppwYpPr5V7Q
         HrEe8QaOQAhpPu78xdMKMQ4/xH32NzcJr496kd3wG0fJOyr/huuSLV/bX10UmZI42a
         F8jFf2UKv1bK96myVv3ydxBmFRmlxTmMHY0GSYYA=
Date:   Mon, 8 Jun 2020 15:51:50 +0100
From:   Will Deacon <will@kernel.org>
To:     Nick Desaulniers <ndesaulniers@google.com>
Cc:     "Kaneda, Erik" <erik.kaneda@intel.com>,
        "Moore, Robert" <robert.moore@intel.com>,
        "Wysocki, Rafael J" <rafael.j.wysocki@intel.com>,
        Len Brown <lenb@kernel.org>, Ard Biesheuvel <ardb@kernel.org>,
        "dvyukov@google.com" <dvyukov@google.com>,
        "glider@google.com" <glider@google.com>,
        "guohanjun@huawei.com" <guohanjun@huawei.com>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "lorenzo.pieralisi@arm.com" <lorenzo.pieralisi@arm.com>,
        "mark.rutland@arm.com" <mark.rutland@arm.com>,
        "pcc@google.com" <pcc@google.com>,
        "rjw@rjwysocki.net" <rjw@rjwysocki.net>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
        "devel@acpica.org" <devel@acpica.org>
Subject: Re: [PATCH] ACPICA: fix UBSAN warning using __builtin_offsetof
Message-ID: <20200608145150.GA7418@willie-the-truck>
References: <CAMj1kXErFuvOoG=DB6sz5HBvDuHDiKwWD8uOyLuxaX-u8-+dbA@mail.gmail.com>
 <20200601231805.207441-1-ndesaulniers@google.com>
 <BYAPR11MB30969737340044437013BF44F08B0@BYAPR11MB3096.namprd11.prod.outlook.com>
 <CAKwvOdmsCmPFiDOq7AYUyEx=60B=qo8u9yhnJDQ6nd6Ew7xDkQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAKwvOdmsCmPFiDOq7AYUyEx=60B=qo8u9yhnJDQ6nd6Ew7xDkQ@mail.gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hey Nick,

On Tue, Jun 02, 2020 at 11:46:31AM -0700, Nick Desaulniers wrote:
> On Mon, Jun 1, 2020 at 5:03 PM Kaneda, Erik <erik.kaneda@intel.com> wrote:
> > > Will reported UBSAN warnings:
> > > UBSAN: null-ptr-deref in drivers/acpi/acpica/tbfadt.c:459:37
> > > UBSAN: null-ptr-deref in arch/arm64/kernel/smp.c:596:6
> > >
> > > Looks like the emulated offsetof macro ACPI_OFFSET is causing these. We
> > > can avoid this by using the compiler builtin, __builtin_offsetof.
> >
> > I'll take a look at this tomorrow
> > >
> > > The non-kernel runtime of UBSAN would print:
> > > runtime error: member access within null pointer of type for this macro.
> >
> > actypes.h is owned by ACPICA so we typically do not allow compiler-specific
> > extensions because the code is intended to be compiled using the C99 standard
> > without compiler extensions. We could allow this sort of thing in a Linux-specific
> > header file like include/acpi/platform/aclinux.h but I'll take a look at the error as well..
> 
> If I'm not allowed to touch that header, it looks like I can include
> <linux/stddef.h> (rather than my host's <stddef.h>) to get a
> definition of `offsetof` thats implemented in terms of
> `__builtin_offsetof`.  I should be able to use that to replace uses of
> ACPI_OFFSET.  Are any of these off limits?

It's not so much about not being allowed to touch the header, but rather
that the kernel imports the code from a different project:

https://acpica.org/community

> $ grep -rn ACPI_OFFSET
> arch/arm64/include/asm/acpi.h:34:#define ACPI_MADT_GICC_MIN_LENGTH
> ACPI_OFFSET(  \
> arch/arm64/include/asm/acpi.h:41:#define ACPI_MADT_GICC_SPE
> (ACPI_OFFSET(struct acpi_madt_generic_interrupt, \

I'm happy to take patches to the stuff under arch/arm64/, fwiw.

Will
