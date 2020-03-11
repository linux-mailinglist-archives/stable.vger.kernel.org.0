Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 788281816CB
	for <lists+stable@lfdr.de>; Wed, 11 Mar 2020 12:26:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726387AbgCKL0K (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 11 Mar 2020 07:26:10 -0400
Received: from mail-oi1-f196.google.com ([209.85.167.196]:44006 "EHLO
        mail-oi1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725834AbgCKL0K (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 11 Mar 2020 07:26:10 -0400
Received: by mail-oi1-f196.google.com with SMTP id p125so1478534oif.10
        for <stable@vger.kernel.org>; Wed, 11 Mar 2020 04:26:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=FxkJtNIXCSiI2XNWfZip0t37PKxo+QgDChOHA/S1Th4=;
        b=IJVA0QpVl4ICq9SVsC6H658vhVbX8VVlJWuOl/ra3jdBqt5Erril023m1NyRQ9CS4K
         ORx/ySPf5OsvxI/UqYKqcEybKmltuIHMiPzrSusOMuMFhMQtfclUg67FAfqPdF/Vk/VM
         xLVFZMnbdvsoTWWW6YzTkz+1tPiG9DHXLB1zo=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=FxkJtNIXCSiI2XNWfZip0t37PKxo+QgDChOHA/S1Th4=;
        b=biEkYW3uhPYtbHfzb0vS2UQVTnTco9QYbVd0Ylb2iJLK+fEO3YuzT3b1yLPE0/JRSW
         Xu5zQhIdfa7o+rFdW+gUIoNaTTViVg8CrkxX/0gpVAFFCa9iTVFUQwbeaFcnTCkJR2Zz
         ww+hnBrVpwRrdtWyVxQR639G3iz/E8GAzoZanGd4Wtrnvr2z1+VHix861J8lq9ECNkVQ
         dmo1C+Q6mjaXVb/FSpP45qKv00QsTwgJzovsCtu9t2YKvO/+fZULcn/nwDeWYHPp5iUS
         bGhDxEa15WD5rWzx+S278/ec/WZKQ5TgZ9j2o1Fjyv3vHtf1bsRjNtMznhKW1ikyq9IB
         fT2Q==
X-Gm-Message-State: ANhLgQ0PQuh/Kj8HRbLAQT4QQ+EChOUJxMFxyIiaTO1thWrFSEDuVAxw
        dyUA5WQvC5p1b1G55MTls7KPVu6jTuaXS2UwKPR3cA==
X-Google-Smtp-Source: ADFU+vtNzWvaA+Q5lzg9R0u5J09epei7cWBuS1Vdz9xPbwdYGQS0/u4fCzXxx5ODeOrXlJFwpcm7g6cJA3o0wcPPPc0=
X-Received: by 2002:aca:80e:: with SMTP id 14mr1492361oii.143.1583925968963;
 Wed, 11 Mar 2020 04:26:08 -0700 (PDT)
MIME-Version: 1.0
References: <1583923013-3935-1-git-send-email-sreekanth.reddy@broadcom.com> <5d68479b9a852cc8c29b36eaa76c45cbd4fdd39a.camel@kernel.org>
In-Reply-To: <5d68479b9a852cc8c29b36eaa76c45cbd4fdd39a.camel@kernel.org>
From:   Sreekanth Reddy <sreekanth.reddy@broadcom.com>
Date:   Wed, 11 Mar 2020 16:55:57 +0530
Message-ID: <CAK=zhgrpov8=MkJVVhyr2O6zcJHaR3B-2h2TcRbyCXBx9i8GCQ@mail.gmail.com>
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

On Wed, Mar 11, 2020 at 4:35 PM Amit Shah <amit@kernel.org> wrote:
>
> On Wed, 2020-03-11 at 06:36 -0400, Sreekanth Reddy wrote:
> > Generic protection fault type kernel panic is observed when user
> > performs soft(ordered) HBA unplug operation while IOs are running
> > on drives connected to HBA.
> >
> > When user performs ordered HBA removal operation then kernel calls
> > PCI device's .remove() call back function where driver is flushing
> > out
> > all the outstanding SCSI IO commands with DID_NO_CONNECT host byte
> > and
> > also un-maps sg buffers allocated for these IO commands.
> > But in the ordered HBA removal case (unlike of real HBA hot unplug)
> > HBA device is still alive and hence HBA hardware is performing the
> > DMA operations to those buffers on the system memory which are
> > already
> > unmapped while flushing out the outstanding SCSI IO commands
> > and this leads to Kernel panic.
> >
> > Fix:
> > Don't flush out the outstanding IOs from .remove() path in case of
> > ordered HBA removal since HBA will be still alive in this case and
> > it can complete the outstanding IOs. Flush out the outstanding IOs
> > only in case physical HBA hot unplug where their won't be any
> > communication with the HBA.
>
> Can you please point to the commit that introduces the bug?

Sure I will add the commit ID which introduced this bug in the next patch.

>
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
> > -     _scsih_flush_running_cmds(ioc);
> > +     if (!pci_device_is_present(pdev))
> > +             _scsih_flush_running_cmds(ioc);
> >
> >       _scsih_fw_event_cleanup_queue(ioc);
> >
> > @@ -9992,8 +9992,8 @@ static void scsih_remove(struct pci_dev *pdev)
>
> Just a note: this function is scsih_shutdown().  Doesn't block
> application of the patch, though.  Just wondering how the patch was
> created.

Sorry I didn't get you. Can you please elaborate your query?

>
> >
> >       ioc->remove_host = 1;
> >
> > -     mpt3sas_wait_for_commands_to_complete(ioc);
> > -     _scsih_flush_running_cmds(ioc);
> > +     if (!pci_device_is_present(pdev))
> > +             _scsih_flush_running_cmds(ioc);
> >
> >       _scsih_fw_event_cleanup_queue(ioc);
> >
>
