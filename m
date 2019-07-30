Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8FA687A734
	for <lists+stable@lfdr.de>; Tue, 30 Jul 2019 13:46:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728647AbfG3LqB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 30 Jul 2019 07:46:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:39920 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728590AbfG3LqA (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 30 Jul 2019 07:46:00 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D767D206E0;
        Tue, 30 Jul 2019 11:45:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1564487159;
        bh=MdCmTq2/62GOla3xYdR1q+U30DvmMzx9ilbakjTfbuY=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=hNRILnIGpwN0IQ17UgUT9sNy5oW3a2JqVMfOgkS1x5zDIp+bnrnOA5gUA3vFMnckT
         ImalFhGvGWcRgYOH4oWtJGoEErv0Hg16NWumKADitrYbYxaF5WUPl3I9wt65hcy2D5
         UpEcc6XDJDwSe5h8nvuSvpKdK1R8vJAO2KCAu+Nk=
Date:   Tue, 30 Jul 2019 13:45:56 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Brian Norris <briannorris@chromium.org>
Cc:     "Rafael J. Wysocki" <rafael@kernel.org>,
        linux-kernel@vger.kernel.org, andriy.shevchenko@linux.intel.com,
        Salvatore Bellizzi <salvatore.bellizzi@linux.seppia.net>,
        andy.shevchenko@gmail.com,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        egranata@chromium.org, egranata@google.com,
        Enric Balletbo i Serra <enric.balletbo@collabora.com>,
        Gwendal Grignou <gwendal@chromium.org>,
        linux-acpi@vger.kernel.org, Benson Leung <bleung@chromium.org>,
        stable@vger.kernel.org
Subject: Re: [PATCH] driver core: platform: return -ENXIO for missing GpioInt
Message-ID: <20190730114556.GA10673@kroah.com>
References: <20190729204954.25510-1-briannorris@chromium.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190729204954.25510-1-briannorris@chromium.org>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Jul 29, 2019 at 01:49:54PM -0700, Brian Norris wrote:
> Commit daaef255dc96 ("driver: platform: Support parsing GpioInt 0 in
> platform_get_irq()") broke the Embedded Controller driver on most LPC
> Chromebooks (i.e., most x86 Chromebooks), because cros_ec_lpc expects
> platform_get_irq() to return -ENXIO for non-existent IRQs.
> Unfortunately, acpi_dev_gpio_irq_get() doesn't follow this convention
> and returns -ENOENT instead. So we get this error from cros_ec_lpc:
> 
>    couldn't retrieve IRQ number (-2)
> 
> I see a variety of drivers that treat -ENXIO specially, so rather than
> fix all of them, let's fix up the API to restore its previous behavior.
> 
> I reported this on v2 of this patch:
> 
> https://lore.kernel.org/lkml/20190220180538.GA42642@google.com/
> 
> but apparently the patch had already been merged before v3 got sent out:
> 
> https://lore.kernel.org/lkml/20190221193429.161300-1-egranata@chromium.org/
> 
> and the result is that the bug landed and remains unfixed.
> 
> I differ from the v3 patch by:
>  * allowing for ret==0, even though acpi_dev_gpio_irq_get() specifically
>    documents (and enforces) that 0 is not a valid return value (noted on
>    the v3 review)
>  * adding a small comment
> 
> Reported-by: Brian Norris <briannorris@chromium.org>
> Reported-by: Salvatore Bellizzi <salvatore.bellizzi@linux.seppia.net>
> Cc: Enrico Granata <egranata@chromium.org>
> Cc: <stable@vger.kernel.org>
> Fixes: daaef255dc96 ("driver: platform: Support parsing GpioInt 0 in platform_get_irq()")
> Signed-off-by: Brian Norris <briannorris@chromium.org>
> Reviewed-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
> Acked-by: Enrico Granata <egranata@google.com>
> ---
> Side note: it might have helped alleviate some of this pain if there
> were email notifications to the mailing list when a patch gets applied.
> I didn't realize (and I'm not sure if Enrico did) that v2 was already
> merged by the time I noted its mistakes. If I had known, I would have
> suggested a follow-up patch, not a v3.
> 
> I know some maintainers' "tip bots" do this, but not all apparently.

We can't drown out mailing list traffic with a ton of "this patch was
applied" emails.  We send them directly to the people involved in it.

Note, you can always set up your own "watch" for stuff like this by
pulling linux-next every day and sending yourself any new patches that
get applied for any specific files/directories you are concerned about.

thanks,

greg k-h
