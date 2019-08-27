Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DDF419DD83
	for <lists+stable@lfdr.de>; Tue, 27 Aug 2019 08:19:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726278AbfH0GTg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Aug 2019 02:19:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:39406 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726091AbfH0GTf (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Aug 2019 02:19:35 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DF3DD206BB;
        Tue, 27 Aug 2019 06:19:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1566886775;
        bh=gcxXUgEVmD3tszbvz3/XBtWwmU2RW47+E5iLJXT9x6Q=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=jR85DFUH7lu3yeWJekLjv4K1HEeClksUtBYq4aFtdESGepJ3YYC5/T7Fc0tNR9NPG
         x9zoQbynhMYyM8ImlzqKZrrg4lv4Diw0TSTuUQdntzN8PkHfx9nTwVxtox6O/KEwL8
         pYxcJBdbgNUYp3pLq+uNPOnrRwvOuQ5eAVIKN7ao=
Date:   Tue, 27 Aug 2019 08:19:33 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Alastair D'Silva <alastair@au1.ibm.com>
Cc:     alastair@d-silva.org, stable@vger.kernel.org,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Thomas Gleixner <tglx@linutronix.de>,
        Allison Randal <allison@lohutok.net>,
        linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] powerpc: Allow flush_(inval_)dcache_range to work
 across ranges >4GB
Message-ID: <20190827061933.GA29250@kroah.com>
References: <20190821001929.4253-1-alastair@au1.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190821001929.4253-1-alastair@au1.ibm.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Aug 21, 2019 at 10:19:27AM +1000, Alastair D'Silva wrote:
> From: Alastair D'Silva <alastair@d-silva.org>
> 
> The upstream commit:
> 22e9c88d486a ("powerpc/64: reuse PPC32 static inline flush_dcache_range()")
> has a similar effect, but since it is a rewrite of the assembler to C, is
> too invasive for stable. This patch is a minimal fix to address the issue in
> assembler.
> 
> This patch applies cleanly to v5.2, v4.19 & v4.14.
> 
> When calling flush_(inval_)dcache_range with a size >4GB, we were masking
> off the upper 32 bits, so we would incorrectly flush a range smaller
> than intended.
> 
> This patch replaces the 32 bit shifts with 64 bit ones, so that
> the full size is accounted for.
> 
> Changelog:
> v2
>   - Add related upstream commit

Now applied, thanks.

greg k-h
