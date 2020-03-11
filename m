Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4BBC9181BAE
	for <lists+stable@lfdr.de>; Wed, 11 Mar 2020 15:49:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729861AbgCKOtG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 11 Mar 2020 10:49:06 -0400
Received: from merlin.infradead.org ([205.233.59.134]:43506 "EHLO
        merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729100AbgCKOtG (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 11 Mar 2020 10:49:06 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=merlin.20170209; h=Content-Transfer-Encoding:Mime-Version:
        Content-Type:References:In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Sender
        :Reply-To:Content-ID:Content-Description;
        bh=ciO+jzKFeCBVC6s8fTQmFiAqvKcW+Wt5eThe08/9Bfo=; b=dCiVxa6GyVh2Peo4sOgXJ4i2Vk
        MLKwNvJwvaY8M6i1FuGThikC1FEEkx6KFVEAGkHok+oTAWbFojTZeLB9cxmKHz8o/sHkQ0LuLgSoH
        Crx0A3ObNpdOm0DFEdpJRItn8wggjBtNpFNeTKxsrXmmF9bdDJEd2VwbhRDJ4MZF7z8NPitYaQU8t
        U0vipf/tP9t1oUQKtvJ8Pusiei4fw6o+M0556Yav7uOdoT4FkfAXDAN/zxIDIF7qNW3CRMhwCFc43
        Dqmh2B7J6yL8iXNJ1DFa7/gumBXhXk0sqIi8AB6hMle/4ibiql3kD3Phi+4FYkXZw8CCR6PVPIsTS
        Yq1O/tAw==;
Received: from [54.239.6.186] (helo=u0c626add9cce5a.drs10.amazon.com)
        by merlin.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jC2fN-00017v-Q3; Wed, 11 Mar 2020 14:49:02 +0000
Message-ID: <8bfcee3ee98003da4d6cdb81d9e80f860d85d7d5.camel@kernel.org>
Subject: Re: [PATCH] mpt3sas: Fix kernel panic observed on soft HBA unplug
From:   Amit Shah <amit@kernel.org>
To:     Sreekanth Reddy <sreekanth.reddy@broadcom.com>
Cc:     "Martin K. Petersen" <martin.petersen@oracle.com>,
        linux-scsi <linux-scsi@vger.kernel.org>,
        Sathya Prakash <sathya.prakash@broadcom.com>,
        Suganath Prabu Subramani 
        <suganath-prabu.subramani@broadcom.com>, stable@vger.kernel.org
Date:   Wed, 11 Mar 2020 15:48:59 +0100
In-Reply-To: <CAK=zhgp-oFoMkG_X8e5sm13=14TA5WZAHXYSeuZAV2fmUKbPow@mail.gmail.com>
References: <1583923013-3935-1-git-send-email-sreekanth.reddy@broadcom.com>
         <5d68479b9a852cc8c29b36eaa76c45cbd4fdd39a.camel@kernel.org>
         <CAK=zhgrpov8=MkJVVhyr2O6zcJHaR3B-2h2TcRbyCXBx9i8GCQ@mail.gmail.com>
         <CAK=zhgp-oFoMkG_X8e5sm13=14TA5WZAHXYSeuZAV2fmUKbPow@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.28.5-0ubuntu0.18.04.1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, 2020-03-11 at 17:19 +0530, Sreekanth Reddy wrote:
> On Wed, Mar 11, 2020 at 4:55 PM Sreekanth Reddy
> <sreekanth.reddy@broadcom.com> wrote:
> > 
> > On Wed, Mar 11, 2020 at 4:35 PM Amit Shah <amit@kernel.org> wrote:
> > > 
> > > On Wed, 2020-03-11 at 06:36 -0400, Sreekanth Reddy wrote:
> > > > Generic protection fault type kernel panic is observed when
> > > > user
> > > > performs soft(ordered) HBA unplug operation while IOs are
> > > > running
> > > > on drives connected to HBA.
> > > > 
> > > > When user performs ordered HBA removal operation then kernel
> > > > calls
> > > > PCI device's .remove() call back function where driver is
> > > > flushing
> > > > out
> > > > all the outstanding SCSI IO commands with DID_NO_CONNECT host
> > > > byte
> > > > and
> > > > also un-maps sg buffers allocated for these IO commands.
> > > > But in the ordered HBA removal case (unlike of real HBA hot
> > > > unplug)
> > > > HBA device is still alive and hence HBA hardware is performing
> > > > the
> > > > DMA operations to those buffers on the system memory which are
> > > > already
> > > > unmapped while flushing out the outstanding SCSI IO commands
> > > > and this leads to Kernel panic.
> > > > 
> > > > Fix:
> > > > Don't flush out the outstanding IOs from .remove() path in case
> > > > of
> > > > ordered HBA removal since HBA will be still alive in this case
> > > > and
> > > > it can complete the outstanding IOs. Flush out the outstanding
> > > > IOs
> > > > only in case physical HBA hot unplug where their won't be any
> > > > communication with the HBA.
> > > 
> > > Can you please point to the commit that introduces the bug?
> > 
> > Sure I will add the commit ID which introduced this bug in the next
> > patch.

Thanks.

> > 
> > > 
> > > > 
> > > > Cc: stable@vger.kernel.org
> > > > Signed-off-by: Sreekanth Reddy <sreekanth.reddy@broadcom.com>
> > > > ---
> > > >  drivers/scsi/mpt3sas/mpt3sas_scsih.c | 8 ++++----
> > > >  1 file changed, 4 insertions(+), 4 deletions(-)
> > > > 
> > > > diff --git a/drivers/scsi/mpt3sas/mpt3sas_scsih.c
> > > > b/drivers/scsi/mpt3sas/mpt3sas_scsih.c
> > > > index 778d5e6..04a40af 100644
> > > > --- a/drivers/scsi/mpt3sas/mpt3sas_scsih.c
> > > > +++ b/drivers/scsi/mpt3sas/mpt3sas_scsih.c
> > > > @@ -9908,8 +9908,8 @@ static void scsih_remove(struct pci_dev
> > > > *pdev)
> > > > 
> > > >       ioc->remove_host = 1;
> > > > 
> > > > -     mpt3sas_wait_for_commands_to_complete(ioc);
> > > > -     _scsih_flush_running_cmds(ioc);
> > > > +     if (!pci_device_is_present(pdev))
> > > > +             _scsih_flush_running_cmds(ioc);
> > > > 
> > > >       _scsih_fw_event_cleanup_queue(ioc);
> > > > 
> > > > @@ -9992,8 +9992,8 @@ static void scsih_remove(struct pci_dev
> > > > *pdev)
> > > 
> > > Just a note: this function is scsih_shutdown().  Doesn't block
> > > application of the patch, though.  Just wondering how the patch
> > > was
> > > created.
> 
> I got your query now,  yes this hunk change is in scsih_shutdown()
> function. I am not sure why scsih_remove name is getting displayed
> here in this hunk. I have used 'git format-patch' to generate the
> patch.

Thanks.  Does the commit description need an update as well?  It only
talks about remove callback.

> 
> > 
> > Sorry I didn't get you. Can you please elaborate your query?
> > 
> > > 
> > > > 
> > > >       ioc->remove_host = 1;
> > > > 
> > > > -     mpt3sas_wait_for_commands_to_complete(ioc);
> > > > -     _scsih_flush_running_cmds(ioc);
> > > > +     if (!pci_device_is_present(pdev))
> > > > +             _scsih_flush_running_cmds(ioc);
> > > > 
> > > >       _scsih_fw_event_cleanup_queue(ioc);
> > > > 

