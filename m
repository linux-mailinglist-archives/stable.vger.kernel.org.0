Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7AD05452EEB
	for <lists+stable@lfdr.de>; Tue, 16 Nov 2021 11:21:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234086AbhKPKYd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 16 Nov 2021 05:24:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39250 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234035AbhKPKY1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 16 Nov 2021 05:24:27 -0500
Received: from mail-ua1-x929.google.com (mail-ua1-x929.google.com [IPv6:2607:f8b0:4864:20::929])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4F04AC061766;
        Tue, 16 Nov 2021 02:21:30 -0800 (PST)
Received: by mail-ua1-x929.google.com with SMTP id ay21so41211137uab.12;
        Tue, 16 Nov 2021 02:21:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=hUo41dA8J9XxTRrnTRH8PmjQf1ZA/nli+HzNQ39/Nrw=;
        b=mfvlRT+G+C0joXUKIQIV1pisFDOl6ozAExFYU0X57hIxjfPz26ZfvvaaIfzp2JZUZi
         jGYt3BI5NEuAk4ounMGlvrod4Q0UzR+XHlib+6/71AistsL+bQAXagjjcSHW/iWsbuRa
         QhxSeMQJQH1NmH1U5FUEgG5aWEcS4kH78oLzdGMOKdPPdHJr5YaUwOEJ2Z6mj6HxT1NC
         3XowRYcPBDAGvAYMM4txOqoBTPM36NXmfU9J+wPGhpeZtM6jZV9EtNmw27h0MyWH9gUw
         lYcieDrZRmLPiP+hjrP9eNQ4aRi5wOw0OivT+w6/oCmW+S0ZbbGIc/mWux6BudJNdOso
         de0A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=hUo41dA8J9XxTRrnTRH8PmjQf1ZA/nli+HzNQ39/Nrw=;
        b=YqQ3S4lWyL6HQtK4LsEIQAlawaHvsibsf51O2VczYkBFFMK9umdEt153wrj8SbheLB
         w4u7UjHb3ULFguknbsJanjXEqz1RoOAmwTEwy7BA7UcZTpbWtpOW9o1znrx4RGcvLqpN
         ml7Q7i5DtUsZjXNcBSCpF58xLznDDx/chyuctFD+LDeG0N0ExJn08TLMxwlFSyhab4JU
         iy7QmyLAw2wNFoEtjdrX2Ll0KZBcuDyYGftBIHCDrG/tJjjg08GzyiHn79u1luVyCkJf
         ES/Pi9meYphXmzLJK7+P444DrSYdxVVvPNAvL8/8tUhj3NvpYlCRT832zze1YkvVR38/
         VqXA==
X-Gm-Message-State: AOAM532a1OWqxiQYgUG9HmpvpHsMihFjW598kunTXmWm4zG22p6DwjM5
        E2gGqBzpHOZfd2PH008kiu5F+NL0R4Glhi444Q==
X-Google-Smtp-Source: ABdhPJw0BIDe3UgX4EYtJQwZmqUk7ZARIQehiSa5nAZZi5z6pOodwsCQENmcw5LDkYTf4QVmDrKhzsb4P+ypLdBhAz4=
X-Received: by 2002:ab0:2498:: with SMTP id i24mr9317458uan.18.1637058089320;
 Tue, 16 Nov 2021 02:21:29 -0800 (PST)
MIME-Version: 1.0
References: <20211104180130.3825416-1-maz@kernel.org> <87ilx64ued.ffs@tglx>
In-Reply-To: <87ilx64ued.ffs@tglx>
From:   Rui Salvaterra <rsalvaterra@gmail.com>
Date:   Tue, 16 Nov 2021 10:21:18 +0000
Message-ID: <CALjTZvag6ex6bhAgJ_rJOfai8GgZQfWesdV=FiMrwEaXhVVVeQ@mail.gmail.com>
Subject: Re: [PATCH 0/2] PCI: MSI: Deal with devices lying about their masking capability
To:     Thomas Gleixner <tglx@linutronix.de>
Cc:     Marc Zyngier <maz@kernel.org>, linux-pci@vger.kernel.org,
        linux-kernel@vger.kernel.org, Bjorn Helgaas <bhelgaas@google.com>,
        kernel-team@android.com, stable@vger.kernel.org,
        gregkh@linuxfoundation.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi, Thomas,

On Fri, 5 Nov 2021 at 13:14, Thomas Gleixner <tglx@linutronix.de> wrote:
>
> On Thu, Nov 04 2021 at 18:01, Marc Zyngier wrote:
> > Rui reported[1] that his Nvidia ION system stopped working with 5.15,
> > with the AHCI device failing to get any MSI. A rapid investigation
> > revealed that although the device doesn't advertise MSI masking, it
> > actually needs it. Quality hardware indeed.
> >
> > Anyway, the couple of patches below are an attempt at dealing with the
> > issue in a more or less generic way.
> >
> > [1] https://lore.kernel.org/r/CALjTZvbzYfBuLB+H=fj2J+9=DxjQ2Uqcy0if_PvmJ-nU-qEgkg@mail.gmail.com
> >
> > Marc Zyngier (2):
> >   PCI: MSI: Deal with devices lying about their MSI mask capability
> >   PCI: Add MSI masking quirk for Nvidia ION AHCI
> >
> >  drivers/pci/msi.c    | 3 +++
> >  drivers/pci/quirks.c | 6 ++++++
> >  include/linux/pci.h  | 2 ++
> >  3 files changed, 11 insertions(+)
>
> Groan.
>
> Reviewed-by: Thomas Gleixner <tglx@linutronix.de>

Just a reminder, to make sure this doesn't fall through the cracks.
It's already in 5.16, but needs to be backported to 5.15. I'm not
seeing it in Greg's 5.15 stable queue yet.

Thanks,
Rui
