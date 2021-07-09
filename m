Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AC5533C28C6
	for <lists+stable@lfdr.de>; Fri,  9 Jul 2021 19:55:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229552AbhGIR6K (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 9 Jul 2021 13:58:10 -0400
Received: from rere.qmqm.pl ([91.227.64.183]:48856 "EHLO rere.qmqm.pl"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229491AbhGIR6K (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 9 Jul 2021 13:58:10 -0400
Received: from remote.user (localhost [127.0.0.1])
        by rere.qmqm.pl (Postfix) with ESMTPSA id 4GM1642518z4x;
        Fri,  9 Jul 2021 19:55:24 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=rere.qmqm.pl; s=1;
        t=1625853324; bh=s2rYFWOsBwqzwKjpx1T5g4sG8Y1sn/4/id+KPsuNJBY=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=rbib2uJTzXtAE5KNUviJCcEI60yzbOIVGcIuSvmubYH8WRm8ZuSUcY+uSEm/i4jjB
         yGP3HVlcvNAKfjmQ/+sRzZrKe+H3reCFRFFUR9nj4+ueAfhrGF3zKoUqNr88v26QLW
         84P8+QImdDAKzA17MEcRLtgRWrCNkVNj5L/uGvlhXey3/rq1zcx1gqIlb8NJooHWSz
         HVnMdCdwy04/n515RqY7tP0BrEQrngMY+ehTnTEthpDFSR+Cf7X8EcxG/zmDzoOKWx
         E3+MgdsUCu/u9QkmSqjC9gFjQu26S+YcaoLNq+X+2RLfZ4prxXanR+EDKCs4Mr5gUx
         MVFkWgCy5s2MQ==
X-Virus-Status: Clean
X-Virus-Scanned: clamav-milter 0.103.2 at mail
Date:   Fri, 9 Jul 2021 19:55:19 +0200
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
Message-ID: <YOiNh2ue6YnN6Zr/@qmqm.qmqm.pl>
References: <20210630125643.264264-1-jonathanh@nvidia.com>
 <YOd7ZTJf0WoQ8oKo@qmqm.qmqm.pl>
 <aad402e7-a2b7-1faf-bc22-eb90bee39d3b@nvidia.com>
 <30057ea5-5699-9335-f4dd-a9e8ed847ee4@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-2
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <30057ea5-5699-9335-f4dd-a9e8ed847ee4@nvidia.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Jul 09, 2021 at 12:38:07PM +0100, Jon Hunter wrote:
> 
> On 09/07/2021 09:34, Jon Hunter wrote:
> > 
> > 
> > On 08/07/2021 23:25, Micha³ Miros³aw wrote:
> >> On Wed, Jun 30, 2021 at 01:56:43PM +0100, Jon Hunter wrote:
> >>> The Tegra serial driver always prints an error message when enabling the
> >>> FIFO for devices that have support for checking the FIFO enable status.
> >>> Fix this by displaying the error message, only when an error occurs.
> >>>
> >>> Finally, update the error message to make it clear that enabling the
> >>> FIFO failed and display the error code.
> >> [...]
> >>> @@ -1045,9 +1045,11 @@ static int tegra_uart_hw_init(struct tegra_uart_port *tup)
> >>>  
> >>>  	if (tup->cdata->fifo_mode_enable_status) {
> >>>  		ret = tegra_uart_wait_fifo_mode_enabled(tup);
> >>> -		dev_err(tup->uport.dev, "FIFO mode not enabled\n");
> >>> -		if (ret < 0)
> >>> +		if (ret < 0) {
> >>> +			dev_err(tup->uport.dev,
> >>> +				"Failed to enable FIFO mode: %d\n", ret);
> >>
> >> Could you change this to use %pe and ERR_PTR(ret)?
> > 
> > Sorry, but it is not clear to me why this would be necessary in this case.
> 
> I see so '%pe' prints the symbolic name of the error code. While that is
> nice, it also looks a bit odd. Given that we simply print the error code
> values in this driver, from looking at other prints, I prefer to keep it
> as is for consistency.

It is a quite new facility of printk(), so I woudn't expect it to be
present in older code. It saves a bit of time when you occasionally
hit an error, so even incremental conversion seems beneficial for me.

Best Regards
Micha³ Miros³aw
