Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D25EF17F6A6
	for <lists+stable@lfdr.de>; Tue, 10 Mar 2020 12:48:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726205AbgCJLsE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Mar 2020 07:48:04 -0400
Received: from mail-io1-f68.google.com ([209.85.166.68]:40225 "EHLO
        mail-io1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726415AbgCJLsE (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 10 Mar 2020 07:48:04 -0400
Received: by mail-io1-f68.google.com with SMTP id d8so12402652ion.7
        for <stable@vger.kernel.org>; Tue, 10 Mar 2020 04:48:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloud.ionos.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=J7ffoxfFles6TznvMj+xvDz53VySQgjHfVSwzpMcGtQ=;
        b=NSTgr8HBRhkTfPg0yD67buVn3TbKl0ZX9y8/L+kw12nW0JI1Idk3sK4vMKtJPXY8J+
         tbNEAUntlhfRrhzvEJ8bvkT7jOovPDVKb56HlBl1NlTQeGbXyTS5kvRsPMEPXO6TCItm
         QmMZil+yBe5OYqlH/T8fbAycXoBXEhnKzBqNzUqUWf/Yn9O7sNOfxIGrXAuN2+vvhWV0
         dOqGREm/cLyoBoz86uXcw/fdC4CZ5f4FR4lgPK2K4nzLpLB8lmOGmdxq+epTAZKB7lA8
         51HshXRqMr+JQbMUQfm70jJ1LfeRk4G+kzRiioZGw05OF7JsDrubzcVs2w/mB5u/zCoj
         0WZw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=J7ffoxfFles6TznvMj+xvDz53VySQgjHfVSwzpMcGtQ=;
        b=OLVBUYWhnnO+ieO5Z/w/oXk+gM51ePoblxtyBfznE1V7prhxnH/Lp2ynBqG7XuWe/W
         VBnhI4ckj3CpTr+NqnLEZUjTi2VeuJzz4oeALKhYa4CWYzJCiIeOWWvTL8/8b4j6rusL
         L9yQzzzZJUokYE1XVlyYEQrQq9nDfOmIaE/B+NVlQDbnwuE+aN4JlwFclI07/6oL6StU
         jbjpAYXwviqyuuzIMUWqcT592roCUsgkFV50Jck8/oVTrnmycOl3sEG5g4GNrx0X0BRi
         6dwUhagENiHTtAapqshTkqsdYOkKYrgnarOCrBNLjXm0qwLoSCafogawbSnVW3Rnreek
         +Atw==
X-Gm-Message-State: ANhLgQ3ySk2Ow2hzX5bYUYVMw0BjoEjfIgcjBpw4y7w0yskG2EdU8d+V
        PZ7xYkHy/DAwakr4sE0WcWrWQuLb9V6t5ai8QqPkwA==
X-Google-Smtp-Source: ADFU+vvcdT5CMbxc957yW9N8d5noTqkNsicn0yo394P/0GtH6xjWIXXQ+HqLIq/9Sc7Gg2vOMvp/VeoA+N8/opN8b08=
X-Received: by 2002:a6b:7407:: with SMTP id s7mr12218530iog.11.1583840884017;
 Tue, 10 Mar 2020 04:48:04 -0700 (PDT)
MIME-Version: 1.0
References: <20200309101739.32483-1-jinpu.wang@cloud.ionos.com>
 <20200309101739.32483-2-jinpu.wang@cloud.ionos.com> <20200310114150.GE3106483@kroah.com>
In-Reply-To: <20200310114150.GE3106483@kroah.com>
From:   Jinpu Wang <jinpu.wang@cloud.ionos.com>
Date:   Tue, 10 Mar 2020 12:47:53 +0100
Message-ID: <CAMGffEkH3QR0S3N0kr0jL84iiqB0Wr8R4O3R+pL7dKPFwqBzOw@mail.gmail.com>
Subject: Re: [stable-4.19 1/2] scsi: pm80xx: panic on ncq error cleaning up
 the read log.
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     sashal@kernel.org, stable <stable@vger.kernel.org>,
        Viswas G <Viswas.G@microsemi.com>,
        Deepak Ukey <deepak.ukey@microsemi.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Mar 10, 2020 at 12:41 PM Greg KH <gregkh@linuxfoundation.org> wrote:
>
> On Mon, Mar 09, 2020 at 11:17:38AM +0100, Jack Wang wrote:
> > From: Viswas G <Viswas.G@microsemi.com>
> >
> > commit 0b6df110b3d0c12562011fcd032cfb6ff16b6d56 upstream
> >
> > when there's an error in 'ncq mode' the host has to read the ncq error
> > log (10h) to clear the error state. however, the ccb that is setup for
> > doing this doesn't setup the ccb so that the previous state is
> > cleared. if the ccb was previously used for an IO n_elems is set and
> > pm8001_ccb_task_free() treats this as the signal to go free a
> > scatter-gather list (that's already been freed).
> >
> > Signed-off-by: Deepak Ukey <deepak.ukey@microsemi.com>
> > Signed-off-by: Viswas G <Viswas.G@microsemi.com>
> > Acked-by: Jack Wang <jinpu.wang@profitbricks.com>
> > Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
> > ---
> >  drivers/scsi/pm8001/pm80xx_hwi.c | 5 +++--
> >  1 file changed, 3 insertions(+), 2 deletions(-)
> >
> > diff --git a/drivers/scsi/pm8001/pm80xx_hwi.c b/drivers/scsi/pm8001/pm80xx_hwi.c
> > index 8627feb80261..bd945d832eb8 100644
> > --- a/drivers/scsi/pm8001/pm80xx_hwi.c
> > +++ b/drivers/scsi/pm8001/pm80xx_hwi.c
> > @@ -1500,8 +1500,9 @@ static void pm80xx_send_read_log(struct pm8001_hba_info *pm8001_ha,
> >       ccb->ccb_tag = ccb_tag;
> >       ccb->task = task;
> >       ccb->n_elem = 0;
> > -     pm8001_ha_dev->id |= NCQ_READ_LOG_FLAG;
> > -     pm8001_ha_dev->id |= NCQ_2ND_RLE_FLAG;
> > +     pm8001_ha_dev->id |= NCQ_READ_LOG_FLAG; // set this flag to indicate read log
> > +     pm8001_ha_dev->id |= NCQ_2ND_RLE_FLAG;  // set this flag to guard against 2nd RLE. Workaround
> > +                                             // till FW fix is available.
>
> Also, this isn't even the commit id referenced above :(
>
> And there is trailing whitespace :(
Sorry, I must mess it up, please ignore it.
