Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3A86EB6506
	for <lists+stable@lfdr.de>; Wed, 18 Sep 2019 15:51:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728941AbfIRNvU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 18 Sep 2019 09:51:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:52698 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728997AbfIRNvU (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 18 Sep 2019 09:51:20 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E86832067B;
        Wed, 18 Sep 2019 13:51:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1568814679;
        bh=C0FJ39ZzCKIX9+jiW5XpQ4c5SpxZKDGE72S8Vkv8nq4=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=pmXg63ggQ4ywWS2LfIrJQHTNGOy6+L7Zl14ZPpnGRNEn7q1C9dnF/AVq4sRyBgcvC
         dki8JCmhcKgr28gaMj2Akm2XdvAkAtA9ABZs3uXI48tuzCpRbBduVAH1/KxgST3YKt
         DZOeYpegVaVIHhnHxXHth8CC4sGesVP5hUSnRvhQ=
Date:   Wed, 18 Sep 2019 15:51:17 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Guenter Roeck <linux@roeck-us.net>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org
Subject: Re: [PATCH 4.19 00/50] 4.19.74-stable review
Message-ID: <20190918135117.GA1913575@kroah.com>
References: <20190918061223.116178343@linuxfoundation.org>
 <b1cff98a-d08f-d6cc-393f-9ca80c9229fe@roeck-us.net>
 <20190918134003.GF1908968@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190918134003.GF1908968@kroah.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Sep 18, 2019 at 03:40:03PM +0200, Greg Kroah-Hartman wrote:
> On Wed, Sep 18, 2019 at 05:59:09AM -0700, Guenter Roeck wrote:
> > On 9/17/19 11:18 PM, Greg Kroah-Hartman wrote:
> > > This is the start of the stable review cycle for the 4.19.74 release.
> > > There are 50 patches in this series, all will be posted as a response
> > > to this one.  If anyone has any issues with these being applied, please
> > > let me know.
> > > 
> > > Responses should be made by Fri 20 Sep 2019 06:09:47 AM UTC.
> > > Anything received after that time might be too late.
> > > 
> > 
> > I see lots of build failures.
> > 
> > kernel/module.c: In function 'free_module':
> > kernel/module.c:2187:2: error: implicit declaration of function 'disable_ro_nx'; did you mean 'disable_irq'?
> > 
> > kernel/module.c: In function 'load_module':
> > kernel/module.c:3828:2: error: implicit declaration of function 'module_disable_nx'; did you mean 'module_disable_ro'?
> > 
> > Reverting
> > 
> > ed510bd0bce3 modules: fix compile error if don't have strict module rwx
> > 22afe9550160 modules: fix BUG when load module with rodata=n
> > 
> > fixes the problem.
> 
> Ugh, I thought I got these right.  Let me see what I got wrong in the
> backport...
> 
> Any hint as to what the .config is here that is causing the problems?

Ok, I think I've fixed this now, I've pushed out an updated queue and a
-rc2 with a change that should resolve this.  Please let me know if that
didn't work.

thanks,

greg k-h
