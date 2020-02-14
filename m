Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7C4A515F918
	for <lists+stable@lfdr.de>; Fri, 14 Feb 2020 22:55:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388630AbgBNVyu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 14 Feb 2020 16:54:50 -0500
Received: from mail.kernel.org ([198.145.29.99]:59778 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388060AbgBNVyk (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 14 Feb 2020 16:54:40 -0500
Received: from localhost (unknown [65.119.211.164])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id ACBEE24649;
        Fri, 14 Feb 2020 21:54:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581717279;
        bh=us7Ky2raribzaFr6D817KcoGYvcrvYH7nSrOgKdWyFQ=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=q+Tp0/+BdplnjTGfb70mf4eYqIUF66en0cAcKKXwf7/Pkg/vhggrd9q0zqm8wUaPW
         tPiNHfrq1PIn2Jqp+7BUa1W47vs4SbU6a5k878fIDl/IiAdYFLJLsxXhBcQNm/8qJm
         y9TLlO9pT0wXfrw/6DFGF9L+kgmUFNeyoXhLK68Q=
Date:   Fri, 14 Feb 2020 16:50:41 -0500
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Sasha Levin <sashal@kernel.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Xiongfeng Wang <wangxiongfeng2@huawei.com>,
        Hulk Robot <hulkci@huawei.com>, linux-serial@vger.kernel.org
Subject: Re: [PATCH AUTOSEL 5.5 200/542] tty: serial: amba-pl011: remove set
 but unused variable
Message-ID: <20200214215041.GI4193448@kroah.com>
References: <20200214154854.6746-1-sashal@kernel.org>
 <20200214154854.6746-200-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200214154854.6746-200-sashal@kernel.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Feb 14, 2020 at 10:43:12AM -0500, Sasha Levin wrote:
> From: Xiongfeng Wang <wangxiongfeng2@huawei.com>
> 
> [ Upstream commit 94345aee285334e9e12fc70572e3d9380791a64e ]
> 
> Fix the following warning:
> drivers/tty/serial/amba-pl011.c: In function check_apply_cts_event_workaround:
> drivers/tty/serial/amba-pl011.c:1461:15: warning: variable dummy_read set but not used [-Wunused-but-set-variable]
> 
> The data read is useless and can be dropped.
> 
> Reported-by: Hulk Robot <hulkci@huawei.com>
> Signed-off-by: Xiongfeng Wang <wangxiongfeng2@huawei.com>
> Link: https://lore.kernel.org/r/1575619526-34482-1-git-send-email-wangxiongfeng2@huawei.com
> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> Signed-off-by: Sasha Levin <sashal@kernel.org>
> ---
>  drivers/tty/serial/amba-pl011.c | 6 ++----
>  1 file changed, 2 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/tty/serial/amba-pl011.c b/drivers/tty/serial/amba-pl011.c
> index 4b28134d596a9..c5e9475feb47a 100644
> --- a/drivers/tty/serial/amba-pl011.c
> +++ b/drivers/tty/serial/amba-pl011.c
> @@ -1452,8 +1452,6 @@ static void pl011_modem_status(struct uart_amba_port *uap)
>  
>  static void check_apply_cts_event_workaround(struct uart_amba_port *uap)
>  {
> -	unsigned int dummy_read;
> -
>  	if (!uap->vendor->cts_event_workaround)
>  		return;
>  
> @@ -1465,8 +1463,8 @@ static void check_apply_cts_event_workaround(struct uart_amba_port *uap)
>  	 * single apb access will incur 2 pclk(133.12Mhz) delay,
>  	 * so add 2 dummy reads
>  	 */
> -	dummy_read = pl011_read(uap, REG_ICR);
> -	dummy_read = pl011_read(uap, REG_ICR);
> +	pl011_read(uap, REG_ICR);
> +	pl011_read(uap, REG_ICR);
>  }
>  
>  static irqreturn_t pl011_int(int irq, void *dev_id)
> -- 
> 2.20.1
> 

Please drop.
