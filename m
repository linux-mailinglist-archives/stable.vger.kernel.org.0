Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CA5AC123377
	for <lists+stable@lfdr.de>; Tue, 17 Dec 2019 18:26:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727201AbfLQR0S (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 17 Dec 2019 12:26:18 -0500
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:38613 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726723AbfLQR0S (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 17 Dec 2019 12:26:18 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1576603577;
        h=from:from:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:mime-version:mime-version:
         content-type:content-type:in-reply-to:in-reply-to:  references:references;
        bh=JhGEPIjSsI2VSpuvPhPcFvkVbdN2zCk8clg6xw3MloI=;
        b=YsJ6ggd/G37Hs/5LHmSDyW9ylj1154vuQIHJHVW5Hxta1Pq0XKJlwlWWHJboXlpxuXZX2b
        7X8l/S0tt8nTu7Fq0eUqpMOCraJ6fIRu0Bk+mKQctqbkP8jkiZmsdca9DzB7wr84AC6Muy
        zS3Ae0oUMKXVw1HDY1WF/Stq6x8UYi8=
Received: from mail-yb1-f199.google.com (mail-yb1-f199.google.com
 [209.85.219.199]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-185-FJSsIUtzMBqON0XoF0tO_Q-1; Tue, 17 Dec 2019 12:26:16 -0500
X-MC-Unique: FJSsIUtzMBqON0XoF0tO_Q-1
Received: by mail-yb1-f199.google.com with SMTP id l8so4882377ybm.22
        for <stable@vger.kernel.org>; Tue, 17 Dec 2019 09:26:16 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:subject:message-id:reply-to
         :mail-followup-to:references:mime-version:content-disposition
         :in-reply-to;
        bh=JhGEPIjSsI2VSpuvPhPcFvkVbdN2zCk8clg6xw3MloI=;
        b=S9k1jKDXwPdne3SGkziZoNMM3/2LuVH7G3tcMcGovFYVX1hldVJU1zNYDcMJ9KTeYk
         ZkezOA2W4mURxf1v7U5xDEYqIJgygdgHhv/5ErzI0ZyUzIYnH3jajnYf1BGRAdjvqQq2
         eAc2PHBosDogTuZ63xAaBfel7/LjJvDchBq7qeU+bnwepByu0SNzFwBwd7bn2pSMWN1B
         WD/wls4YEW34PnPe0oNpxLb3WMbg60jMt7fLvjq/6Kdc/4YvEYuMRiTCD+SoBnYjEBbV
         gqEDKRkrHFWDNozk9ZNqO422+xLzw+KwAHD8SumcgdeNnbabSvSxVDb0e3FktwPDQRYs
         mH5A==
X-Gm-Message-State: APjAAAUtksd8jzfgVqoSxWVp8OmSjEI7gQuam01XZsNvDKhvehBuiYdj
        nOzeR9XQIn7RGeOKwiRWOtiIjWipMO+98HBvHLE8+uG//BLtgKzHES3g++j55QpzXgPdf8HQHgB
        21yMfBwwKzSzaY84c
X-Received: by 2002:a25:f0a:: with SMTP id 10mr25608037ybp.196.1576603574469;
        Tue, 17 Dec 2019 09:26:14 -0800 (PST)
X-Google-Smtp-Source: APXvYqwDmC7V5LtArkYd5Wktr23Ul1nvyduPiQFSdqQohnh+fkE7SYSce96fOw7HJjezxJt0EkZh4A==
X-Received: by 2002:a25:f0a:: with SMTP id 10mr25608021ybp.196.1576603574213;
        Tue, 17 Dec 2019 09:26:14 -0800 (PST)
Received: from localhost (ip70-163-223-149.ph.ph.cox.net. [70.163.223.149])
        by smtp.gmail.com with ESMTPSA id k133sm9930453ywc.9.2019.12.17.09.26.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 17 Dec 2019 09:26:13 -0800 (PST)
Date:   Tue, 17 Dec 2019 10:26:12 -0700
From:   Jerry Snitselaar <jsnitsel@redhat.com>
To:     Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>,
        Dan Williams <dan.j.williams@intel.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Christian Bundy <christianbundy@fraction.io>,
        Peter Huewe <peterhuewe@gmx.de>,
        Jason Gunthorpe <jgg@ziepe.ca>,
        Stefan Berger <stefanb@linux.vnet.ibm.com>,
        stable <stable@vger.kernel.org>, linux-integrity@vger.kernel.org
Subject: Re: [PATCH v2] tpm_tis: reserve chip for duration of
 tpm_tis_core_init
Message-ID: <20191217172612.5hxyt7w3wtbrkypm@cantor>
Reply-To: Jerry Snitselaar <jsnitsel@redhat.com>
Mail-Followup-To: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>,
        Dan Williams <dan.j.williams@intel.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Christian Bundy <christianbundy@fraction.io>,
        Peter Huewe <peterhuewe@gmx.de>, Jason Gunthorpe <jgg@ziepe.ca>,
        Stefan Berger <stefanb@linux.vnet.ibm.com>,
        stable <stable@vger.kernel.org>, linux-integrity@vger.kernel.org
References: <20191211231758.22263-1-jsnitsel@redhat.com>
 <20191211235455.24424-1-jsnitsel@redhat.com>
 <5aef0fbe28ed23b963c53d61445b0bac6f108642.camel@linux.intel.com>
 <CAPcyv4h60z889bfbiwvVhsj6MxmOPiPY8ZuPB_skxkZx-N+OGw@mail.gmail.com>
 <20191217020022.knh7uxt4pn77wk5m@cantor>
 <CAPcyv4iepQup4bwMuWzq6r5gdx83hgYckUWFF7yF=rszjz3dtQ@mail.gmail.com>
 <5d0763334def7d7ae1e7cf931ef9b14184dce238.camel@linux.intel.com>
 <20191217171844.huqlj5csr262zkkk@cantor>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Disposition: inline
In-Reply-To: <20191217171844.huqlj5csr262zkkk@cantor>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue Dec 17 19, Jerry Snitselaar wrote:
>On Tue Dec 17 19, Jarkko Sakkinen wrote:
>>On Mon, 2019-12-16 at 18:14 -0800, Dan Williams wrote:
>>>On Mon, Dec 16, 2019 at 6:00 PM Jerry Snitselaar <jsnitsel@redhat.com> wrote:
>>>> On Mon Dec 16 19, Dan Williams wrote:
>>>> > On Mon, Dec 16, 2019 at 4:59 PM Jarkko Sakkinen
>>>> > <jarkko.sakkinen@linux.intel.com> wrote:
>>>> > > On Wed, 2019-12-11 at 16:54 -0700, Jerry Snitselaar wrote:
>>>> > > > Instead of repeatedly calling tpm_chip_start/tpm_chip_stop when
>>>> > > > issuing commands to the tpm during initialization, just reserve the
>>>> > > > chip after wait_startup, and release it when we are ready to call
>>>> > > > tpm_chip_register.
>>>> > > >
>>>> > > > Cc: Christian Bundy <christianbundy@fraction.io>
>>>> > > > Cc: Dan Williams <dan.j.williams@intel.com>
>>>> > > > Cc: Peter Huewe <peterhuewe@gmx.de>
>>>> > > > Cc: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
>>>> > > > Cc: Jason Gunthorpe <jgg@ziepe.ca>
>>>> > > > Cc: Stefan Berger <stefanb@linux.vnet.ibm.com>
>>>> > > > Cc: stable@vger.kernel.org
>>>> > > > Cc: linux-integrity@vger.kernel.org
>>>> > > > Fixes: a3fbfae82b4c ("tpm: take TPM chip power gating out of tpm_transmit()")
>>>> > > > Fixes: 5b359c7c4372 ("tpm_tis_core: Turn on the TPM before probing IRQ's")
>>>> > > > Signed-off-by: Jerry Snitselaar <jsnitsel@redhat.com>
>>>> > >
>>>> > > I pushed to my master with minor tweaks and added my tags.
>>>> > >
>>>> > > Please check before I put it to linux-next.
>>>> >
>>>> > I don't see it yet here:
>>>> >
>>>> > http://git.infradead.org/users/jjs/linux-tpmdd.git/shortlog/refs/heads/master
>>>> >
>>>> > However, I wanted to make sure you captured that this does *not* fix
>>>> > the interrupt issue. I.e. make sure you remove the "Fixes:
>>>> > 5b359c7c4372 ("tpm_tis_core: Turn on the TPM before probing IRQ's")"
>>>> > tag.
>>>> >
>>>> > With that said, are you going to include the revert of:
>>>> >
>>>> > 1ea32c83c699 tpm_tis_core: Set TPM_CHIP_FLAG_IRQ before probing for interrupts
>>>>
>>>> Dan, with the above reverted do you still get the screaming interrupt?
>>>
>>>Yes, the screaming interrupt goes away, although it is replaced by
>>>these messages when the driver starts:
>>>
>>>[    3.725131] tpm_tis IFX0740:00: 2.0 TPM (device-id 0x1B, rev-id 16)
>>>[    3.725358] tpm tpm0: tpm_try_transmit: send(): error -5
>>>[    3.725359] tpm tpm0: [Firmware Bug]: TPM interrupt not working,
>>>polling instead
>>>
>>>If the choice is "error message + polled-mode" vs "pinning a cpu with
>>>interrupts" I'd accept the former, but wanted Jarkko with his
>>>maintainer hat to weigh in.
>>>
>>>Is there a simple sanity check I can run to see if the TPM is still
>>>operational in this state?
>>
>>What about T490S?
>>
>>/Jarkko
>>
>
>Hi Jarkko, I'm waiting to hear back from the t490s user, but I imagine
>it still has the problem as well.
>

It appears he is out of the office until January, so I doubt I will hear
anything back until then.

>Christian, were you able to try this patch and verify it still
>resolves the issue you were having with the kernel failing to get the
>timeouts and durations from the tpm?
>
>Thanks,
>Jerry

