Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9EC7D1524C9
	for <lists+stable@lfdr.de>; Wed,  5 Feb 2020 03:28:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727140AbgBEC0j (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 4 Feb 2020 21:26:39 -0500
Received: from mail26.static.mailgun.info ([104.130.122.26]:21186 "EHLO
        mail26.static.mailgun.info" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727674AbgBEC0j (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 4 Feb 2020 21:26:39 -0500
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1580869598; h=Message-ID: References: In-Reply-To: Subject:
 Cc: To: From: Date: Content-Transfer-Encoding: Content-Type:
 MIME-Version: Sender; bh=Pgq9KvjPRshhckyUvQfLK0OTeO6Xr6mnSEYtpz2S3GE=;
 b=oic5PAMqoH8CTKVI86mItCckTOcke/VNhj2BXVFo4TMcWT6PPtAmOTzKhQpCdNR95BX0YHMT
 rglad2CerKHWZrC6yqIYhlnfm09P+oFOtAtZg1rzfCvp+ZpwcrpfMleDE+yr+5VXZaWf9T5M
 XIcYKUbICS3QmWfTA4QJCwjm7+8=
X-Mailgun-Sending-Ip: 104.130.122.26
X-Mailgun-Sid: WyI1ZjI4MyIsICJzdGFibGVAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171])
 by mxa.mailgun.org with ESMTP id 5e3a27dc.7f7f05ee4298-smtp-out-n01;
 Wed, 05 Feb 2020 02:26:36 -0000 (UTC)
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 7BABBC447A1; Wed,  5 Feb 2020 02:26:36 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=2.0 tests=ALL_TRUSTED,URIBL_BLOCKED
        autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.codeaurora.org (localhost.localdomain [127.0.0.1])
        (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: cang)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 38A01C433CB;
        Wed,  5 Feb 2020 02:26:35 +0000 (UTC)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Wed, 05 Feb 2020 10:26:35 +0800
From:   Can Guo <cang@codeaurora.org>
To:     Stanley Chu <stanley.chu@mediatek.com>
Cc:     linux-scsi@vger.kernel.org, martin.petersen@oracle.com,
        avri.altman@wdc.com, alim.akhtar@samsung.com, jejb@linux.ibm.com,
        beanhuo@micron.com, asutoshd@codeaurora.org,
        matthias.bgg@gmail.com, bvanassche@acm.org,
        linux-mediatek@lists.infradead.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        kuohong.wang@mediatek.com, peter.wang@mediatek.com,
        chun-hung.wu@mediatek.com, andy.teng@mediatek.com,
        stable@vger.kernel.org
Subject: Re: [PATCH RESEND v3 3/4] scsi: ufs: fix Auto-Hibern8 error detection
In-Reply-To: <20200129105251.12466-4-stanley.chu@mediatek.com>
References: <20200129105251.12466-1-stanley.chu@mediatek.com>
 <20200129105251.12466-4-stanley.chu@mediatek.com>
Message-ID: <42d40d961663b0a83e4d6bb266fe5ca1@codeaurora.org>
X-Sender: cang@codeaurora.org
User-Agent: Roundcube Webmail/1.3.9
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 2020-01-29 18:52, Stanley Chu wrote:
> Auto-Hibern8 may be disabled by some vendors or sysfs
> in runtime even if Auto-Hibern8 capability is supported
> by host. If Auto-Hibern8 capability is supported by host
> but not actually enabled, Auto-Hibern8 error shall not happen.
> 
> To fix this, provide a way to detect if Auto-Hibern8 is
> actually enabled first, and bypass Auto-Hibern8 disabling
> case in ufshcd_is_auto_hibern8_error().
> 
> Fixes: 821744403913 ("scsi: ufs: Add error-handling of Auto-Hibernate")
> Cc: stable@vger.kernel.org
> Signed-off-by: Stanley Chu <stanley.chu@mediatek.com>
> Reviewed-by: Bean Huo <beanhuo@micron.com>
> ---

Reviewed-by: Can Guo <cang@codeaurora.org>

>  drivers/scsi/ufs/ufshcd.c | 3 ++-
>  drivers/scsi/ufs/ufshcd.h | 6 ++++++
>  2 files changed, 8 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
> index abd0e6b05f79..214a3f373dd8 100644
> --- a/drivers/scsi/ufs/ufshcd.c
> +++ b/drivers/scsi/ufs/ufshcd.c
> @@ -5479,7 +5479,8 @@ static irqreturn_t
> ufshcd_update_uic_error(struct ufs_hba *hba)
>  static bool ufshcd_is_auto_hibern8_error(struct ufs_hba *hba,
>  					 u32 intr_mask)
>  {
> -	if (!ufshcd_is_auto_hibern8_supported(hba))
> +	if (!ufshcd_is_auto_hibern8_supported(hba) ||
> +	    !ufshcd_is_auto_hibern8_enabled(hba))
>  		return false;
> 
>  	if (!(intr_mask & UFSHCD_UIC_HIBERN8_MASK))
> diff --git a/drivers/scsi/ufs/ufshcd.h b/drivers/scsi/ufs/ufshcd.h
> index 2ae6c7c8528c..81c71a3e3474 100644
> --- a/drivers/scsi/ufs/ufshcd.h
> +++ b/drivers/scsi/ufs/ufshcd.h
> @@ -55,6 +55,7 @@
>  #include <linux/clk.h>
>  #include <linux/completion.h>
>  #include <linux/regulator/consumer.h>
> +#include <linux/bitfield.h>
>  #include "unipro.h"
> 
>  #include <asm/irq.h>
> @@ -773,6 +774,11 @@ static inline bool
> ufshcd_is_auto_hibern8_supported(struct ufs_hba *hba)
>  	return (hba->capabilities & MASK_AUTO_HIBERN8_SUPPORT);
>  }
> 
> +static inline bool ufshcd_is_auto_hibern8_enabled(struct ufs_hba *hba)
> +{
> +	return FIELD_GET(UFSHCI_AHIBERN8_TIMER_MASK, hba->ahit) ? true : 
> false;
> +}
> +
>  #define ufshcd_writel(hba, val, reg)	\
>  	writel((val), (hba)->mmio_base + (reg))
>  #define ufshcd_readl(hba, reg)	\
