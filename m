Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1D467148FE8
	for <lists+stable@lfdr.de>; Fri, 24 Jan 2020 22:08:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725887AbgAXVIi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 Jan 2020 16:08:38 -0500
Received: from [167.172.186.51] ([167.172.186.51]:57100 "EHLO shell.v3.sk"
        rhost-flags-FAIL-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725747AbgAXVIi (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 24 Jan 2020 16:08:38 -0500
Received: from localhost (localhost.localdomain [127.0.0.1])
        by zimbra.v3.sk (Postfix) with ESMTP id 3D8B6DFE17;
        Fri, 24 Jan 2020 21:08:46 +0000 (UTC)
Received: from shell.v3.sk ([127.0.0.1])
        by localhost (zimbra.v3.sk [127.0.0.1]) (amavisd-new, port 10032)
        with ESMTP id nsCRUdqw7lCo; Fri, 24 Jan 2020 21:08:45 +0000 (UTC)
Received: from localhost (localhost.localdomain [127.0.0.1])
        by zimbra.v3.sk (Postfix) with ESMTP id 97A45DFEAD;
        Fri, 24 Jan 2020 21:08:45 +0000 (UTC)
X-Virus-Scanned: amavisd-new at zimbra.v3.sk
Received: from shell.v3.sk ([127.0.0.1])
        by localhost (zimbra.v3.sk [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id ELtJo5_L7sxB; Fri, 24 Jan 2020 21:08:45 +0000 (UTC)
Received: from localhost (unknown [109.183.109.54])
        by zimbra.v3.sk (Postfix) with ESMTPSA id 4F1C4DFE17;
        Fri, 24 Jan 2020 21:08:45 +0000 (UTC)
Date:   Fri, 24 Jan 2020 22:08:33 +0100
From:   Lubomir Rintel <lkundrak@v3.sk>
To:     Sasha Levin <sashal@kernel.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Stephen Boyd <sboyd@kernel.org>,
        Olof Johansson <olof@lixom.net>, linux-clk@vger.kernel.org
Subject: Re: [PATCH AUTOSEL 5.4 028/107] clk: mmp2: Fix the order of timer
 mux parents
Message-ID: <20200124210833.GA244505@furthur.local>
References: <20200124141817.28793-1-sashal@kernel.org>
 <20200124141817.28793-28-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200124141817.28793-28-sashal@kernel.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Jan 24, 2020 at 09:16:58AM -0500, Sasha Levin wrote:
> From: Lubomir Rintel <lkundrak@v3.sk>
> 
> [ Upstream commit 8bea5ac0fbc5b2103f8779ddff216122e3c2e1ad ]
> 
> Determined empirically, no documentation is available.
> 
> The OLPC XO-1.75 laptop used parent 1, that one being VCTCXO/4 (65MHz), but
> thought it's a VCTCXO/2 (130MHz). The mmp2 timer driver, not knowing
> what is going on, ended up just dividing the rate as of
> commit f36797ee4380 ("ARM: mmp/mmp2: dt: enable the clock")'

Hi,

this has to go together with this one (in other stable trees too):

  commit 0bd0f30bbf060891f58866a46083a9931f71787c
  Author: Lubomir Rintel <lkundrak@v3.sk>
  Date:   Wed Dec 18 20:04:53 2019 +0100
  
      ARM: mmp: do not divide the clock rate
      
      This was done because the clock driver returned the wrong rate, which is
      fixed in "clk: mmp2: Fix the order of timer mux parents" patch.

It removes a workaround for the same issue from before it was
understood what is going on. If it stays, the clock will run twice as
fast.

Thanks
Lubo

> 
> Link: https://lore.kernel.org/r/20191218190454.420358-3-lkundrak@v3.sk
> Signed-off-by: Lubomir Rintel <lkundrak@v3.sk>
> Acked-by: Stephen Boyd <sboyd@kernel.org>
> Signed-off-by: Olof Johansson <olof@lixom.net>
> Signed-off-by: Sasha Levin <sashal@kernel.org>
> ---
>  drivers/clk/mmp/clk-of-mmp2.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/clk/mmp/clk-of-mmp2.c b/drivers/clk/mmp/clk-of-mmp2.c
> index a60a1be937ad6..b4a95cbbda989 100644
> --- a/drivers/clk/mmp/clk-of-mmp2.c
> +++ b/drivers/clk/mmp/clk-of-mmp2.c
> @@ -134,7 +134,7 @@ static DEFINE_SPINLOCK(ssp3_lock);
>  static const char *ssp_parent_names[] = {"vctcxo_4", "vctcxo_2", "vctcxo", "pll1_16"};
>  
>  static DEFINE_SPINLOCK(timer_lock);
> -static const char *timer_parent_names[] = {"clk32", "vctcxo_2", "vctcxo_4", "vctcxo"};
> +static const char *timer_parent_names[] = {"clk32", "vctcxo_4", "vctcxo_2", "vctcxo"};
>  
>  static DEFINE_SPINLOCK(reset_lock);
>  
> -- 
> 2.20.1
> 
