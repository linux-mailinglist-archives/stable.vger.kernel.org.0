Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2DA56450462
	for <lists+stable@lfdr.de>; Mon, 15 Nov 2021 13:26:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230507AbhKOM3O (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 07:29:14 -0500
Received: from mail.kernel.org ([198.145.29.99]:34214 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230132AbhKOM3M (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 07:29:12 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2253E6324D;
        Mon, 15 Nov 2021 12:26:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1636979176;
        bh=7J7CP89TH+bDmrT0xTIz86KRWuGezTtoREshOd7sb6E=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=QF5PvEPOCuYhFNwfel3BMeLEebCwA4AHZeGE6x8cQA/A6vw6zufJwKlpszMj8iuJy
         CO6YQe9Y3hmqa2hKgbb3YKM2M3Y36MqEf3s3caJ9zG2CN3JpzFNkETTlaKUNBwIxGB
         jCrQ+5NOeswL6DnqgS3gbym4tdOb7kUjaVwvzsEw=
Date:   Mon, 15 Nov 2021 13:26:14 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Johan Hovold <johan@kernel.org>
Cc:     stable@vger.kernel.org, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, Peter Chen <peter.chen@kernel.org>
Subject: Re: [PATCH stable-4.9] USB: chipidea: fix interrupt deadlock
Message-ID: <YZJR5p2Zu39sdkap@kroah.com>
References: <20211115080043.23894-1-johan@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211115080043.23894-1-johan@kernel.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Nov 15, 2021 at 09:00:43AM +0100, Johan Hovold wrote:
> commit 9aaa81c3366e8393a62374e3a1c67c69edc07b8a upstream.
> 
> Chipidea core was calling the interrupt handler from non-IRQ context
> with interrupts enabled, something which can lead to a deadlock if
> there's an actual interrupt trying to take a lock that's already held
> (e.g. the controller lock in udc_irq()).
> 
> Add a wrapper that can be used to fake interrupts instead of calling the
> handler directly.
> 
> Fixes: 3ecb3e09b042 ("usb: chipidea: Use extcon framework for VBUS and ID detect")
> Fixes: 876d4e1e8298 ("usb: chipidea: core: add wakeup support for extcon")
> Cc: Peter Chen <peter.chen@kernel.org>
> Cc: stable@vger.kernel.org      # 4.4
> Signed-off-by: Johan Hovold <johan@kernel.org>
> Link: https://lore.kernel.org/r/20211021083447.20078-1-johan@kernel.org
> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> [ johan: backport to 4.9; adjust context ]
> Signed-off-by: Johan Hovold <johan@kernel.org>
> ---
> 
> This one should apply to 4.4 as well.

All now queued up, thanks.

greg k-h
