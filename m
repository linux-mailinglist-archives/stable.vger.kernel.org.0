Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 751693C1B81
	for <lists+stable@lfdr.de>; Fri,  9 Jul 2021 00:35:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230451AbhGHWiR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 8 Jul 2021 18:38:17 -0400
Received: from rere.qmqm.pl ([91.227.64.183]:52253 "EHLO rere.qmqm.pl"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229497AbhGHWiR (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 8 Jul 2021 18:38:17 -0400
X-Greylist: delayed 590 seconds by postgrey-1.27 at vger.kernel.org; Thu, 08 Jul 2021 18:38:16 EDT
Received: from remote.user (localhost [127.0.0.1])
        by rere.qmqm.pl (Postfix) with ESMTPSA id 4GLW8Q2rRLzMT;
        Fri,  9 Jul 2021 00:25:42 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=rere.qmqm.pl; s=1;
        t=1625783142; bh=e54EZYnhz2/diQUGmYLli8uvYZdZ3+QkPp8ageHuW/g=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=fjCBMF2LOLl9a9eqbpNR6rvsC7McNsLnEOONpDfUAdOBydd+uI44iTlRmVR/FI9NA
         f4CsjBPQzs9RhXHzD7U5LLdzDzjccaHc/NsT/b9OQhOzmyaIbMB3zrzryezyuadpSi
         1QDxzZENajFscTDSiY5dsvVtvyLiygFAsfxqSZuS1KqcNwUXZlb0Iir2tUbALtoat2
         K14o7Z2aD4SCX8NmbLt75apxT4dGKb+Cy2VpqbD4IlWSfMXqMotO62owlOfwaO1n5q
         8Le8vCIYAIo4a4+uQdfqK+IwqlDOc4vzA/kkos4704YlCOG7O5nwcb1if4l/VfdUZd
         V8T3usV1/XjDA==
X-Virus-Status: Clean
X-Virus-Scanned: clamav-milter 0.103.2 at mail
Date:   Fri, 9 Jul 2021 00:25:41 +0200
From:   =?iso-8859-2?Q?Micha=B3_Miros=B3aw?= <mirq-linux@rere.qmqm.pl>
To:     Jon Hunter <jonathanh@nvidia.com>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jirislaby@kernel.org>,
        Thierry Reding <thierry.reding@gmail.com>,
        Laxman Dewangan <ldewangan@nvidia.com>,
        Krishna Yarlagadda <kyarlagadda@nvidia.com>,
        linux-serial@vger.kernel.org, linux-tegra@vger.kernel.org,
        stable@vger.kernel.org
Subject: Re: [PATCH V2] serial: tegra: Only print FIFO error message when an
 error occurs
Message-ID: <YOd7ZTJf0WoQ8oKo@qmqm.qmqm.pl>
References: <20210630125643.264264-1-jonathanh@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-2
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20210630125643.264264-1-jonathanh@nvidia.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Jun 30, 2021 at 01:56:43PM +0100, Jon Hunter wrote:
> The Tegra serial driver always prints an error message when enabling the
> FIFO for devices that have support for checking the FIFO enable status.
> Fix this by displaying the error message, only when an error occurs.
> 
> Finally, update the error message to make it clear that enabling the
> FIFO failed and display the error code.
[...]
> @@ -1045,9 +1045,11 @@ static int tegra_uart_hw_init(struct tegra_uart_port *tup)
>  
>  	if (tup->cdata->fifo_mode_enable_status) {
>  		ret = tegra_uart_wait_fifo_mode_enabled(tup);
> -		dev_err(tup->uport.dev, "FIFO mode not enabled\n");
> -		if (ret < 0)
> +		if (ret < 0) {
> +			dev_err(tup->uport.dev,
> +				"Failed to enable FIFO mode: %d\n", ret);

Could you change this to use %pe and ERR_PTR(ret)?

Best Regards
Micha³ Miros³aw
