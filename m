Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2643B2E9FFE
	for <lists+stable@lfdr.de>; Mon,  4 Jan 2021 23:26:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726651AbhADWZ5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 4 Jan 2021 17:25:57 -0500
Received: from mail.kernel.org ([198.145.29.99]:46518 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726289AbhADWZ5 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 4 Jan 2021 17:25:57 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6850822522;
        Mon,  4 Jan 2021 22:25:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1609799116;
        bh=Moh1Im9+alXtJJK1YOL7K6rqnZB2FhHs23YlgDF6keU=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=dIu7OlXTpr40Bd3Y1w4HFmWQiZG32R8yHx66zUYLCVMFon6hcTpiLC9UrL0NXrbyQ
         OXINU/zPk1KxO5uPCbWtsws3hAi3GCrbzdFuPY52Prn3lqBYY2v6vwi5ZDMItZ2AzZ
         Yn7hfxFROn7TVC8foTgohNzaOUkprRlte4PrZo4GrZZTJkzWUeM5IqNsjZXtRGOtd4
         AJkGoEnP6Oful8hRotrqetvfSKGKOIACtuV0MHd/+yhNoHjY8k/Y6Y+56PfjWbEzUa
         tTo1PSshm0FIgFcxY7waGbMQLxBJXcaqTJsf5Ziz5cki0Rzlq3LjztUNHadz+XHHrS
         OxMCoy0U2l70w==
Received: by mail-oo1-f44.google.com with SMTP id x23so6655732oop.1;
        Mon, 04 Jan 2021 14:25:16 -0800 (PST)
X-Gm-Message-State: AOAM531HbdXubHCDLwBSu3i7RQxAEpDhdnPAkGcDBGWWUBwhmPiVLXcN
        Kjpjs6+jXAGhWvM8ALmvYO/oIm8K3LmC2x99JV0=
X-Google-Smtp-Source: ABdhPJzU7lxA3RMtpM1O2RkpS8lnhhhv7nbKAojeMrdvGNK4FnPfTaCRqXG+DdKLY1S/2NMem6TUSzDvIvx/Y3Hcsgg=
X-Received: by 2002:a4a:2cc9:: with SMTP id o192mr49383360ooo.66.1609799115782;
 Mon, 04 Jan 2021 14:25:15 -0800 (PST)
MIME-Version: 1.0
References: <20200908213715.3553098-1-arnd@arndb.de> <20200908213715.3553098-2-arnd@arndb.de>
 <20201231001553.GB16945@home.linuxace.com> <CAK8P3a0_WORgd4Wvd3n+59oR=-rrESwg_MgpDJN4xPo_e6ir5Q@mail.gmail.com>
 <20210104174826.GA76610@home.linuxace.com>
In-Reply-To: <20210104174826.GA76610@home.linuxace.com>
From:   Arnd Bergmann <arnd@kernel.org>
Date:   Mon, 4 Jan 2021 23:24:59 +0100
X-Gmail-Original-Message-ID: <CAK8P3a0FUL2FpF1Av47CK-9G3R9QdT3ihhA93gsFvfLVO3kC+Q@mail.gmail.com>
Message-ID: <CAK8P3a0FUL2FpF1Av47CK-9G3R9QdT3ihhA93gsFvfLVO3kC+Q@mail.gmail.com>
Subject: Re: [PATCH 2/3] scsi: megaraid_sas: check user-provided offsets
To:     Phil Oester <kernel@linuxace.com>
Cc:     Arnd Bergmann <arnd@arndb.de>,
        Kashyap Desai <kashyap.desai@broadcom.com>,
        Sumit Saxena <sumit.saxena@broadcom.com>,
        Shivasharan S <shivasharan.srikanteshwara@broadcom.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Christoph Hellwig <hch@infradead.org>,
        "# 3.4.x" <stable@vger.kernel.org>,
        Anand Lodnoor <anand.lodnoor@broadcom.com>,
        Chandrakanth Patil <chandrakanth.patil@broadcom.com>,
        Hannes Reinecke <hare@suse.de>, megaraidlinux.pdl@broadcom.com,
        linux-scsi <linux-scsi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Jan 4, 2021 at 6:48 PM Phil Oester <kernel@linuxace.com> wrote:
>
> On Sun, Jan 03, 2021 at 05:26:29PM +0100, Arnd Bergmann wrote:
> > Thank you for the report and bisecting the issue, and sorry this broke
> > your system!
> >
> > Fortunately, the patch is fairly small, so there are only a limited number
> > of things that could go wrong. I haven't tried to analyze that message,
> > but I have two ideas:
> >
> > a) The added ioc->sense_off check gets triggered and the code relies
> >   on the data being written outside of the structure
> >
> > b) the address actually needs to always be written as a 64-bit value
> >     regardless of the instance->consistent_mask_64bit flag, as the
> >    driver did before. This looked like it was done in error.
> >
> > Can you try the patch below instead of the revert and see if that
> > resolves the regression, and if it triggers the warning message I
> > add?
>
> Thanks Arnd, I tried your patch and it resolves the regression.  It does not
> trigger the warning message you added.

Ok, thanks for testing! That would mean the range check is correct,
but the sense pointer must indeed be treated as a 64-bit entity
regardless of instance->consistent_mask_64bit, or at least the
upper 32 bit must be zero when the flag is unset, rather than
the recycled previous value.

I'll send a proper fix shortly, it would be nice if you could give it
another spin, but the behavior should be the same as this patch.

       Arnd
