Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7BFDF4A7148
	for <lists+stable@lfdr.de>; Wed,  2 Feb 2022 14:12:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236122AbiBBNM1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 2 Feb 2022 08:12:27 -0500
Received: from mail.acc.umu.se ([130.239.18.156]:51113 "EHLO mail.acc.umu.se"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233173AbiBBNMZ (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 2 Feb 2022 08:12:25 -0500
Received: from localhost (localhost.localdomain [127.0.0.1])
        by amavisd-new (Postfix) with ESMTP id 783EA44B90;
        Wed,  2 Feb 2022 14:12:24 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=acc.umu.se; s=mail1;
        t=1643807544; bh=QL6UvS/QjjE8M4+dEWR4NS/jhXWfvAVtTJujher8n7I=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=yx1PzOuebjjeRKigZSCX63giPs4fuy8+MxIdwueYbtXwrvhzR+YEUdREPyIbDB7AF
         rdm56+coI4ew0Nf3yTpJIkjJvJj8gXMBz25raA6Vu3Hp34mVOI+J1u5er9xQDn5wRe
         m8DJiYAJo3PLvD0SP2M4FI3n90MFN2Xyyr5/jtz4xk3/TxIBUqI72/PqocBZcUt9t1
         GfUl1kYwPCcYwHQNTMN945R+5miklmY+6a+AHoYZg13/4fx2b4V1l6yOldl2e4Iacn
         sSFmEyhOOstbpFGXeErlzEvxUZoNSjgaYHT20Vc+I5xdJ3ytqszXC5HctqvMEIXDFv
         JakzQVmJiUzkA==
Received: by mail.acc.umu.se (Postfix, from userid 24471)
        id 176BF44B92; Wed,  2 Feb 2022 14:12:24 +0100 (CET)
Date:   Wed, 2 Feb 2022 14:12:23 +0100
From:   Anton Lundin <glance@acc.umu.se>
To:     Damien Le Moal <damien.lemoal@opensource.wdc.com>
Cc:     linux-ide@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH] libata: Don't issue ATA_LOG_DIRECTORY to SATADOM-ML 3ME
Message-ID: <20220202131223.GG723116@montezuma.acc.umu.se>
References: <20220202100536.1909665-1-glance@acc.umu.se>
 <68992064-ee43-db10-fdd4-f40a09734ffe@opensource.wdc.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <68992064-ee43-db10-fdd4-f40a09734ffe@opensource.wdc.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 02 February, 2022 - Damien Le Moal wrote:

> On 2/2/22 19:05, Anton Lundin wrote:
> > Back in 06f6c4c6c3e8 ("ata: libata: add missing ata_identify_page_supported() calls")
> > a read of ATA_LOG_DIRECTORY page was added. This caused the
> > SATADOM-ML 3ME to lock up.
> > 
> > In 636f6e2af4fb ("libata: add horkage for missing Identify Device log")
> > a flag was added to cache if a device supports this or not.
> > 
> > This adds a blacklist entry which flags that these devices doesn't
> > support that call and shouldn't be issued that call.
> > 
> > Cc: stable@vger.kernel.org # v5.10+
> > Signed-off-by: Anton Lundin <glance@acc.umu.se>
> > Depends-on: 636f6e2af4fb ("libata: add horkage for missing Identify Device log")
> > ---
> >  drivers/ata/libata-core.c | 7 +++++++
> >  1 file changed, 7 insertions(+)
> > 
> > diff --git a/drivers/ata/libata-core.c b/drivers/ata/libata-core.c
> > index 87d36b29ca5f..e024af9f33d0 100644
> > --- a/drivers/ata/libata-core.c
> > +++ b/drivers/ata/libata-core.c
> > @@ -4070,6 +4070,13 @@ static const struct ata_blacklist_entry ata_device_blacklist [] = {
> >  	{ "WDC WD3000JD-*",		NULL,	ATA_HORKAGE_WD_BROKEN_LPM },
> >  	{ "WDC WD3200JD-*",		NULL,	ATA_HORKAGE_WD_BROKEN_LPM },
> >  
> > +	/*
> > +	 * This sata dom goes on a walkabout when it sees the
> > +	 * ATA_LOG_DIRECTORY read request so ensure we don't issue such a
> > +	 * request to these devices.
> > +	 */
> > +	{ "SATADOM-ML 3ME",		NULL,	ATA_HORKAGE_NO_ID_DEV_LOG },
> > +
> >  	/* End Marker */
> >  	{ }
> >  };
> 
> Can you try the attached patch ?
> 
> I think it is important to confirm if the lockup on your drive happens
> due to reads of the log directory log page or due to reads of the
> identify device log page. The attached patch prevents the former, your
> patch prevents the latter. If your patch is all that is needed, then it
> is good, modulo some rephrasing of the commit message and comments.
 
This patch also fixes the issue with these devices. From what I've
previously concluded is that nothing else requests the log directory log
page on these devices.


//Anton

-- 
Anton Lundin	+46702-161604
