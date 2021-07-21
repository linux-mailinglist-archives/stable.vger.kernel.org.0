Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2C7713D0E74
	for <lists+stable@lfdr.de>; Wed, 21 Jul 2021 14:03:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238989AbhGULWr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 21 Jul 2021 07:22:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:56050 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238185AbhGULUZ (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 21 Jul 2021 07:20:25 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A064861181;
        Wed, 21 Jul 2021 12:01:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1626868861;
        bh=e/vlteaJBktOmPKsskSDx+AWnwvwZTl8zneuBz1GiXs=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Jk+X6bDFisucKyRu4K7IEj+W6TPeW8c0nKzAiCzeVY0KpxkRU+GqVwNQ3BHhs31FK
         2EwzoSHh7KEeEYLQp39D3jsEG70HH7Ol+8Z50GJeHwK5LLvdskoTTTPUxrG7GQr3C0
         G8O+Len0iwp3s+JbixPMCCZF5Lo8B7gvUn7/bEvpFni+vcDKJUKLs6yUcPjdPuQt50
         C3j8iAXXgZ11XpcAwvWocr4oJYYRzKFGk5CAYHYhl+szATzm0FADIkAjIjWGGSKk51
         VHCs3T1iKr1Mtux+rbpHDehhB4uhZAM6OlN0NUBnvyK33+d4/U6iuT6PPA9oOqnNO3
         jV688Hz1U2blg==
Received: from johan by xi.lan with local (Exim 4.94.2)
        (envelope-from <johan@kernel.org>)
        id 1m6Atw-0006IE-EL; Wed, 21 Jul 2021 14:00:37 +0200
Date:   Wed, 21 Jul 2021 14:00:36 +0200
From:   Johan Hovold <johan@kernel.org>
To:     Dongliang Mu <mudongliangabcd@gmail.com>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jirislaby@kernel.org>, stable@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@suse.de>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] tty: nozomi: tty_unregister_device ->
 tty_port_unregister_device
Message-ID: <YPgMZBK/FWLRD1Ic@hovoldconsulting.com>
References: <20210721113305.1524059-1-mudongliangabcd@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210721113305.1524059-1-mudongliangabcd@gmail.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Jul 21, 2021 at 07:33:04PM +0800, Dongliang Mu wrote:
> The pairwise api invocation of tty_port_register_device should be
> tty_port_unregister_device, other than tty_unregister_device.

Are you sure about that? Please explain why you think this to be the
case and why this change is needed.

> Fixes: a6afd9f3e819 ("tty: move a number of tty drivers from drivers/char/ to drivers/tty/")

Please try a little harder, that's clearly not the commit that changed
to the port registration helper.

> Cc: stable@vger.kernel.org

Why do you think this is stable material? (hint: it is not)

> Signed-off-by: Dongliang Mu <mudongliangabcd@gmail.com>
> ---
>  drivers/tty/nozomi.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/tty/nozomi.c b/drivers/tty/nozomi.c
> index 0c80f25c8c3d..08bdd82f60b5 100644
> --- a/drivers/tty/nozomi.c
> +++ b/drivers/tty/nozomi.c
> @@ -1417,7 +1417,8 @@ static int nozomi_card_init(struct pci_dev *pdev,
>  
>  err_free_tty:
>  	for (i--; i >= 0; i--) {
> -		tty_unregister_device(ntty_driver, dc->index_start + i);
> +		tty_port_unregister_device(&dc->port[i].port, ntty_driver,
> +				dc->index_start + i);
>  		tty_port_destroy(&dc->port[i].port);
>  	}
>  	free_irq(pdev->irq, dc);

Johan
