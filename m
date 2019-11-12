Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0A164F87F3
	for <lists+stable@lfdr.de>; Tue, 12 Nov 2019 06:32:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725887AbfKLFcQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 Nov 2019 00:32:16 -0500
Received: from mail.kernel.org ([198.145.29.99]:60042 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725283AbfKLFcQ (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 12 Nov 2019 00:32:16 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D875521783;
        Tue, 12 Nov 2019 05:32:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573536735;
        bh=3yDlZ009U3Ri0j4hyJgKZsiwqwvvJk77A4m47/BiNAo=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=ISDAs1lVYKzHCPacV/DtE6K6v+vp2U6YPWUbct0XP02RaAeFkGdBl2lcVh3A55MKU
         ZkkD5P2Ar05CRmp9ZmSZY0rnOBOLx23PudcDEssYU3YFFQ6p3OjnbQXhHfvCaCt5q+
         uesK3cztkeakm35MLxdYKdGVLut3g5daKzlaO0M8=
Date:   Tue, 12 Nov 2019 06:16:29 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Guenter Roeck <linux@roeck-us.net>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org
Subject: Re: [PATCH 4.4 00/43] 4.4.201-stable review
Message-ID: <20191112051629.GA1160519@kroah.com>
References: <20191111181246.772983347@linuxfoundation.org>
 <20191111233540.GA15059@roeck-us.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191111233540.GA15059@roeck-us.net>
User-Agent: Mutt/1.12.2 (2019-09-21)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Nov 11, 2019 at 03:35:40PM -0800, Guenter Roeck wrote:
> On Mon, Nov 11, 2019 at 07:28:14PM +0100, Greg Kroah-Hartman wrote:
> > This is the start of the stable review cycle for the 4.4.201 release.
> > There are 43 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> > 
> > Responses should be made by Wed, 13 Nov 2019 18:08:44 +0000.
> > Anything received after that time might be too late.
> > 
> 
> I am getting lots of
> 
> WARNING: modpost: Found 2 section mismatch(es).
> To see full details build your kernel with:
> 'make CONFIG_DEBUG_SECTION_MISMATCH=y'
> FATAL: modpost: Section mismatches detected.
> Set CONFIG_SECTION_MISMATCH_WARN_ONLY=y to allow them.
> scripts/Makefile.modpost:97: recipe for target 'vmlinux.o' failed
> 
> for v4.4.y, v4.9.y, and v4.14.y.
> 
> Bisecting in v4.4.y points to commit 13e9ce202ddcf95bf6 ("mm, meminit:
> recalculate pcpu batch and high limits after init completes"). Reverting
> it fixes the problem in all three branches.

Wow that patch was backported incorrectly, gotta love quilt at times :(

I've dropped that from all 3 of those trees and will work to backport it
"correctly" by hand for a later release.  I'll go release -rc2 for all 3
of those trees now.

thanks,

greg k-h
