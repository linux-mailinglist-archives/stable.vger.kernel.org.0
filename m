Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ED0D528FF0A
	for <lists+stable@lfdr.de>; Fri, 16 Oct 2020 09:25:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404573AbgJPHZX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 16 Oct 2020 03:25:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:46618 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2404530AbgJPHZX (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 16 Oct 2020 03:25:23 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6A2E32073A;
        Fri, 16 Oct 2020 07:25:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602833123;
        bh=Mvjo+4acZA2eevU24BrzsAsAwxevV4zX2zHo8L/A5l8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=BbChAX/byzVES85AB/qkdIM3WDsVKK5OGyvR0ceonYGAHcEHu+h1n/oj8zUDw096V
         cYeU9THx8CA4wmhWF88KXJQSrU+OoNWntj+HjatTLC1GtnIrENe2dUFFTXIpzSut1E
         5dXohm670B8amaXL2FmsKAuDgEikcRLOJsQB0H2Y=
Date:   Fri, 16 Oct 2020 09:25:53 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Hans-Christian Noren Egtvedt <hegtvedt@cisco.com>
Cc:     linux-kernel@vger.kernel.org,
        Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
        Marcel Holtmann <marcel@holtmann.org>, stable@vger.kernel.org
Subject: Re: [v5.8/bluetooth PATCH] Bluetooth: Disconnect if E0 is used for
 Level 4
Message-ID: <20201016072553.GA578349@kroah.com>
References: <20201015211124.1187822-1-hegtvedt@cisco.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201015211124.1187822-1-hegtvedt@cisco.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Oct 15, 2020 at 11:11:24PM +0200, Hans-Christian Noren Egtvedt wrote:
> From: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
> 
> E0 is not allowed with Level 4:
> 
> BLUETOOTH CORE SPECIFICATION Version 5.2 | Vol 3, Part C page 1319:
> 
>   '128-bit equivalent strength for link and encryption keys
>    required using FIPS approved algorithms (E0 not allowed,
>    SAFER+ not allowed, and P-192 not allowed; encryption key
>    not shortened'
> 
> SC enabled:
> 
> > HCI Event: Read Remote Extended Features (0x23) plen 13
>         Status: Success (0x00)
>         Handle: 256
>         Page: 1/2
>         Features: 0x0b 0x00 0x00 0x00 0x00 0x00 0x00 0x00
>           Secure Simple Pairing (Host Support)
>           LE Supported (Host)
>           Secure Connections (Host Support)
> > HCI Event: Encryption Change (0x08) plen 4
>         Status: Success (0x00)
>         Handle: 256
>         Encryption: Enabled with AES-CCM (0x02)
> 
> SC disabled:
> 
> > HCI Event: Read Remote Extended Features (0x23) plen 13
>         Status: Success (0x00)
>         Handle: 256
>         Page: 1/2
>         Features: 0x03 0x00 0x00 0x00 0x00 0x00 0x00 0x00
>           Secure Simple Pairing (Host Support)
>           LE Supported (Host)
> > HCI Event: Encryption Change (0x08) plen 4
>         Status: Success (0x00)
>         Handle: 256
>         Encryption: Enabled with E0 (0x01)
> [May 8 20:23] Bluetooth: hci0: Invalid security: expect AES but E0 was used
> < HCI Command: Disconnect (0x01|0x0006) plen 3
>         Handle: 256
>         Reason: Authentication Failure (0x05)
> 
> Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
> Signed-off-by: Marcel Holtmann <marcel@holtmann.org>
> (cherry picked from commit 8746f135bb01872ff412d408ea1aa9ebd328c1f5)
> Cc: stable@vger.kernel.org # 5.8

Any reason you didn't sign off on these backports?  You should take the
credit for them :)

thanks,

greg k-h
