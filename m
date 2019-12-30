Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DBCFC12D508
	for <lists+stable@lfdr.de>; Tue, 31 Dec 2019 00:24:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727767AbfL3XY5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 30 Dec 2019 18:24:57 -0500
Received: from mail25.static.mailgun.info ([104.130.122.25]:19757 "EHLO
        mail25.static.mailgun.info" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727746AbfL3XY5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 30 Dec 2019 18:24:57 -0500
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1577748296; h=Message-ID: References: In-Reply-To: Subject:
 Cc: To: From: Date: Content-Transfer-Encoding: Content-Type:
 MIME-Version: Sender; bh=vBXvyWu/WmFpK3s/9QyjuCrueKEXWqV2Lek88cSNWSQ=;
 b=XJVRG1RP8sgVrjsc2QsktrXIcGjcOvfUocUyELzHMVcxmPMrNfQVy6n0gF0qGxMj+pFeVSmU
 MenizJUrahHDBoezBal91yfP6Kk4xmYbKbNWieXoXIg7bNzu1NVAvtEx1nDoSGnAbysEXW9X
 tRIzITIjJ8+Y35b7XdPucAdsREs=
X-Mailgun-Sending-Ip: 104.130.122.25
X-Mailgun-Sid: WyI1ZjI4MyIsICJzdGFibGVAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171])
 by mxa.mailgun.org with ESMTP id 5e0a8748.7fe87b388298-smtp-out-n02;
 Mon, 30 Dec 2019 23:24:56 -0000 (UTC)
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 0007AC447A4; Mon, 30 Dec 2019 23:24:55 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=2.0 tests=ALL_TRUSTED,URIBL_BLOCKED
        autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.codeaurora.org (localhost.localdomain [127.0.0.1])
        (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: asutoshd)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 9A397C43383;
        Mon, 30 Dec 2019 23:24:54 +0000 (UTC)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Mon, 30 Dec 2019 15:24:54 -0800
From:   asutoshd@codeaurora.org
To:     Stanley Chu <stanley.chu@mediatek.com>
Cc:     linux-scsi@vger.kernel.org, martin.petersen@oracle.com,
        avri.altman@wdc.com, alim.akhtar@samsung.com,
        pedrom.sousa@synopsys.com, jejb@linux.ibm.com,
        matthias.bgg@gmail.com, bvanassche@acm.org,
        subhashj@codeaurora.org, beanhuo@micron.com, cang@codeaurora.org,
        linux-mediatek@lists.infradead.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        kuohong.wang@mediatek.com, peter.wang@mediatek.com,
        chun-hung.wu@mediatek.com, andy.teng@mediatek.com,
        stable@vger.kernel.org, linux-scsi-owner@vger.kernel.org
Subject: Re: [PATCH v1 1/2] scsi: ufs: set device as default active power mode
 during initialization only
In-Reply-To: <1577693546-7598-2-git-send-email-stanley.chu@mediatek.com>
References: <1577693546-7598-1-git-send-email-stanley.chu@mediatek.com>
 <1577693546-7598-2-git-send-email-stanley.chu@mediatek.com>
Message-ID: <fd129b859c013852bd80f60a36425757@codeaurora.org>
X-Sender: asutoshd@codeaurora.org
User-Agent: Roundcube Webmail/1.3.9
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Stanley,

On 2019-12-30 00:12, Stanley Chu wrote:
> Currently ufshcd_probe_hba() always sets device status as "active".
> This shall be by an assumption that device is already in active state
> during the boot stage before kernel.
> 
> However, if link is configured as "off" state and device is requested
> to enter "sleep" or "powerdown" power mode during suspend flow, device
> will NOT be waken up to "active" power mode during resume flow because
> device is already set as "active" power mode in ufhcd_probe_hba().
> 
> Fix it by setting device as default active power mode during
> initialization only, and skipping changing mode during PM flow
> in ufshcd_probe_hba().
> 
> Fixes: 7caf489b99a4 (scsi: ufs: issue link starup 2 times if device
> isn't active)
> Cc: Alim Akhtar <alim.akhtar@samsung.com>
> Cc: Avri Altman <avri.altman@wdc.com>
> Cc: Bart Van Assche <bvanassche@acm.org>
> Cc: Bean Huo <beanhuo@micron.com>
> Cc: Can Guo <cang@codeaurora.org>
> Cc: Matthias Brugger <matthias.bgg@gmail.com>
> Cc: Subhash Jadavani <subhashj@codeaurora.org>
> Cc: stable@vger.kernel.org
> Signed-off-by: Stanley Chu <stanley.chu@mediatek.com>
> ---
>  drivers/scsi/ufs/ufshcd.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
> index ed02a704c1c2..9abb7085a5d0 100644
> --- a/drivers/scsi/ufs/ufshcd.c
> +++ b/drivers/scsi/ufs/ufshcd.c
> @@ -6986,7 +6986,8 @@ static int ufshcd_probe_hba(struct ufs_hba *hba)
>  	ufshcd_tune_unipro_params(hba);
> 
>  	/* UFS device is also active now */
> -	ufshcd_set_ufs_dev_active(hba);
> +	if (!hba->pm_op_in_progress)
> +		ufshcd_set_ufs_dev_active(hba);
>  	ufshcd_force_reset_auto_bkops(hba);
>  	hba->wlun_dev_clr_ua = true;

I see that there's a get_sync done before.
So, how would the suspend be triggered in that case?

Thanks,
asd
