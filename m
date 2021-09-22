Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0D8A641447D
	for <lists+stable@lfdr.de>; Wed, 22 Sep 2021 11:05:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234217AbhIVJGz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 22 Sep 2021 05:06:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:40952 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234203AbhIVJGv (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 22 Sep 2021 05:06:51 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id BFB9A6120F;
        Wed, 22 Sep 2021 09:05:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1632301521;
        bh=i1ZuVgR89V/t0znAa7boPt9g0yKj5SY8/b+8mOxQl04=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=wsyIPmuq4FSFusXHdeozGXEJQX/1ejqkHJUekyUuz9tx7To65bJn9EHzTWxepzJHt
         wampQOzkhuWHBLj2JRDGWx0QM8ekKRzGqfgyTokSnAQ8vATQHgGbgDG94SSmjYe6no
         ++7YD1LWb7xGtrqUKfohvg1daRv8nyp+cFZhv7Sc=
Date:   Wed, 22 Sep 2021 11:05:19 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Pavel Machek <pavel@denx.de>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        Bartosz Golaszewski <bgolaszewski@baylibre.com>,
        Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 5.10 100/122] gpio: mpc8xxx: Fix a potential double
 iounmap call in mpc8xxx_probe()
Message-ID: <YUrxz1tG43TIyypq@kroah.com>
References: <20210920163915.757887582@linuxfoundation.org>
 <20210920163919.067590477@linuxfoundation.org>
 <20210921212526.GA28467@duo.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210921212526.GA28467@duo.ucw.cz>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Sep 21, 2021 at 11:25:26PM +0200, Pavel Machek wrote:
> Hi!
> 
> > [ Upstream commit 7d6588931ccd4c09e70a08175cf2e0cf7fc3b869 ]
> > 
> > Commit 76c47d1449fc ("gpio: mpc8xxx: Add ACPI support") has switched to a
> > managed version when dealing with 'mpc8xxx_gc->regs'. So the corresponding
> > 'iounmap()' call in the error handling path and in the remove should be
> > removed to avoid a double unmap.
> 
> This is wrong, AFAICT. 5.10 does not have 76c47d1449fc ("gpio:
> mpc8xxx: Add ACPI support") so iounmap is still neccessary and this
> adds a memory leak.

Ah, but then I have to drop 889a1b3f35db ("gpio: mpc8xxx: Use
'devm_gpiochip_add_data()' to simplify the code and avoid a leak") from
the 5.10 queue as it depends on this one.

Can you provide a working backport of that commit so that I can queue up
the fix?

thanks,

greg k-h
