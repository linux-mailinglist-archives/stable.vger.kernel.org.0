Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6135611C095
	for <lists+stable@lfdr.de>; Thu, 12 Dec 2019 00:30:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727118AbfLKXax (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 11 Dec 2019 18:30:53 -0500
Received: from mail-oi1-f195.google.com ([209.85.167.195]:43098 "EHLO
        mail-oi1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726890AbfLKXaw (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 11 Dec 2019 18:30:52 -0500
Received: by mail-oi1-f195.google.com with SMTP id x14so314280oic.10
        for <stable@vger.kernel.org>; Wed, 11 Dec 2019 15:30:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=intel-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to;
        bh=u5EYBeY7DMUFDYGcRwf5OFQhhNuQnK3tgQ7xtLF/bL0=;
        b=ijN0BBiifrHOQUvBafavzPiAtfcjrHqSWNBtq7gCsmBw3lOMLU5xy2mEy+NAB2WCfZ
         QXMTvO+d2I6Tcn3VJk+x6SfqhAhnBHDF0hbU1WxTxKaOpnL+xUkp+jVe4Bvz+uoiHxH1
         auO0DvWjcmNwkom7gtlF7YZKxpBsil4zLgi+1bFXkDujDluhddarjR4cXvvLKBBq5W/j
         pB6KrFffB7ThG5i27LLkqbIzqGa04oovBm2zbwEOJR1eB4LFjCOD6hpRwf3+laE8R+eb
         AclMiFO+ekBDEy9Sarhe4JUZurtOoikzqnoJmc15XLfkfVRRvsumrut/YJ3t4O38ubix
         mmSQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to;
        bh=u5EYBeY7DMUFDYGcRwf5OFQhhNuQnK3tgQ7xtLF/bL0=;
        b=E1RHnhhJ3XE122um3auo4ffr3cYsrszOun1ZYVORX9UdFHYnoeVi6DJ8uTEfGaPuGd
         R44zYQrYVrp23Ocnm7AJZcXT3TcoPNyG814fsIzw/3DKTngioX85qu/y4+vV+X+IiZCo
         Hwz7RB1Xl6jr9FYKoOcy73IkW3VOfv4RAcdb5K47ZypWtmSmBYNdTZfCqy3sBA1mIpFS
         ghKUq9KdSgHWLlADtih3t3pMI29sRE9oyIM8ZtPM2GAEMYXv8bvL7tfSg2Ww65KFV79C
         k5IwWV9nBjMehHbEE0xVHfzOWkZOrMSb15BSYqQHI6LPESSIWjCmpN1UKZ8vU2rdDYeI
         B1ew==
X-Gm-Message-State: APjAAAUQr1CYzVLbBuUJ1sjGd6nCPTNhkfVMXeNc/cF6lnD1AWYyJJJ7
        bNvOknGN9JdcOajMS1C9+EmuR2uNc+Sy4KKTefOTAw==
X-Google-Smtp-Source: APXvYqyLZkYhBOvDF9PkIrrn7AL6acOwV56SY7wGTAM47hWUspRcfbKnDMcStIbXUHhF5Dvhm19L5lJjHK5XdwPeG34=
X-Received: by 2002:a05:6808:7da:: with SMTP id f26mr4285646oij.73.1576107051733;
 Wed, 11 Dec 2019 15:30:51 -0800 (PST)
MIME-Version: 1.0
References: <20191211231758.22263-1-jsnitsel@redhat.com> <20191211232612.miaizaxxikhlgvfj@cantor>
In-Reply-To: <20191211232612.miaizaxxikhlgvfj@cantor>
From:   Dan Williams <dan.j.williams@intel.com>
Date:   Wed, 11 Dec 2019 15:30:40 -0800
Message-ID: <CAPcyv4iwJoX6tVVBUc0dSwHUwsu2duoUFayOnAhDEd5SjYug8g@mail.gmail.com>
Subject: Re: [PATCH] tpm_tis: reserve chip for duration of tpm_tis_core_init
To:     Jerry Snitselaar <jsnitsel@redhat.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Christian Bundy <christianbundy@fraction.io>,
        Dan Williams <dan.j.williams@intel.com>,
        Peter Huewe <peterhuewe@gmx.de>,
        Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>,
        Jason Gunthorpe <jgg@ziepe.ca>,
        Stefan Berger <stefanb@linux.vnet.ibm.com>,
        stable <stable@vger.kernel.org>, linux-integrity@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Dec 11, 2019 at 3:27 PM Jerry Snitselaar <jsnitsel@redhat.com> wrote:
>
> On Wed Dec 11 19, Jerry Snitselaar wrote:
> >Instead of repeatedly calling tpm_chip_start/tpm_chip_stop when
> >issuing commands to the tpm during initialization, just reserve the
> >chip after wait_startup, and release it when we are ready to call
> >tpm_chip_register.
> >
> >Cc: Christian Bundy <christianbundy@fraction.io>
> >Cc: Dan Williams <dan.j.williams@intel.com>
> >Cc: Peter Huewe <peterhuewe@gmx.de>
> >Cc: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
> >Cc: Jason Gunthorpe <jgg@ziepe.ca>
> >Cc: Stefan Berger <stefanb@linux.vnet.ibm.com>
> >Cc: stable@vger.kernel.org
> >Cc: linux-intergrity@vger.kernel.org
>
> Typo on the list address, do you want me to resend Jarkko?
>
> >Fixes: a3fbfae82b4c ("tpm: take TPM chip power gating out of tpm_transmit()")
> >Signed-off-by: Jerry Snitselaar <jsnitsel@redhat.com>
> >---
>
> I did some initial testing with both a 1.2 device and a 2.0 device here.
> Christian, can you verify that this still solves your timeouts problem
> you were seeing? Dan, can you try this on the internal system with
> the interrupt issues? I will see if I can get the t490s owner to run
> it as well.

Will do. I assume you'd also want to add 'Fixes: 5b359c7c4372
("tpm_tis_core: Turn on the TPM before probing IRQ's")' if it works?
