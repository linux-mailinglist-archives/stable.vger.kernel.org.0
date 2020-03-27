Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A4738195560
	for <lists+stable@lfdr.de>; Fri, 27 Mar 2020 11:36:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726215AbgC0KgG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 27 Mar 2020 06:36:06 -0400
Received: from mail-ot1-f68.google.com ([209.85.210.68]:41854 "EHLO
        mail-ot1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726165AbgC0KgG (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 27 Mar 2020 06:36:06 -0400
Received: by mail-ot1-f68.google.com with SMTP id f52so9178867otf.8
        for <stable@vger.kernel.org>; Fri, 27 Mar 2020 03:36:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=NoJNkqMuLLCwMgTCsahSJfCT5FPrUvQ7S5KH1RUQFzc=;
        b=A4rMZT23UajmeTlGKkeyk1OjAT6dSB3dl8IkmENirGI5y09hppTbbQla4iaFFf4/9P
         6E+BY2SdBrUyfXsfIFybTpimbR5xSmSwjqNQ99LBh2x+qL0xtX9TQPkaxJ23yhLs9ePh
         b9qXMUP3winXIzRmqfADydVCa1kbvk26eyMJE=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=NoJNkqMuLLCwMgTCsahSJfCT5FPrUvQ7S5KH1RUQFzc=;
        b=jlpNExblAO0kPoMgpxK8nW+y6syBvwJs0tKpbZ31U8Or+ahPoncEivboyVq/MGSMum
         FGGXw4cH8ZNBNsO+1eLxy2oRz/4FbUZYnJ+bAAZ9Z5wiuBkaUGQYA+I8eGZpxobZ17D0
         O39Iyq6iPlD/KwlBQtdXK3n3jpZW9PN57bZEfZhD5rrY+U2Mv5i4W28B6Z9Z0Nb5Etl+
         EtKojyjmzVFv7N4zPI7gKktpSy8hHFOyd5QqBUpC3ER/LaaqIo505uALG+C5PV+aSQxE
         eTNyN6uTuKTieUEoHj12Y0hDlTUVPFOtJjzOf0evowzX7h5L4NRQV3M0y4DVIDoMjDTC
         AREw==
X-Gm-Message-State: ANhLgQ3HsEmEQVhGHT5ooNkBp/D8JymO67C+jONRgnniR37VWysWrIgj
        vnWPKsux6IpWczNcare8chbUv/CV7klDPInYpD7vMw==
X-Google-Smtp-Source: ADFU+vuq2CFuwBV9iHb7DRW9+OLH1AV6U7OHpE8qyoaO7D4AiaAJl0QmjPL8cAOCQHtmtXtwAlj5TCY/9U3oCs3YsLo=
X-Received: by 2002:a9d:1920:: with SMTP id j32mr9323866ota.221.1585305365378;
 Fri, 27 Mar 2020 03:36:05 -0700 (PDT)
MIME-Version: 1.0
References: <1583923013-3935-1-git-send-email-sreekanth.reddy@broadcom.com>
 <DF4PR8401MB12415ADC9760286F3930DBE4ABFB0@DF4PR8401MB1241.NAMPRD84.PROD.OUTLOOK.COM>
 <CAK=zhgqWJs+Wbmgy9xp6WDRp2w5e+5BGD+R5mck-dVh5oOUQ0g@mail.gmail.com> <yq1bloiftvs.fsf@oracle.com>
In-Reply-To: <yq1bloiftvs.fsf@oracle.com>
From:   Sreekanth Reddy <sreekanth.reddy@broadcom.com>
Date:   Fri, 27 Mar 2020 16:05:54 +0530
Message-ID: <CAK=zhgoPd85MOpHzfgaRAk8j_mFdVqZU1dRXYFnJWDTHFhiiRg@mail.gmail.com>
Subject: Re: [PATCH] mpt3sas: Fix kernel panic observed on soft HBA unplug
To:     "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     "Elliott, Robert (Servers)" <elliott@hpe.com>,
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

On Fri, Mar 27, 2020 at 7:20 AM Martin K. Petersen
<martin.petersen@oracle.com> wrote:
>
>
> Sreekanth,
>
> > In the unload path driver call sas_remove_host() API before releasing
> > the resources. This sas_remove_host() API waits for all the
> > outstanding IOs to be completed. So here, indirectly driver is waiting
> > for the outstanding IOs to be processed before releasing the HBA
> > resources.  So only in the cases where HBA is inaccessible (e.g. HBA
> > unplug case), driver is flushing out the outstanding commands to avoid
> > SCSI error handling over head and can quilkey complete the driver
> > unload operation.
>
> None of this is clear from the commit description. Please resubmit patch
> with a new description clarifying why and when it is safe to drop
> outstanding commands.

Martin,

Posted the patch with updated description.
https://patchwork.kernel.org/patch/11462107/

Thanks & Regards,
Sreekanth

>
> --
> Martin K. Petersen      Oracle Linux Engineering
