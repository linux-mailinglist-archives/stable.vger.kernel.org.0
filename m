Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E956935C9B0
	for <lists+stable@lfdr.de>; Mon, 12 Apr 2021 17:22:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242822AbhDLPWx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Apr 2021 11:22:53 -0400
Received: from mta-02.yadro.com ([89.207.88.252]:37602 "EHLO mta-01.yadro.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S242823AbhDLPWw (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Apr 2021 11:22:52 -0400
Received: from localhost (unknown [127.0.0.1])
        by mta-01.yadro.com (Postfix) with ESMTP id 5E7C941273;
        Mon, 12 Apr 2021 15:22:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=yadro.com; h=
        in-reply-to:content-disposition:content-type:content-type
        :mime-version:references:message-id:subject:subject:from:from
        :date:date:received:received:received; s=mta-01; t=1618240948;
         x=1620055349; bh=XSH74MCWUelVOrb+Sy4ySeqT/YeAOBnq8N/Bju/S4uU=; b=
        VDowSuJMIZrIg/DVB5EG3qs/2MGNf/JaXNMQFeWChuSADV5+iYg9UdsHQUYwwvxT
        pE98zDuYygSX2ntsYsJwHplSoZxmEgVBtbS3Uqsw2f6ziGbNOlKTsG+XSxxKG2i1
        ppy1cVth6L+HKAVpiCIjkpUptJ7scRgtyFfaD6Sp4Hs=
X-Virus-Scanned: amavisd-new at yadro.com
Received: from mta-01.yadro.com ([127.0.0.1])
        by localhost (mta-01.yadro.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id iHNA4UBkczTY; Mon, 12 Apr 2021 18:22:28 +0300 (MSK)
Received: from T-EXCH-03.corp.yadro.com (t-exch-03.corp.yadro.com [172.17.100.103])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mta-01.yadro.com (Postfix) with ESMTPS id 291784120E;
        Mon, 12 Apr 2021 18:22:27 +0300 (MSK)
Received: from localhost (172.17.204.212) by T-EXCH-03.corp.yadro.com
 (172.17.100.103) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384_P384) id 15.1.669.32; Mon, 12
 Apr 2021 18:22:26 +0300
Date:   Mon, 12 Apr 2021 18:22:26 +0300
From:   Roman Bolshakov <r.bolshakov@yadro.com>
To:     Daniel Wagner <dwagner@suse.de>
CC:     <martin.petersen@oracle.com>, <linux-scsi@vger.kernel.org>,
        <linux@yadro.com>, Daniel Wagner <daniel.wagner@suse.com>,
        Himanshu Madhani <himanshu.madhani@oracle.com>,
        Quinn Tran <qutran@marvell.com>,
        Nilesh Javali <njavali@marvell.com>, <stable@vger.kernel.org>,
        Aleksandr Volkov <a.y.volkov@yadro.com>,
        Aleksandr Miloserdov <a.miloserdov@yadro.com>
Subject: Re: [PATCH] Revert "scsi: qla2xxx: Limit interrupt vectors to number
 of CPUs"
Message-ID: <YHRlsuwSOxEnSWgx@SPB-NB-133.local>
References: <20210409061759.42807-1-r.bolshakov@yadro.com>
 <20210409073645.67e3r5kcsx2ltx32@beryllium.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20210409073645.67e3r5kcsx2ltx32@beryllium.lan>
X-Originating-IP: [172.17.204.212]
X-ClientProxiedBy: T-EXCH-01.corp.yadro.com (172.17.10.101) To
 T-EXCH-03.corp.yadro.com (172.17.100.103)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Apr 09, 2021 at 09:36:45AM +0200, Daniel Wagner wrote:
> On Fri, Apr 09, 2021 at 09:17:59AM +0300, Roman Bolshakov wrote:
> >  drivers/scsi/qla2xxx/qla_isr.c | 6 ++----
> >  1 file changed, 2 insertions(+), 4 deletions(-)
> > 
> > diff --git a/drivers/scsi/qla2xxx/qla_isr.c b/drivers/scsi/qla2xxx/qla_isr.c
> > index 11d6e0db07fe..6641978dfecf 100644
> > --- a/drivers/scsi/qla2xxx/qla_isr.c
> > +++ b/drivers/scsi/qla2xxx/qla_isr.c
> > @@ -3998,12 +3998,10 @@ qla24xx_enable_msix(struct qla_hw_data *ha, struct rsp_que *rsp)
> >  	if (USER_CTRL_IRQ(ha) || !ha->mqiobase) {
> >  		/* user wants to control IRQ setting for target mode */
> >  		ret = pci_alloc_irq_vectors(ha->pdev, min_vecs,
> > -		    min((u16)ha->msix_count, (u16)num_online_cpus()),
> > -		    PCI_IRQ_MSIX);
> > +		    ha->msix_count, PCI_IRQ_MSIX);
> >  	} else
> >  		ret = pci_alloc_irq_vectors_affinity(ha->pdev, min_vecs,
> > -		    min((u16)ha->msix_count, (u16)num_online_cpus()),
> > -		    PCI_IRQ_MSIX | PCI_IRQ_AFFINITY,
> > +		    ha->msix_count, PCI_IRQ_MSIX | PCI_IRQ_AFFINITY,
> >  		    &desc);
> 
> 
> Commit message a6dcfe08487e ("scsi: qla2xxx: Limit interrupt vectors to number of
> CPUs") says
> 
>     Driver created too many QPairs(126) with 28xx adapter.  Limit to the number
>     of CPUs to minimize wasted resources.
> 
> I think a simple revert is not taking the resource wasting into
> account. Maybe the min vector calculation just needs a higher lower
> bound. So something stupid like
> 
>   min(msix_cound, num_online_cpus() > 2? num_online_cpus() : 3)
> 
> ?

Hi Daniel,

That would reduce number of Queue Pairs on small-core systems, e.g. 14
HW queues are going to be available on 16-CPU system, even if the HBA
has enough MSI-X vectors for 16 HW queues.

But... min((u16)ha->msix_count, (u16)num_online_cpus() + 3) might
actually do the trick... I'll try that.

Thanks,
Roman
