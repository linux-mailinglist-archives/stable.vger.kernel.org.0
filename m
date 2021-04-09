Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DABB235967B
	for <lists+stable@lfdr.de>; Fri,  9 Apr 2021 09:36:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231686AbhDIHhA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 9 Apr 2021 03:37:00 -0400
Received: from mx2.suse.de ([195.135.220.15]:55230 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229621AbhDIHg7 (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 9 Apr 2021 03:36:59 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 0AC27AF27;
        Fri,  9 Apr 2021 07:36:46 +0000 (UTC)
Date:   Fri, 9 Apr 2021 09:36:45 +0200
From:   Daniel Wagner <dwagner@suse.de>
To:     Roman Bolshakov <r.bolshakov@yadro.com>
Cc:     martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        linux@yadro.com, Daniel Wagner <daniel.wagner@suse.com>,
        Himanshu Madhani <himanshu.madhani@oracle.com>,
        Quinn Tran <qutran@marvell.com>,
        Nilesh Javali <njavali@marvell.com>, stable@vger.kernel.org,
        Aleksandr Volkov <a.y.volkov@yadro.com>,
        Aleksandr Miloserdov <a.miloserdov@yadro.com>
Subject: Re: [PATCH] Revert "scsi: qla2xxx: Limit interrupt vectors to number
 of CPUs"
Message-ID: <20210409073645.67e3r5kcsx2ltx32@beryllium.lan>
References: <20210409061759.42807-1-r.bolshakov@yadro.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210409061759.42807-1-r.bolshakov@yadro.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Apr 09, 2021 at 09:17:59AM +0300, Roman Bolshakov wrote:
>  drivers/scsi/qla2xxx/qla_isr.c | 6 ++----
>  1 file changed, 2 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/scsi/qla2xxx/qla_isr.c b/drivers/scsi/qla2xxx/qla_isr.c
> index 11d6e0db07fe..6641978dfecf 100644
> --- a/drivers/scsi/qla2xxx/qla_isr.c
> +++ b/drivers/scsi/qla2xxx/qla_isr.c
> @@ -3998,12 +3998,10 @@ qla24xx_enable_msix(struct qla_hw_data *ha, struct rsp_que *rsp)
>  	if (USER_CTRL_IRQ(ha) || !ha->mqiobase) {
>  		/* user wants to control IRQ setting for target mode */
>  		ret = pci_alloc_irq_vectors(ha->pdev, min_vecs,
> -		    min((u16)ha->msix_count, (u16)num_online_cpus()),
> -		    PCI_IRQ_MSIX);
> +		    ha->msix_count, PCI_IRQ_MSIX);
>  	} else
>  		ret = pci_alloc_irq_vectors_affinity(ha->pdev, min_vecs,
> -		    min((u16)ha->msix_count, (u16)num_online_cpus()),
> -		    PCI_IRQ_MSIX | PCI_IRQ_AFFINITY,
> +		    ha->msix_count, PCI_IRQ_MSIX | PCI_IRQ_AFFINITY,
>  		    &desc);


Commit message a6dcfe08487e ("scsi: qla2xxx: Limit interrupt vectors to number of
CPUs") says

    Driver created too many QPairs(126) with 28xx adapter.  Limit to the number
    of CPUs to minimize wasted resources.

I think a simple revert is not taking the resource wasting into
account. Maybe the min vector calculation just needs a higher lower
bound. So something stupid like

  min(msix_cound, num_online_cpus() > 2? num_online_cpus() : 3)

?
