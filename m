Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C0B36A81AC
	for <lists+stable@lfdr.de>; Wed,  4 Sep 2019 13:59:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729749AbfIDL5g (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 Sep 2019 07:57:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:38846 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727156AbfIDL5g (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 4 Sep 2019 07:57:36 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4896D22DBF;
        Wed,  4 Sep 2019 11:57:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1567598255;
        bh=ZRXn29GWAqoFb0gk00UfjbGw6+gywg1whC8MPxc3uJI=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=rMknOy57y4QMbnHPdAl40bBU04krJY0LOYc0uKmmhMD+2WDtZTt/gpwBf22oxpxKO
         HH8FFDyx1UMxAHepp76EYL/KlBrvhZdBLVic1s1cKQVDzzFOTE8cenuiUZoZn+JPz+
         pjSSUNu91H6gtiKywvpfSgxQjjn8KyZgh3OrrbWI=
Date:   Wed, 4 Sep 2019 13:57:33 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     "Sonawane, Aashish P" <AashishPSonawane@eaton.com>
Cc:     "a.zummo@towertech.it" <a.zummo@towertech.it>,
        "alexandre.belloni@free-electrons.com" 
        <alexandre.belloni@free-electrons.com>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "Saitwal, Meghan" <MeghanSaitwal@eaton.com>
Subject: Re: [PATCH] rtc : Restricting year setting between 2000 to 2099 in
 rtc-s35390a driver
Message-ID: <20190904115733.GA9993@kroah.com>
References: <29075B3123F59F41878316669231A55F0A9ED945@SIMTCSMB12.napa.ad.etn.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <29075B3123F59F41878316669231A55F0A9ED945@SIMTCSMB12.napa.ad.etn.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Sep 04, 2019 at 11:20:26AM +0000, Sonawane, Aashish P wrote:
> 
> S-35390A RTC chip allows to set the lower two digit of the Western calendar year (00 to 99) and links together with the auto calendar from the year 2000 to the year 2099. If we try to set year earlier than 2000 then hardware clock get reset to "epoch". This patch check for year value between 2000 to 2099 otherwise returns "EINVAL" error. In conclusion this patch restricts system to set hardware clock to set year below and above the year 2000 and 2099 respectively.
> 
> Signed-off-by: Aashish P Sonawane mailto:AashishPSonawane@eaton.com
> Suggested-by: Meghan Saitwal mailto:MeghanSaitwal@eaton.com
> ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------diff --git a/drivers/rtc/rtc-s35390a.c b/drivers/rtc/rtc-s35390a.c
> index 84806ff763cf..aea52548571e 100644
> --- a/drivers/rtc/rtc-s35390a.c
> +++ b/drivers/rtc/rtc-s35390a.c
> @@ -214,6 +214,9 @@ static int s35390a_rtc_set_time(struct device *dev, struct rtc_time *tm)
>  	int i, err;
>  	char buf[7], status;
>  
> +	if (tm->tm_year < 100 || tm->tm_year > 199)
> +		return EINVAL;
> +
>  	dev_dbg(&client->dev, "%s: tm is secs=%d, mins=%d, hours=%d mday=%d, "
>  		"mon=%d, year=%d, wday=%d\n", __func__, tm->tm_sec,
>  		tm->tm_min, tm->tm_hour, tm->tm_mday, tm->tm_mon, tm->tm_year,

<formletter>

This is not the correct way to submit patches for inclusion in the
stable kernel tree.  Please read:
    https://www.kernel.org/doc/html/latest/process/stable-kernel-rules.html
for how to do this properly.

</formletter>
