Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4ED54E4EA1
	for <lists+stable@lfdr.de>; Fri, 25 Oct 2019 16:12:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2503631AbfJYOMJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 25 Oct 2019 10:12:09 -0400
Received: from mx1.redhat.com ([209.132.183.28]:33254 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2406101AbfJYOMJ (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 25 Oct 2019 10:12:09 -0400
Received: from mail-pl1-f197.google.com (mail-pl1-f197.google.com [209.85.214.197])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id AE0113688E
        for <stable@vger.kernel.org>; Fri, 25 Oct 2019 14:12:08 +0000 (UTC)
Received: by mail-pl1-f197.google.com with SMTP id g13so1552667plq.20
        for <stable@vger.kernel.org>; Fri, 25 Oct 2019 07:12:08 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:reply-to
         :references:mime-version:content-disposition:in-reply-to:user-agent;
        bh=mngp9ByjJpQg9SxtEqbRAAoshsDSaBU3xx6GDmhW2Rk=;
        b=tHTw5Vt0/ETLRmGbzKaK6/j/zYZYNEKHAPew2MRWGT37i6qAFPql+1OSplITs3/iCL
         r7H3qIE1XkeRJZF0MYdTDUudXx13m6RfDiC9FMPvDghya3sw+6igx6F7ZroFykDt4fFn
         qinRktXDIKa7Ch8E6JyEz+JZdqi2fh4BSNSUWyuYUbDSaFQn+6ughWTkEKxGOpKIb2a3
         Oi0la03V6otdWitJtQBGoElxio4/oAPWKkI/2LxuqAqw4LJC2lfkBNhiO5oYyA3I+7E4
         6FqibLvOyWClanUsFBblChj1RnFcFEpYZrvqQhUPfLW/QlHJfoynyLiviYnEOtjyOUTw
         viMw==
X-Gm-Message-State: APjAAAXuJPNoupgRbt/4kGWYrsm8Qk2ZgpDlhaoAVdFwEGbPySjTYG9r
        d00Dnt6uKtyZfpH3RoFDAJMZ/1vB04y8+F61gOx5A9G1VN2hupPdGX/aXrqc4vbzTwK5i7h+vNY
        z2ZSRvngsMvULm+xv
X-Received: by 2002:a17:902:7684:: with SMTP id m4mr3940755pll.13.1572012727832;
        Fri, 25 Oct 2019 07:12:07 -0700 (PDT)
X-Google-Smtp-Source: APXvYqz7AEcm435KjYgZqphptYvJ49zOefG9Ex/lTNGT+5fch3KhjaaMUw8kACuhB2ab3+0PFqWY0Q==
X-Received: by 2002:a17:902:7684:: with SMTP id m4mr3940724pll.13.1572012727562;
        Fri, 25 Oct 2019 07:12:07 -0700 (PDT)
Received: from localhost (ip70-163-223-149.ph.ph.cox.net. [70.163.223.149])
        by smtp.gmail.com with ESMTPSA id 82sm4101072pfa.115.2019.10.25.07.12.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 25 Oct 2019 07:12:06 -0700 (PDT)
Date:   Fri, 25 Oct 2019 07:12:05 -0700
From:   Jerry Snitselaar <jsnitsel@redhat.com>
To:     Hans de Goede <hdegoede@redhat.com>
Cc:     Peter Huewe <peterhuewe@gmx.de>,
        Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>,
        Jason Gunthorpe <jgg@ziepe.ca>, Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-integrity@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH v2] tpm: Switch to platform_get_irq_optional()
Message-ID: <20191025141205.vejqamwsppvdmp7a@cantor>
Reply-To: Jerry Snitselaar <jsnitsel@redhat.com>
References: <20191025091448.4424-1-hdegoede@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20191025091448.4424-1-hdegoede@redhat.com>
User-Agent: NeoMutt/20180716
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri Oct 25 19, Hans de Goede wrote:
>platform_get_irq() calls dev_err() on an error. As the IRQ usage in the
>tpm_tis driver is optional, this is undesirable.
>
>Specifically this leads to this new false-positive error being logged:
>[    5.135413] tpm_tis MSFT0101:00: IRQ index 0 not found
>
>This commit switches to platform_get_irq_optional(), which does not log
>an error, fixing this.
>
>Fixes: 7723f4c5ecdb ("driver core: platform: Add an error message to platform_get_irq*()"
>Cc: <stable@vger.kernel.org> # 5.4.x
>Signed-off-by: Hans de Goede <hdegoede@redhat.com>

Reviewed-by: Jerry Snitselaar <jsnitsel@redhat.com>

>---
>Changes in v2:
>- Slightly reword commit msg, add Fixes tag
>---
> drivers/char/tpm/tpm_tis.c | 2 +-
> 1 file changed, 1 insertion(+), 1 deletion(-)
>
>diff --git a/drivers/char/tpm/tpm_tis.c b/drivers/char/tpm/tpm_tis.c
>index e4fdde93ed4c..e7df342a317d 100644
>--- a/drivers/char/tpm/tpm_tis.c
>+++ b/drivers/char/tpm/tpm_tis.c
>@@ -286,7 +286,7 @@ static int tpm_tis_plat_probe(struct platform_device *pdev)
> 	}
> 	tpm_info.res = *res;
>
>-	tpm_info.irq = platform_get_irq(pdev, 0);
>+	tpm_info.irq = platform_get_irq_optional(pdev, 0);
> 	if (tpm_info.irq <= 0) {
> 		if (pdev != force_pdev)
> 			tpm_info.irq = -1;
>-- 
>2.23.0
>

