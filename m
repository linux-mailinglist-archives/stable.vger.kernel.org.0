Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2295F1992C5
	for <lists+stable@lfdr.de>; Tue, 31 Mar 2020 11:58:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730238AbgCaJ6J (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 31 Mar 2020 05:58:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:57604 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729997AbgCaJ6J (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 31 Mar 2020 05:58:09 -0400
Received: from linux-8ccs (p5B2812F9.dip0.t-ipconnect.de [91.40.18.249])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 36A8E207FF;
        Tue, 31 Mar 2020 09:58:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1585648687;
        bh=j53bvZidThROsMlIKqxJh6L5OROspIzLNeciEaCtFzs=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=EBh8rBOM0iPoZa7T/yhJaggNiQYCjxnXFxSfp8oiusNoEvZ4xsfOUikvuWa9iDab0
         SYiB81mMVKdi6dCCj2pSvw4JtoTuDykVQMTK+90otGUorPI0gLF7vaojwQRvZ5Zf4C
         rE+n0qnyXYoAIBul8CIKKf7+gNUMbxgwddThTcs0=
Date:   Tue, 31 Mar 2020 11:58:02 +0200
From:   Jessica Yu <jeyu@kernel.org>
To:     John Stultz <john.stultz@linaro.org>
Cc:     Masahiro Yamada <yamada.masahiro@socionext.com>,
        Matthias Maennich <maennich@google.com>,
        Lucas De Marchi <lucas.de.marchi@gmail.com>,
        stable@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2] modpost: move the namespace field in Module.symvers
 last
Message-ID: <20200331095802.GA3026@linux-8ccs>
References: <20200311170120.12641-1-jeyu@kernel.org>
 <CANcMJZDhSUV8CU_ixOSxstVVBMW3rVrrQVYMmy1fz=OdhxA_GQ@mail.gmail.com>
 <CANcMJZD9Lz-J_idL5i225VR_3Mo6PcTRsYBBrGsMByX6W4jepQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <CANcMJZD9Lz-J_idL5i225VR_3Mo6PcTRsYBBrGsMByX6W4jepQ@mail.gmail.com>
X-OS:   Linux linux-8ccs 4.12.14-lp150.12.61-default x86_64
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

+++ John Stultz [30/03/20 23:25 -0700]:
>On Mon, Mar 30, 2020 at 10:49 PM John Stultz <john.stultz@linaro.org> wrote:
>> On Wed, Mar 11, 2020 at 10:03 AM Jessica Yu <jeyu@kernel.org> wrote:
>> >
>> > In order to preserve backwards compatability with kmod tools, we have to
>> > move the namespace field in Module.symvers last, as the depmod -e -E
>> > option looks at the first three fields in Module.symvers to check symbol
>> > versions (and it's expected they stay in the original order of crc,
>> > symbol, module).
>> >
>> > In addition, update an ancient comment above read_dump() in modpost that
>> > suggested that the export type field in Module.symvers was optional. I
>> > suspect that there were historical reasons behind that comment that are
>> > no longer accurate. We have been unconditionally printing the export
>> > type since 2.6.18 (commit bd5cbcedf44), which is over a decade ago now.
>> >
>> > Fix up read_dump() to treat each field as non-optional. I suspect the
>> > original read_dump() code treated the export field as optional in order
>> > to support pre <= 2.6.18 Module.symvers (which did not have the export
>> > type field). Note that although symbol namespaces are optional, the
>> > field will not be omitted from Module.symvers if a symbol does not have
>> > a namespace. In this case, the field will simply be empty and the next
>> > delimiter or end of line will follow.
>> >
>> > Cc: stable@vger.kernel.org
>> > Fixes: cb9b55d21fe0 ("modpost: add support for symbol namespaces")
>> > Tested-by: Matthias Maennich <maennich@google.com>
>> > Reviewed-by: Matthias Maennich <maennich@google.com>
>> > Reviewed-by: Lucas De Marchi <lucas.demarchi@intel.com>
>> > Signed-off-by: Jessica Yu <jeyu@kernel.org>
>> > ---
>> > v2:
>> >
>> >   - Explain the changes to read_dump() and the comment (and provide
>> >     historical context) in the commit message. (Lucas De Marchi)
>> >
>> >  Documentation/kbuild/modules.rst |  4 ++--
>> >  scripts/export_report.pl         |  2 +-
>> >  scripts/mod/modpost.c            | 24 ++++++++++++------------
>> >  3 files changed, 15 insertions(+), 15 deletions(-)
>> >
>> > diff --git a/Documentation/kbuild/modules.rst b/Documentation/kbuild/modules.rst
>> > index 69fa48ee93d6..e0b45a257f21 100644
>> > --- a/Documentation/kbuild/modules.rst
>> > +++ b/Documentation/kbuild/modules.rst
>> > @@ -470,9 +470,9 @@ build.
>> >
>> >         The syntax of the Module.symvers file is::
>> >
>> > -       <CRC>       <Symbol>          <Namespace>  <Module>                         <Export Type>
>> > +       <CRC>       <Symbol>         <Module>                         <Export Type>     <Namespace>
>> >
>> > -       0xe1cc2a05  usb_stor_suspend  USB_STORAGE  drivers/usb/storage/usb-storage  EXPORT_SYMBOL_GPL
>> > +       0xe1cc2a05  usb_stor_suspend drivers/usb/storage/usb-storage  EXPORT_SYMBOL_GPL USB_STORAGE
>> >
>> >         The fields are separated by tabs and values may be empty (e.g.
>> >         if no namespace is defined for an exported symbol).
>>
>> Despite the documentation here claiming the namespace field can be
>> empty, I'm seeing some trouble with this patch when building external
>> modules:
>>   FATAL: parse error in symbol dump file
>>
>> I've confirmed reverting it make things work again, but its not clear
>> to me quite yet why.
>>
>> The only difference I can find is that the Module.symvers in the
>> external module project doesn't seem to have a tab at the end of each
>> line (where as Module.symvers for the kernel - which doesn't seem to
>> have any namespace names - does).
>>
>> Is there something I need to tweak on the external Kbuild to get
>> Module.symvers to be generated properly (with the empty tab at the
>> end) for this new change?
>> Or does the parser need to be a bit more flexible?
>>
>
>One extra clue on this: I noticed the external module Makefile had
>KBUILD_EXTRA_SYMBOLS="$(EXTRA_SYMBOLS)"  in the $(MAKE) string, where
>EXTRA_SYMBOLS pointed to some files that no longer exist.  I removed
>the KBUILD_EXTRA_SYMBOLS= argument, and magically, the generated
>Module.symvers now had tabs at the end of each line.
>
>I wonder if there some path in the KBUILD_EXTRA_SYMBOLS= handling that
>isn't generating the output in the same way?

I'm afraid we're going to need some specifics on reproducing this
issue. Could you provide a reproducer or steps on how to reproduce? I
have not been able to trigger this problem even with
KBUILD_EXTRA_SYMBOLS pointing to an invalid path (I also tested with
valid paths).

I tested with a skeleton external module that exports two functions,
one with a namespace and one without. I built this module against the
latest v5.6 kernel. The generated Module.symvers was correct - the
namespaced function had the namespace at the end and the other
function without a namespace had a tab at the end.

I also tested with two external modules, one with a symbol dependency
on the other, so KBUILD_EXTRA_SYMBOLS usage is required here. The
generated Module.symvers was also correct here.

The only advice I can offer at this time is that all external modules
must be built against the new kernel to generate a correctly formated
Module.symvers file. If you have any KBUILD_EXTRA_SYMBOLS pointing to
an outdated Module.symvers file for example, you will see the "FATAL:
parse error in symbol dump file" error.

Hope this helps,

Jessica

