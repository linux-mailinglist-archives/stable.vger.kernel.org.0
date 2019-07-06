Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DE0E960FE5
	for <lists+stable@lfdr.de>; Sat,  6 Jul 2019 12:49:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725990AbfGFKtR convert rfc822-to-8bit (ORCPT
        <rfc822;lists+stable@lfdr.de>); Sat, 6 Jul 2019 06:49:17 -0400
Received: from coyote.holtmann.net ([212.227.132.17]:53714 "EHLO
        mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725926AbfGFKtR (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 6 Jul 2019 06:49:17 -0400
Received: from [192.168.0.113] (CMPC-089-239-107-172.CNet.Gawex.PL [89.239.107.172])
        by mail.holtmann.org (Postfix) with ESMTPSA id 19908CEFAE;
        Sat,  6 Jul 2019 12:57:47 +0200 (CEST)
Content-Type: text/plain;
        charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 12.4 \(3445.104.11\))
Subject: Re: [PATCH v3 2/2] Bluetooth: hci_ldisc: Add NULL check for
 tiocmget() and tiocmset() in hci_uart_set_flow_control()
From:   Marcel Holtmann <marcel@holtmann.org>
In-Reply-To: <4cc3a826614822661dbedad74d9970172cbfa6d7.1549346039.git.mhjungk@gmail.com>
Date:   Sat, 6 Jul 2019 12:49:14 +0200
Cc:     Johan Hedberg <johan.hedberg@gmail.com>,
        linux-bluetooth@vger.kernel.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Content-Transfer-Encoding: 8BIT
Message-Id: <CB134419-019E-4B55-A1F6-E3361BD581C4@holtmann.org>
References: <cover.1549346039.git.mhjungk@gmail.com>
 <cover.1549346039.git.mhjungk@gmail.com>
 <4cc3a826614822661dbedad74d9970172cbfa6d7.1549346039.git.mhjungk@gmail.com>
To:     Myungho Jung <mhjungk@gmail.com>
X-Mailer: Apple Mail (2.3445.104.11)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Myungho,

> tiocmget() or tiocmset() operations are optional. Just return from
> hci_uart_set_flow_control() if tiocmget() or tiocmset() operation is
> NULL.
> 
> Fixes: 2a973dfada2b ("hci_uart: Add new line discipline enhancements")
> Cc: <stable@vger.kernel.org> # 4.2
> Signed-off-by: Myungho Jung <mhjungk@gmail.com>
> ---
> Changes in v2:
>  - Remove braces in if statment
> 
> Changes in v3:
>  - Split into 2 patches
>  - Add stable CC and fixes tags
> 
> drivers/bluetooth/hci_ldisc.c | 4 ++++
> 1 file changed, 4 insertions(+)
> 
> diff --git a/drivers/bluetooth/hci_ldisc.c b/drivers/bluetooth/hci_ldisc.c
> index fbf7b4df23ab..cb31c2d8d826 100644
> --- a/drivers/bluetooth/hci_ldisc.c
> +++ b/drivers/bluetooth/hci_ldisc.c
> @@ -314,6 +314,10 @@ void hci_uart_set_flow_control(struct hci_uart *hu, bool enable)
> 		return;
> 	}
> 
> +	/* tiocmget() and tiocmset() operations are optional */
> +	if (!tty->driver->ops->tiocmget || !tty->driver->ops->tiocmset)
> +		return;
> +

lets just fail setting the line discipline if these ops are not available.  Doing some silent ignoring is not going to help.

Regards

Marcel

