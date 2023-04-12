Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6563C6DF672
	for <lists+stable@lfdr.de>; Wed, 12 Apr 2023 15:05:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229639AbjDLNFo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 Apr 2023 09:05:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58366 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229749AbjDLNFn (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 12 Apr 2023 09:05:43 -0400
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9301846B1;
        Wed, 12 Apr 2023 06:05:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1681304743; x=1712840743;
  h=date:from:to:cc:subject:in-reply-to:message-id:
   references:mime-version;
  bh=SIIbTWQFtQiwPFHLG3XRxl427QCGbNZPIB/wgRCV9gw=;
  b=ImipW82lxvv7OmeYSD/zm32eB6/dUxj7Gj5E/grSNNfbFKpE9Sgp9UGA
   24qwRQLHkl4D/dLdat0YtV/OY+2GXBTAMoExdWLlKgq5y7AozVkIxGO+Y
   tYxgwh4H5LH28+4+MLhMaXYJ3xzxTpkrWvGKHWOmda2rsZmdkRAtEUrYa
   IZ+6jPk4QPzN4MIfMNvsdbLHHyC0YqyVXtv3C5k5fmXrPW1Rv2DLGaidP
   oO9/hYASxYMRha8JtTG6P6b6V3w7j9v16OXHdVN7QQBclmWRQErzNc/Zv
   RutCD9qxnSvWsGm3DxoQwJgd1VPA3b17FLt2fDfiKTXlW7pAExDeto0OI
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10678"; a="332583354"
X-IronPort-AV: E=Sophos;i="5.98,339,1673942400"; 
   d="scan'208";a="332583354"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Apr 2023 06:03:50 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10678"; a="639226969"
X-IronPort-AV: E=Sophos;i="5.98,339,1673942400"; 
   d="scan'208";a="639226969"
Received: from chanse1-mobl2.ger.corp.intel.com ([10.251.213.80])
  by orsmga003-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Apr 2023 06:03:47 -0700
Date:   Wed, 12 Apr 2023 16:03:45 +0300 (EEST)
From:   =?ISO-8859-15?Q?Ilpo_J=E4rvinen?= <ilpo.jarvinen@linux.intel.com>
To:     Johan Hovold <johan@kernel.org>
cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jirislaby@kernel.org>,
        Arnd Bergmann <arnd@arndb.de>, linux-arch@vger.kernel.org,
        linux-serial <linux-serial@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, stable@vger.kernel.org
Subject: Re: [PATCH] serial: fix TIOCSRS485 locking
In-Reply-To: <20230412124811.11217-1-johan@kernel.org>
Message-ID: <1c814de8-ea36-7a63-34c2-b957d6608cec@linux.intel.com>
References: <20230412124811.11217-1-johan@kernel.org>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="8323329-1754916380-1681304629=:2300"
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--8323329-1754916380-1681304629=:2300
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT

On Wed, 12 Apr 2023, Johan Hovold wrote:

> The RS485 multipoint addressing support for some reason added a new
> ADDRB termios cflag which is (only!) updated from one of the RS485
> ioctls.
> 
> Make sure to take the termios rw semaphore for the right ioctl (i.e.
> set, not get).
> 
> Fixes: ae50bb275283 ("serial: take termios_rwsem for ->rs485_config() & pass termios as param")
> Cc: stable@vger.kernel.org	# 6.0
> Cc: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
> Signed-off-by: Johan Hovold <johan@kernel.org>
> ---
> 
> I did not have time to review the multipoint addressing patches at the
> time and only skimmed the archives now, but I can't seem to find any
> motivation for why a precious termios bit was seemingly wasted on ADDRB
> when it is only updated from the RS485 ioctls.
> 
> I hope it wasn't done just to simplify the implementation of
> tty_get_frame_size()? Or was it a left-over from the RFC which
> apparently actually used termios to enable this feature?

No. I made it intentionally. It felt natural place for storing it because 
ADDRB does impact the wire format and cflag is where other wire-format 
impacting bits are also stored.

> Should we consider dropping the Linux-specific ADDRB bit again?
> 
> Johan
> 
> 
>  drivers/tty/serial/serial_core.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/tty/serial/serial_core.c b/drivers/tty/serial/serial_core.c
> index 2bd32c8ece39..728cb72be066 100644
> --- a/drivers/tty/serial/serial_core.c
> +++ b/drivers/tty/serial/serial_core.c
> @@ -1552,7 +1552,7 @@ uart_ioctl(struct tty_struct *tty, unsigned int cmd, unsigned long arg)
>  		goto out;
>  
>  	/* rs485_config requires more locking than others */
> -	if (cmd == TIOCGRS485)
> +	if (cmd == TIOCSRS485)
>  		down_write(&tty->termios_rwsem);
>  
>  	mutex_lock(&port->mutex);
> @@ -1595,7 +1595,7 @@ uart_ioctl(struct tty_struct *tty, unsigned int cmd, unsigned long arg)
>  	}
>  out_up:
>  	mutex_unlock(&port->mutex);
> -	if (cmd == TIOCGRS485)
> +	if (cmd == TIOCSRS485)
>  		up_write(&tty->termios_rwsem);
>  out:
>  	return ret;
> 

Indeed, the caps are so blinding.

Reviewed-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>

-- 
 i.

--8323329-1754916380-1681304629=:2300--
