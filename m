Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BC25C122156
	for <lists+stable@lfdr.de>; Tue, 17 Dec 2019 02:18:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726320AbfLQBSM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Dec 2019 20:18:12 -0500
Received: from mail-oi1-f196.google.com ([209.85.167.196]:47101 "EHLO
        mail-oi1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726016AbfLQBSM (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 Dec 2019 20:18:12 -0500
Received: by mail-oi1-f196.google.com with SMTP id p67so78202oib.13
        for <stable@vger.kernel.org>; Mon, 16 Dec 2019 17:18:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=intel-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=gQlxuukx7ZYSQZmNiora65lLQtsKLdrcwl34+cNn20I=;
        b=ZML1YlPfc4X1lcJ2MEbwwuNUKRegQeZ1YWVhElf9aNxBihtxGgtQUSJL6yDQFiM2rL
         y/lqLODFRtPxZRmMnuW9B1kUabr/9AGAClBFwX0znrz0wJsyiRGYNjaCepLaxTeWBNBX
         SiVi4m+QZl/9PWp2i/Gej2UCGi0YWW8IAKtvPz0U5FZS7Amc68+vfcu8BwfvUeSscuVF
         kUfLmgSgMrtPuf0Vc+yijMqQUx6yzFsgm3vk0Y0emxOOEaff735UHNk7VQWa65n7NFlF
         8COOeab+RZx6zAqGm2MLWzNGm3Zrmk68eKfmuXeXklk3Q1r3cMwqb0r/fmpqOyWsTBPs
         vwMQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=gQlxuukx7ZYSQZmNiora65lLQtsKLdrcwl34+cNn20I=;
        b=Z60JNX8A52jyvJ83j6FAq8Er2k219/4g5ccqVKXklPuaXNfPEvv6mFxydC4c1kHr6N
         dTYwxpQKIwDfPdVvc0Hp27+1uMwJM5DZI/ieGaBwhTBwoljvcAxbjoFwIaesfGpikv2Q
         XhdfklIWO/rST/xYefbOiwYyid/9H29mq+4x+cyN7udAwx0YBTqvvZSdN3FwNKmaxCTI
         QwKCnpeUyy3bgogG/QHhNyEAJAFfiD+5nw57k+rH9KZ1LLUnOsXEchQcSHMDsg40xz5q
         8jgdVk3cY9NsudVeHTO0E/TW3E7HeS1wRZ+XsZvd07ScGFf/7SmYoedisA9EHgV65hgg
         YVlA==
X-Gm-Message-State: APjAAAWlOCY45nb8liKXR3mGsVogDYxP4aO0qxk3/pWFN5ZuIeP/GNZN
        pYfonvx3QfAVzdwsU7PS7FyYtCJR6sLGvPkS95bJlw==
X-Google-Smtp-Source: APXvYqyALUz6qMsfZ8CPqN2DhPrepKX8K+FY6z1DAn5DPLETrrCCRCs0bMrUATx7fxnThIB2URczhSpUKLEZ1cMtY+s=
X-Received: by 2002:aca:c354:: with SMTP id t81mr1065974oif.149.1576545490980;
 Mon, 16 Dec 2019 17:18:10 -0800 (PST)
MIME-Version: 1.0
References: <20191211231758.22263-1-jsnitsel@redhat.com> <20191211235455.24424-1-jsnitsel@redhat.com>
 <5aef0fbe28ed23b963c53d61445b0bac6f108642.camel@linux.intel.com>
In-Reply-To: <5aef0fbe28ed23b963c53d61445b0bac6f108642.camel@linux.intel.com>
From:   Dan Williams <dan.j.williams@intel.com>
Date:   Mon, 16 Dec 2019 17:18:00 -0800
Message-ID: <CAPcyv4h60z889bfbiwvVhsj6MxmOPiPY8ZuPB_skxkZx-N+OGw@mail.gmail.com>
Subject: Re: [PATCH v2] tpm_tis: reserve chip for duration of tpm_tis_core_init
To:     Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Cc:     Jerry Snitselaar <jsnitsel@redhat.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Christian Bundy <christianbundy@fraction.io>,
        Peter Huewe <peterhuewe@gmx.de>,
        Jason Gunthorpe <jgg@ziepe.ca>,
        Stefan Berger <stefanb@linux.vnet.ibm.com>,
        stable <stable@vger.kernel.org>, linux-integrity@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Dec 16, 2019 at 4:59 PM Jarkko Sakkinen
<jarkko.sakkinen@linux.intel.com> wrote:
>
> On Wed, 2019-12-11 at 16:54 -0700, Jerry Snitselaar wrote:
> > Instead of repeatedly calling tpm_chip_start/tpm_chip_stop when
> > issuing commands to the tpm during initialization, just reserve the
> > chip after wait_startup, and release it when we are ready to call
> > tpm_chip_register.
> >
> > Cc: Christian Bundy <christianbundy@fraction.io>
> > Cc: Dan Williams <dan.j.williams@intel.com>
> > Cc: Peter Huewe <peterhuewe@gmx.de>
> > Cc: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
> > Cc: Jason Gunthorpe <jgg@ziepe.ca>
> > Cc: Stefan Berger <stefanb@linux.vnet.ibm.com>
> > Cc: stable@vger.kernel.org
> > Cc: linux-integrity@vger.kernel.org
> > Fixes: a3fbfae82b4c ("tpm: take TPM chip power gating out of tpm_transmit()")
> > Fixes: 5b359c7c4372 ("tpm_tis_core: Turn on the TPM before probing IRQ's")
> > Signed-off-by: Jerry Snitselaar <jsnitsel@redhat.com>
>
> I pushed to my master with minor tweaks and added my tags.
>
> Please check before I put it to linux-next.

I don't see it yet here:

http://git.infradead.org/users/jjs/linux-tpmdd.git/shortlog/refs/heads/master

However, I wanted to make sure you captured that this does *not* fix
the interrupt issue. I.e. make sure you remove the "Fixes:
5b359c7c4372 ("tpm_tis_core: Turn on the TPM before probing IRQ's")"
tag.

With that said, are you going to include the revert of:

1ea32c83c699 tpm_tis_core: Set TPM_CHIP_FLAG_IRQ before probing for interrupts
5b359c7c4372 tpm_tis_core: Turn on the TPM before probing IRQ's

...in your -rc3 pull?
