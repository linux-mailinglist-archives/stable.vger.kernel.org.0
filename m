Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 73CB9181711
	for <lists+stable@lfdr.de>; Wed, 11 Mar 2020 12:50:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729165AbgCKLuD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 11 Mar 2020 07:50:03 -0400
Received: from mail-ot1-f65.google.com ([209.85.210.65]:37167 "EHLO
        mail-ot1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729016AbgCKLuD (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 11 Mar 2020 07:50:03 -0400
Received: by mail-ot1-f65.google.com with SMTP id b3so1604017otp.4
        for <stable@vger.kernel.org>; Wed, 11 Mar 2020 04:50:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Xy7DjMTeIRHoMxJnXMiMNMf4Q69p1Oxv7TIvAtxfT9c=;
        b=YQh5UMbw47J5h9vQqSC3JBKsWPZuXJXRmK/pRh1J6TbaR1v/u7wCbaOwP98A9Vqb/C
         BvNhZKL8SEunuynTYeXJPATieyTaDEEfxM0MynoM8MJvIYY12alDBPaNnO5c/zNwcv8z
         xFx0pcV0HWHa3ytx70YfrftAkITVWUKqcFBr4=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Xy7DjMTeIRHoMxJnXMiMNMf4Q69p1Oxv7TIvAtxfT9c=;
        b=um57AM8LxW/ulUrhVzYO30dL03n6PlWU21hNjdDFhJISoDloAtouOqD38rRBBf4vWv
         EjjISBPIUHbmz5jUrPk12SRJjKPzMuv8HNI+AF8oOFWFlQd5VacoXATXMnjs9dnk4MCR
         kc2dTDcx2eIvfeNdpMDFOw7xzjwxeflH9Oecme6HvGZ9MkX5w5Gasnr43fHn0NXHnd84
         NN4gCzOtCaw+QDL3Nmem7Yw1WDjzUS4PqR79EDrCgk63eNRnzNKtqa596ZtlXST333XZ
         oeSHklWPd5B8sA8AtecNTLm5YLAsV7vDqPkw72ZaHgzN2FilOx7nxjDgH/UEQlG7B9aK
         ifsg==
X-Gm-Message-State: ANhLgQ0Ld5Wxin0iNHFlsF2ySFlC1H0Q5yLOsRCFNYeeSO14+1ZR26/L
        sBX4f5Xsauwt1IZLGSSCOKAslSJKvUxCnSc3Uw8kbQ==
X-Google-Smtp-Source: ADFU+vsZ5brv97OyXUL7zxrDRiFZQpFhd3Ccroy9Ob0D0PnJQzHP6SONUsVWuzSd2CJPEiT5d3eM3Izh1O9cZo3MMBM=
X-Received: by 2002:a9d:64b:: with SMTP id 69mr1899193otn.237.1583927402216;
 Wed, 11 Mar 2020 04:50:02 -0700 (PDT)
MIME-Version: 1.0
References: <1583923013-3935-1-git-send-email-sreekanth.reddy@broadcom.com>
 <5d68479b9a852cc8c29b36eaa76c45cbd4fdd39a.camel@kernel.org> <CAK=zhgrpov8=MkJVVhyr2O6zcJHaR3B-2h2TcRbyCXBx9i8GCQ@mail.gmail.com>
In-Reply-To: <CAK=zhgrpov8=MkJVVhyr2O6zcJHaR3B-2h2TcRbyCXBx9i8GCQ@mail.gmail.com>
From:   Sreekanth Reddy <sreekanth.reddy@broadcom.com>
Date:   Wed, 11 Mar 2020 17:19:50 +0530
Message-ID: <CAK=zhgp-oFoMkG_X8e5sm13=14TA5WZAHXYSeuZAV2fmUKbPow@mail.gmail.com>
Subject: Re: [PATCH] mpt3sas: Fix kernel panic observed on soft HBA unplug
To:     Amit Shah <amit@kernel.org>
Cc:     "Martin K. Petersen" <martin.petersen@oracle.com>,
        linux-scsi <linux-scsi@vger.kernel.org>,
        Sathya Prakash <sathya.prakash@broadcom.com>,
        Suganath Prabu Subramani 
        <suganath-prabu.subramani@broadcom.com>, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Mar 11, 2020 at 4:55 PM Sreekanth Reddy
<sreekanth.reddy@broadcom.com> wrote:
>
> On Wed, Mar 11, 2020 at 4:35 PM Amit Shah <amit@kernel.org> wrote:
> >
> > On Wed, 2020-03-11 at 06:36 -0400, Sreekanth Reddy wrote:
> > > Generic protection fault type kernel panic is observed when user
> > > performs soft(ordered) HBA unplug operation while IOs are running
> > > on drives connected to HBA.
> > >
> > > When user performs ordered HBA removal operation then kernel calls
> > > PCI device's .remove() call back function where driver is flushing
> > > out
> > > all the outstanding SCSI IO commands with DID_NO_CONNECT host byte
> > > and
> > > also un-maps sg buffers allocated for these IO commands.
> > > But in the ordered HBA removal case (unlike of real HBA hot unplug)
> > > HBA device is still alive and hence HBA hardware is performing the
> > > DMA operations to those buffers on the system memory which are
> > > already
> > > unmapped while flushing out the outstanding SCSI IO commands
> > > and this leads to Kernel panic.
> > >
> > > Fix:
> > > Don't flush out the outstanding IOs from .remove() path in case of
> > > ordered HBA removal since HBA will be still alive in this case and
> > > it can complete the outstanding IOs. Flush out the outstanding IOs
> > > only in case physical HBA hot unplug where their won't be any
> > > communication with the HBA.
> >
> > Can you please point to the commit that introduces the bug?
>
> Sure I will add the commit ID which introduced this bug in the next patch.
>
> >
> > >
> > > Cc: stable@vger.kernel.org
> > > Signed-off-by: Sreekanth Reddy <sreekanth.reddy@broadcom.com>
> > > ---
> > >  drivers/scsi/mpt3sas/mpt3sas_scsih.c | 8 ++++----
> > >  1 file changed, 4 insertions(+), 4 deletions(-)
> > >
> > > diff --git a/drivers/scsi/mpt3sas/mpt3sas_scsih.c
> > > b/drivers/scsi/mpt3sas/mpt3sas_scsih.c
> > > index 778d5e6..04a40af 100644
> > > --- a/drivers/scsi/mpt3sas/mpt3sas_scsih.c
> > > +++ b/drivers/scsi/mpt3sas/mpt3sas_scsih.c
> > > @@ -9908,8 +9908,8 @@ static void scsih_remove(struct pci_dev *pdev)
> > >
> > >       ioc->remove_host = 1;
> > >
> > > -     mpt3sas_wait_for_commands_to_complete(ioc);
> > > -     _scsih_flush_running_cmds(ioc);
> > > +     if (!pci_device_is_present(pdev))
> > > +             _scsih_flush_running_cmds(ioc);
> > >
> > >       _scsih_fw_event_cleanup_queue(ioc);
> > >
> > > @@ -9992,8 +9992,8 @@ static void scsih_remove(struct pci_dev *pdev)
> >
> > Just a note: this function is scsih_shutdown().  Doesn't block
> > application of the patch, though.  Just wondering how the patch was
> > created.

I got your query now,  yes this hunk change is in scsih_shutdown()
function. I am not sure why scsih_remove name is getting displayed
here in this hunk. I have used 'git format-patch' to generate the
patch.

>
> Sorry I didn't get you. Can you please elaborate your query?
>
> >
> > >
> > >       ioc->remove_host = 1;
> > >
> > > -     mpt3sas_wait_for_commands_to_complete(ioc);
> > > -     _scsih_flush_running_cmds(ioc);
> > > +     if (!pci_device_is_present(pdev))
> > > +             _scsih_flush_running_cmds(ioc);
> > >
> > >       _scsih_fw_event_cleanup_queue(ioc);
> > >
> >
