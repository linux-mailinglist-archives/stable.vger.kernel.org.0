Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4DE34431010
	for <lists+stable@lfdr.de>; Mon, 18 Oct 2021 07:58:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229998AbhJRGBH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 Oct 2021 02:01:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:45716 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229901AbhJRGBG (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 18 Oct 2021 02:01:06 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7754960F59;
        Mon, 18 Oct 2021 05:58:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1634536736;
        bh=5rYzsvdza9zw7gO2DMRBVkoMGA9Kg9wwVy5zLFnLKZI=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=v4QAs1kK+bK+WtH42VpXGgoJ5jSvIxqIPo60uGaU2NrRryAs8LtZnosSocyXN5Wi7
         DsG0a/pggIoJc3PbqNadTlfDiVIvKoAJKxc6dX7uCiLCrlm/z6auZn5iV3TX1e9AqF
         mL2miSkcdr9GJS80a/7107o46nodeRP2OTiM2ji0=
Date:   Mon, 18 Oct 2021 07:58:50 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Mateusz =?utf-8?Q?Jo=C5=84czyk?= <mat.jonczyk@o2.pl>
Cc:     linux-kernel@vger.kernel.org, linux-rtc@vger.kernel.org,
        Alessandro Zummo <a.zummo@towertech.it>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        stable@vger.kernel.org
Subject: Re: [PATCH RESEND 2/6] rtc-cmos: dont touch alarm registers during
 update
Message-ID: <YW0NGiZDhZf2RrjN@kroah.com>
References: <20211017193927.277409-1-mat.jonczyk@o2.pl>
 <20211017193927.277409-3-mat.jonczyk@o2.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20211017193927.277409-3-mat.jonczyk@o2.pl>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sun, Oct 17, 2021 at 09:39:23PM +0200, Mateusz Jończyk wrote:
> Some Intel chipsets disconnect the time and date RTC registers when the
> clock update is in progress: during this time reads may return bogus
> values and writes fail silently. This includes the RTC alarm registers.
> [1]
> 
> cmos_read_alarm() and cmos_set_alarm() did not take account for that,
> which caused alarm time reads to sometimes return bogus values. This can
> be shown with a test patch that I am attaching to this patch series.
> Setting the alarm clock also probably did fail sometimes.
> 
> To make this patch suitable for inclusion in stable kernels, I'm using a
> simple method for avoiding the RTC update cycle. This method is used in
> mach_set_rtc_mmss() in arch/x86/kernel/rtc.c. A more elaborate algorithm
> - as in mc146818_get_time() in drivers/rtc/rtc-mc146818-lib.c - would be
> too complcated for stable. [2]

No, just do it properly the first time, do not worry about stable
kernels, we can just take the also-correct version for backporting if
needed.

thanks,

greg k-h
