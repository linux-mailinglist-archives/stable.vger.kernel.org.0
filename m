Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8C8B2E1B1F
	for <lists+stable@lfdr.de>; Wed, 23 Oct 2019 14:45:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390292AbfJWMox (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 23 Oct 2019 08:44:53 -0400
Received: from mail-il1-f193.google.com ([209.85.166.193]:46064 "EHLO
        mail-il1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2391686AbfJWMox (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 23 Oct 2019 08:44:53 -0400
Received: by mail-il1-f193.google.com with SMTP id u1so18734884ilq.12
        for <stable@vger.kernel.org>; Wed, 23 Oct 2019 05:44:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=KCumm8k8QZFgEaXx7omB9aOrf4hbPGxPHtVfgyDzsMc=;
        b=LDTrBOZ1+JfvlvTSEcwWYsX9iOf1MJ/3FxEIKmXp4Akg+bT8+VGTRqQHVDd0X/Pc8T
         5peWru6fWsvOmE81EZWhTYodhcZWSfRwnVLoQ0s9+ZDDJ/wAAZrBGoxyK91L011Q5jzu
         umB3NkXBxTUnTlLHb+HXzytdkPhcf1BA8k7x0rxVXD7NxX77WPNhl8tSSfn2K4G3Imkm
         YBZoa2UtM3fuSmJUMEVaDEh7uC4j1VHlaQpAN5OSJxiejDk5dW1RaiTNhXQwM1kZjybM
         KgOs1OaZDxXllyfDA4j/gHmEPbj8cobL+taLvSWPV+eyYoiJgVO333jORm+eRbQOVfmR
         BfKQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=KCumm8k8QZFgEaXx7omB9aOrf4hbPGxPHtVfgyDzsMc=;
        b=gNGDBx0UrJ+9JbEs56JrIwics8l4jmCK1R7ql5tw1rpwqCmDHueZA0BkDPCt1fCtWS
         n+Esq9AUNLd+ViI403nhCLamI8CJCFyAj4bK+o966rhglxy2njhIklgiW/H4wC+WSk1T
         KOXFZ6CHygzng725/3/gJ++IJ+SIRzqyAN6FRtCWJTYxexe+l8WMcFEFXMpz6fgJdRIV
         xSMgXbZhcjeZKuTvEtx6MJSOYKelPWK17KZDSmF81ne0yGg6x9z2+aF58LRG/l9gNE3k
         LDKWrbhI39W3JeZa5t1nDLupxJquNAaAMuM+X/lkESmBJk3SYQizaF0ze5pKGEXaycgV
         zgKQ==
X-Gm-Message-State: APjAAAWaj0w++SOW6IWb9SzeSJE0EuCripBOyOJnHO3G8qS6aJMCQqGM
        YWVR1uj69TTZHCYTzQMUWeOz+wad5emPKHO3iZoz/2G4
X-Google-Smtp-Source: APXvYqzGbgRiDbN76eWO+FVMnXbtQ0VH2X2AA23kY/MsgxfNsvGqm1CxUlxMFtF/ZtAbu7rSzhosvv+FbY0J/2Yjnno=
X-Received: by 2002:a92:5ac2:: with SMTP id b63mr39871670ilg.192.1571834692034;
 Wed, 23 Oct 2019 05:44:52 -0700 (PDT)
MIME-Version: 1.0
References: <20191023013635.2512-1-oohall@gmail.com> <20191023112102.GN28442@gate.crashing.org>
In-Reply-To: <20191023112102.GN28442@gate.crashing.org>
From:   "Oliver O'Halloran" <oohall@gmail.com>
Date:   Wed, 23 Oct 2019 23:44:41 +1100
Message-ID: <CAOSf1CGjVt1v4RcazXTLkbm=fsswF8a5nqsLZod4=YwymLXPvg@mail.gmail.com>
Subject: Re: [PATCH] powerpc/boot: Fix the initrd being overwritten under qemu
To:     Segher Boessenkool <segher@kernel.crashing.org>
Cc:     linuxppc-dev <linuxppc-dev@lists.ozlabs.org>,
        Alexey Kardashevskiy <aik@ozlabs.ru>,
        stable <stable@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Oct 23, 2019 at 10:21 PM Segher Boessenkool
<segher@kernel.crashing.org> wrote:
>
> On Wed, Oct 23, 2019 at 12:36:35PM +1100, Oliver O'Halloran wrote:
> > When booting under OF the zImage expects the initrd address and size to be
> > passed to it using registers r3 and r4. SLOF (guest firmware used by QEMU)
> > currently doesn't do this so the zImage is not aware of the initrd
> > location.  This can result in initrd corruption either though the zImage
> > extracting the vmlinux over the initrd, or by the vmlinux overwriting the
> > initrd when relocating itself.
> >
> > QEMU does put the linux,initrd-start and linux,initrd-end properties into
> > the devicetree to vmlinux to find the initrd. We can work around the SLOF
> > bug by also looking those properties in the zImage.
>
> This is not a bug.  What boot protocol requires passing the initrd start
> and size in GPR3, GPR4?
>
> The CHRP binding (what SLOF implements) requires passing two zeroes here.
> And ePAPR requires passing the address of a device tree and a zero, plus
> something in GPR6 to allow distinguishing what it does.

This is what is assumed by the zImage.pseries. I have no idea where
that assumption comes from,A B

> As Alexey says, initramfs works just fine, so please use that?  initrd was
> deprecated when this code was written already.

That's not what Alexey said and the distinction between an initrd and
an initramfs is completely arbitrary.

>
>
> Segher
