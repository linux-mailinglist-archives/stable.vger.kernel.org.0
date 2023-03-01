Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 875396A6BBE
	for <lists+stable@lfdr.de>; Wed,  1 Mar 2023 12:33:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229876AbjCALdP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 1 Mar 2023 06:33:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46466 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229510AbjCALdP (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 1 Mar 2023 06:33:15 -0500
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2C92E1CF48;
        Wed,  1 Mar 2023 03:33:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1677670394; x=1709206394;
  h=date:from:to:cc:subject:in-reply-to:message-id:
   references:mime-version;
  bh=AkdMnSVRqKHnboe7AK7DDj91/5KWkNYHH8ZRSSJ14z8=;
  b=BhNvixJlxwkL6ubh6ct1iM/psymT8UAdp9c/HcJ/l9ILzNkt8uXdpBtG
   fq0alsnw1TdwX8rZ8Nc5HKBH2efBjpquNXZZ1ukj5Qsmw6Dsg/v3hz/nY
   thMWrYS+G4oaKYCmkSYrsAwm52PmtLSnPSVa//C3H2/p9TlgakvBKGsLn
   vJ2LCGG/L14r7AsANXZyAJ6C5yw4lbV/NF/TvCg5G7SyHjBSrdqS2zJDc
   aEY7nhyRQjWPTCIK3NE4m1qyXraEB6T1CnS2UoCWs3W+D0kFyb0fGtjY7
   S2VxB+gXrb8V4v8RBMlVDu2oStdbcJHlOal8XjJ0sQCoAnmU62KPKVJdI
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10635"; a="331864640"
X-IronPort-AV: E=Sophos;i="5.98,224,1673942400"; 
   d="scan'208";a="331864640"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Mar 2023 03:33:13 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10635"; a="920213429"
X-IronPort-AV: E=Sophos;i="5.98,224,1673942400"; 
   d="scan'208";a="920213429"
Received: from rlocatel-mobl1.ger.corp.intel.com ([10.252.57.87])
  by fmsmga006-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Mar 2023 03:33:11 -0800
Date:   Wed, 1 Mar 2023 13:33:09 +0200 (EET)
From:   =?ISO-8859-15?Q?Ilpo_J=E4rvinen?= <ilpo.jarvinen@linux.intel.com>
To:     Lukasz Majczak <lma@semihalf.com>
cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jirislaby@kernel.org>,
        Guenter Roeck <groeck@chromium.org>,
        linux-serial <linux-serial@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, upstream@semihalf.com,
        stable@vger.kernel.org
Subject: Re: [PATCH] serial: core: fix broken console after suspend
In-Reply-To: <20230301075751.43839-1-lma@semihalf.com>
Message-ID: <1ffc536e-9bdc-c246-d31d-ae368fcf6072@linux.intel.com>
References: <20230301075751.43839-1-lma@semihalf.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, 1 Mar 2023, Lukasz Majczak wrote:

> Re-enable the console device after suspending, causes its cflags,

Re-enabling

> ispeed and ospeed to be set anew, basing on the values stored in
> uport->cons. The issue is that these values are set only once,
> when parsing console parameters after boot (see uart_set_options()),

Remove "The issue is that" from here and just state:

"These values are set only once when parsing console parameters after boot 
(see uart_set_options())."

> next after configuring a port in uart_port_startup() these parameteres

parameters

> (cflags, ispeed and ospeed) are copied to termios structure and
> the orginal one (stored in uport->cons) are cleared, but there is no place

original

> in code where those fields are checked against 0.
> When kernel calls uart_resume_port() and setups console, it copies cflags,
> ispeed and ospeed values from uart->cons,but those are alread cleared.

missing space after comma.

alread -> already

> The efect is that console is broken.

effect

> This patch address this by preserving the cflags, ispeed and

Too many "this", don't start with "This patch" but go directly to the 
point.


-- 
 i.


> ospeed fields in uart->cons during uart_port_startup().
> 
> Signed-off-by: Lukasz Majczak <lma@semihalf.com>
> Cc: stable@vger.kernel.org
> ---
>  drivers/tty/serial/serial_core.c | 3 ---
>  1 file changed, 3 deletions(-)
> 
> diff --git a/drivers/tty/serial/serial_core.c b/drivers/tty/serial/serial_core.c
> index 2bd32c8ece39..394a05c09d87 100644
> --- a/drivers/tty/serial/serial_core.c
> +++ b/drivers/tty/serial/serial_core.c
> @@ -225,9 +225,6 @@ static int uart_port_startup(struct tty_struct *tty, struct uart_state *state,
>  			tty->termios.c_cflag = uport->cons->cflag;
>  			tty->termios.c_ispeed = uport->cons->ispeed;
>  			tty->termios.c_ospeed = uport->cons->ospeed;
> -			uport->cons->cflag = 0;
> -			uport->cons->ispeed = 0;
> -			uport->cons->ospeed = 0;
>  		}
>  		/*
>  		 * Initialise the hardware port settings.
> 
