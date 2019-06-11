Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 232363C32A
	for <lists+stable@lfdr.de>; Tue, 11 Jun 2019 07:07:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390983AbfFKFHX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 11 Jun 2019 01:07:23 -0400
Received: from mail-pf1-f196.google.com ([209.85.210.196]:46333 "EHLO
        mail-pf1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2390387AbfFKFHX (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 11 Jun 2019 01:07:23 -0400
Received: by mail-pf1-f196.google.com with SMTP id 81so6610238pfy.13;
        Mon, 10 Jun 2019 22:07:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:references:cc:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-transfer-encoding;
        bh=wkWM1sR/IFbO5oMe7Lbr307SWhapRDl2FwvCP8Cm0DQ=;
        b=H7KQ4YE1BdcqVmVdPo9Iv1b26xjwbPzBiKEs1JStOXdfVbwqIPfct7MN0R6bN7QT6m
         JA76QZ3UGggm0pmIB5/aBuD0PzfNpEEoagwkJURiuS1X6vnhKlpTmgdipsdq2aCPPrpu
         UfWFQEAfNIKLQ4YKexBGnhWagD8E0j0rs4F0JARjkzajr2VV35WarHi54MYU7x4rs9kg
         NWhlzlqjAP/zZmTTqr2yOFcaasCu9xTNRmUly9t8rTSvjPJQ00VtnGm29qqCtywALFsG
         9tVUQC0Xm8KUikPMJA7Vw1WcfnQbzTez+s/l3nS8mBgkhGq2+t4t3ai1QTqNXppm3+n9
         lhbw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:cc:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding;
        bh=wkWM1sR/IFbO5oMe7Lbr307SWhapRDl2FwvCP8Cm0DQ=;
        b=IfKN8CUUwIq+38/aoDqKIUbw7lq5p4+b36OdG53SFgeiCwXPc2QCXjkx+T82WhkMb+
         9ENYdr33HSXUTDDYCVenmwAEbRBXoHp9NQ/zpbCXHy+3rUooAycO2mmvVlaLxbjrC/dG
         34WswqJk3Bv31sjbhr9+d2rGCpRR1LFIHcAcfLPitBnZ+4WIP8GD6zSWelqXuOausuJi
         TbgIQCNUTuePPEB09DyBGcIjIgLlbVqyGmsPeTboF9KWB1vg8Q7DDm9iX6/u/QhDvCeg
         UqXhawDfsVzvf4bz5q9VGho6o08kQS6auzqiE+XFRRgxKIO6LOhUwgtBLPIcnQblxoNU
         mpgg==
X-Gm-Message-State: APjAAAW9RAeRR/LyCBfLOTqg9PVIx6dikF/w90M7K+nR00Wdrl9kyH1y
        HYtkPj7TkiZY55L1YJXI6FxAZeXI
X-Google-Smtp-Source: APXvYqzulpP+6B6D5TiYLMd8uZ6luoILfila7CC3xVWXdCCzQiyQpPs5XiIxNsSlrmSzhLKcvrm28w==
X-Received: by 2002:aa7:8502:: with SMTP id v2mr2666466pfn.98.1560229642113;
        Mon, 10 Jun 2019 22:07:22 -0700 (PDT)
Received: from [192.168.1.101] (122-58-182-39-adsl.sparkbb.co.nz. [122.58.182.39])
        by smtp.gmail.com with ESMTPSA id p27sm8751478pfq.136.2019.06.10.22.07.17
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 10 Jun 2019 22:07:21 -0700 (PDT)
Subject: Re: [PATCH v2 2/7] scsi: NCR5380: Always re-enable reselection
 interrupt
To:     Finn Thain <fthain@telegraphics.com.au>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
References: <cover.1560043151.git.fthain@telegraphics.com.au>
 <61f0c0f6aaf8fa96bf3dade5475615b2cfbc8846.1560043151.git.fthain@telegraphics.com.au>
Cc:     linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
From:   Michael Schmitz <schmitzmic@gmail.com>
Message-ID: <58081aba-4e77-3c8e-847e-0698cf80e426@gmail.com>
Date:   Tue, 11 Jun 2019 17:07:16 +1200
User-Agent: Mozilla/5.0 (X11; Linux ppc; rv:45.0) Gecko/20100101
 Icedove/45.4.0
MIME-Version: 1.0
In-Reply-To: <61f0c0f6aaf8fa96bf3dade5475615b2cfbc8846.1560043151.git.fthain@telegraphics.com.au>
Content-Type: text/plain; charset=iso-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Finn,

IIRC I'd tested that change as well - didn't change broken target 
behaviour but no regressions in other respects. Add my tested-by if needed.

Cheers,

	Michael


Am 09.06.2019 um 13:19 schrieb Finn Thain:
> The reselection interrupt gets disabled during selection and must be
> re-enabled when hostdata->connected becomes NULL. If it isn't re-enabled
> a disconnected command may time-out or the target may wedge the bus while
> trying to reselect the host. This can happen after a command is aborted.
>
> Fix this by enabling the reselection interrupt in NCR5380_main() after
> calls to NCR5380_select() and NCR5380_information_transfer() return.
>
> Cc: Michael Schmitz <schmitzmic@gmail.com>
> Cc: stable@vger.kernel.org # v4.9+
> Fixes: 8b00c3d5d40d ("ncr5380: Implement new eh_abort_handler")
> Tested-by: Stan Johnson <userm57@yahoo.com>
> Signed-off-by: Finn Thain <fthain@telegraphics.com.au>
> ---
>  drivers/scsi/NCR5380.c | 12 ++----------
>  1 file changed, 2 insertions(+), 10 deletions(-)
>
> diff --git a/drivers/scsi/NCR5380.c b/drivers/scsi/NCR5380.c
> index fe0535affc14..08e3ea8159b3 100644
> --- a/drivers/scsi/NCR5380.c
> +++ b/drivers/scsi/NCR5380.c
> @@ -709,6 +709,8 @@ static void NCR5380_main(struct work_struct *work)
>  			NCR5380_information_transfer(instance);
>  			done = 0;
>  		}
> +		if (!hostdata->connected)
> +			NCR5380_write(SELECT_ENABLE_REG, hostdata->id_mask);
>  		spin_unlock_irq(&hostdata->lock);
>  		if (!done)
>  			cond_resched();
> @@ -1110,8 +1112,6 @@ static bool NCR5380_select(struct Scsi_Host *instance, struct scsi_cmnd *cmd)
>  		spin_lock_irq(&hostdata->lock);
>  		NCR5380_write(INITIATOR_COMMAND_REG, ICR_BASE);
>  		NCR5380_reselect(instance);
> -		if (!hostdata->connected)
> -			NCR5380_write(SELECT_ENABLE_REG, hostdata->id_mask);
>  		shost_printk(KERN_ERR, instance, "reselection after won arbitration?\n");
>  		goto out;
>  	}
> @@ -1119,7 +1119,6 @@ static bool NCR5380_select(struct Scsi_Host *instance, struct scsi_cmnd *cmd)
>  	if (err < 0) {
>  		spin_lock_irq(&hostdata->lock);
>  		NCR5380_write(INITIATOR_COMMAND_REG, ICR_BASE);
> -		NCR5380_write(SELECT_ENABLE_REG, hostdata->id_mask);
>
>  		/* Can't touch cmd if it has been reclaimed by the scsi ML */
>  		if (!hostdata->selecting)
> @@ -1157,7 +1156,6 @@ static bool NCR5380_select(struct Scsi_Host *instance, struct scsi_cmnd *cmd)
>  	if (err < 0) {
>  		shost_printk(KERN_ERR, instance, "select: REQ timeout\n");
>  		NCR5380_write(INITIATOR_COMMAND_REG, ICR_BASE);
> -		NCR5380_write(SELECT_ENABLE_REG, hostdata->id_mask);
>  		goto out;
>  	}
>  	if (!hostdata->selecting) {
> @@ -1826,9 +1824,6 @@ static void NCR5380_information_transfer(struct Scsi_Host *instance)
>  					 */
>  					NCR5380_write(TARGET_COMMAND_REG, 0);
>
> -					/* Enable reselect interrupts */
> -					NCR5380_write(SELECT_ENABLE_REG, hostdata->id_mask);
> -
>  					maybe_release_dma_irq(instance);
>  					return;
>  				case MESSAGE_REJECT:
> @@ -1860,8 +1855,6 @@ static void NCR5380_information_transfer(struct Scsi_Host *instance)
>  					 */
>  					NCR5380_write(TARGET_COMMAND_REG, 0);
>
> -					/* Enable reselect interrupts */
> -					NCR5380_write(SELECT_ENABLE_REG, hostdata->id_mask);
>  #ifdef SUN3_SCSI_VME
>  					dregs->csr |= CSR_DMA_ENABLE;
>  #endif
> @@ -1964,7 +1957,6 @@ static void NCR5380_information_transfer(struct Scsi_Host *instance)
>  					cmd->result = DID_ERROR << 16;
>  					complete_cmd(instance, cmd);
>  					maybe_release_dma_irq(instance);
> -					NCR5380_write(SELECT_ENABLE_REG, hostdata->id_mask);
>  					return;
>  				}
>  				msgout = NOP;
>
