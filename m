Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CBA4437A23
	for <lists+stable@lfdr.de>; Thu,  6 Jun 2019 18:53:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728523AbfFFQxt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 6 Jun 2019 12:53:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:37562 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727445AbfFFQxt (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 6 Jun 2019 12:53:49 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E9ECA20693;
        Thu,  6 Jun 2019 16:53:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1559840028;
        bh=D4UJP80FAdK9LRFAqEia+BMLNszARCWS/F17g9KPeEA=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=ab//aI0UBRKWWFG1qVkLjglYjKyNYj9h76GAgyyb9BUQ/+jS1T3mbziDlTHoIgK80
         U/jIVlc9LXg53QiqnOPHH4RawJj1cXrlKBuifjOnuf2JYZj+tzR1960U+QkJg3NwZA
         QRxTgrZCw/fCie41FCmSmyJm8hY8ddQFcwDOKbkE=
Date:   Thu, 6 Jun 2019 18:53:46 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Nathan Chancellor <natechancellor@gmail.com>
Cc:     Pavel Machek <pavel@denx.de>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        James Smart <james.smart@broadcom.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 4.19 237/276] scsi: lpfc: avoid uninitialized variable
 warning
Message-ID: <20190606165346.GB3249@kroah.com>
References: <20190530030523.133519668@linuxfoundation.org>
 <20190530030539.944220603@linuxfoundation.org>
 <20190606125323.GC27432@amd>
 <20190606160042.GA54183@archlinux-epyc>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190606160042.GA54183@archlinux-epyc>
User-Agent: Mutt/1.12.0 (2019-05-25)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Jun 06, 2019 at 09:00:42AM -0700, Nathan Chancellor wrote:
> On Thu, Jun 06, 2019 at 02:53:23PM +0200, Pavel Machek wrote:
> > Hi!
> > 
> > > [ Upstream commit faf5a744f4f8d76e7c03912b5cd381ac8045f6ec ]
> > > 
> > > clang -Wuninitialized incorrectly sees a variable being used without
> > > initialization:
> > > 
> > > drivers/scsi/lpfc/lpfc_nvme.c:2102:37: error: variable 'localport' is uninitialized when used here
> > >       [-Werror,-Wuninitialized]
> > >                 lport = (struct lpfc_nvme_lport *)localport->private;
> > >                                                   ^~~~~~~~~
> > > drivers/scsi/lpfc/lpfc_nvme.c:2059:38: note: initialize the variable 'localport' to silence this warning
> > >         struct nvme_fc_local_port *localport;
> > >                                             ^
> > >                                              = NULL
> > > 1 error generated.
> > > 
> > > This is clearly in dead code, as the condition leading up to it is always
> > > false when CONFIG_NVME_FC is disabled, and the variable is always
> > > initialized when nvme_fc_register_localport() got called successfully.
> > > 
> > > Change the preprocessor conditional to the equivalent C construct, which
> > > makes the code more readable and gets rid of the warning.
> > 
> > Unfortunately, this missed "else" branch where the code was freeing
> > the memory with kfree(cstat)... so this introduces a memory leak.
> > 
> > Best regards,
> > 									Pavel
> 
> For the record, this is not a problem with the upstream commit (not
> saying you thought that or not, I just want to be clear).
> 
> Looks like commit 4c47efc140fa ("scsi: lpfc: Move SCSI and NVME Stats to
> hardware queue structures") "resolved" this by not making it an issue in
> the first place. I think the simpler fix is this.
> 
> Thanks for pointing it out!
> 
> diff --git a/drivers/scsi/lpfc/lpfc_nvme.c b/drivers/scsi/lpfc/lpfc_nvme.c
> index 099f70798fdd..645ffb5332b4 100644
> --- a/drivers/scsi/lpfc/lpfc_nvme.c
> +++ b/drivers/scsi/lpfc/lpfc_nvme.c
> @@ -2477,14 +2477,14 @@ lpfc_nvme_create_localport(struct lpfc_vport *vport)
>         lpfc_nvme_template.max_sgl_segments = phba->cfg_nvme_seg_cnt + 1;
>         lpfc_nvme_template.max_hw_queues = phba->cfg_nvme_io_channel;
>  
> +       if (!IS_ENABLED(CONFIG_NVME_FC))
> +               return ret;
> +
>         cstat = kmalloc((sizeof(struct lpfc_nvme_ctrl_stat) *
>                         phba->cfg_nvme_io_channel), GFP_KERNEL);
>         if (!cstat)
>                 return -ENOMEM;
>  
> -       if (!IS_ENABLED(CONFIG_NVME_FC))
> -               return ret;
> -
>         /* localport is allocated from the stack, but the registration
>          * call allocates heap memory as well as the private area.
>          */
> 

Can you send this as a real patch that I can queue up?

thanks,

greg k-h
