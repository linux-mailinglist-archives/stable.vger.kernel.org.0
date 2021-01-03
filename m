Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6DEB92E8DD4
	for <lists+stable@lfdr.de>; Sun,  3 Jan 2021 19:50:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726042AbhACSuh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 3 Jan 2021 13:50:37 -0500
Received: from mail.kernel.org ([198.145.29.99]:46318 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725840AbhACSuh (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 3 Jan 2021 13:50:37 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1006620936;
        Sun,  3 Jan 2021 18:49:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1609699796;
        bh=1hccwkBFs5HyDIu0N8vGlP8CeaDkRThJMMvyqFTI9Vw=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=Iw5cZa+WHJXQOUWaOVS7eSbkLnPE3jp5berENnZe1BoGwIjrraCVXLL3vEpGa53AL
         eSlIRUoLr2yQLvVSnW5d9/2USwuWWjFJflheT6JjsgVXKR0qg0E7u8scxOXRYblafa
         s/64/w7rFqgMd3aucZ4nVY/FhBQm5SkdZwPRxBhfbt3j+y49BvC9rxjZf+Wmmr30ff
         TCrzZuPj6GCfs7CyZcCU3sFiVE1uKzSGZ2zjwUZ9hZLSwNtMXNVJKgsHb8nhgz36+F
         AET6LybPo44kuWTqxIJXlMp+G64tfLRHGiuhQ4z3RypYC5aPV8wpfOVPFiTCpUCVdd
         ExHCneUGRk6Cw==
Received: by mail-ot1-f52.google.com with SMTP id 11so24087036oty.9;
        Sun, 03 Jan 2021 10:49:56 -0800 (PST)
X-Gm-Message-State: AOAM5332yNFFBRvPS9xiF0PFi8KluvjSugrcdpRePkwLaQT/Iij6tck+
        cNKhNcw9fnekFRbfvZcsPrdMMvkmbbq9hD4ZhVA=
X-Google-Smtp-Source: ABdhPJyuAwdXaBRn7qvmVSYAHzIuGYPx0cxmJKEOtavHiMxqf31nnrFlLSvcuIIFLmewEgRF39tDpBebknE+9C4J2WY=
X-Received: by 2002:a05:6830:2413:: with SMTP id j19mr52366598ots.251.1609699795399;
 Sun, 03 Jan 2021 10:49:55 -0800 (PST)
MIME-Version: 1.0
References: <20200908213715.3553098-1-arnd@arndb.de> <20200908213715.3553098-2-arnd@arndb.de>
 <20201231001553.GB16945@home.linuxace.com> <CAK8P3a0_WORgd4Wvd3n+59oR=-rrESwg_MgpDJN4xPo_e6ir5Q@mail.gmail.com>
 <739a3639944f099a76d145eb119b77701f13444d.camel@linux.ibm.com>
In-Reply-To: <739a3639944f099a76d145eb119b77701f13444d.camel@linux.ibm.com>
From:   Arnd Bergmann <arnd@kernel.org>
Date:   Sun, 3 Jan 2021 19:49:39 +0100
X-Gmail-Original-Message-ID: <CAK8P3a1kmoBeBM3Nk=VigR-CnN8c2HKC8eubrvLt1TpD7gsAHw@mail.gmail.com>
Message-ID: <CAK8P3a1kmoBeBM3Nk=VigR-CnN8c2HKC8eubrvLt1TpD7gsAHw@mail.gmail.com>
Subject: Re: [PATCH 2/3] scsi: megaraid_sas: check user-provided offsets
To:     "James E.J. Bottomley" <jejb@linux.ibm.com>
Cc:     Phil Oester <kernel@linuxace.com>, Arnd Bergmann <arnd@arndb.de>,
        Kashyap Desai <kashyap.desai@broadcom.com>,
        Sumit Saxena <sumit.saxena@broadcom.com>,
        Shivasharan S <shivasharan.srikanteshwara@broadcom.com>,
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

On Sun, Jan 3, 2021 at 6:00 PM James Bottomley <jejb@linux.ibm.com> wrote:
> On Sun, 2021-01-03 at 17:26 +0100, Arnd Bergmann wrote:
> [...]
> > @@ -8209,7 +8208,7 @@ megasas_mgmt_fw_ioctl(struct megasas_instance
> > *instance,
> >                 if (instance->consistent_mask_64bit)
> >                         put_unaligned_le64(sense_handle, sense_ptr);
> >                 else
> > -                       put_unaligned_le32(sense_handle, sense_ptr);
> > +                       put_unaligned_le64(sense_handle, sense_ptr);
> >         }
>
> This hunk can't be right.  It effectively means removing the if.

I'm just trying to restore the state before the regression introduced
in my 381d34e376e3 ("scsi: megaraid_sas: Check user-provided offsets").

The old code always stored 'sizeof(long)' bytes into sense_ptr,
regardless of instance->consistent_mask_64bit, but it would truncate
the address to 32 bit if that was cleared. This was clearly bogus
and I tried to make it do something more meaningful, only storing
8 bytes into the structure if it was configured for 64-bit DMA, regardless
of the capabilities of the kernel.

> However, the if is needed because sense_handle is a dma_addr_t which
> can be either 32 or 64 bit.  What about changing the if to
>
> if (sizeof(dma_addr_t) == 8)
>
> instead?

That would not be useful either, the device surely does not care
if the kernel supports 64-bit DMA. What we'd really need here is
someone with access to the interface specifications to see how
many bytes should be stored in the structure. I suspect always
storing 64 bits (as my patch does) is correct, and would send a
proper patch to remove the if() if Phil confirms that my test
patch fixes the regression.

        Arnd
