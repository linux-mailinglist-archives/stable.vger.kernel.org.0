Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1B4DC9F7C7
	for <lists+stable@lfdr.de>; Wed, 28 Aug 2019 03:21:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726096AbfH1BVw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Aug 2019 21:21:52 -0400
Received: from mail.overt.org ([157.230.92.47]:58441 "EHLO mail.overt.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726092AbfH1BVw (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Aug 2019 21:21:52 -0400
X-Greylist: delayed 389 seconds by postgrey-1.27 at vger.kernel.org; Tue, 27 Aug 2019 21:21:52 EDT
Received: from authenticated-user (mail.overt.org [157.230.92.47])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.overt.org (Postfix) with ESMTPSA id B598B3F246;
        Tue, 27 Aug 2019 20:15:21 -0500 (CDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=overt.org; s=mail;
        t=1566954922; bh=tkxFE05zBdRKg+WXfglpzaSon0igXNH51O5eLRCpQCg=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=JUmXJMUeMy4jNCMAMn+4+Zl51pomK27+aLGcJFz0W4YwcbFPt5M/ZdpGj5jyQUPTM
         lXDCQvFoicdvj7G+TzI/i4is0C0WEz9AzJVinNMHeTsMD5C9Y6Y2LcLZJPAXmOp6C1
         Pn0Z3HHCG78wWOTjcFFUr3PPSRrL6CWp3gP91cp9wPKT6+Vs9IU/G2oBhT2kLoPMts
         4HIV5pMEfw1kYGAIZqYsbDolMccwB1Y5gas+OuT/KJ1wAuqXVEVXVzI5em+hBh0X2I
         Gw4oK9nEboW872SxdEMdfrZxyecDARvQdiSx51xAuxwNqY/7gQ6q+doYuFg368hdiB
         Iy+V32jZmpVUw==
Date:   Tue, 27 Aug 2019 18:15:18 -0700
From:   Philip Langdale <philipl@overt.org>
To:     Ulf Hansson <ulf.hansson@linaro.org>
Cc:     linux-mmc@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH] mmc: core: Fix init of SD cards reporting an invalid
 VDD range
Message-ID: <20190827181518.2e7aaa44@fido6>
In-Reply-To: <20190827081043.15443-1-ulf.hansson@linaro.org>
References: <20190827081043.15443-1-ulf.hansson@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, 27 Aug 2019 10:10:43 +0200
Ulf Hansson <ulf.hansson@linaro.org> wrote:

> The OCR register defines the supported range of VDD voltages for SD
> cards. However, it has turned out that some SD cards reports an
> invalid voltage range, for example having bit7 set.
> 
> When a host supports MMC_CAP2_FULL_PWR_CYCLE and some of the voltages
> from the invalid VDD range, this triggers the core to run a power
> cycle of the card to try to initialize it at the lowest common
> supported voltage. Obviously this fails, since the card can't support
> it.
> 
> Let's fix this problem, by clearing invalid bits from the read OCR
> register for SD cards, before proceeding with the VDD voltage
> negotiation.
> 
> Cc: stable@vger.kernel.org
> Reported-by: Philip Langdale <philipl@overt.org>
> Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
> ---
>  drivers/mmc/core/sd.c | 6 ++++++
>  1 file changed, 6 insertions(+)
> 
> diff --git a/drivers/mmc/core/sd.c b/drivers/mmc/core/sd.c
> index d681e8aaca83..fe914ff5f5d6 100644
> --- a/drivers/mmc/core/sd.c
> +++ b/drivers/mmc/core/sd.c
> @@ -1292,6 +1292,12 @@ int mmc_attach_sd(struct mmc_host *host)
>  			goto err;
>  	}
>  
> +	/*
> +	 * Some SD cards claims an out of spec VDD voltage range.
> Let's treat
> +	 * these bits as being in-valid and especially also bit7.
> +	 */
> +	ocr &= ~0x7FFF;
> +
>  	rocr = mmc_select_voltage(host, ocr);
>  
>  	/*

Looks right. Tried it out and worked as expected.

Reviewed-by: Philip Langdale <philipl@overt.org>

--phil
