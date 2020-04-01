Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6DBCB19A6BE
	for <lists+stable@lfdr.de>; Wed,  1 Apr 2020 10:00:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731889AbgDAIAk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 1 Apr 2020 04:00:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:37082 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731850AbgDAIAj (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 1 Apr 2020 04:00:39 -0400
Received: from linux-8ccs (p5B2810DC.dip0.t-ipconnect.de [91.40.16.220])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 38CBD20772;
        Wed,  1 Apr 2020 08:00:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1585728039;
        bh=im9NhckjMhp6IuKXAiwXCPVbJm/9/jk8yEApnbmzIgs=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=mM7o4/Xi38CVA5xh9o6QlLEVPe3IbxkThzhk1h5UQnzvQXgvOlgOiVhNgJyYr5yto
         wCyLOPe+KrWXJjfiG0DxmPcwk/nCM9/2Dhsc82DF0AVrszXZMN8DsXq1YqthgDsIzr
         dUkoL+0ahXpIBA9kt4U7WQygpErH5algqY2klaVw=
Date:   Wed, 1 Apr 2020 10:00:34 +0200
From:   Jessica Yu <jeyu@kernel.org>
To:     John Stultz <john.stultz@linaro.org>
Cc:     Masahiro Yamada <yamada.masahiro@socionext.com>,
        Matthias Maennich <maennich@google.com>,
        Lucas De Marchi <lucas.de.marchi@gmail.com>,
        stable <stable@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2] modpost: move the namespace field in Module.symvers
 last
Message-ID: <20200401080033.GA12505@linux-8ccs>
References: <20200311170120.12641-1-jeyu@kernel.org>
 <CANcMJZDhSUV8CU_ixOSxstVVBMW3rVrrQVYMmy1fz=OdhxA_GQ@mail.gmail.com>
 <CANcMJZD9Lz-J_idL5i225VR_3Mo6PcTRsYBBrGsMByX6W4jepQ@mail.gmail.com>
 <20200331095802.GA3026@linux-8ccs>
 <CALAqxLWZ8aET=gHpYUi_v0ez-gDT5nPEnAEb+2uxebFU8D9RXg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <CALAqxLWZ8aET=gHpYUi_v0ez-gDT5nPEnAEb+2uxebFU8D9RXg@mail.gmail.com>
X-OS:   Linux linux-8ccs 4.12.14-lp150.12.61-default x86_64
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

+++ John Stultz [31/03/20 15:09 -0700]:
>On Tue, Mar 31, 2020 at 2:58 AM Jessica Yu <jeyu@kernel.org> wrote:
>> +++ John Stultz [30/03/20 23:25 -0700]:
>> >On Mon, Mar 30, 2020 at 10:49 PM John Stultz <john.stultz@linaro.org> wrote:
>> >> The only difference I can find is that the Module.symvers in the
>> >> external module project doesn't seem to have a tab at the end of each
>> >> line (where as Module.symvers for the kernel - which doesn't seem to
>> >> have any namespace names - does).
>> >>
>> >> Is there something I need to tweak on the external Kbuild to get
>> >> Module.symvers to be generated properly (with the empty tab at the
>> >> end) for this new change?
>> >> Or does the parser need to be a bit more flexible?
>> >>
>> >
>> >One extra clue on this: I noticed the external module Makefile had
>> >KBUILD_EXTRA_SYMBOLS="$(EXTRA_SYMBOLS)"  in the $(MAKE) string, where
>> >EXTRA_SYMBOLS pointed to some files that no longer exist.  I removed
>> >the KBUILD_EXTRA_SYMBOLS= argument, and magically, the generated
>> >Module.symvers now had tabs at the end of each line.
>> >
>> >I wonder if there some path in the KBUILD_EXTRA_SYMBOLS= handling that
>> >isn't generating the output in the same way?
>>
>> I'm afraid we're going to need some specifics on reproducing this
>> issue. Could you provide a reproducer or steps on how to reproduce? I
>> have not been able to trigger this problem even with
>> KBUILD_EXTRA_SYMBOLS pointing to an invalid path (I also tested with
>> valid paths).
>>
>> I tested with a skeleton external module that exports two functions,
>> one with a namespace and one without. I built this module against the
>> latest v5.6 kernel. The generated Module.symvers was correct - the
>> namespaced function had the namespace at the end and the other
>> function without a namespace had a tab at the end.
>>
>> I also tested with two external modules, one with a symbol dependency
>> on the other, so KBUILD_EXTRA_SYMBOLS usage is required here. The
>> generated Module.symvers was also correct here.
>>
>> The only advice I can offer at this time is that all external modules
>> must be built against the new kernel to generate a correctly formated
>> Module.symvers file. If you have any KBUILD_EXTRA_SYMBOLS pointing to
>> an outdated Module.symvers file for example, you will see the "FATAL:
>> parse error in symbol dump file" error.
>
>Well, my apologies.  :(  In the light of day, this isn't reproducing
>anymore. I'm a bit at a loss as to why I was tripping over it so
>regularly before, but I suspect something in the build is leaving a
>stale Modules.symvers around from before this patch landed.
>
>Terribly sorry for the noise.

No problem, thank for reporting back!

Jessica
