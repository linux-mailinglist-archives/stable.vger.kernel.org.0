Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 487848F885
	for <lists+stable@lfdr.de>; Fri, 16 Aug 2019 03:42:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726464AbfHPBma (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 15 Aug 2019 21:42:30 -0400
Received: from ozlabs.org ([203.11.71.1]:49931 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726357AbfHPBma (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 15 Aug 2019 21:42:30 -0400
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 468mKG2TSzz9sN6;
        Fri, 16 Aug 2019 11:42:26 +1000 (AEST)
From:   Michael Ellerman <mpe@ellerman.id.au>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Alastair D'Silva <alastair@au1.ibm.com>
Cc:     alastair@d-silva.org, stable@vger.kernel.org,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>,
        Allison Randal <allison@lohutok.net>,
        Thomas Gleixner <tglx@linutronix.de>,
        linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] powerpc: Allow flush_(inval_)dcache_range to work across ranges >4GB
In-Reply-To: <20190815071924.GA26670@kroah.com>
References: <20190815045543.16325-1-alastair@au1.ibm.com> <20190815071924.GA26670@kroah.com>
Date:   Fri, 16 Aug 2019 11:42:22 +1000
Message-ID: <87mug97uo1.fsf@concordia.ellerman.id.au>
MIME-Version: 1.0
Content-Type: text/plain
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Greg Kroah-Hartman <gregkh@linuxfoundation.org> writes:
> On Thu, Aug 15, 2019 at 02:55:42PM +1000, Alastair D'Silva wrote:
>> From: Alastair D'Silva <alastair@d-silva.org>
>> 
>> Heads Up: This patch cannot be submitted to Linus's tree, as the affected
>> assembler functions have already been converted to C.

That was done in upstream commit:

22e9c88d486a ("powerpc/64: reuse PPC32 static inline flush_dcache_range()")

Which is a larger change that we don't want to backport. This patch is a
minimal fix for stable trees.


>> When calling flush_(inval_)dcache_range with a size >4GB, we were masking
>> off the upper 32 bits, so we would incorrectly flush a range smaller
>> than intended.
>> 
>> This patch replaces the 32 bit shifts with 64 bit ones, so that
>> the full size is accounted for.
>> 
>> Signed-off-by: Alastair D'Silva <alastair@d-silva.org>
>> ---
>>  arch/powerpc/kernel/misc_64.S | 4 ++--
>>  1 file changed, 2 insertions(+), 2 deletions(-)

Acked-by: Michael Ellerman <mpe@ellerman.id.au>

> <formletter>
>
> This is not the correct way to submit patches for inclusion in the
> stable kernel tree.  Please read:
>     https://www.kernel.org/doc/html/latest/process/stable-kernel-rules.html
> for how to do this properly.
>
> </formletter>

Hi Greg,

This is "option 3", submit the patch directly, and the patch "deviates
from the original upstream patch" because the upstream patch was a
wholesale conversion from asm to C.

This patch applies cleanly to v4.14 and v4.19.

The change log should have mentioned which upstream patch it is not a
backport of, is there anything else we should have done differently to
avoid the formletter bot :)

cheers
