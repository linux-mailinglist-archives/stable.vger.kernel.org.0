Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4A4E31864F3
	for <lists+stable@lfdr.de>; Mon, 16 Mar 2020 07:15:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729489AbgCPGP0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Mar 2020 02:15:26 -0400
Received: from mail-ot1-f68.google.com ([209.85.210.68]:40074 "EHLO
        mail-ot1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729381AbgCPGP0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 Mar 2020 02:15:26 -0400
Received: by mail-ot1-f68.google.com with SMTP id h17so16643726otn.7
        for <stable@vger.kernel.org>; Sun, 15 Mar 2020 23:15:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=YXhnrDszyFH56EmyR4eCmN00/9g9ltcCsSqXK8jNA5w=;
        b=WLVQfAfH6GU+1QiSRbjTOR0lf8JcZ84ivmJ+0ExwQqVuv3gNnB1s1wUl4C9fJbTPVR
         O8vJbUnCHgepdmGcXn180dfMeYJHYT7O/Brbdql9uwGDSDmh+yTRSpWK5bpevRELGm69
         qaV4bJs6gS7xJsWzguTTEp90LUXK++ooJ3mXI=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=YXhnrDszyFH56EmyR4eCmN00/9g9ltcCsSqXK8jNA5w=;
        b=plqq4Xx3HtLvTnGj5nE4LQrt8aqD9mwN5a4HrJkWiFIHzG7J8EIDRHDDAANSaLLghW
         LB7zUPtci6plXo0OZ17myx+0N9l9i/UUOwdvf6KDTzynoe8NxunPw9H9cRf49iuvdEcV
         9CpwgP3xJ+J1e+XYSVDg7cvZcpj7x7Ld4MwWP0XkxYBi7sNC3PCSuR/24nlg5/synTiY
         L5k9AxAnokog01qDqVE+dXy8uqczUq/Od+LNoDqljUFlXti1S29IsUXlwUw/ysERkbhB
         h/1G5yz7eWnFOrzwgsM0FuKgUUmLnwyco71mvRD/U04rIefT1UezRhkr/FuJQX4hIn1C
         IuVg==
X-Gm-Message-State: ANhLgQ3kimfnJPPvMKL5qrnBLTU1giowksfr/fFGTm/8VsY12cjQKVTF
        EEV1UgWV/8PWIu/Q5iRc4CU+wwRhCPvULeqh5WANSQ==
X-Google-Smtp-Source: ADFU+vtaYHbXXdExSGONHsJsOy7R5W0XOFKWMW56TrzpZLfXmNXgANNaexVHHbKbwTiwXcUkd5rdZAgrGMfXk+S2tMI=
X-Received: by 2002:a9d:518e:: with SMTP id y14mr871884otg.27.1584339325445;
 Sun, 15 Mar 2020 23:15:25 -0700 (PDT)
MIME-Version: 1.0
References: <1583923013-3935-1-git-send-email-sreekanth.reddy@broadcom.com> <DF4PR8401MB12415ADC9760286F3930DBE4ABFB0@DF4PR8401MB1241.NAMPRD84.PROD.OUTLOOK.COM>
In-Reply-To: <DF4PR8401MB12415ADC9760286F3930DBE4ABFB0@DF4PR8401MB1241.NAMPRD84.PROD.OUTLOOK.COM>
From:   Sreekanth Reddy <sreekanth.reddy@broadcom.com>
Date:   Mon, 16 Mar 2020 11:45:15 +0530
Message-ID: <CAK=zhgqWJs+Wbmgy9xp6WDRp2w5e+5BGD+R5mck-dVh5oOUQ0g@mail.gmail.com>
Subject: Re: [PATCH] mpt3sas: Fix kernel panic observed on soft HBA unplug
To:     "Elliott, Robert (Servers)" <elliott@hpe.com>
Cc:     "martin.petersen@oracle.com" <martin.petersen@oracle.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "sathya.prakash@broadcom.com" <sathya.prakash@broadcom.com>,
        "suganath-prabu.subramani@broadcom.com" 
        <suganath-prabu.subramani@broadcom.com>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "amit@kernel.org" <amit@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sat, Mar 14, 2020 at 7:56 AM Elliott, Robert (Servers)
<elliott@hpe.com> wrote:
>
>
>
> > -----Original Message-----
> > From: linux-scsi-owner@vger.kernel.org <linux-scsi-
> > owner@vger.kernel.org> On Behalf Of Sreekanth Reddy
> > Sent: Wednesday, March 11, 2020 5:37 AM
> > To: martin.petersen@oracle.com
> > Cc: linux-scsi@vger.kernel.org; sathya.prakash@broadcom.com; suganath-
> > prabu.subramani@broadcom.com; stable@vger.kernel.org; amit@kernel.org;
> > Sreekanth Reddy <sreekanth.reddy@broadcom.com>
> > Subject: [PATCH] mpt3sas: Fix kernel panic observed on soft HBA unplug
> >
> > Generic protection fault type kernel panic is observed when user
> > performs soft(ordered) HBA unplug operation while IOs are running
> > on drives connected to HBA.
> >
> > When user performs ordered HBA removal operation then kernel calls
> > PCI device's .remove() call back function where driver is flushing out
> > all the outstanding SCSI IO commands with DID_NO_CONNECT host byte and
> > also un-maps sg buffers allocated for these IO commands.
> > But in the ordered HBA removal case (unlike of real HBA hot unplug)
> > HBA device is still alive and hence HBA hardware is performing the
> > DMA operations to those buffers on the system memory which are already
> > unmapped while flushing out the outstanding SCSI IO commands
> > and this leads to Kernel panic.
> >
> > Fix:
> > Don't flush out the outstanding IOs from .remove() path in case of
> > ordered HBA removal since HBA will be still alive in this case and
> > it can complete the outstanding IOs. Flush out the outstanding IOs
> > only in case physical HBA hot unplug where their won't be any
> > communication with the HBA.
> >
> > Cc: stable@vger.kernel.org
> > Signed-off-by: Sreekanth Reddy <sreekanth.reddy@broadcom.com>
> > ---
> >  drivers/scsi/mpt3sas/mpt3sas_scsih.c | 8 ++++----
> >  1 file changed, 4 insertions(+), 4 deletions(-)
> >
> > diff --git a/drivers/scsi/mpt3sas/mpt3sas_scsih.c
> > b/drivers/scsi/mpt3sas/mpt3sas_scsih.c
> > index 778d5e6..04a40af 100644
> > --- a/drivers/scsi/mpt3sas/mpt3sas_scsih.c
> > +++ b/drivers/scsi/mpt3sas/mpt3sas_scsih.c
> > @@ -9908,8 +9908,8 @@ static void scsih_remove(struct pci_dev *pdev)
> >
> >       ioc->remove_host = 1;
> >
> > -     mpt3sas_wait_for_commands_to_complete(ioc);
>
> Immediately removing the driver with IOs pending seems dangerous.
>
> That function includes a timeout to avoid hanging forever, which
> is reasonable (avoid hanging during system shutdown). Perhaps the
> kernel panic was happening because that function timed out?
>
> Reporting a warning or error and doing special handling might be
> appropriate if that occurs. That should be rare, though; the normal
> case should be to cleanly finish any outstanding commands.
>
> > -     _scsih_flush_running_cmds(ioc);
> > +     if (!pci_device_is_present(pdev))
> > +             _scsih_flush_running_cmds(ioc);
>
> If that branch is not taken, then it proceeds to remove the driver
> with IOs pending. That'll wipe out all sorts of ioc structures
> and things like interrupt handler code, leaving memory mapped forever
> (no code left to call scsi_dma_unmap). That might be better than
> a kernel panic, but still not good.

In the unload path driver call sas_remove_host() API before releasing
the resources. This sas_remove_host() API waits for all the
outstanding IOs to be completed. So here, indirectly driver is waiting
for the outstanding IOs to be processed before releasing the HBA
resources.  So only in the cases where HBA is inaccessible (e.g. HBA
unplug case), driver is flushing out the outstanding commands to avoid
SCSI error handling over head and can quilkey complete the driver
unload operation.

>
>
